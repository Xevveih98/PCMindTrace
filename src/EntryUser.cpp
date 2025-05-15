#include "EntryUser.h"

EntryUser::EntryUser(int id,
    const QString &userLogin,
    const QString &title,
    const QString &content,
    int moodId,
    int folderId,
    const QDate &date,
    const QTime &time,
    const QVector<int> &tagIds,
    const QVector<int> &activityIds,
    const QVector<int> &emotionIds)
    : m_id(id),
    m_userLogin(userLogin),
    m_title(title),
    m_content(content),
    m_moodId(moodId),
    m_folderId(folderId),
    m_date(date),
    m_time(time),
    m_tagIds(tagIds),
    m_activityIds(activityIds),
    m_emotionIds(emotionIds)
{
}

int EntryUser::getId() const {
    return m_id;
}

QString EntryUser::getUserLogin() const {
    return m_userLogin;
}

QString EntryUser::getTitle() const {
    return m_title;
}

QString EntryUser::getContent() const {
    return m_content;
}

int EntryUser::getMoodId() const {
    return m_moodId;
}

int EntryUser::getFolderId() const {
    return m_folderId;
}

QDate EntryUser::getDate() const {
    return m_date;
}

QTime EntryUser::getTime() const {
    return m_time;
}

QVector<int> EntryUser::getTagIds() const {
    return m_tagIds;
}

QVector<int> EntryUser::getActivityIds() const {
    return m_activityIds;
}

QVector<int> EntryUser::getEmotionIds() const {
    return m_emotionIds;
}

void EntryUser::setTagIds(const QVector<int> &tags) {
    m_tagIds = tags;
}

void EntryUser::setActivityIds(const QVector<int> &activities) {
    m_activityIds = activities;
}

void EntryUser::setEmotionIds(const QVector<int> &emotions) {
    m_emotionIds = emotions;
}


EntryUser EntryUser::fromJson(const QJsonObject &obj)
{
    qDebug() << "EntryUser::fromJson() called. Source object:" << obj;

    int id = obj.value("id").toInt();
    QString login = obj.value("user_login").toString();
    QString title = obj.value("entry_title").toString();
    QString content = obj.value("entry_content").toString();
    int moodId = obj.value("entry_mood_id").toInt();
    int folderId = obj.value("entry_folder_id").toInt();

    QString dateStr = obj.value("entry_date").toString();
    QString timeStr = obj.value("entry_time").toString();
    QDate date = QDate::fromString(dateStr, Qt::ISODate);
    QTime time = QTime::fromString(timeStr, "hh:mm:ss");

    QVector<int> tags, activities, emotions;

    QJsonArray tagsArray = obj.value("tags").toArray();
    for (const QJsonValue &val : tagsArray)
        tags.append(val.toInt());

    QJsonArray activitiesArray = obj.value("activities").toArray();
    for (const QJsonValue &val : activitiesArray)
        activities.append(val.toInt());

    QJsonArray emotionsArray = obj.value("emotions").toArray();
    for (const QJsonValue &val : emotionsArray)
        emotions.append(val.toInt());

    qDebug() << "Создан EntryUser из JSON:"
             << "ID:" << id
             << "Login:" << login
             << "Title:" << title
             << "Date:" << date
             << "Tags:" << tags;

    return EntryUser(id, login, title, content, moodId, folderId, date, time, tags, activities, emotions);
}

QJsonObject EntryUser::toJson() const
{
    qDebug() << "EntryUser::toJson() called. Serializing entry:" << m_id << m_title;

    QJsonObject obj;
    obj["id"] = m_id;
    obj["user_login"] = m_userLogin;
    obj["entry_title"] = m_title;
    obj["entry_content"] = m_content;
    obj["entry_mood_id"] = m_moodId;
    obj["entry_folder_id"] = m_folderId;
    obj["entry_date"] = m_date.toString(Qt::ISODate);
    obj["entry_time"] = m_time.toString("hh:mm:ss");

    QJsonArray tagsArray;
    for (int tag : m_tagIds)
        tagsArray.append(tag);
    obj["tags"] = tagsArray;

    QJsonArray activitiesArray;
    for (int activity : m_activityIds)
        activitiesArray.append(activity);
    obj["activities"] = activitiesArray;

    QJsonArray emotionsArray;
    for (int emotion : m_emotionIds)
        emotionsArray.append(emotion);
    obj["emotions"] = emotionsArray;

    qDebug() << "EntryUser JSON serialization result:" << obj;

    return obj;
}
