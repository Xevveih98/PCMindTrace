#include "AuthUser.h"
#include <QDebug>

AuthUser::AuthUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkManager, &QNetworkAccessManager::finished,
            this, &AuthUser::onRegistrationReply);

    qDebug() << "AuthUser initialized and connected to network manager.";
}

void AuthUser::registerUser(const QString &login, const QString &email, const QString &password)
{
    qDebug() << "registerUser called with:";
    qDebug() << "  login:" << login;
    qDebug() << "  email:" << email;
    qDebug() << "  password:" << password;

    QJsonObject json;
    json["login"] = login;
    json["email"] = email;
    json["password"] = password;

    qDebug() << "QJsonObject created:" << json;

    QJsonDocument jsonDoc(json);
    qDebug() << "QJsonDocument created:" << jsonDoc.toJson(QJsonDocument::Compact);

    QUrl serverUrl("http://192.168.46.184:8080/register");
    qDebug() << "Sending data to URL:" << serverUrl.toString();

    sendToServer(jsonDoc, serverUrl);
}

void AuthUser::sendToServer(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendToServer called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload:" << data;

    m_networkManager.post(request, data);
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
