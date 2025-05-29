#ifndef APPSAVE_H
#define APPSAVE_H

#include <QObject>
#include <QSettings>

class AppSave : public QObject {
    Q_OBJECT
public:
    explicit AppSave(QObject *parent = nullptr);

    Q_INVOKABLE bool isUserLoggedIn() const;

    Q_INVOKABLE QString getSavedLogin() const;
    Q_INVOKABLE QString getSavedEmail() const;

    Q_INVOKABLE void saveUser(const QString &login, const QString &email);
    Q_INVOKABLE void clearUser();

    Q_INVOKABLE void saveSwitchState(bool checked);
    Q_INVOKABLE bool loadSwitchState() const;
    Q_INVOKABLE void clearSwitchState();

    Q_INVOKABLE void savePinCode(const QString pin);
    Q_INVOKABLE QString loadPinCode() const;
    Q_INVOKABLE void clearPinCode();
    Q_INVOKABLE bool isUserHasPinCode() const;

private:
    QSettings settings;
};

#endif // APPSAVE_H
