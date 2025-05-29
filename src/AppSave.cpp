#include "AppSave.h"

AppSave::AppSave(QObject *parent)
    : QObject(parent), settings("MyOrg", "MyApp") {}

bool AppSave::isUserLoggedIn() const {
    return settings.contains("login");
}

QString AppSave::getSavedLogin() const {
    return settings.value("login").toString().trimmed();
}

void AppSave::saveUser(const QString &login, const QString &email) {
    settings.setValue("login", login.trimmed());
    settings.setValue("email", email.trimmed());
}

void AppSave::clearUser() {
    settings.remove("login");
    settings.remove("email");
}

QString AppSave::getSavedEmail() const {
    return settings.value("email").toString().trimmed();
}

void AppSave::saveSwitchState(bool checked) {
    settings.setValue("customSwitchState", checked);
}

bool AppSave::loadSwitchState() const {
    return settings.value("customSwitchState", false).toBool();
}

void AppSave::clearSwitchState() {
    settings.remove("customSwitchState");
}

void AppSave::savePinCode(const QString pin) {
    settings.setValue("PinCode", pin);
}

QString AppSave::loadPinCode() const {
    return settings.value("PinCode", "").toString();
}

void AppSave::clearPinCode() {
    settings.remove("PinCode");
}

bool AppSave::isUserHasPinCode() const {
    return settings.contains("PinCode");
}
