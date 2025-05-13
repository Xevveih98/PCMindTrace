#ifndef APPCONFIG_H
#define APPCONFIG_H

#include <QString>

class AppConfig {
public:
    static QString serverUrl() {
        return "http://localhost:8080";
    }
};

#endif // APPCONFIG_H
