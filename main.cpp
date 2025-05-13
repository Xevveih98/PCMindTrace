#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QSqlError>
#include <QDebug>
#include <QFile>
#include <QQmlContext>
#include "src/AuthUser.h"
#include "src/AppSave.h"
#include "src/TodoUser.h"
#include "src/CategoriesUser.h"
#include "src/FoldersUser.h"
#include "src/CustomComponentsSingleton.h"
#include "models/EntryModel.h""

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
    qmlRegisterSingletonType<CustomComponentsSingleton>("CustomComponents", 1, 0, "CustomComponents",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            return CustomComponentsSingleton::instance();
    });

    AuthUser authUser;
    TodoUser todoUser;
    CategoriesUser categoriesUser;
    FoldersUser foldersUser;
    EntryModel entryModel;
    engine.rootContext()->setContextProperty("entryModel", &entryModel);
    engine.rootContext()->setContextProperty("authUser", &authUser);
    engine.rootContext()->setContextProperty("todoUser", &todoUser);
    engine.rootContext()->setContextProperty("categoriesUser", &categoriesUser);
    engine.rootContext()->setContextProperty("foldersUser", &foldersUser);

    engine.addImportPath("qrc:/");
    engine.loadFromModule("PCMindTrace", "Main");

    return app.exec();
}
