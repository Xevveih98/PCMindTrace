#include "AppSave.h"

AppSave::AppSave(QObject *parent)
    : QObject(parent), settings("MyOrg", "MyApp") {}

bool AppSave::isUserLoggedIn() const {
    return settings.contains("login");
}

QString AppSave::getSavedLogin() const {
    return settings.value("login").toString();
}

void AppSave::saveLogin(const QString &login) {
    settings.setValue("login", login);
}

void AppSave::clearLogin() {
    settings.remove("login");
}
