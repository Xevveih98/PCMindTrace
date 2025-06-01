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
    Q_INVOKABLE void changePassword(const QString &oldPassword, const QString &newPassword);
    Q_INVOKABLE void changeEmail(const QString &email);
    Q_INVOKABLE void changeLogin(const QString &newlogin);
    Q_INVOKABLE void recoverPassword(const QString &email, const QString &newPassword);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void deleteUser();



signals:
    void registrationSuccess();
    void registrationFailed(const QString &error);

    void loginSuccess();
    void loginFailed(const QString &loginError, const QString &passwordError);

    void passwordChangeSuccess();
    void passwordChangeFailed(const QString &error);

    void passwordRecoverSuccess();
    void passwordRecoverFailed(const QString &error);

    void emailChangeSuccess();
    void emailChangeFailed(const QString &error);

    void logoutSuccess();
    void deleteUserSuccess();

    void loginChangeSuccess();
    void loginChangeFailed(const QString &error);


private slots:
    void onRegistrationReply(QNetworkReply *reply);
    void onLoginReply(QNetworkReply *reply);
    void onPasswordChangeReply(QNetworkReply *reply);
    void onEmailChangeReply(QNetworkReply *reply);
    void onLoginChangeReply(QNetworkReply *reply);
    void onPasswordRecoverReply(QNetworkReply *reply);


private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);

    QNetworkAccessManager m_networkManager;
};

#endif // AUTHUSER_H
