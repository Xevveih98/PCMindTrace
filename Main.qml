import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0
import CustomComponents

Window {
    id: mainLoader
    width: 411
    height: 914
    visible: true
    color: "#181718"

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: AppSave.isUserLoggedIn() ? "qrc:/pages/mainContent.qml" : "qrc:/pages/AuthWindow.qml"
    }

    CustNtfyAntn {
        id: notify
        notificationTitle: "уведомление"
    }

    Connections {
        target: authUser
        onLoginSuccess: {
            Qt.callLater(function() {
                notify.notificationTitle = "Вход прошел успешно!"
                notify.triggerAnimation()
                pageLoader.source = "qrc:/pages/mainContent.qml"
            })
        }
    }

    Connections {
        target: authUser
        onLogoutSuccess: {
            Qt.callLater(function() {
                notify.notificationTitle = "Успешный выход!"
                notify.triggerAnimation()
                pageLoader.source = "qrc:/pages/AuthWindow.qml";
            })
        }
    }

    Connections {
        target: authUser
        onDeleteUserSuccess: {
            Qt.callLater(function() {
                notify.notificationTitle = "Аккаунт удален!"
                notify.triggerAnimation()
                pageLoader.source = "qrc:/pages/AuthWindow.qml";
            })
        }
    }

    Connections {
        target: authUser
        onPasswordRecoverSuccess: {
            Qt.callLater(function() {
                notify.notificationTitle = "Аккаунт восстановлен!"
                notify.triggerAnimation()
                pageLoader.source = "qrc:/pages/mainContent.qml";
            })
        }
    }
}


//------------------ ПОТОМ
// 1. Сделать статистику (попап) --

//------------------ СДЕЛАНО
// 2. Уведомления для смены почты и пароля
// 3. Смену пароля
// 4. Уведомления для выхода из аккаунта и удаления

//------------------ СДЕЛАТЬ

// 5. Пин код
// 6. Поправить категории
// 7. Смена логина
// 8. Добавить фильтр по эмоциям и активностям
// 9. Сделать очистку фильтров
// 10. Сделать сравнение по неделям(горизонтальные бары)
// 11. Переделать насыщенный день под самый счастливый
// 12. Добавить самый плохой день за месяц
// 13. Тоггл для менеджера папок
// 14. Поправить менеджер папок
// 15. Поправить задачи на сегодня(быстрые задачи)
// 16. Поправить записи? (дать возможность не заполнять содержание)
// 17. Добавить раздел "Справка"
// 18. Подумать что можно впихнуть в профиль

