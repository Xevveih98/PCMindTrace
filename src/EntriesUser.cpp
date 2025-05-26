#include "EntriesUser.h"
#include "AppConfig.h"
#include "AppSave.h"

EntriesUser::EntriesUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        //qDebug() << "Network reply received from:" << endpoint.toString();

        if (endpoint.path().contains("/saveentry")) {
            onEntrySaveReply(reply);
        } else if (endpoint.path().contains("/getuserentries")) {
            onUserEntryFetchReply(reply);
        } else if (endpoint.path().contains("/searchentriesbywords")) {
            onUserEntryFetchReply(reply);
        } else if (endpoint.path().contains("/searchentriesbytags")) {
            onUserEntryFetchReply(reply);
        } else if (endpoint.path().contains("/searchentriesbydate")) {
            onUserEntryFetchReply(reply);
        } else if (endpoint.path().contains("/getmoodidies")) {
            onUserMoodIdsFetchReply(reply);
        } else {
            qWarning() << "Unhandled endpoint in EntriesUser:" << endpoint.toString();
            reply->deleteLater();
        }
    });

    m_entryUserModel = new EntryUserModel(this);
    m_searchModel = new EntryUserModel(this);
    m_dateSearchModel = new EntryUserModel(this);
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
    } else {
        qWarning() << "Ошибка при сохранении записи:" << reply->errorString();
        emit entrySavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

//------------------------- загрузка записей (дата и папка)------------------------------

void EntriesUser::loadUserEntries(int folderId, int year, int month)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Выгружаем записи для пользователя:" << login
             << " | Папка ID:" << folderId
             << " | Год:" << year
             << " | Месяц:" << month;

    QUrl serverUrl = AppConfig::apiUrl("/getuserentries");
    QUrlQuery query;
    query.addQueryItem("login", login);
    query.addQueryItem("folderId", QString::number(folderId));
    query.addQueryItem("year", QString::number(year));
    query.addQueryItem("month", QString::number(month));
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.get(request);
}

void EntriesUser::onUserEntryFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserEntryFetchReply вызван.";

    QString path = reply->request().url().path();
    EntryUserModel* targetModel = nullptr;

    if (path.contains("/getuserentries")) {
        targetModel = m_entryUserModel;
    } else if (path.contains("/searchentriesbywords") || path.contains("/searchentriesbytags")) {
        targetModel = m_searchModel;
    } else if (path.contains("/searchentriesbydate")) {
        targetModel = m_dateSearchModel;
    } else {
        qWarning() << "Unknown path in onUserEntryFetchReply:" << path;
        reply->deleteLater();
        return;
    }

    if (reply->error() == QNetworkReply::NoError) {
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

        targetModel->setEntries(entries);  // <--- В выбранную модель

        emit entriesLoadedSuccess(entries);

    } else {
        qWarning() << "Failed to load user entries. Error:" << reply->errorString();
        emit entriesLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}


//-------------------- загрузка записей (ключевые слова и теги) ----------------------------

void EntriesUser::loadUserEntriesByKeywords(const QStringList &keywords)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Ищем записи для пользователя:" << login
             << " | По ключевым словам:" << keywords;

    QUrl serverUrl = AppConfig::apiUrl("/searchentriesbywords");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Формируем JSON-объект
    QJsonObject json;
    json["login"] = login;

    QJsonArray keywordArray;
    for (const QString &word : keywords) {
        keywordArray.append(word);
    }
    json["keywords"] = keywordArray;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkUser.post(request, data);
}

void EntriesUser::loadUserEntriesByTags(const QList<int> &tagIds)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Ищем записи для пользователя:" << login
             << " | По тегам:" << tagIds;

    QUrl serverUrl = AppConfig::apiUrl("/searchentriesbytags");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Формируем JSON-объект
    QJsonObject json;
    json["login"] = login;

    QJsonArray tagsArray;
    for (int tagId : tagIds) {
        tagsArray.append(tagId);
    }
    json["tag_ids"] = tagsArray;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkUser.post(request, data);
}

//--------------------------------- загрзука записей (дата) ------------------------

void EntriesUser::loadUserEntriesByDate(const QString &date)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Ищем записи для пользователя:" << login
             << " | По дате:" << date;

    QUrl serverUrl = AppConfig::apiUrl("/searchentriesbydate");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject json;
    json["login"] = login;
    json["date"] = date;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkUser.post(request, data);
}

//------------------------------ загрузка настроения -------------------------------

