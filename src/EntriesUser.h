#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include "EntryUser.h"
#include "EntryUserModel.h"

class EntriesUser : public QObject
{
    Q_OBJECT
    Q_PROPERTY(EntryUserModel* entryUserModel READ entryUserModel NOTIFY entryUserModelChanged)
    Q_PROPERTY(EntryUserModel* searchModel READ searchModel NOTIFY searchModelChanged)



public:
    explicit EntriesUser(QObject *parent = nullptr);
    void saveEntry(const EntryUser &entry);
    Q_INVOKABLE void loadUserEntries(int folderId, int year, int month);
    Q_INVOKABLE void loadUserEntriesByKeywords(const QStringList &keywords);
    Q_INVOKABLE void saveEntryFromQml(const QVariant &entryDataVariant);
    EntryUserModel* entryUserModel() const;
    EntryUserModel* searchModel() const;
    Q_INVOKABLE void clearSearchModel();

signals:
    void entrySavedSuccess();
    void entrySavedFailed(const QString &error);
    void entriesLoadedSuccess(const QList<EntryUser> &entries);
    void entriesLoadedFailed(const QString &error);
    void entryUserModelChanged();
    void searchModelChanged();

private:
    void sendEntrySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void onEntrySaveReply(QNetworkReply *reply);
    void onUserEntryFetchReply(QNetworkReply *reply);
    EntryUserModel *m_entryUserModel;
    EntryUserModel* m_searchModel;


    QNetworkAccessManager m_networkUser;
};
