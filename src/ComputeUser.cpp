#include "ComputeUser.h"
#include "AppConfig.h"
#include "AppSave.h"

ComputeUser::ComputeUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Сетевой ответ в вычислительном модуле получен от:" << endpoint.toString();

        if (endpoint.path().contains("/loadentriesbymonth")) {
            onLoadEntriesByMonthReply(reply);
        } else {
            qWarning() << "Необработанный ответ в вычислительном модуле:" << endpoint.toString();
            reply->deleteLater();
        }
    });

    m_entryCurrentMonthModel = new EntryUserModel(this);
    m_entryLastMonthModel = new EntryUserModel(this);
    qDebug() << "Вычислительный модуль активен.";
}

// ---------------- загрузка записей за месяц (прошлый и текущий) --------------


void ComputeUser::loadEntriesByMonth(const QString &lastMonth, const QString &currentMonth)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Загружаем записи для пользователя:" << login
             << " | За прошлый месяц:" << lastMonth
             << " | За текущий месяц:" << currentMonth;

    QUrl serverUrl = AppConfig::apiUrl("/loadentriesbymonth");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject json;
    json["login"] = login;
    json["lastMonth"] = lastMonth;
    json["currentMonth"] = currentMonth;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();
    QNetworkReply *reply = m_networkUser.post(request, data);
}

void ComputeUser::onLoadEntriesByMonthReply(QNetworkReply *reply)
{
    qDebug() << "Загрузка записей в модели (прошлый и текущий месяц) вызван.";

    QString path = reply->request().url().path();

    if (!path.contains("/loadentriesbymonth")) {
        qWarning() << "Unknown path in onUserEntryFetchReply:" << path;
        reply->deleteLater();
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Failed to load entries. Error:" << reply->errorString();
        emit entriesLoadedFailed(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray response = reply->readAll();
    qDebug() << "Entries loaded successfully.";

    if (response.isEmpty()) {
        qWarning() << "Empty entry response received.";
        emit entriesLoadedFailed("Empty response from server.");
        reply->deleteLater();
        return;
    }

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(response, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error:" << parseError.errorString();
        emit entriesLoadedFailed("JSON parse error.");
        reply->deleteLater();
        return;
    }

    if (!doc.isObject()) {
        qWarning() << "Invalid JSON format: expected object.";
        emit entriesLoadedFailed("Invalid JSON format.");
        reply->deleteLater();
        return;
    }

    QJsonObject rootObj = doc.object();

    QList<EntryUser> entriesLast;
    QList<EntryUser> entriesCurrent;

    if (rootObj.contains("lastMonthEntries") && rootObj["lastMonthEntries"].isArray()) {
        QJsonArray lastArray = rootObj["lastMonthEntries"].toArray();
        for (const QJsonValue &val : lastArray) {
            if (!val.isObject()) continue;
            QJsonObject obj = val.toObject();
            entriesLast.append(EntryUser::fromJson(obj));
        }
    } else {
        qWarning() << "Missing or invalid 'lastMonthEntries'.";
    }

    if (rootObj.contains("currentMonthEntries") && rootObj["currentMonthEntries"].isArray()) {
        QJsonArray currentArray = rootObj["currentMonthEntries"].toArray();
        for (const QJsonValue &val : currentArray) {
            if (!val.isObject()) continue;
            QJsonObject obj = val.toObject();
            entriesCurrent.append(EntryUser::fromJson(obj));
        }
    } else {
        qWarning() << "Missing or invalid 'currentMonthEntries'.";
    }

    qDebug() << " | Получено записей прошлого месяца:" << entriesLast.count();
    qDebug() << " | Получено записей текущего месяца:" << entriesCurrent.count();

    m_entryLastMonthModel->setEntries(entriesLast);
    m_entryCurrentMonthModel->setEntries(entriesCurrent);

    emit entriesLoadedSuccess();

    reply->deleteLater();
}



//----------------- геттеры ------------------


EntryUserModel* ComputeUser::entryCurrentMonthModel() const
{
    return m_entryCurrentMonthModel;
}

EntryUserModel* ComputeUser::entryLastMonthModel() const
{
    return m_entryLastMonthModel;
}
