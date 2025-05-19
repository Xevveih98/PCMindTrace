#ifndef TODOUSER_H
#define TODOUSER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QDebug>
#include <QUrlQuery>

class TodoUser : public QObject
{
    Q_OBJECT
public:
    explicit TodoUser(QObject *parent = nullptr);

    Q_INVOKABLE void saveTodo(const QString &todo);
    Q_INVOKABLE void loadTodo();
    Q_INVOKABLE void deleteTodo(const QString &todo);

signals:
    void todoSavedSuccess();
    void todoSavedFailed(const QString &error);
    void todoosLoadedSuccess(const QStringList &todoos);
    void todoosLoadedFailed(const QString &error);
    void todoDeletedSuccess();
    void todoDeletedFailed(const QString &error);
    void clearTodoList();

private slots:
    void onTodoSaveReply(QNetworkReply *reply);
    void onUserTodoFetchReply(QNetworkReply *reply);
    void onTodoDeleteReply(QNetworkReply *reply);

private:
    void sendToServer(const QJsonDocument &jsonDoc, const QUrl &url);

    void sendTodoSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url);
    void sendTodoDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url);

    QNetworkAccessManager m_networkUser;
};

#endif // TODOUSER_H
