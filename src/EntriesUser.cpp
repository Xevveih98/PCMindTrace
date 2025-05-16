#include "EntriesUser.h"
#include "AppConfig.h"
#include "AppSave.h"

EntriesUser::EntriesUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Network reply received from:" << endpoint.toString();

        if (endpoint.path().contains("/saveentry")) {
            onEntrySaveReply(reply);
        } else if (endpoint.path().contains("/getuserentries")) {
            onUserEntryFetchReply(reply);
        } else {
            qWarning() << "Unhandled endpoint in EntriesUser:" << endpoint.toString();
            reply->deleteLater();
        }
    });

    m_entryUserModel = new EntryUserModel(this);
    qDebug() << "EntriesUser initialized and connected to network manager.";
}

//--------------------- получение данных из кюмель-----------------------------


void EntriesUser::saveEntryFromQml(const QVariant &entryDataVariant)
{
    QVariantMap entryData = entryDataVariant.toMap();

    QString title = entryData.value("title").toString();
    QString content = entryData.value("content").toString();
    QString dateStr = entryData.value("date").toString(); // формат "yyyy-MM-dd"
    int moodId = entryData.value("moodId").toInt();
    int folderId = entryData.value("folder").toInt();

    // Парсим дату
    QDate date = QDate::fromString(dateStr, Qt::ISODate);
    if (!date.isValid()) {
        qWarning() << "Invalid date format:" << dateStr << ", using current date.";
        date = QDate::currentDate();
    }

    QTime time = QTime::currentTime(); // время записи текущее

    // Вспомогательная функция для конвертации QList<int> -> QVector<UserItem>
    auto convertIdsToUserItems = [](const QVariantList &idList) -> QVector<UserItem> {
        QVector<UserItem> items;
        for (const QVariant &v : idList) {
            int id = v.toInt();
            if (id > 0) {
                UserItem item;
                item.id = id;
                item.iconId = 0;  // если иконка нужна, подставь логику
                item.label = "";  // если нужно, можно расширить, но из QML приходит только id
                items.append(item);
            }
        }
        return items;
    };

    QVector<UserItem> tags = convertIdsToUserItems(entryData.value("tags").toList());
    QVector<UserItem> activities = convertIdsToUserItems(entryData.value("activities").toList());
    QVector<UserItem> emotions = convertIdsToUserItems(entryData.value("emotions").toList());

    // Добавим логирование содержимого
    qInfo() << "Количество тегов:" << tags.size();
    for (const auto &tag : tags) {
        qInfo() << "  tag id:" << tag.id;
    }

    qInfo() << "Количество активностей:" << activities.size();
    for (const auto &act : activities) {
        qInfo() << "  activity id:" << act.id;
    }

    qInfo() << "Количество эмоций:" << emotions.size();
    for (const auto &emo : emotions) {
        qInfo() << "  emotion id:" << emo.id;
    }

    QString currentUserLogin = AppSave().getSavedLogin(); // <-- подставь актуальный логин пользователя

    EntryUser entry(
        0,
        currentUserLogin,
        title,
        content,
        moodId,
        folderId,
        date,
        time,
        tags,
        activities,
        emotions
        );

    saveEntry(entry);
}

//--------------------------- сохранение записей ------------------------------

void EntriesUser::saveEntry(const EntryUser &entry)
{
    QString login = entry.getUserLogin();
    if (login.isEmpty()) {
        qWarning() << "No user login set for entry save!";
        return;
    }

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

//------------------------- загрузка записей ------------------------------

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

        if (!doc.isObject()) {
            qWarning() << "Invalid JSON format: expected object with 'entries' array.";
            emit entriesLoadedFailed("Invalid JSON format.");
            reply->deleteLater();
            return;
        }

        QJsonObject rootObj = doc.object();
        if (!rootObj.contains("entries") || !rootObj.value("entries").isArray()) {
            qWarning() << "JSON missing 'entries' array.";
            emit entriesLoadedFailed("Missing 'entries' array in JSON.");
            reply->deleteLater();
            return;
        }

        QJsonArray entryArray = rootObj.value("entries").toArray();
        QList<EntryUser> entries;

        for (const QJsonValue &val : entryArray) {
            if (!val.isObject()) {
                qWarning() << "Invalid entry JSON format, expected object.";
                continue;
            }
            QJsonObject obj = val.toObject();
            entries.append(EntryUser::fromJson(obj));
        }

        qDebug() << "Parsed entries count:" << entries.count();

        m_entryUserModel->setEntries(entries);

        emit entriesLoadedSuccess(entries);
    } else {
        qWarning() << "Failed to load user entries. Error:" << reply->errorString();
        emit entriesLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}

EntryUserModel* EntriesUser::entryUserModel() const
{
    return m_entryUserModel;
}
