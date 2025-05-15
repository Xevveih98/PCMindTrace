#include "CategoriesUser.h"
#include "AppSave.h"
#include "AppConfig.h"

CategoriesUser::CategoriesUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Network reply received from:" << endpoint.toString();

        if (endpoint.path().contains("/savetags")) {
            onTagsSaveReply(reply);
        } else if (endpoint.path().contains("/getusertags")) {
            onUserTagsFetchReply(reply);
        } else if (endpoint.path().contains("/deletetag")) {
            onTagDeleteReply(reply);
        } else if (endpoint.path().contains("/saveactivity")) {
            onActivitySaveReply(reply);
        } else if (endpoint.path().contains("/getuseractivity")) {
            onUserActivitiesFetchReply(reply);
        } else if (endpoint.path().contains("/deleteactivity")) {
            onActivityDeleteReply(reply);
        } else {
            qWarning() << "Unhandled endpoint in CategoriesUser:" << endpoint.toString();
            reply->deleteLater();
        }
    });

    qDebug() << "CategoriesUser initialized and connected to network manager.";
}

// ----------- Сохранение тегов -----------

void CategoriesUser::saveTags(const QStringList &tags)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin().trimmed();

    qDebug() << "saveTags called with login:" << savedLogin;
    qDebug() << "tags:" << tags;

    QJsonObject json;
    json["login"] = savedLogin;

    QJsonArray jsonTags;
    for (const QString &tag : tags) {
        if (!tag.trimmed().isEmpty())
            jsonTags.append(tag.trimmed());
    }

    json["tags"] = jsonTags;

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/savetags");
    sendTagsSaveRequest(jsonDoc, serverUrl);
}

void CategoriesUser::sendTagsSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendTagsSaveRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (save tags):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onTagsSaveReply(reply);
    });
}

void CategoriesUser::onTagsSaveReply(QNetworkReply *reply)
{
    qDebug() << "onTagsSaveReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Tags saved successfully. Server response:" << reply->readAll();
        emit tagsSavedSuccess();
    } else {
        qWarning() << "Tags save failed. Error:" << reply->errorString();
        emit tagsSavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Выгрузка тегов -----------

void CategoriesUser::loadTags()
{
    AppSave appSave;
    QString login = appSave.getSavedLogin().trimmed();
    qDebug() << "Loading tags for login:" << login;
    QUrl serverUrl = AppConfig::apiUrl("/getusertags");
    QUrlQuery query;
    query.addQueryItem("login", login);
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Выполняем GET-запрос
    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserTagsFetchReply(reply);
    });
}

void CategoriesUser::onUserTagsFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserTagsFetchReply called.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Tags loaded successfully. Server response:" << response;

        if (response.isEmpty()) {
            qWarning() << "Empty response received, skipping.";
            reply->deleteLater();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonArray array = doc.object().value("tags").toArray();

        QStringList tags;
        for (const auto &val : array)
            tags << val.toString();

        emit tagsLoaded(tags);
    } else {
        qWarning() << "Failed to load tags. Error:" << reply->errorString();
        emit tagsLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}

// ----------- Удаление тегов -----------

void CategoriesUser::deleteTag(const QString &tag)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin().trimmed();

    qDebug() << "deleteTag called with login:" << savedLogin;
    qDebug() << "tag:" << tag;

    QJsonObject json;
    json["login"] = savedLogin;
    json["tag"] = tag.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/deletetag");
    sendTagDeleteRequest(jsonDoc, serverUrl);
}

void CategoriesUser::sendTagDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendTagDeleteRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (delete tag):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onTagDeleteReply(reply);
    });
}

