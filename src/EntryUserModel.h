#pragma once

#include <QAbstractListModel>
#include "EntryUser.h"

class EntryUserModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)


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

signals:
    void countChanged();

private:
    QList<EntryUser> m_entries;
};
