#include "FoldersUser.h"
#include "AppSave.h"
#include "AppConfig.h"

FoldersUser::FoldersUser(QObject *parent)
    : QObject(parent)
{
    connect(this, &FoldersUser::folderChangedSuccess, this, &FoldersUser::loadFolder);
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Получен сетевой ответ от:" << endpoint.toString();

        if (endpoint.path().contains("/savefolder")) {
            onFolderSaveReply(reply);
        } else if (endpoint.path().contains("/getuserfolder")) {
            onUserFolderFetchReply(reply);
        } else if (endpoint.path().contains("/deletefolder")) {
            onFolderDeleteReply(reply);
        } else if (endpoint.path().contains("/changefolder")) {
            onFolderDeleteReply(reply);
        } else {
            qWarning() << "Необработанный эндпоинт в FolderUser:" << endpoint.toString();
        reply->deleteLater();
    }
    });
    qDebug() << "FoldersUser инициализирован и вызван.";
}

// ----------- Сохранение папки -----------

void FoldersUser::saveFolder(const QString &folder)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "СохранениеПапки вызвано пользователем:" << savedLogin;
    qDebug() << "Папка:" << folder;

    QJsonObject json;
    json["login"] = savedLogin;
    json["folder"] = folder.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/savefolder");
    sendFolderSaveRequest(jsonDoc, serverUrl);
}

void FoldersUser::sendFolderSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendFolderSaveRequest вызван.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (сохранить папки):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onFolderSaveReply(reply);
    });
}

void FoldersUser::onFolderSaveReply(QNetworkReply *reply)
{
    qDebug() << "onFolderSaveReply вызван.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Папки успешно сохранены. Ответ сервера:" << reply->readAll();
        emit folderSavedSuccess();
        FoldersUser::loadFolder();
    } else {
        qWarning() << "Папки не сохранились. Ответ сервера:" << reply->errorString();
        emit folderSavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Выгрузка папок -----------

void FoldersUser::loadFolder()
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Выгружаем папки для пользователя:" << login;

    QUrl serverUrl = AppConfig::apiUrl("/getuserfolders");
    QUrlQuery query;
    query.addQueryItem("login", login);
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserFolderFetchReply(reply);
    });
}

void FoldersUser::onUserFolderFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserFolderFetchReply called.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Folders loaded successfully. Server response:" << QString::fromUtf8(response);

        if (response.isEmpty()) {
            qWarning() << "Empty folder response received.";
            emit folderLoadedFailed("Empty response from server.");
            reply->deleteLater();
            return;
        }

        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(response, &parseError);
        if (parseError.error != QJsonParseError::NoError) {
            qWarning() << "JSON parse error:" << parseError.errorString();
            emit folderLoadedFailed("JSON parse error.");
            reply->deleteLater();
            return;
        }

        if (!doc.isObject()) {
            qWarning() << "Invalid JSON format: expected object at top level.";
            emit folderLoadedFailed("Invalid JSON format.");
            reply->deleteLater();
            return;
        }

        QJsonObject root = doc.object();
        QJsonArray foldersArray = root.value("folders").toArray();

        QVariantList foldersList;
        for (const QJsonValue &val : foldersArray) {
            QJsonObject obj = val.toObject();
            QVariantMap map;

            map["id"] = obj.value("id").toInt();

            map["name"] = obj.value("name").toString();

            map["itemCount"] = obj.value("itemCount").toInt();

            foldersList.append(map);
        }

        qDebug() << "Sending folders to QML:" << foldersList;
        emit foldersLoadedSuccess(foldersList);
    } else {
        qWarning() << "Failed to load user folders. Error:" << reply->errorString();
        emit folderLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}



// ----------- Удаление папки -----------

void FoldersUser::deleteFolder(const QString &folder)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "УдалениеПапки вызвано пользователем:" << savedLogin;
    qDebug() << "Папка:" << folder;

    QJsonObject json;
    json["login"] = savedLogin;
    json["folder"] = folder.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/deletefolder");
    sendFolderDeleteRequest(jsonDoc, serverUrl);
}

void FoldersUser::sendFolderDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendFolderDeleteRequest вызван.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (удаление папки):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onFolderDeleteReply(reply);
    });
}

void FoldersUser::onFolderDeleteReply(QNetworkReply *reply)
{
    qDebug() << "onFolderDeleteReply вызван.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Папка успешно удалена. Ответ сервера:" << reply->readAll();
        emit folderDeletedSuccess();
        emit clearFolderList();
        FoldersUser::loadFolder();
    } else {
        qWarning() << "Удаление папки не удалось. Ошибка:" << reply->errorString();
        emit folderDeletedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Изменение папки -----------

void FoldersUser::changeFolder(const QString &newName, const QString &oldName)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "ИзменениеПапки вызвано пользователем:" << savedLogin;
    qDebug() << "Старое название:" << oldName;
    qDebug() << "Новое название:" << newName;

    QJsonObject json;
    json["login"] = savedLogin;
    json["oldName"] = oldName.trimmed();
    json["newName"] = newName.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/changefolder");
    sendFolderChangeRequest(jsonDoc, serverUrl);
}

void FoldersUser::sendFolderChangeRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendFolderChangeRequest вызван.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (изменение папки):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onFolderChangeReply(reply);
    });
}

void FoldersUser::onFolderChangeReply(QNetworkReply *reply)
{
    qDebug() << "onFolderChangeReply вызван.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Папка успешно изменена. Ответ сервера:" << reply->readAll();
        emit folderChangedSuccess();
        emit clearFolderList();
        FoldersUser::loadFolder();
    } else {
        qWarning() << "Изменение папки не удалось. Ошибка:" << reply->errorString();
        emit folderChangedFailed(reply->errorString());
    }
    reply->deleteLater();
}
