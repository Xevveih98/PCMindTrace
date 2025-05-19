#include "TodoUser.h"
#include "AppSave.h"
#include "AppConfig.h"

TodoUser::TodoUser(QObject *parent)
    : QObject(parent)
{
    connect(&m_networkUser, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {
        QUrl endpoint = reply->request().url();
        qDebug() << "Получен сетевой ответ от:" << endpoint.toString();

        if (endpoint.path().contains("/savetodo")) {
            onTodoSaveReply(reply);
        } else if (endpoint.path().contains("/getusertodoos")) {
            onUserTodoFetchReply(reply);
        } else if (endpoint.path().contains("/deletetodo")) {
            onTodoDeleteReply(reply);
        } else {
            qWarning() << "Необработанный эндпоинт в TodoUser:" << endpoint.toString();
            reply->deleteLater();
        }
    });
    qDebug() << "TodoUser инициализирован и вызван.";
}

// ----------- Сохранение папки -----------

void TodoUser::saveTodo(const QString &todo)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "Сохранение задачи вызвано пользователем:" << savedLogin;
    qDebug() << "Задача:" << todo;

    QJsonObject json;
    json["login"] = savedLogin;
    json["todo"] = todo.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/savetodo");

    sendTodoSaveRequest(jsonDoc, serverUrl);
}

void TodoUser::sendTodoSaveRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "sendTodoSaveRequest вызван.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (сохранить задачу):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onTodoSaveReply(reply);
    });
}

void TodoUser::onTodoSaveReply(QNetworkReply *reply)
{
    qDebug() << "onTodoSaveReply вызван.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Задача успешно сохранена. Ответ сервера:" << reply->readAll();
        emit todoSavedSuccess();
        TodoUser::loadTodo();
    } else {
        qWarning() << "Задача не сохранилась. Ответ сервера:" << reply->errorString();
        emit todoSavedFailed(reply->errorString());
    }
    reply->deleteLater();
}

// ----------- Выгрузка папок -----------

void TodoUser::loadTodo()
{
    AppSave appSave;
    QString login = appSave.getSavedLogin();
    qDebug() << "Выгружаем задачи для пользователя:" << login;

    QUrl serverUrl = AppConfig::apiUrl("/getusertodoos");
    QUrlQuery query;
    query.addQueryItem("login", login);
    serverUrl.setQuery(query);

    QNetworkRequest request(serverUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkUser.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUserTodoFetchReply(reply);
    });
}

void TodoUser::onUserTodoFetchReply(QNetworkReply *reply)
{
    qDebug() << "Распаковка списка задач.";

    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        qDebug() << "Задачи успешно выгружены. Ответ сервера:" << QString::fromUtf8(response);

        if (response.isEmpty()) {
            qWarning() << "Получен пустой ответ, бездействие.";
            reply->deleteLater();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonArray array = doc.object().value("todoos").toArray();

        QStringList todoos;
        for (const auto &val : array)
            todoos << val.toString();

        qDebug() << "Задачи успешно выгружены." << todoos;
        emit todoosLoadedSuccess(todoos);
    } else {
        qWarning() << "Не удалось загрузить список. Ответ сервера:" << reply->errorString();
        emit todoosLoadedFailed(reply->errorString());
    }

    reply->deleteLater();
}



// ----------- Удаление папки -----------

void TodoUser::deleteTodo(const QString &todo)
{
    AppSave appSave;
    QString savedLogin = appSave.getSavedLogin();

    qDebug() << "Удаление задачи вызвано пользователем:" << savedLogin;
    qDebug() << "Задача:" << todo;

    QJsonObject json;
    json["login"] = savedLogin;
    json["todo"] = todo.trimmed();

    QJsonDocument jsonDoc(json);
    QUrl serverUrl = AppConfig::apiUrl("/deletetodo");
    sendTodoDeleteRequest(jsonDoc, serverUrl);
}

void TodoUser::sendTodoDeleteRequest(const QJsonDocument &jsonDoc, const QUrl &url)
{
    qDebug() << "Отправка задачи для удаления на сервер.";
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QByteArray data = jsonDoc.toJson();
    qDebug() << "Request payload (удаление задачи):" << data;

    QNetworkReply *reply = m_networkUser.post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onTodoDeleteReply(reply);
    });
}

void TodoUser::onTodoDeleteReply(QNetworkReply *reply)
{
    qDebug() << "Получение ответа от сервера по удалению задачи.";
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Задача успешно удалена. Ответ сервера:" << reply->readAll();
        emit todoDeletedSuccess();
        emit clearTodoList();
        TodoUser::loadTodo();
    } else {
        qWarning() << "Удаление задачи не удалось. Ошибка:" << reply->errorString();
        emit todoDeletedFailed(reply->errorString());
    }
    reply->deleteLater();
}
