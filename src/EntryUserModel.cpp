#include "EntryUsermodel.h"

EntryUserModel::EntryUserModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int EntryUserModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_entries.count();
}

QVariant EntryUserModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_entries.count())
        return QVariant();

    const EntryUser &entry = m_entries.at(index.row());

    switch (role) {
    case IdRole: return entry.getId();
    case TitleRole: return entry.getTitle();
    case ContentRole: return entry.getContent();
    case MoodIdRole: return entry.getMoodId();
    case FolderIdRole: return entry.getFolderId();
    case DateRole: return entry.getDate().toString(Qt::ISODate);
    case TimeRole: return entry.getTime().toString("HH:mm");

    case TagsRole: {
        QVariantList list;
        for (const auto &item : entry.getTagItems()) {
            QVariantMap map;
            map["id"] = item.id;
            map["iconId"] = item.iconId;
            map["label"] = item.label;
            list.append(map);
        }
        return list;
    }
    case ActivitiesRole: {
        QVariantList list;
        for (const auto &item : entry.getActivityItems()) {
            QVariantMap map;
            map["id"] = item.id;
            map["iconId"] = item.iconId;
            map["label"] = item.label;
            list.append(map);
        }
        return list;
    }
    case EmotionsRole: {
        QVariantList list;
        for (const auto &item : entry.getEmotionItems()) {
            QVariantMap map;
            map["id"] = item.id;
            map["iconId"] = item.iconId;
            map["label"] = item.label;
            list.append(map);
        }
        return list;
    }
    }

    return QVariant();
}

QHash<int, QByteArray> EntryUserModel::roleNames() const
{
    return {
        {IdRole, "id"},
        {TitleRole, "title"},
        {ContentRole, "content"},
        {MoodIdRole, "moodId"},
        {FolderIdRole, "folderId"},
        {DateRole, "date"},
        {TimeRole, "time"},
        {TagsRole, "tags"},
        {ActivitiesRole, "activities"},
        {EmotionsRole, "emotions"}
    };
}

void EntryUserModel::setEntries(const QList<EntryUser> &entries)
{
    beginResetModel();
    m_entries = entries;
    endResetModel();
}

void EntryUserModel::clear()
{
    beginResetModel();
    m_entries.clear();
    endResetModel();
}
