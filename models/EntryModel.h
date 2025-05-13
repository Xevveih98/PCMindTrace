#ifndef ENTRYMODEL_H
#define ENTRYMODEL_H

#include <QAbstractListModel>
#include "EntryClass.h"

class EntryModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum EntryRoles {
        IdRole = Qt::UserRole + 1,
        DateRole,
        TimeRole,
        FolderRole,
        LoginRole,
        TitleRole,
        ContentRole
    };

    explicit EntryModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addEntry(const EntryClass &entry);
    Q_INVOKABLE void updateEntry(int id, const EntryClass &newData);
    Q_INVOKABLE void removeEntry(int id);
    Q_INVOKABLE EntryClass getEntryById(int id) const;

    void setEntries(const QList<EntryClass> &entries);

private:
    QList<EntryClass> m_entries;
};

#endif // ENTRYMODEL_H
