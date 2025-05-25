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

    std::sort(m_entries.begin(), m_entries.end(), [](const EntryUser &a, const EntryUser &b) {
        if (a.getDate() == b.getDate()) {

            return a.getTime() > b.getTime();
        }
        return a.getDate() > b.getDate();
    });

    endResetModel();
    emit countChanged();
}

void EntryUserModel::clear()
{
    beginResetModel();
    m_entries.clear();
    endResetModel();
}

bool EntryUserModel::removeEntryById(int id)
{
    for (int i = 0; i < m_entries.size(); ++i) {
        if (m_entries[i].getId() == id) {
            beginRemoveRows(QModelIndex(), i, i);
            m_entries.removeAt(i);
            endRemoveRows();
            emit countChanged();
            return true;
        }
    }
    return false;
}

QVariant EntryUserModel::get(int index) const
{
    if (index < 0 || index >= m_entries.size())
        return QVariant();

    const EntryUser &entry = m_entries[index];
    QVariantMap map;
    map["id"] = entry.getId();
    map["title"] = entry.getTitle();
    map["content"] = entry.getContent();
    map["moodId"] = entry.getMoodId();
    map["folderId"] = entry.getFolderId();
    map["date"] = entry.getDate().toString("yyyy-MM-dd");
    map["time"] = entry.getTime().toString("HH:mm");
    return map;
}
