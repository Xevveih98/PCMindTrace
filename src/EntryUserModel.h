#ifndef ENTRYUSERMODEL_H
#define ENTRYUSERMODEL_H

#include <QAbstractListModel>
#include "EntryUser.h"

class EntryUserModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit EntryUserModel(QObject *parent = nullptr);

    enum EntryRoles {
        IdRole = Qt::UserRole + 1,
        UserLoginRole,
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
    Q_ENUM(EntryRoles)

    // Количество элементов
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    // Данные для QML
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Роли
    QHash<int, QByteArray> roleNames() const override;

    // Добавление, удаление
    void setEntries(const QList<EntryUser> &entries);
    void clear();

    Q_INVOKABLE EntryUser getEntry(int index) const;
    Q_INVOKABLE void removeEntry(int index);
    Q_INVOKABLE void addEntry(const EntryUser &entry);

private:
    QList<EntryUser> m_entries;
};

#endif // ENTRYUSERMODEL_H
