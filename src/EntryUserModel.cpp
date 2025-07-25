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
    QMap<int, int> moodCounts;
    QVector<int> moods;

    for (int i = 0; i < count; ++i) {
        QModelIndex idx = index(i, 0);
        int mood = data(idx, MoodIdRole).toInt();
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

    int veryGood = moodCounts.value(1, 0);
    int good = moodCounts.value(2, 0);
    int neutral = moodCounts.value(3, 0);
    int bad = moodCounts.value(4, 0);
    int veryBad = moodCounts.value(5, 0);

    QStringList summaryList;
    QString stabilityColor;

    if (avgMood <= 2.0 && veryBad <= 2) {
        summaryList << "Месяц прошёл спокойно.";
        stabilityColor = "#5ACC78";
    } else if (avgMood >= 4.0 && veryGood <= 2) {
        summaryList << "Месяц был тяжёлым.";
        stabilityColor = "#C04753";
    } else if (stddev < 0.8) {
        summaryList << "Настроение было стабильным.";
        stabilityColor = "#8AB195";
    } else if (stddev < 1.5) {
        summaryList << "Настроение немного колебалось.";
        stabilityColor = "#D4C447";
    } else {
        summaryList << "Настроение сильно менялось.";
        stabilityColor = "#D47947";
    }

    double veryGoodRatio = static_cast<double>(veryGood) / count;
    double veryBadRatio = static_cast<double>(veryBad) / count;
    double neutralRatio = static_cast<double>(neutral) / count;
    double dominantMoodRatio = static_cast<double>(primaryCount) / count;

    // Более тонкий анализ
    if (veryBadRatio >= 0.5)
        summaryList << "Плохое настроение преобладало.";
    else if (veryBadRatio >= 0.35)
        summaryList << "Плохое настроение было частым.";

    if (veryGoodRatio >= 0.5)
        summaryList << "Хорошее настроение преобладало.";
    else if (veryGoodRatio >= 0.35)
        summaryList << "Хорошее настроение было частым.";

    if (neutralRatio >= 0.6)
        summaryList << "Настроение было в основном нейтральным.";

    if (dominantMoodRatio >= 0.5)
        summaryList << "Преобладало одно настроение.";

    // Использовались ли почти все типы настроения
    int moodTypesUsed = 0;
    for (int i = 1; i <= 5; ++i) {
        if (moodCounts.value(i, 0) > 0)
            moodTypesUsed++;
    }
    if (moodTypesUsed <= 2)
        summaryList << "Настроение менялось редко.";

    // Почти не было нейтрального
    if (neutralRatio < 0.1 && (veryGood + good + bad + veryBad) >= count * 0.9)
        summaryList << "Настроение колебалось между крайностями.";

    result["avgMoodRounded"] = avgMoodRounded;
    result["avgMoodExact"] = avgMood;
    result["primaryCount"] = primaryCount;
    result["stabilityText"] = summaryList.join(" ");
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

        int index = date.dayOfWeek() - 1;
        int invertedMood = 6 - entry.getMoodId(); // Инверсия: 1 (лучшее) → 5, 5 (худшее) → 1
        sums[index] += invertedMood;
        counts[index] += 1;
    }

    QVector<QPair<int, double>> indexedAverages;
    for (int i = 0; i < 7; ++i) {
        double avg = counts[i] > 0 ? sums[i] / counts[i] : -1.0;
        indexedAverages.append(qMakePair(i, avg));
    }

    // Отфильтруем дни с данными (avg >= 0)
    QVector<QPair<int, double>> validAverages;
    for (const auto& pair : indexedAverages) {
        if (pair.second >= 0.0)
            validAverages.append(pair);
    }

    // Если нет данных — возвращаем сразу с -1 для всех
    if (validAverages.isEmpty()) {
        QVariantList emptyAverages;
        for (int i = 0; i < 7; ++i)
            emptyAverages.append(-1.0);

        QVariantMap result;
        result["averages"] = emptyAverages;
        result["bestDayIndex"] = -1;
        result["secondDayIndex"] = -1;
        result["thirdDayIndex"] = -1;
        result["bestDay"] = QString("");
        result["secondDay"] = QString("");
        result["thirdDay"] = QString("");
        return result;
    }

    // Сортируем валидные по возрастанию для нормализации
    std::sort(validAverages.begin(), validAverages.end(), [](const QPair<int, double> &a, const QPair<int, double> &b) {
        return a.second < b.second;
    });

    // Применяем минимальный интервал 0.3
    for (int i = 1; i < validAverages.size(); ++i) {
        double prev = validAverages[i - 1].second;
        double &curr = validAverages[i].second;

        if (curr - prev < 0.3)
            curr = prev + 0.3;
    }

    // Ограничиваем значения по диапазону [0.5, 5.4]
    for (auto &pair : validAverages) {
        pair.second = std::clamp(pair.second, 0.5, 5.4);
    }

    // Создаём итоговый массив adjusted с -1 по умолчанию
    QVector<double> adjusted(7, -1.0);
    for (const auto &pair : validAverages) {
        adjusted[pair.first] = pair.second;
    }

    QVariantList averages;
    for (double val : adjusted) {
        averages.append(val);
    }

    // Находим топ-3 среди дней с валидными значениями
    QVector<QPair<int, double>> sortedForBest;
    for (int i = 0; i < 7; ++i) {
        if (adjusted[i] >= 0.0)
            sortedForBest.append(qMakePair(i, adjusted[i]));
    }

    std::sort(sortedForBest.begin(), sortedForBest.end(), [](const QPair<int, double> &a, const QPair<int, double> &b) {
        return a.second > b.second;
    });

    auto getValidIndex = [&](int pos) -> int {
        return (sortedForBest.size() > pos) ? sortedForBest[pos].first : -1;
    };

    int bestIndex = getValidIndex(0);
    int secondIndex = getValidIndex(1);
    int thirdIndex = getValidIndex(2);

    static const char* dayNames[7] = {
        "понедельник", "вторник", "среда",
        "четверг", "пятница", "суббота", "воскресенье"
    };

    QVariantMap result;
    result["averages"] = averages;
    result["bestDayIndex"] = bestIndex;
    result["secondDayIndex"] = secondIndex;
    result["thirdDayIndex"] = thirdIndex;
    result["bestDay"] = (bestIndex >= 0) ? QString(dayNames[bestIndex]) : QString("");
    result["secondDay"] = (secondIndex >= 0) ? QString(dayNames[secondIndex]) : QString("");
    result["thirdDay"] = (thirdIndex >= 0) ? QString(dayNames[thirdIndex]) : QString("");

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
        result["formattedDate"] = "... которых в этом месяце не было!";
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
