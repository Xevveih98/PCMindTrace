#ifndef AUTHUSER_H
#define AUTHUSER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QDebug>

class AuthUser : public QObject
{
    Q_OBJECT
public:
    explicit AuthUser(QObject *parent = nullptr);

    Q_INVOKABLE void registerUser(const QString &login, const QString &email, const QString &password);

signals:
    void registrationSuccess();
    void registrationFailed(const QString &error);

private slots:
    void onRegistrationReply(QNetworkReply *reply);

private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);

    QNetworkAccessManager m_networkManager;
};

#endif // AUTHUSER_H
