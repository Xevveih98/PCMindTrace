// model/usermodel.cpp
#include "UserModel.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include <QDebug>

namespace {
QString hashPassword(const QString &password) {
    return QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());
}
}

bool UserModel::registerUser(const QString &login, const QString &email, const QString &password) {
    QSqlQuery query;
    query.prepare("INSERT INTO users (user_login, user_email, user_passhach) "
                  "VALUES (?, ?, ?)");
    query.addBindValue(login);
    query.addBindValue(email);
    query.addBindValue(hashPassword(password));
    return query.exec();
}

bool UserModel::loginUser(const QString &login, const QString &password) {
    QSqlQuery query;
    query.prepare("SELECT id FROM users WHERE user_login = ? AND user_passhach = ?");
    query.addBindValue(login);
    query.addBindValue(hashPassword(password));
    if (query.exec() && query.next()) {
        // Обновим user_status
        logoutAll(); // Сбросим все статусы
        QSqlQuery update;
        update.prepare("UPDATE users SET user_status = 1 WHERE user_login = ?");
        update.addBindValue(login);
        return update.exec();
    }
    return false;
}

bool UserModel::recoverPassword(const QString &email, const QString &newPassword) {
    QSqlQuery query;
    query.prepare("UPDATE users SET user_passhach = ? WHERE user_email = ?");
    query.addBindValue(hashPassword(newPassword));
    query.addBindValue(email);
    return query.exec();
}

bool UserModel::isUserLoggedIn() {
    QSqlQuery query("SELECT 1 FROM users WHERE user_status = 1");
    return query.exec() && query.next();
}

void UserModel::logoutAll() {
    QSqlQuery query("UPDATE users SET user_status = 0");
    query.exec();
}
