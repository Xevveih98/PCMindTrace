#pragma once

#include <QAbstractListModel>
#include "EntryUser.h"

class EntryUserModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum EntryRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        ContentRole,
        MoodIdRole,
        FolderIdRole,
        DateRole,
        TimeRole,
        TagsRole,
        ActivitiesRole,
        EmotionsRole
    };

    explicit EntryUserModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setEntries(const QList<EntryUser> &entries);
    void clear();

private:
    QList<EntryUser> m_entries;
};
