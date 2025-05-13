#include "AuthUser.h"
#include "AppSave.h"
#include <QDebug>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QNetworkReply>

AuthUser::AuthUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkManager, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Network reply received from:" << endpoint.toString();

        if (endpoint.path().contains("/register")) {
            onRegistrationReply(reply);
        } else if (endpoint.path().contains("/login")) {
            onLoginReply(reply);
        } else if (endpoint.path().contains("/changepassword")) {
            onPasswordChangeReply(reply);
        } else if (endpoint.path().contains("/changemail")) {
            onEmailChangeReply(reply);
        } else {
            qWarning() << "Unhandled endpoint in CategoriesManager:" << endpoint.toString();
        }
        reply->deleteLater();
    });

    qDebug() << "AuthUser initialized and connected to network manager.";
}

// ----------- Регистрация -----------
void AuthUser::registerUser(const QString &login, const QString &email, const QString &password)
{
    qDebug() << "registerUser called with:";
    qDebug() << "  login:" << login.trimmed();
    qDebug() << "  email:" << email.trimmed();
    qDebug() << "  password:" << password.trimmed();

    QJsonObject json;
    json["login"] = login.trimmed();
    json["email"] = email.trimmed();
    json["password"] = password.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl("http://192.168.30.184:8080/register");
    sendToServer(jsonDoc, serverUrl);
}

void AuthUser::onRegistrationReply(QNetworkReply *reply)
{
    qDebug() << "onRegistrationReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Registration successful. Server response:" << reply->readAll();
        emit registrationSuccess();
    } else {
        qDebug() << "Registration failed. Error:" << reply->errorString();
        emit registrationFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Вход (Login) -----------
void AuthUser::loginUser(const QString &login, const QString &email, const QString &password)
{
    qDebug() << "loginUser called with:";
    qDebug() << "  login:" << login.trimmed();
    qDebug() << "  email:" << email.trimmed();
    qDebug() << "  password:" << password.trimmed();

    QJsonObject json;
    json["login"] = login.trimmed();
    json["email"] = email.trimmed();
    json["password"] = password.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl("http://192.168.30.184:8080/login");
    sendLoginRequest(jsonDoc, serverUrl);
}

void AuthUser::sendLoginRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendLoginRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (login):" << data;

    m_networkManager.post(request, data);
}

void AuthUser::onLoginReply(QNetworkReply *reply)
{
    qDebug() << "onLoginReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Login successful. Server response:" << reply->readAll();
        emit loginSuccess();
    } else {
        qDebug() << "Login failed. Error:" << reply->errorString();
        emit loginFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Смена пароля -----------
void AuthUser::changePassword(const QString &email, const QString &newPassword, const QString &newPasswordCheck)
{
    qDebug() << "changePassword called with:";
    qDebug() << "  email:" << email;
    qDebug() << "  newPassword:" << newPassword;
    qDebug() << "  newPasswordCheck:" << newPasswordCheck;

    QJsonObject json;
    json["email"] = email.trimmed();
    json["password"] = newPassword.trimmed();
    json["password_check"] = newPasswordCheck.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl("http://192.168.30.184:8080/changepassword");
    sendPasswordChangeRequest(jsonDoc, serverUrl);
}

void AuthUser::sendPasswordChangeRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendPasswordChangeRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (password change):" << data;

    QNetworkReply *reply = m_networkManager.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onPasswordChangeReply(reply);
    });
}

void AuthUser::onPasswordChangeReply(QNetworkReply *reply)
{
    qDebug() << "onPasswordChangeReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Password change successful. Server response:" << reply->readAll();
        emit passwordChangeSuccess();
    } else {
        qDebug() << "Password change failed. Error:" << reply->errorString();
        emit passwordChangeFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Удаление аккаунта -----------

void AuthUser::triggerSendSavedLogin()
{
    qDebug() << "triggerSendSavedLogin called.";
    sendSavedLoginToServer();  // Вызов метода отправки сохраненного логина
}

void AuthUser::sendSavedLoginToServer()
{
    AppSave appSave;  // Создаем объект для работы с QSettings
    if (appSave.isUserLoggedIn()) {
        QString savedLogin = appSave.getSavedLogin();  // Получаем сохраненный логин

        QJsonObject json;
        json["login"] = savedLogin;  // Упаковываем логин в JSON объект

        QJsonDocument jsonDoc(json);  // Создаем JSON документ
        QUrl serverUrl("http://192.168.30.184:8080/deleteuser");  // Замените на правильный URL
        sendToServer(jsonDoc, serverUrl);  // Отправляем на сервер
    } else {
        qWarning() << "No saved login found.";
    }
}

// ----------- Изменение почты -----------

void AuthUser::changeEmail(const QString &email)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();
    qDebug() << "changeEmail called with:";
    qDebug() << "  email:" << email;

    QJsonObject json;
    json["login"] = savedLogin;
    json["email"] = email.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl("http://192.168.30.184:8080/changemail");
    sendEmailChangeRequest(jsonDoc, serverUrl);
}

void AuthUser::sendEmailChangeRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendEmailChangeRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (email change):" << data;

    QNetworkReply *reply = m_networkManager.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onEmailChangeReply(reply);
    });
}

void AuthUser::onEmailChangeReply(QNetworkReply *reply)
{
    qDebug() << "onEmailChangeReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Email change successful. Server response:" << reply->readAll();
        emit emailChangeSuccess();
    } else {
        qDebug() << "Email change failed. Error:" << reply->errorString();
        emit emailChangeFailed(reply->errorString());
    }
    reply->deleteLater();
}


// ----------- Общий метод отправки (используется для регистрации) -----------
void AuthUser::sendToServer(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendToServer called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (register):" << data;

    m_networkManager.post(request, data);
}
