#include "EntryUsermodel.h"

EntryUserModel::EntryUserModel(QObject *parent)
    : QAbstractListModel(parent)
{
    connect(this, &EntryUserModel::countChanged, this, [](){
        qDebug() << "[EntryUserModel] countChanged сигнал испущен";
    });
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

    qDebug() << "В модели(QAbstractListModel) установлено записей:" << m_entries.size();

    endResetModel();
    emit countChanged();
    qDebug() << "countChanged сигнал отправлен";
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

QVariantMap EntryUserModel::averageMoodByDay() const
{
    QMap<int, QList<int>> dayToMoods;

    for (const EntryUser &entry : m_entries) {
        if (!entry.getDate().isValid())
            continue;

        int day = entry.getDate().day();
        dayToMoods[day].append(entry.getMoodId());
    }

    QVariantMap result;
    for (auto it = dayToMoods.begin(); it != dayToMoods.end(); ++it) {
        const QList<int> &moods = it.value();
        if (!moods.isEmpty()) {
            int sum = std::accumulate(moods.begin(), moods.end(), 0);
            int avg = qRound(static_cast<double>(sum) / moods.size());
            result[QString::number(it.key())] = avg;
        }
    }

    return result;
}

QVariantMap EntryUserModel::calculateMoodStats() const
{
    QVariantMap result;

    int count = rowCount();
    if (count == 0) {
        result["avgMoodRounded"] = 0;
        result["avgMoodExact"] = 0.0;
        result["primaryCount"] = 0;
        result["stabilityText"] = "(нет данных)";
        result["stabilityColor"] = "#808080";
        return result;
    }

    int sumMood = 0;
    QMap<int, int> moodCounts; // moodId -> количество
    QVector<int> moods; // для дисперсии

    for (int i = 0; i < count; ++i) {
        QModelIndex idx = index(i, 0);
        int mood = data(idx, MoodIdRole).toInt(); // RoleMoodId — роль для moodId, нужно заменить на твою роль
        sumMood += mood;
        moodCounts[mood]++;
        moods.append(mood);
    }

    double avgMood = static_cast<double>(sumMood) / count;
    int avgMoodRounded = qRound(avgMood);
    int primaryCount = moodCounts.value(avgMoodRounded, 0);

    double variance = 0;
    for (int mood : moods) {
        double diff = mood - avgMood;
        variance += diff * diff;
    }
    variance /= count;
    double stddev = sqrt(variance);

    QString stabilityText;
     QString stabilityColor;

    if (stddev < 0.5) {
        stabilityText = "(очень стабильное настроение!)";
        stabilityColor = "#3CB371";
    } else if (stddev < 1.35) {
        stabilityText = "(стабильное настроение!)";
        stabilityColor = "#519D65";
    } else if (stddev < 2.5) {
        stabilityText = "(настроение колеблется)";
        stabilityColor = "#D2691E";
    } else {
        stabilityText = "(настроение сильно нестабильное)";
        stabilityColor = "#B22222";
    }

    result["avgMoodRounded"] = avgMoodRounded;
    result["avgMoodExact"] = avgMood;
    result["primaryCount"] = primaryCount;
    result["stabilityText"] = stabilityText;
    result["stabilityColor"] = stabilityColor;

    return result;
}

int EntryUserModel::countMood(int moodId) const
{
    int count = 0;
    for (int i = 0; i < rowCount(); ++i) {
        QModelIndex idx = index(i, 0);
        int mood = data(idx, MoodIdRole).toInt();
        if (mood == moodId)
            ++count;
    }
    return count;
}

QVariantMap EntryUserModel::averageMoodByWeekday() const
{
    QVector<double> sums(7, 0.0);
    QVector<int> counts(7, 0);

    for (const EntryUser &entry : m_entries) {
        QDate date = entry.getDate();
        if (!date.isValid())
            continue;

        int dayOfWeek = date.dayOfWeek();
        int index = dayOfWeek - 1;

        sums[index] += entry.getMoodId();
        counts[index] += 1;
    }

    QVariantList averages;
    double maxAverage = -1.0;
    int bestIndex = -1;

    for (int i = 0; i < 7; ++i) {
        double avg = counts[i] > 0 ? sums[i] / counts[i] : 0.0;
        averages.append(avg);

        if (avg > maxAverage) {
            maxAverage = avg;
            bestIndex = i;
        }
    }
    static const char* dayNames[7] = {
        "понедельник",
        "вторник",
        "среда",
        "четверг",
        "пятница",
        "суббота",
        "воскресенье"
    };

    QVariantMap result;
    result["averages"] = averages;
    result["bestDay"] = (bestIndex >= 0) ? QString(dayNames[bestIndex]) : QString("");

    return result;
}

QVariantMap EntryUserModel::dateWithMostEntries() const
{
    QMap<QDate, int> dateCounts;

    for (const EntryUser &entry : m_entries) {
        QDate date = entry.getDate();
        if (!date.isValid())
            continue;

        dateCounts[date] += 1;
    }

    QVariantMap result;
    if (dateCounts.isEmpty()) {
        qDebug() << "dateCounts is empty!";
        result["formattedDate"] = "";
        result["rawDate"] = "";
        return result;
    }

    QDate bestDate;
    int maxCount = 0;

    for (auto it = dateCounts.constBegin(); it != dateCounts.constEnd(); ++it) {
        qDebug() << "Date:" << it.key() << "Count:" << it.value();
        if (it.value() > maxCount) {
            maxCount = it.value();
            bestDate = it.key();
        }
    }

    qDebug() << "Best date:" << bestDate << "Is valid:" << bestDate.isValid();

    if (!bestDate.isValid()) {
        result["formattedDate"] = "";
        result["rawDate"] = "";
        return result;
    }

    static const char* monthNamesGenitive[12] = {
        "января", "февраля", "марта", "апреля", "мая", "июня",
        "июля", "августа", "сентября", "октября", "ноября", "декабря"
    };

    int day = bestDate.day();
    int month = bestDate.month();
    int year = bestDate.year();

    QString formattedDate = QString("%1 %2 %3").arg(day).arg(monthNamesGenitive[month - 1]).arg(year);
    QString rawDate = bestDate.toString(Qt::ISODate);

    qDebug() << "Formatted date:" << formattedDate << "Raw date:" << rawDate;

    result["formattedDate"] = formattedDate;
    result["rawDate"] = rawDate;

    return result;
}
