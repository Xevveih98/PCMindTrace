#include "FoldersUser.h"
#include "AppSave.h"  // для доступа к сохраненному логину

FoldersUser::FoldersUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Получен сетевой ответ от:" << endpoint.toString();

        if (endpoint.path().contains("/savefolder")) {
            onFolderSaveReply(reply);
        } else if (endpoint.path().contains("/getuserfolder")) {
            onUserFolderFetchReply(reply);
        } else if (endpoint.path().contains("/deletefolder")) {
            onFolderDeleteReply(reply);
        } else {
            qWarning() << "Необработанный эндпоинт в FolderUser:" << endpoint.toString();
            reply->deleteLater();
        }
    });
    qDebug() << "FoldersUser инициализирован и вызван.";
}

// ----------- Сохранение папки -----------

void FoldersUser::saveFolder(const QStringList &folders)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "СохранениеПапок вызвано пользователем:" << savedLogin;
    qDebug() << "Папки:" << folders;

    QJsonObject json;
    json["login"] = savedLogin;

    QJsonArray jsonFolders;
    for (const QString &folder : folders) {
        if (!folder.trimmed().isEmpty())
            jsonFolders.append(folder.trimmed());
    }
    json["folders"] = jsonFolders;

    QJsonDocument jsonDoc(json);
    QUrl serverUrl("http://192.168.46.184:8080/savefolder");
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
    qDebug() << "Loading tags for login:" << login;

    QUrl url("http://192.168.46.184:8080/getusertags");
    QUrlQuery query;
    query.addQueryItem("login", login);
    url.setQuery(query);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserFolderFetchReply(reply);
    });
}

void FoldersUser::onUserFolderFetchReply(QNetworkReply *reply)
{
    qDebug() << "onUserFolderFetchReply вызван.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Папки успешно выгружены. Ответ сервера:" << response;

        if (response.isEmpty()) {
            qWarning() << "Получен пустой ответ, пропуск.";
            reply->deleteLater();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonArray array = doc.object().value("folders").toArray();

        QStringList folders;
        for (const auto &val : array)
            folders << val.toString();

        emit folderLoaded(folders);
    } else {
        qWarning() << "Не удалось выгрузить папки. Ошибка:" << reply->errorString();
        emit folderLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}

// ----------- Удаление тегов -----------

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
    QUrl serverUrl("http://192.168.46.184:8080/deletefolder");
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
    } else {
        qWarning() << "Удаление папки не удалось. Ошибка:" << reply->errorString();
        emit folderDeletedFailed(reply->errorString());
    }
    reply->deleteLater();
}
