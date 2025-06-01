import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0

Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.6
    modal: true
    focus: true
    dim: true
    padding: 0
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#181718"
        opacity: 0.9
        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }
    }
    background: Rectangle {
        color: "#2D292C"
        radius: 8

    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            currentIndex: 0
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Добро пожаловать!"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Это пространство для <b><font color='#DA446A'>хранения ваших записей</font></b> и <b><font color='#DA446A'>отслеживания настроения</font></b>.
Приложение поможет наглядно видеть изменения эмоционального состояния и лучше организовать свои мысли и задачи."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Что здесь можно делать?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Создавать тематические <b><font color='#DA446A'>папки</font></b> для удобной организации записей. Добавлять быстрые <b><font color='#DA446A'>задачи</font></b> — краткие заметки и дела. Создавать <b><font color='#DA446A'>записи</font></b> с выбранным настроением, содержанием и собственными категориями.
Отслеживать <b><font color='#DA446A'>динамику</font></b> настроения с помощью календаря и графиков.
Быстро <b><font color='#DA446A'>находить</font></b> нужные записи с помощью поиска по фильтрам и ключевым словам."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Зачем нужны папки?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Папки помогают <b><font color='#DA446A'>организовать</font></b> ваши записи по темам. В каждой папке отображается количество записей, которые к ней относятся. Вы можете <b><font color='#DA446A'>переименовать</font></b> папку в любой момент или <b><font color='#DA446A'>удалить</font></b> её вместе со всеми связанными записями — если она больше не нужна."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260

                        Rectangle {
                            color: "#181718"
                            anchors.fill: parent
                        }

                        ColumnLayout{
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                id: folderTabs
                                Layout.preferredWidth: parent.width * 0.93
                                Layout.preferredHeight: 45
                                Layout.alignment: Qt.AlignCenter

                                Rectangle {
                                    color: "#090809"
                                    radius: 8
                                    anchors.fill: parent

                                    Item {
                                        id: plusminifolder
                                        width: height
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.leftMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        Image {
                                            anchors.centerIn: parent
                                            width: 18
                                            height: 18
                                            source: "qrc:/images/addfolders.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }

                                    ListModel {
                                        id: foldersListModel
                                        ListElement { foldername: "Главная" }
                                        ListElement { foldername: "Мероприятия" }
                                        ListElement { foldername: "Спортзал" }
                                        ListElement { foldername: "Друзья и семья" }
                                    }

                                    Item {
                                        id: sdeeer
                                        anchors.left: plusminifolder.right
                                        width: parent.width * 0.8
                                        height: 40
                                        anchors.verticalCenter: parent.verticalCenter

                                        ListView {
                                            anchors.fill: parent
                                            model: foldersListModel
                                            spacing: 6
                                            orientation: ListView.Horizontal
                                            clip: true
                                            id: foldersListView

                                            delegate: CustFoldButn {
                                                folderName: model.foldername
                                                buttonWidth: implicitWidth
                                                buttonHeight: 40
                                                isSelected: ListView.isCurrentItem
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Что за задачи на сегодня?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Задачи на сегодня помогают <b><font color='#DA446A'>сфокусироваться</font></b> на важных делах. Просто добавьте короткие пункты — например, «купить молоко» или «сделать зарядку». Когда задача выполнена, <b><font color='#DA446A'>отметьте её</font></b> галочкой — и она исчезнет из списка, чтобы не отвлекать."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260

                        Rectangle {
                            color: "#181718"
                            anchors.fill: parent
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                id: todayTasksView
                                Layout.preferredWidth: parent.width*0.93
                                Layout.preferredHeight: 210
                                Layout.alignment: Qt.AlignCenter

                                Rectangle {
                                    color: "#2D292C"
                                    radius: 8
                                    anchors.fill: parent
                                }

                                Item {
                                    height: 40
                                    width: parent.width

                                    Text{
                                        color: "#d9d9d9"
                                        text: "Задачи на сегодня"
                                        font.pixelSize: 16
                                        font.bold: true
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                Item {
                                    id: plusminitodo
                                    width: height
                                    height: 36
                                    anchors.left: parent.left
                                    anchors.leftMargin: 16

                                    Image {
                                        anchors.centerIn: parent
                                        width: 20
                                        height: 20
                                        source: "qrc:/images/addtodoos.png"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                ListModel {
                                    id: todoListModel

                                    ListElement { todoname: "Купить молоко" }
                                    ListElement { todoname: "Позвонить другу" }
                                    ListElement { todoname: "Закончить проект" }
                                    ListElement { todoname: "Прочитать 10 страниц книги" }
                                }

                                Item {
                                    id: sdeer
                                    anchors.top: plusminitodo.bottom
                                    width: parent.width
                                    height: parent.height * 0.77
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "#262326"
                                    }

                                    Item {
                                        id: mama
                                        width: parent.width *0.96
                                        height: parent.height * 0.9
                                        anchors.centerIn: parent

                                        ListView {
                                            anchors.fill: parent
                                            model: todoListModel
                                            spacing: 6
                                            clip: true

                                            delegate: CustChbxHome {
                                                todoName: model.todoname
                                                buttonWidth: mama.width
                                                buttonHeight: 32
                                                //todoIndex: index
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Как добавить запись?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Чтобы <b><font color='#DA446A'>добавить запись</font></b>, нажмите на одну из пяти эмоций на главной странице — так вы задаёте настроение. Затем укажите <b><font color='#DA446A'>заголовок</font></b> записи, при желании добавьте текст и выберите <b><font color='#DA446A'>подходящие категории</font></b> — теги, события и впечатления, которые лучше всего описывают ваш день."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260

                        Rectangle {
                            color: "#181718"
                            anchors.fill: parent
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                id: newEntryPanel
                                Layout.preferredWidth: parent.width * 0.9
                                Layout.preferredHeight: 100
                                Layout.alignment: Qt.AlignHCenter

                                Rectangle {
                                    color: "#2D292C"
                                    radius: 12
                                    anchors.fill: parent

                                    Item {
                                        id: headerwha
                                        height: 36
                                        width: parent.width

                                        Text{
                                            color: "#d9d9d9"
                                            text: "Что вы сейчас чувствуете?"
                                            font.pixelSize: 16
                                            font.bold: true
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    IconModelMod {
                                        id: iconModelMood
                                    }

                                    Item {
                                        anchors.top: headerwha.bottom
                                        width: parent.width * 0.86
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        height: 60

                                        Row {
                                            id: iconRow
                                            anchors.fill: parent
                                            spacing: 12

                                            Repeater {
                                                model: iconModelMood
                                                delegate: Item {
                                                    width: 45
                                                    height: 45
                                                    Image {
                                                        anchors.fill: parent
                                                        source: model.path
                                                        fillMode: Image.PreserveAspectFit
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Что за категории?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Категории помогают <b><font color='#DA446A'>точнее описать</font></b> ваш день.
Они делятся на три типа:
     <b><font color='#DA446A'>События</font></b> — что происходило (например, готовка, спорт, прогулка с друзьями)
     <b><font color='#DA446A'>Впечатления</font></b> — как вы это восприняли (например, «не понравилось», «смеялась до слёз»)
     <b><font color='#DA446A'>Теги</font></b> — с кем или с чем это было связано (например, мама, школа, сестра)
Выбирайте всё, что подходит — это поможет лучше понять себя при просмотре записей позже."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "Где найти эти категории?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "<b>Настроить категории</b> можно во вкладке <b><font color='#DA446A'>настроек</font></b>,
в разделе <b><font color='#DA446A'>«Управление категориями»</font></b> — добавляйте свои варианты, меняйте или удаляйте ненужные."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260

                        Rectangle {
                            color: "#181718"
                            anchors.fill: parent
                        }

                        Item {
                            width:parent.width*0.86
                            height: parent.height * 0.8
                            anchors.centerIn: parent


                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 0

                                Label {
                                    Layout.fillWidth: true
                                    Layout.leftMargin: -14
                                    Layout.topMargin: 0
                                    Layout.bottomMargin: 10
                                    text: "Управление категориями"
                                    font.pixelSize: 19
                                    color: "#d9d9d9"
                                    font.bold: true
                                }

                                CustButtSett {
                                    Layout.fillWidth: true

                                    buttonText: "Редактировать события"
                                    iconSource: "qrc:/images/DataRecovery.png"
                                }

                                CustButtSett {
                                    Layout.fillWidth: true

                                    buttonText: "Редактировать впечатления"
                                    iconSource: "qrc:/images/DataRecovery.png"
                                }

                                CustButtSett {
                                    Layout.fillWidth: true

                                    buttonText: "Редактировать теги"
                                    iconSource: "qrc:/images/DataRecovery.png"
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "За что отвечают другие пункты меню?"
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: " <b><font color='#DA446A'>Главная</font></b> — настройка папок, добавление быстрых задач и создание первой записи.
 <b><font color='#DA446A'>Поиск</font></b> — быстрый доступ к записям по ключевым словам, тегам и категориям.
 <b><font color='#DA446A'>Календарь</font></b> — добавление записей в любые даты, просмотр анализа настроения и сравнение с прошлыми периодами.
 <b><font color='#DA446A'>Настройки</font></b> — управление категориями (теги, события, впечатления), <b>изменение данных аккаунта</b> и <b>установка PIN-кода</b> для защиты данных."
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    Text {
                        text: "На случай, если вы потерялись.."
                        color: "#D9D9D9"
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Чтобы открыть меню, <b><font color='#DA446A'>свайпните вправо</font></b> от левого края экрана,
там вы сможете найти пункт <b><font color='#DA446A'>справка</font></b> и ознакомится с основной информацией ещё раз.
Все открывающиеся окна можно легко закрыть, просто кликнув за пределами окна. <b><font color='#DA446A'>Удачи!</font></b> Пусть каждый день будет наполнен яркими эмоциями!"
                        color: "#D9D9D9"
                        font.pixelSize: 14
                        Layout.preferredWidth: parent.width * 0.93
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Button {
                        id: startButton
                        text: "Познать свои чувства"
                        Layout.preferredWidth: parent.width*0.7
                        Layout.alignment: Qt.AlignHCenter
                        background: Rectangle {
                            color: "#AD464B"
                            radius: 100
                        }
                        contentItem: Text {
                            text: startButton.text
                            color: "#d9d9d9"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 16
                        }
                        onClicked: managerPopup.close()
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                    }
                }
            }
        }

        PageIndicator {
            id: indicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            Layout.alignment: Qt.AlignHCenter
            visible: swipeView.currentIndex !== swipeView.count - 1
            delegate: Rectangle {
                width: 8
                height: 8
                radius: 4
                color: index === indicator.currentIndex ? "#DA446A" : "#5A5A5A"
                opacity: index === indicator.currentIndex ? 1 : 0.5
            }
        }
    }
}
