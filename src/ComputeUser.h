#ifndef COMPUTEUSER_H
#define COMPUTEUSER_H

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

class ComputeUser : public QObject
{
    Q_OBJECT
    Q_PROPERTY(EntryUserModel* entryCurrentMonthModel READ entryCurrentMonthModel NOTIFY entryCurrentMonthModelChanged)
    Q_PROPERTY(EntryUserModel* entryLastMonthModel READ entryLastMonthModel NOTIFY entryLastMonthModelChanged)

public:
    explicit ComputeUser(QObject *parent = nullptr);
    Q_INVOKABLE void loadEntriesByMonth(const QString &lastMonth, const QString &currentMonth);


    EntryUserModel* entryCurrentMonthModel() const;
    EntryUserModel* entryLastMonthModel() const;

signals:
    void entriesLoadedFailed(const QString &error);
    void entriesLoadedSuccess();


    void entryCurrentMonthModelChanged();
    void entryLastMonthModelChanged();

private:
    void onLoadEntriesByMonthReply(QNetworkReply *reply);


    QNetworkAccessManager m_networkUser;
    EntryUserModel *m_entryCurrentMonthModel;
    EntryUserModel *m_entryLastMonthModel;
};

#endif // COMPUTEUSER_H
