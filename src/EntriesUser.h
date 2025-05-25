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
    Q_PROPERTY(EntryUserModel* monthSearchModel READ monthSearchModel NOTIFY monthSearchModelChanged)

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
    Q_INVOKABLE void loadUserEntriesByMonth(const QString &date);

    EntryUserModel* entryUserModel() const;
    EntryUserModel* searchModel() const;
    EntryUserModel* dateSearchModel() const;
    EntryUserModel* monthSearchModel() const;

    Q_INVOKABLE void clearSearchModel();
    Q_INVOKABLE void clearDateSearchModel();
    Q_INVOKABLE void clearMonthSearchModel();

signals:
    void entrySavedSuccess();
    void entrySavedFailed(const QString &error);
    void entriesLoadedSuccess(const QList<EntryUser> &entries);
    void entriesLoadedFailed(const QString &error);
    void entryDeleted(int entryId);
    void entryUserModelChanged();
    void searchModelChanged();
    void dateSearchModelChanged();
    void monthSearchModelChanged();
    void monthEntriesChanged();

private:
    void sendEntrySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void onEntrySaveReply(QNetworkReply *reply);
    void onUserEntryFetchReply(QNetworkReply *reply);

    QNetworkAccessManager m_networkUser;
    EntryUserModel *m_entryUserModel;
    EntryUserModel *m_searchModel;
    EntryUserModel *m_dateSearchModel;
    EntryUserModel *m_monthSearchModel;
};