void EntriesUser::loadUserEntriesMoodIdies(const QString &date)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Ищем записи для пользователя:" << login
             << " | По дате:" << date;

    QUrl serverUrl = AppConfig::apiUrl("/getmoodidies");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject json;
    json["login"] = login;
    json["date"] = date;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QNetworkReply *reply = m_networkUser.post(request, data);
}

void EntriesUser::onUserMoodIdsFetchReply(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        emit moodIdsLoadFailed(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray response = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    if (!doc.isObject()) {
        emit moodIdsLoadFailed("Invalid JSON format");
        reply->deleteLater();
        return;
    }

    QJsonArray moodIdsArray = doc.object().value("moodIds").toArray();
    QString date = doc.object().value("date").toString();
    QList<int> moodIds;
    for (const auto &val : moodIdsArray) {
        if (val.isDouble())
            moodIds.append(val.toInt());
    }
    emit moodIdsLoadSuccess(moodIds, date);
    reply->deleteLater();
}


//-------------------------- удаление и изменение записи --------------------------

void EntriesUser::deleteUserEntry(int entryId)
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();

    QJsonObject json;
    json["id"] = entryId;
    json["login"] = login;

    qDebug() << "клиент айди" << entryId;

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/deleteentry");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.post(request, jsonDoc.toJson());

    connect(reply, &QNetworkReply::finished, this, [=]() {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug() << "Entry deleted successfully with ID:" << entryId;
            if (m_dateSearchModel->removeEntryById(entryId)) {
                qDebug() << "Entry removed from local model.";
                emit entryDeleted(entryId);
                emit entryDeletedSucc();
            } else {
                qWarning() << "Entry ID not found in local model.";
            }

        } else {
            qWarning() << "Failed to delete entry:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void EntriesUser::updateEntryFromQml(const QVariant &entryDataVariant)
{
    QVariantMap entryData = entryDataVariant.toMap();

    int id = entryData.value("id", -1).toInt();
    if (id < 0) {
        qWarning() << "Invalid entry id for update!";
        return;
    }

    QString title = entryData.value("title").toString();
    QString content = entryData.value("content").toString();
    QString dateStr = entryData.value("date").toString();
    int moodId = entryData.value("moodId").toInt();
    int folderId = entryData.contains("folder") ? entryData.value("folder").toInt() : -1;

    // Парсим дату
    QDate date = QDate::fromString(dateStr, Qt::ISODate);
    if (!date.isValid()) {
        qWarning() << "Invalid date format:" << dateStr << ", using current date.";
        date = QDate::currentDate();
    }

    QTime time = QTime::currentTime();

    auto convertIdsToUserItems = [](const QVariantList &idList) -> QVector<UserItem> {
        QVector<UserItem> items;
        for (const QVariant &v : idList) {
            int id = v.toInt();
            if (id > 0) {
                UserItem item;
                item.id = id;
                item.iconId = 0;
                item.label = "";
                items.append(item);
            }
        }
        return items;
    };

    QVector<UserItem> tags = convertIdsToUserItems(entryData.value("tags").toList());
    QVector<UserItem> activities = convertIdsToUserItems(entryData.value("activities").toList());
    QVector<UserItem> emotions = convertIdsToUserItems(entryData.value("emotions").toList());

    QString currentUserLogin = AppSave().getSavedLogin();

    EntryUser entry(
        id,
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

    updateEntry(entry);
}

void EntriesUser::updateEntry(const EntryUser &entry)
{
    QString login = entry.getUserLogin();
    if (login.isEmpty()) {
        qWarning() << "No user login set for entry update!";
        return;
    }

    QJsonObject json = entry.toJson();
    json["login"] = login;
    json["id"] = entry.getId();

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    QUrl serverUrl = AppConfig::apiUrl("/updateentry");

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.post(request, data);

    connect(reply, &QNetworkReply::finished, this, [reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            qInfo() << "Entry updated successfully.";
        } else {
            qWarning() << "Failed to update entry:" << reply->errorString();
        }
        reply->deleteLater();
    });
}


//--------------------------------------------- геттеры ----------------------------

EntryUserModel* EntriesUser::entryUserModel() const
{
    return m_entryUserModel;
}

EntryUserModel* EntriesUser::searchModel() const
{
    return m_searchModel;
}

EntryUserModel* EntriesUser::dateSearchModel() const
{
    return m_dateSearchModel;
}

void EntriesUser::clearSearchModel() {
    if (m_searchModel) {
        m_searchModel->clear();
        emit searchModelChanged();
    }
}

void EntriesUser::clearDateSearchModel() {
    if (m_dateSearchModel) {
        m_dateSearchModel->clear();
        emit dateSearchModelChanged();
    }
}
