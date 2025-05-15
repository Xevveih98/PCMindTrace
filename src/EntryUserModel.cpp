#include "EntryUserModel.h"

EntryUserModel::EntryUserModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int EntryUserModel::rowCount(const QModelIndex &) const {
    return m_entries.count();
}

QVariant EntryUserModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_entries.count())
        return QVariant();

    const EntryUser &entry = m_entries.at(index.row());

    switch (role) {
    case IdRole: return entry.getId();
    case UserLoginRole: return entry.getUserLogin();
    case TitleRole: return entry.getTitle();
    case ContentRole: return entry.getContent();
    case MoodIdRole: return entry.getMoodId();
    case FolderIdRole: return entry.getFolderId();
    case DateRole: return entry.getDate();
    case TimeRole: return entry.getTime();
    case TagsRole: return QVariant::fromValue(entry.getTagIds());
    case ActivitiesRole: return QVariant::fromValue(entry.getActivityIds());
    case EmotionsRole: return QVariant::fromValue(entry.getEmotionIds());
    default: return QVariant();
    }
}

QHash<int, QByteArray> EntryUserModel::roleNames() const {
    return {
        {IdRole, "id"},
        {UserLoginRole, "userLogin"},
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

void EntryUserModel::setEntries(const QList<EntryUser> &entries) {
    beginResetModel();
    m_entries = entries;
    endResetModel();
}

void EntryUserModel::clear() {
    beginResetModel();
    m_entries.clear();
    endResetModel();
}

EntryUser EntryUserModel::getEntry(int index) const {
    if (index >= 0 && index < m_entries.size())
        return m_entries.at(index);
    return EntryUser(0, "", "", "", 0, 0, QDate(), QTime()); // Пустой
}

void EntryUserModel::removeEntry(int index) {
    if (index < 0 || index >= m_entries.size()) return;
    beginRemoveRows(QModelIndex(), index, index);
    m_entries.removeAt(index);
    endRemoveRows();
}

void EntryUserModel::addEntry(const EntryUser &entry) {
    beginInsertRows(QModelIndex(), m_entries.size(), m_entries.size());
    m_entries.append(entry);
    endInsertRows();
}
