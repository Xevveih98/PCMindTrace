#ifndef CATEGORIESUSER_H
#define CATEGORIESUSER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QDebug>
#include <QUrlQuery>

class CategoriesUser : public QObject
{
    Q_OBJECT
public:
    explicit CategoriesUser(QObject *parent = nullptr);

    Q_INVOKABLE void saveTags(const QStringList &tags);
    Q_INVOKABLE void loadTags();
    Q_INVOKABLE void deleteTag(const QString &tag);

    Q_INVOKABLE void saveActivity(const QString &iconId, const QString &iconlabel);
    Q_INVOKABLE void loadActivity();
    Q_INVOKABLE void deleteActivity(const QString &activity);

    Q_INVOKABLE void saveEmotion(const QString &iconId, const QString &emotionLabel);
    Q_INVOKABLE void loadEmotion();
    Q_INVOKABLE void deleteEmotion(const QString &emotion);


signals:
    void tagsSavedSuccess();
    void tagsSavedFailed(const QString &error);
    void tagsLoaded(const QStringList &tags);
    void tagsLoadedFailed(const QString &error);
    void tagDeletedSuccess();
    void tagDeletedFailed(const QString &error);

    void activitySavedSuccess();
    void activitySavedFailed(const QString &error);
    void activityLoadedSuccess(const QVariantList &activities);
    void activityLoadedFailed(const QString &error);
    void activityDeletedSuccess();
    void activityDeletedFailed(const QString &error);

    void emotionSavedSuccess();
    void emotionSavedFailed(const QString &error);
    void emotionLoadedSuccess(const QVariantList &emotions);
    void emotionLoadedFailed(const QString &error);
    void emotionDeletedSuccess();
    void emotionDeletedFailed(const QString &error);

private slots:
    void onTagsSaveReply(QNetworkReply *reply);
    void onUserTagsFetchReply(QNetworkReply *reply);
    void onTagDeleteReply(QNetworkReply *reply);

    void onActivitySaveReply(QNetworkReply *reply);
    void onUserActivitiesFetchReply(QNetworkReply *reply);
    void onActivityDeleteReply(QNetworkReply *reply);

    void onEmotionSaveReply(QNetworkReply *reply);
    void onUserEmotionsFetchReply(QNetworkReply *reply);
    void onEmotionDeleteReply(QNetworkReply *reply);

private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);

    void sendTagsSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendTagDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url);

    void sendActivitySaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendActivityDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url);

    void sendEmotionSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendEmotionDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url);

    QNetworkAccessManager m_networkUser;
};

#endif // CATEGORIESUSER_H
