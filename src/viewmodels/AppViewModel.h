// src/viewmodels/AppViewModel.h
#ifndef APPVIEWMODEL_H
#define APPVIEWMODEL_H

#include <QObject>

class AppViewModel : public QObject
{
    Q_OBJECT
public:
    explicit AppViewModel(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void switchToAuth() {
        emit changeScreen("qrc:/pages/AuthWindow.qml");
    }

    Q_INVOKABLE void switchToMain() {
        emit changeScreen("qrc:/pages/mainContent.qml");
    }

signals:
    void changeScreen(const QString &newPage);
};

#endif // APPVIEWMODEL_H
