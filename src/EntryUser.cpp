#include "EntryUser.h"

EntryUser::EntryUser(int id,
                     const QString &userLogin,
                     const QString &title,
                     const QString &content,
                     int moodId,
                     int folderId,
                     const QDate &date,
                     const QTime &time,
                     const QVector<UserItem> &tagItems,
                     const QVector<UserItem> &activityItems,
                     const QVector<UserItem> &emotionItems)
    : m_id(id),
    m_userLogin(userLogin),
    m_title(title),
    m_content(content),
    m_moodId(moodId),
    m_folderId(folderId),
    m_date(date),
    m_time(time),
    m_tagItems(tagItems),
    m_activityItems(activityItems),
    m_emotionItems(emotionItems)
{
}

int EntryUser::getId() const { return m_id; }
QString EntryUser::getUserLogin() const { return m_userLogin; }
QString EntryUser::getTitle() const { return m_title; }
QString EntryUser::getContent() const { return m_content; }
int EntryUser::getMoodId() const { return m_moodId; }
int EntryUser::getFolderId() const { return m_folderId; }
QDate EntryUser::getDate() const { return m_date; }
QTime EntryUser::getTime() const { return m_time; }

QVector<UserItem> EntryUser::getTagItems() const { return m_tagItems; }
QVector<UserItem> EntryUser::getActivityItems() const { return m_activityItems; }
QVector<UserItem> EntryUser::getEmotionItems() const { return m_emotionItems; }

void EntryUser::setTagItems(const QVector<UserItem> &tags) { m_tagItems = tags; }
void EntryUser::setActivityItems(const QVector<UserItem> &activities) { m_activityItems = activities; }
void EntryUser::setEmotionItems(const QVector<UserItem> &emotions) { m_emotionItems = emotions; }

static QVector<UserItem> parseUserItemArray(const QJsonArray &array) {
    QVector<UserItem> result;
    for (const QJsonValue &val : array) {
        QJsonObject obj = val.toObject();
        UserItem item;
        item.id = obj.value("id").toInt();
        item.iconId = obj.value("iconId").toInt();
        item.label = obj.value("label").toString();
        result.append(item);
    }
    return result;
}

static QJsonArray toJsonUserItemArray(const QVector<UserItem> &items) {
    QJsonArray array;
    for (const UserItem &item : items) {
        QJsonObject obj;
        obj["id"] = item.id;
        obj["iconId"] = item.iconId;
        obj["label"] = item.label;
        array.append(obj);
    }
    return array;
}

EntryUser EntryUser::fromJson(const QJsonObject &obj)
{
    qDebug() << "EntryUser::fromJson() called. Source object:" << obj;

    int id = obj.value("id").toInt();
    QString login = obj.value("login").toString();
    QString title = obj.value("title").toString();
    QString content = obj.value("content").toString();
    int moodId = obj.value("moodId").toInt();
    int folderId = obj.value("folderId").toInt();

    QDate date = QDate::fromString(obj.value("date").toString(), Qt::ISODate);
    QTime time = QTime::fromString(obj.value("time").toString(), "hh:mm");

    QVector<UserItem> tags = parseUserItemArray(obj.value("tags").toArray());
    QVector<UserItem> activities = parseUserItemArray(obj.value("activities").toArray());
    QVector<UserItem> emotions = parseUserItemArray(obj.value("emotions").toArray());

    qDebug() << "Создан EntryUser из JSON:"
             << "ID:" << id
             << "Login:" << login
             << "Title:" << title
             << "Date:" << date
             << "Tags count:" << tags.size();

    return EntryUser(id, login, title, content, moodId, folderId, date, time, tags, activities, emotions);
}


QJsonObject EntryUser::toJson() const
{
    QJsonObject obj;
    obj["title"] = m_title;
    obj["content"] = m_content;
    obj["date"] = m_date.toString(Qt::ISODate);
    obj["time"] = m_time.toString();
    obj["folder"] = m_folderId;
    obj["moodId"] = m_moodId;

    // Сериализация QVector<UserItem> в массив id
    auto userItemsToJsonArray = [](const QVector<UserItem> &items) {
        QJsonArray array;
        for (const auto &item : items)
            array.append(item.id);
        return array;
    };

    obj["tags"] = userItemsToJsonArray(m_tagItems);
    obj["activities"] = userItemsToJsonArray(m_activityItems);
    obj["emotions"] = userItemsToJsonArray(m_emotionItems);

    obj["id"] = m_id;

    return obj;
}
