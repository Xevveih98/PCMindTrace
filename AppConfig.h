#ifndef APPCONFIG_H
#define APPCONFIG_H

#include <QString>
#include <QUrl>

class AppConfig {
public:
    static QUrl baseServerUrl() {
        return QUrl("http://192.168.30.184:8080");
    }

    static QUrl apiUrl(const QString& path) {
        return baseServerUrl().resolved(QUrl(path));
    }
};

#endif // APPCONFIG_H
