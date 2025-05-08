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

signals:
    void tagsSavedSuccess();
    void tagsSavedFailed(const QString &error);

    void tagsLoaded(const QStringList &tags);
    void tagsLoadedFailed(const QString &error);

    void tagDeletedSuccess();
    void tagDeletedFailed(const QString &error);


private slots:
    void onTagsSaveReply(QNetworkReply *reply);
    void onUserTagsFetchReply(QNetworkReply *reply);
    void onTagDeleteReply(QNetworkReply *reply);

private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendTagsSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendTagDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url);

    QNetworkAccessManager m_networkUser;
};

#endif // CATEGORIESUSER_H
