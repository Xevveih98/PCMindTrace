#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QSqlError>
#include <QDebug>
#include <QFile>

bool connectToDatabase()
{
    QString dbPath = QCoreApplication::applicationDirPath() + "/../../src/db/mindtracedb.db";

    if (!QFile::exists(dbPath)) {
        qCritical() << "Database file not found at:" << dbPath;
        return false;
    }

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbPath);

    if (!db.open()) {
        qCritical() << "Failed to open database:" << db.lastError().text();
        return false;
    }

    qDebug() << "Database connected successfully at:" << dbPath;
    return true;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    if (!connectToDatabase()) {
        return -1;
    }

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("PCMindTrace", "Main");

    return app.exec();
}
