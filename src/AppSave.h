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

private:
    QSettings settings;
};

#endif // APPSAVE_H
