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
    Q_INVOKABLE void loginUser(const QString &login, const QString &password);
    Q_INVOKABLE void changePassword(const QString &email, const QString &newPassword, const QString &newPasswordCheck);
    Q_INVOKABLE void triggerSendSavedLogin();



signals:
    void registrationSuccess();
    void registrationFailed(const QString &error);

    void loginSuccess();
    void loginFailed(const QString &error);

    void passwordChangeSuccess();
    void passwordChangeFailed(const QString &error);


private slots:
    void onRegistrationReply(QNetworkReply *reply);
    void onLoginReply(QNetworkReply *reply);
    void onPasswordChangeReply(QNetworkReply *reply);


private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendLoginRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendPasswordChangeRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendSavedLoginToServer();

    QNetworkAccessManager m_networkManager;
};

#endif // AUTHUSER_H
