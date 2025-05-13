#ifndef ENTRYCLASS_H
#define ENTRYCLASS_H

#include <QString>
#include <QDate>
#include <QTime>
#include <QJsonObject>
#include <QJsonArray>

class EntryClass {
public:
    EntryClass() = default;

    int id = -1;
    QDate date;
    QTime createdTime;
    QString folder;
    QString userLogin;
    QString title;
    QString content;

    QList<int> tagIds;
    QList<int> activityIds;
    QList<int> emotionIds;

    QJsonObject toJson() const;
    static EntryClass fromJson(const QJsonObject &obj);
};

#endif // ENTRYCLASS_H
