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
    Q_PROPERTY(EntryUserModel* dateSearchModel READ dateSearchModel NOTIFY dateSearchModelChanged)

public:
    explicit EntriesUser(QObject *parent = nullptr);

    void saveEntry(const EntryUser &entry);
    void updateEntry(const EntryUser &entry);
    Q_INVOKABLE void saveEntryFromQml(const QVariant &entryDataVariant);
    Q_INVOKABLE void updateEntryFromQml(const QVariant &entryDataVariant);
    Q_INVOKABLE void deleteUserEntry(int entryId);

    Q_INVOKABLE void loadUserEntries(int folderId, int year, int month);
    Q_INVOKABLE void loadUserEntriesByKeywords(const QStringList &keywords);
    Q_INVOKABLE void loadUserEntriesByTags(const QList<int> &tagIds);
    Q_INVOKABLE void loadUserEntriesByDate(const QString &date);
    Q_INVOKABLE void loadUserEntriesMoodIdies(const QString &date);

    EntryUserModel* entryUserModel() const;
    EntryUserModel* searchModel() const;
    EntryUserModel* dateSearchModel() const;

    Q_INVOKABLE void clearSearchModel();
    Q_INVOKABLE void clearDateSearchModel();

signals:
    void moodIdsLoadSuccess(const QList<int> &moodIds, const QString &datet);
    void moodIdsLoadFailed(const QString &errorString);
    void entrySavedSuccess();
    void entrySavedFailed(const QString &error);
    void entriesLoadedSuccess(const QList<EntryUser> &entries);
    void entriesLoadedFailed(const QString &error);
    void entryDeleted(int entryId);
    void entryUserModelChanged();
    void searchModelChanged();
    void dateSearchModelChanged();

private:
    void sendEntrySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void onEntrySaveReply(QNetworkReply *reply);
    void onUserEntryFetchReply(QNetworkReply *reply);
    void onUserMoodIdsFetchReply(QNetworkReply *reply);

    QNetworkAccessManager m_networkUser;
    EntryUserModel *m_entryUserModel;
    EntryUserModel *m_searchModel;
    EntryUserModel *m_dateSearchModel;
};
