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
        const QVector<int> &tagIds = {},
        const QVector<int> &activityIds = {},
        const QVector<int> &emotionIds = {});

    int getId() const;
    QString getUserLogin() const;
    QString getTitle() const;
    QString getContent() const;
    int getMoodId() const;
    int getFolderId() const;
    QDate getDate() const;
    QTime getTime() const;

    QVector<int> getTagIds() const;
    QVector<int> getActivityIds() const;
    QVector<int> getEmotionIds() const;

    void setTagIds(const QVector<int> &tags);
    void setActivityIds(const QVector<int> &activities);
    void setEmotionIds(const QVector<int> &emotions);

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

    QVector<int> m_tagIds;
    QVector<int> m_activityIds;
    QVector<int> m_emotionIds;
};

#endif // ENTRYUSER_H
