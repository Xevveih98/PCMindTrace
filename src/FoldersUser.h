#ifndef FOLDERSUSER_H
#define FOLDERSUSER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QDebug>
#include <QUrlQuery>

class FoldersUser : public QObject
{
    Q_OBJECT
public:
    explicit FoldersUser(QObject *parent = nullptr);

    Q_INVOKABLE void saveFolder(const QString &folder);
    Q_INVOKABLE void loadFolder();
    Q_INVOKABLE void deleteFolder(const QString &folder);
    Q_INVOKABLE void changeFolder(const QString &newName, const QString &oldName);

signals:
    void folderSavedSuccess();
    void folderSavedFailed(const QString &error);
    void foldersLoadedSuccess(const QVariantList &folders);
    void folderLoadedFailed(const QString &error);
    void folderDeletedSuccess();
    void folderDeletedFailed(const QString &error);
    void folderChangedSuccess();
    void folderChangedFailed(const QString &error);
    void clearFolderList();

private slots:
    void onFolderSaveReply(QNetworkReply *reply);
    void onUserFolderFetchReply(QNetworkReply *reply);
    void onFolderDeleteReply(QNetworkReply *reply);
    void onFolderChangeReply(QNetworkReply *reply);

private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);

    void sendFolderSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendFolderDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendFolderChangeRequest(const QJsonDocument &jsonDoc, const QUrl &url);

    QNetworkAccessManager m_networkUser;
};

#endif // FOLDERSUSER_H
