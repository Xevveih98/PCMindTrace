#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QSqlError>
#include <QDebug>
#include <QFile>
#include <QQmlContext>
#include "src/AuthUser.h"
#include "src/AppSave.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterSingletonInstance("PCMindTrace", 1, 0, "AppSave", new AppSave);
    AuthUser authUser;
    engine.rootContext()->setContextProperty("authUser", &authUser);

    engine.addImportPath("qrc:/");
    engine.loadFromModule("PCMindTrace", "Main");

    return app.exec();
}
