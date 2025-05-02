// model/usermodel.h
#pragma once
#include <QString>
#include <QSqlDatabase>

class UserModel {
public:
    static bool registerUser(const QString &login, const QString &email, const QString &password);
    static bool loginUser(const QString &login, const QString &password);
    static bool recoverPassword(const QString &email, const QString &newPassword);
    static bool isUserLoggedIn();
    static void logoutAll();
};
