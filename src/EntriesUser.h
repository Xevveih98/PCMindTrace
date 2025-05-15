#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include "EntryUser.h"

class EntriesUser : public QObject
{
    Q_OBJECT

public:
    explicit EntriesUser(QObject *parent = nullptr);
    void saveEntry(const EntryUser &entry);
    void loadUserEntries();

signals:
    void entrySavedSuccess();
    void entrySavedFailed(const QString &error);
    void entriesLoadedSuccess(const QList<EntryUser> &entries);
    void entriesLoadedFailed(const QString &error);

private:
    void sendEntrySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void onEntrySaveReply(QNetworkReply *reply);
    void onUserEntryFetchReply(QNetworkReply *reply);

    QNetworkAccessManager m_networkUser;
};
