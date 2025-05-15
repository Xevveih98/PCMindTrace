#include "EntriesUser.h"
#include "AppConfig.h"
#include "AppSave.h"

EntriesUser::EntriesUser(QObject *parent) : QObject(parent) {}

void EntriesUser::saveEntry(const EntryUser &entry)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Сохранение записи вызвано пользователем:" << login;

    QJsonObject json = entry.toJson();
    json["login"] = login;

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/saveentry");

    sendEntrySaveRequest(jsonDoc, serverUrl);
}

void EntriesUser::sendEntrySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendEntrySaveRequest вызван.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (сохранение записи):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onEntrySaveReply(reply);
    });
}

void EntriesUser::onEntrySaveReply(QNetworkReply *reply)
{
    qDebug() << "onEntrySaveReply вызван.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Запись успешно сохранена. Ответ сервера:" << reply->readAll();
        emit entrySavedSuccess();
        loadUserEntries();
    } else {
        qWarning() << "Ошибка при сохранении записи:" << reply->errorString();
        emit entrySavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

void EntriesUser::loadUserEntries()
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Выгружаем записи для пользователя:" << login;

    QUrl serverUrl = AppConfig::apiUrl("/getuserentries");
    QUrlQuery query;
    query.addQueryItem("login", login);
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserEntryFetchReply(reply);
    });
}

void EntriesUser::onUserEntryFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserEntryFetchReply вызван.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Entries loaded successfully. Server response:" << QString::fromUtf8(response);

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

        if (!doc.isArray()) {
            qWarning() << "Invalid JSON format: expected array.";
            emit entriesLoadedFailed("Invalid JSON format.");
            reply->deleteLater();
            return;
        }

        QJsonArray entryArray = doc.array();
        QList<EntryUser> entries;

        for (const QJsonValue &val : entryArray) {
            QJsonObject obj = val.toObject();
            entries.append(EntryUser::fromJson(obj));
        }

        qDebug() << "Parsed entries count:" << entries.count();
        emit entriesLoadedSuccess(entries);
    } else {
        qWarning() << "Failed to load user entries. Error:" << reply->errorString();
        emit entriesLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}
