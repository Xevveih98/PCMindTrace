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

    if (!path.contains("/login")) {
        qWarning() << "Неизвестный путь в onLoginReply:" << path;
        reply->deleteLater();
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Ошибка сети при авторизации:" << reply->errorString();
        emit loginFailed("Ошибка сети: " + reply->errorString(), "");
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    qDebug() << "Raw response data from server:" << responseData;


    if (responseData.isEmpty()) {
        qWarning() << "Пустой ответ от сервера при авторизации.";
        emit loginFailed("Пустой ответ от сервера.", "");
        reply->deleteLater();
        return;
    }

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
    QUrl serverUrl = AppConfig::apiUrl("/changepassword");
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
        QUrl serverUrl = AppConfig::apiUrl("/deleteuser");  // Замените на правильный URL
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

    // if (parseError.error != QJsonParseError::NoError) {
    //     qWarning() << "Ошибка парсинга JSON при смене email:" << parseError.errorString();
    //     emit emailChangeFailed(reply->errorString());
    //     reply->deleteLater();
    //     return;
    // }

    // if (!jsonDoc.isObject()) {
    //     qWarning() << "Неверный формат JSON: ожидался объект при смене email.";
    //     emit emailChangeFailed(reply->errorString());
    //     reply->deleteLater();
    //     return;
    // }

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
