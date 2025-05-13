#include "EntryModel.h"

EntryModel::EntryModel(QObject *parent)
    : QAbstractListModel(parent) {}

int EntryModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);
    return m_entries.count();
}

QVariant EntryModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_entries.size())
        return {};

    const EntryClass &entry = m_entries[index.row()];

    switch (role) {
    case IdRole: return entry.id;
    case DateRole: return entry.date.toString(Qt::ISODate);
    case TimeRole: return entry.createdTime.toString("HH:mm:ss");
    case FolderRole: return entry.folder;
    case LoginRole: return entry.userLogin;
    case TitleRole: return entry.title;
    case ContentRole: return entry.content;
    default: return {};
    }
}

QHash<int, QByteArray> EntryModel::roleNames() const {
    return {
        {IdRole, "id"},
        {DateRole, "date"},
        {TimeRole, "createdTime"},
        {FolderRole, "folder"},
        {LoginRole, "userLogin"},
        {TitleRole, "title"},
        {ContentRole, "content"}
    };
}

void EntryModel::addEntry(const EntryClass &entry) {
    beginInsertRows(QModelIndex(), m_entries.size(), m_entries.size());
    m_entries.append(entry);
    endInsertRows();
}

void EntryModel::updateEntry(int id, const EntryClass &newData) {
    for (int i = 0; i < m_entries.size(); ++i) {
        if (m_entries[i].id == id) {
            m_entries[i] = newData;
            emit dataChanged(index(i), index(i));
            return;
        }
    }
}

void EntryModel::removeEntry(int id) {
    for (int i = 0; i < m_entries.size(); ++i) {
        if (m_entries[i].id == id) {
            beginRemoveRows(QModelIndex(), i, i);
            m_entries.removeAt(i);
            endRemoveRows();
            return;
        }
    }
}

EntryClass EntryModel::getEntryById(int id) const {
    for (const EntryClass &entry : m_entries) {
        if (entry.id == id)
            return entry;
    }
    return {};
}

void EntryModel::setEntries(const QList<EntryClass> &entries) {
    beginResetModel();
    m_entries = entries;
    endResetModel();
}
