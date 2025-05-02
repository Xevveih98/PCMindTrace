// viewmodel/authviewmodel.h
#pragma once
#include <QObject>

class AuthViewModel : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE bool registerUser(const QString &login, const QString &email, const QString &password);
    Q_INVOKABLE bool loginUser(const QString &login, const QString &password);
    Q_INVOKABLE bool recoverPassword(const QString &email, const QString &newPass, const QString &newPassCheck);
    Q_INVOKABLE bool isUserLoggedIn();
    Q_INVOKABLE void logout();
};
