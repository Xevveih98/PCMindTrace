#include "AuthUser.h"
#include "AppSave.h"
#include "AppConfig.h"

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
    QUrl serverUrl = AppConfig::apiUrl("/register");
    sendToServer(jsonDoc, serverUrl);
}

void AuthUser::onRegistrationReply(QNetworkReply *reply)
{
    QByteArray responseData = reply->readAll();
    int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    qDebug() << "onRegistrationReply called.";
    qDebug() << "HTTP status code:" << statusCode;
    qDebug() << "Server response:" << responseData;

    if (statusCode == 200) {
        emit registrationSuccess();
    } else if (statusCode == 409) {
        emit registrationFailed(QStringLiteral("*Пользователь с таким логином уже существует"));
    } else {
        emit registrationFailed(QString::fromUtf8(responseData));
    }

    reply->deleteLater();
}


// ----------- Вход (Login) -----------

void AuthUser::loginUser(const QString &login, const QString &password)
{
    qDebug() << "loginUser called with:";
    qDebug() << "  login:" << login.trimmed();
    qDebug() << "  password:" << password.trimmed();

    QUrl serverUrl = AppConfig::apiUrl("/login");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;
    json["login"] = login.trimmed();
    json["password"] = password.trimmed();

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkManager.post(request, data);
}

void AuthUser::onLoginReply(QNetworkReply *reply)
{
    qDebug() << "Обработка ответа на запрос авторизации.";

    QString path = reply->request().url().path();
    QByteArray responseData = reply->readAll();
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "Ошибка парсинга JSON при авторизации:" << parseError.errorString();
        emit loginFailed("Неверный ответ сервера: " + parseError.errorString(), "");
        reply->deleteLater();
        return;
    }

    if (!jsonDoc.isObject()) {
        qWarning() << "Неверный формат JSON: ожидался объект.";
        emit loginFailed("Неверный формат ответа сервера.", "");
        reply->deleteLater();
        return;
    }

    QJsonObject json = jsonDoc.object();

    bool success = json.value("success").toBool(false);
    QString loginError = json.value("loginError").toString("");
    QString passwordError = json.value("passwordError").toString("");

    if (success) {
        QString login = json.value("login").toString("");
        QString email = json.value("email").toString("");

        if (login.isEmpty() || email.isEmpty()) {
            qWarning() << "Отсутствуют обязательные поля login или email в успешном ответе.";
            emit loginFailed("Некорректный ответ сервера.", "");
            reply->deleteLater();
            return;
        }

        AppSave appSave;
        appSave.saveUser(login, email);

        emit loginSuccess();
    } else {
        emit loginFailed(loginError, passwordError);
    }

    reply->deleteLater();
}


// ----------- Смена пароля -----------

void AuthUser::changePassword(const QString &oldPassword, const QString &newPassword)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Изменение пароля для пользователя " << login.trimmed() <<" with:";
    qDebug() << "  oldPassword:" << oldPassword.trimmed();
    qDebug() << "  newPassword:" << newPassword.trimmed();

    QUrl serverUrl = AppConfig::apiUrl("/changepassword");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;
    json["login"] = login.trimmed();
    json["oldPassword"] = oldPassword.trimmed();
    json["newPassword"] = newPassword.trimmed();

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkManager.post(request, data);
}

void AuthUser::onPasswordChangeReply(QNetworkReply *reply)
{
    qDebug() << "onPasswordChangeReply called.";

    QByteArray responseData = reply->readAll();
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "Ошибка парсинга JSON при смене пароля:" << parseError.errorString();
        emit passwordChangeFailed("Неверный ответ сервера: " + parseError.errorString());
        reply->deleteLater();
        return;
    }

    if (!jsonDoc.isObject()) {
        qWarning() << "Неверный формат JSON: ожидался объект.";
        emit passwordChangeFailed("Неверный формат ответа сервера.");
        reply->deleteLater();
        return;
    }

    QJsonObject json = jsonDoc.object();
    QString status = json.value("status").toString();
    QString message = json.value("message").toString("Неизвестная ошибка");

    if (status == "ok") {
        qDebug() << "Password change successful:" << message;
        emit passwordChangeSuccess();
    } else {
        qWarning() << "Password change failed:" << message;
        emit passwordChangeFailed(message);
    }

    reply->deleteLater();
}


// ----------- Удаление аккаунта -----------

void AuthUser::triggerSendSavedLogin()
{
    qDebug() << "triggerSendSavedLogin called.";
    sendSavedLoginToServer();

}

void AuthUser::sendSavedLoginToServer()
{
    AppSave appSave;
    if (appSave.isUserLoggedIn()) {
        QString savedLogin = appSave.getSavedLogin();
        QJsonObject json;
        json["login"] = savedLogin;

        QJsonDocument jsonDoc(json);
        QUrl serverUrl = AppConfig::apiUrl("/deleteuser");
        sendToServer(jsonDoc, serverUrl);
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
    qDebug() << "  login:" << savedLogin;
    qDebug() << "  email:" << email.trimmed();

    QUrl serverUrl = AppConfig::apiUrl("/changemail");
    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;
    json["login"] = savedLogin;
    json["email"] = email.trimmed();

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkManager.post(request, data);
}


void AuthUser::onEmailChangeReply(QNetworkReply *reply)
{
    qDebug() << "Обработка ответа на запрос смены email.";

    QString path = reply->request().url().path();

    if (!path.contains("/changemail")) {
        qWarning() << "Неизвестный путь в onEmailChangeReply:" << path;
        reply->deleteLater();
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Ошибка сети при смене email:" << reply->errorString();
        emit emailChangeFailed(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    qDebug() << "Ответ сервера на смену email:" << responseData;

    if (responseData.isEmpty()) {
        qWarning() << "Пустой ответ от сервера при смене email.";
        emit emailChangeFailed(reply->errorString());
        reply->deleteLater();
        return;
    }

    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData, &parseError);
    QJsonObject json = jsonDoc.object();
    QString email = json.value("email").toString().trimmed();

    if (email.isEmpty()) {
        qWarning() << "Отсутствует поле email в ответе сервера при смене email.";
        emit emailChangeFailed(reply->errorString());
        reply->deleteLater();
        return;
    }

    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();
    appSave.clearUser();
    appSave.saveUser(savedLogin, email);

    emit emailChangeSuccess();

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
