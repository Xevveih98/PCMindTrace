#pragma once

#include <QAbstractListModel>
#include "EntryUser.h"

class EntryUserModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

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
    Q_INVOKABLE void clear();
    Q_INVOKABLE bool removeEntryById(int id);
    Q_INVOKABLE QVariantMap averageMoodByDay() const;
    Q_INVOKABLE QVariantMap calculateMoodStats() const;
    Q_INVOKABLE int countMood(int moodId) const;
    Q_INVOKABLE QVariantMap averageMoodByWeekday() const;
    Q_INVOKABLE QVariantMap dateWithMostEntries() const;

    int count() const { return m_entries.count(); }


signals:
    void countChanged();
    void moodStatsChanged();

private:
    QList<EntryUser> m_entries;
};
