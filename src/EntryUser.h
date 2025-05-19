#ifndef ENTRYUSER_H
#define ENTRYUSER_H

#include <QString>
#include <QDate>
#include <QTime>
#include <QVector>
#include <QJsonArray>
#include <QDebug>
#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include "UserItem.h"

class EntryUser
{
public:
    EntryUser(int id,
        const QString &userLogin,
        const QString &title,
        const QString &content,
        int moodId,
        int folderId,
        const QDate &date,
        const QTime &time,
        const QVector<UserItem> &tagItems,
        const QVector<UserItem> &activityItems,
        const QVector<UserItem> &emotionItems);

    int getId() const;
    QString getUserLogin() const;
    QString getTitle() const;
    QString getContent() const;
    int getMoodId() const;
    int getFolderId() const;
    QDate getDate() const;
    QTime getTime() const;

    QVector<UserItem> getTagItems() const;
    QVector<UserItem> getActivityItems() const;
    QVector<UserItem> getEmotionItems() const;

    void setTagItems(const QVector<UserItem> &tags);
    void setActivityItems(const QVector<UserItem> &activities);
    void setEmotionItems(const QVector<UserItem> &emotions);

    static EntryUser fromJson(const QJsonObject &obj);
    QJsonObject toJson() const;


private:
    int m_id;
    QString m_userLogin;
    QString m_title;
    QString m_content;
    int m_moodId;
    int m_folderId;
    QDate m_date;
    QTime m_time;

    QVector<UserItem> m_tagItems;
    QVector<UserItem> m_activityItems;
    QVector<UserItem> m_emotionItems;
};

#endif // ENTRYUSER_H
