#include "EntryClass.h"

QJsonObject EntryClass::toJson() const {
    QJsonObject obj;
    obj["date"] = date.toString(Qt::ISODate);
    obj["createdTime"] = createdTime.toString("HH:mm:ss");
    obj["folder"] = folder;
    obj["userLogin"] = userLogin;
    obj["title"] = title;
    obj["content"] = content;

    QJsonArray tags;
    for (int id : tagIds) tags.append(id);
    obj["tagIds"] = tags;

    QJsonArray activities;
    for (int id : activityIds) activities.append(id);
    obj["activityIds"] = activities;

    QJsonArray emotions;
    for (int id : emotionIds) emotions.append(id);
    obj["emotionIds"] = emotions;

    return obj;
}

EntryClass EntryClass::fromJson(const QJsonObject &obj) {
    EntryClass entry;
    entry.id = obj["id"].toInt();
    entry.date = QDate::fromString(obj["date"].toString(), Qt::ISODate);
    entry.createdTime = QTime::fromString(obj["createdTime"].toString(), "HH:mm:ss");
    entry.folder = obj["folder"].toString();
    entry.userLogin = obj["userLogin"].toString();
    entry.title = obj["title"].toString();
    entry.content = obj["content"].toString();

    QJsonArray tags = obj["tagIds"].toArray();
    for (const auto &t : tags) entry.tagIds.append(t.toInt());

    QJsonArray acts = obj["activityIds"].toArray();
    for (const auto &a : acts) entry.activityIds.append(a.toInt());

    QJsonArray emos = obj["emotionIds"].toArray();
    for (const auto &e : emos) entry.emotionIds.append(e.toInt());

    return entry;
}
