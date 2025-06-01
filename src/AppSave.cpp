#include "AppSave.h"

AppSave::AppSave(QObject *parent)
    : QObject(parent), settings("MyOrg", "MyApp") {}

bool AppSave::isUserLoggedIn() const {
    return settings.contains("login");
}

QString AppSave::getSavedLogin() const {
    return settings.value("login").toString().trimmed();
}

void AppSave::saveLogin(const QString &login) {
    settings.setValue("login", login.trimmed());
    settings.sync();
}

void AppSave::saveEmail(const QString &email) {
    settings.setValue("email", email.trimmed());
    settings.sync();
}

void AppSave::saveUser(const QString &login, const QString &email) {
    saveLogin(login);
    if (!email.isEmpty()) {
        saveEmail(email);
    }
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
    settings.sync();
}

bool AppSave::loadSwitchState() const {
    return settings.value("customSwitchState", false).toBool();
}

void AppSave::clearSwitchState() {
    settings.remove("customSwitchState");
}

void AppSave::savePinCode(const QString &pin) {
    if (!pin.isEmpty()) {
        settings.setValue("PinCode", pin);
        settings.setValue("customSwitchState", true);
        settings.sync();
    } else {
        qWarning() << "Попытка сохранить пустой пинкод.";
    }
}

QString AppSave::loadPinCode() const {
    return settings.value("PinCode").toString();
}

bool AppSave::isUserHasPinCode() const {
    return settings.contains("PinCode") && !settings.value("PinCode").toString().isEmpty();
}

void AppSave::clearPinCode() {
    settings.remove("PinCode");
    settings.setValue("customSwitchState", false);
    settings.sync();
}

void AppSave::saveAvatarId(int avatarId) {
    settings.setValue("avatarId", avatarId);
    settings.sync();
}

int AppSave::getSavedAvatarId() const {
    return settings.value("avatarId", 1).toInt();
}

void AppSave::clearAvatarId() {
    settings.remove("avatarId");
}

void AppSave::setValue(const QString &key, const QVariant &value)
{
    settings.setValue(key, value);
}

QVariant AppSave::value(const QString &key, const QVariant &defaultValue)
{
    return settings.value(key, defaultValue);
}
void AppSave::removeValue(const QString &key)
{
    settings.remove(key);
}