void CategoriesUser::onTagDeleteReply(QNetworkReply *reply)
{
    qDebug() << "onTagDeleteReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Tag deleted successfully. Server response:" << reply->readAll();
        emit tagDeletedSuccess();
    } else {
        qWarning() << "Tag delete failed. Error:" << reply->errorString();
        emit tagDeletedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Добавление активностей -----------

void CategoriesUser::saveActivity(const QString &iconId, const QString &iconlabel)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin().trimmed();
    QString cleanedIconId = iconId.trimmed();
    QString cleanedIconLabel = iconlabel.trimmed();

    qDebug() << "saveActivity called with login:" << savedLogin;
    qDebug() << "iconId:" << iconId << ", icon_label:" << iconlabel;

    if (savedLogin.isEmpty() || cleanedIconId.isEmpty() || cleanedIconLabel.isEmpty()) {
        qWarning() << "Invalid input data: Login, iconId, or iconLabel is empty!";
        return;
    }

    QJsonObject json;
    json["login"] = savedLogin;
    json["icon_id"] = cleanedIconId;
    json["icon_label"] = cleanedIconLabel;

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/saveactivity");
    sendActivitySaveRequest(jsonDoc, serverUrl);
}


void CategoriesUser::sendActivitySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendActivitySaveRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (save activity):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onActivitySaveReply(reply);
    });
}

void CategoriesUser::onActivitySaveReply(QNetworkReply *reply)
{
    qDebug() << "onActivitySaveReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Activity saved successfully. Server response:" << reply->readAll();
        emit activitySavedSuccess();
    } else {
        qWarning() << "Activity save failed. Error:" << reply->errorString();
        emit activitySavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Выгрузка активностей -----------

void CategoriesUser::loadActivity()
{
    AppSave appSave;
    QString login = appSave.getSavedLogin().trimmed();
    qDebug() << "Loading user activity for login:" << login;


    QUrl serverUrl = AppConfig::apiUrl("/getuseractivity");
    qDebug() << "Request URL:" << serverUrl.toString();

    QUrlQuery query;
    query.addQueryItem("login", login);
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() << "Request URL:" << serverUrl.toString();

    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserActivitiesFetchReply(reply);
    });
}

void CategoriesUser::onUserActivitiesFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserActivitiesFetchReply called.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Activity loaded successfully. Server response:" << QString::fromUtf8(response);

        if (response.isEmpty()) {
            qWarning() << "Empty activity response received.";
            emit activityLoadedFailed("Empty response from server.");
            reply->deleteLater();
            return;
        }

        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(response, &parseError);
        if (parseError.error != QJsonParseError::NoError) {
            qWarning() << "JSON parse error:" << parseError.errorString();
            emit activityLoadedFailed("JSON parse error.");
            reply->deleteLater();
            return;
        }

        if (!doc.isObject()) {
            qWarning() << "Invalid JSON format: expected object at top level.";
            emit activityLoadedFailed("Invalid JSON format.");
            reply->deleteLater();
            return;
        }

        QJsonObject root = doc.object();
        QJsonArray activitiesArray = root.value("activities").toArray();

        QVariantList activityList;
        for (const QJsonValue &val : activitiesArray) {
            QJsonObject obj = val.toObject();
            QVariantMap map;
            map["activity"] = obj.value("activity").toString();
            map["iconId"] = obj.value("iconId").toString().toInt();  // <-- теперь корректно
            activityList.append(map);
        }

        qDebug() << "Sending activities to QML:" << activityList;
        emit activityLoadedSuccess(activityList);
    } else {
        qWarning() << "Failed to load user activity. Error:" << reply->errorString();
        emit activityLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}




// ----------- Удаление активностей -----------

void CategoriesUser::deleteActivity(const QString &activity)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin().trimmed();

    qDebug() << "deleteActivity called with login:" << savedLogin;
    qDebug() << "activity:" << activity;

    QJsonObject json;
    json["login"] = savedLogin;
    json["activity"] = activity.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/deleteactivity");  // Убедись, что сервер принимает этот эндпоинт
    sendActivityDeleteRequest(jsonDoc, serverUrl);
}


void CategoriesUser::sendActivityDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendActivityDeleteRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (delete activity):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onActivityDeleteReply(reply);
    });
}


