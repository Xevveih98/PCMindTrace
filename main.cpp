#include <QApplication>
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
#include "src/EntryUserModel.h"
#include "src/EntriesUser.h"
#include "src/ComputeUser.h"
#include "src/vibrationutils.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

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
    EntriesUser entriesUser;
    EntryUserModel entryUserModel;
    ComputeUser computeUser;
    VibrationUtils vibra;
    engine.rootContext()->setContextProperty("VibrationUtils", &vibra);
    engine.rootContext()->setContextProperty("entryCurrentMonthModel", computeUser.entryCurrentMonthModel());
    engine.rootContext()->setContextProperty("entryLastMonthModel", computeUser.entryLastMonthModel());
    engine.rootContext()->setContextProperty("computeUser", &computeUser);
    engine.rootContext()->setContextProperty("dateSearchModel", entriesUser.dateSearchModel());
    engine.rootContext()->setContextProperty("entryUserModel", &entryUserModel);
    engine.rootContext()->setContextProperty("entriesUser", &entriesUser);
    engine.rootContext()->setContextProperty("authUser", &authUser);
    engine.rootContext()->setContextProperty("todoUser", &todoUser);
    engine.rootContext()->setContextProperty("categoriesUser", &categoriesUser);
    engine.rootContext()->setContextProperty("foldersUser", &foldersUser);

    engine.addImportPath("qrc:/");
    engine.loadFromModule("PCMindTrace", "Main");

    return app.exec();
}
