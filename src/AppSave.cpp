#include "AppSave.h"

AppSave::AppSave(QObject *parent)
    : QObject(parent), settings("MyOrg", "MyApp") {}

bool AppSave::isUserLoggedIn() const {
    return settings.contains("login");

}

QString AppSave::getSavedLogin() const {
    return settings.value("login").toString();
}

void AppSave::saveUser(const QString &login, const QString &email) {
    settings.setValue("login", login);
    settings.setValue("email", email);
}

void AppSave::clearUser() {
    settings.remove("login");
    settings.remove("Email");
}

QString AppSave::getSavedEmail() const {
    return settings.value("email").toString();
}