void CategoriesUser::onActivityDeleteReply(QNetworkReply *reply)
{
    qDebug() << "onActivityDeleteReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Activity deleted successfully. Server response:" << reply->readAll();
        emit activityDeletedSuccess();
    } else {
        qWarning() << "Activity delete failed. Error:" << reply->errorString();
        emit activityDeletedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Добавление настроения -----------

void CategoriesUser::saveEmotion(const QString &iconId, const QString &iconlabel)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin().trimmed();
    QString cleanedIconId = iconId.trimmed();
    QString cleanedIconLabel = iconlabel.trimmed();

    qDebug() << "saveEmotion called with login:" << savedLogin;
    qDebug() << "iconId:" << iconId << ", iconlabel:" << iconlabel;

    if (savedLogin.isEmpty() || cleanedIconId.isEmpty() || cleanedIconLabel.isEmpty()) {
        qWarning() << "Invalid input data: Login, iconId, or iconLabel is empty!";
        return;
    }

    QJsonObject json;
    json["login"] = savedLogin;
    json["icon_id"] = cleanedIconId;
    json["icon_label"] = cleanedIconLabel;

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/saveemotion");
    sendEmotionSaveRequest(jsonDoc, serverUrl);
}

void CategoriesUser::sendEmotionSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendEmotionSaveRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (save emotion):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onEmotionSaveReply(reply);
    });
}

void CategoriesUser::onEmotionSaveReply(QNetworkReply *reply)
{
    qDebug() << "onEmotionSaveReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Emotion saved successfully. Server response:" << reply->readAll();
        emit emotionSavedSuccess();
    } else {
        qWarning() << "Emotion save failed. Error:" << reply->errorString();
        emit emotionSavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Выгрузка настроения -----------

void CategoriesUser::loadEmotion()
{
    AppSave appSave;
    QString login = appSave.getSavedLogin().trimmed();
    qDebug() << "Loading user emotions for login:" << login;

    QUrl serverUrl = AppConfig::apiUrl("/getuseremotions");
    QUrlQuery query;
    query.addQueryItem("login", login);
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserEmotionsFetchReply(reply);
    });
}

void CategoriesUser::onUserEmotionsFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserEmotionsFetchReply called.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Emotions loaded successfully. Server response:" << QString::fromUtf8(response);

        if (response.isEmpty()) {
            qWarning() << "Empty emotion response received.";
            emit emotionLoadedFailed("Empty response from server.");
            reply->deleteLater();
            return;
        }

        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(response, &parseError);
        if (parseError.error != QJsonParseError::NoError) {
            qWarning() << "JSON parse error:" << parseError.errorString();
            emit emotionLoadedFailed("JSON parse error.");
            reply->deleteLater();
            return;
        }

        if (!doc.isObject()) {
            qWarning() << "Invalid JSON format: expected object at top level.";
            emit emotionLoadedFailed("Invalid JSON format.");
            reply->deleteLater();
            return;
        }

        QJsonObject root = doc.object();
        QJsonArray emotionsArray = root.value("emotions").toArray();

        QVariantList emotionList;
        for (const QJsonValue &val : emotionsArray) {
            QJsonObject obj = val.toObject();
            QVariantMap map;
            map["emotion"] = obj.value("emotion").toString();
            map["iconId"] = obj.value("iconId").toString().toInt();
            emotionList.append(map);
        }

        qDebug() << "Sending emotions to QML:" << emotionList;
        emit emotionLoadedSuccess(emotionList);
    } else {
        qWarning() << "Failed to load user emotions. Error:" << reply->errorString();
        emit emotionLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}


// ----------- Удаление настроения -----------

void CategoriesUser::deleteEmotion(const QString &emotion)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "deleteEmotion called with login:" << savedLogin;
    qDebug() << "emotion:" << emotion;

    QJsonObject json;
    json["login"] = savedLogin;
    json["emotion"] = emotion.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/deleteemotion");
    sendEmotionDeleteRequest(jsonDoc, serverUrl);
}

void CategoriesUser::sendEmotionDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendEmotionDeleteRequest called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (delete emotion):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onEmotionDeleteReply(reply);
    });
}

void CategoriesUser::onEmotionDeleteReply(QNetworkReply *reply)
{
    qDebug() << "onEmotionDeleteReply called.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Emotion deleted successfully. Server response:" << reply->readAll();
        emit emotionDeletedSuccess();
    } else {
        qWarning() << "Emotion delete failed. Error:" << reply->errorString();
        emit emotionDeletedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Общий метод отправки (используется для регистрации) -----------
void CategoriesUser::sendToServer(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendToServer called.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (categories):" << data;

    m_networkUser.post(request, data);
}
