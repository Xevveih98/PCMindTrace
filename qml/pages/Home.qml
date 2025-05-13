import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0
import "../CustomComponents"

Rectangle {
    id: pageHomeScreen
    color: "#181718"

    CustPageHead {
        id: header
        headerWidth: parent.width
        titleText: "Главная"
    }

    Item {
        id: itemcore
        width: parent.width * 0.93
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom

        ScrollView {
            anchors.fill: parent

            Column {
                width: parent.width
                spacing: 12

// ---------------- менеджер папок -----------------

                Item {
                    id: folderTabs
                    width:  parent.width
                    height: 45

                    Rectangle {
                        color: "#090809"
                        border.color: "#363636"
                        border.width: 1
                        radius: 8
                        anchors.fill: parent

                        Item {
                            id: plusminifolder
                            width: height
                            height: 40
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Попытка создать компонент popFoldersManager.qml");
                                    var component = Qt.createComponent("qrc:/popups/popFoldersManager.qml");
                                    if (component.status === Component.Ready) {
                                        console.log("Компонент успешно загружен.");

                                        var popup = component.createObject(parent);
                                        if (popup) {
                                            console.log("Попап успешно создан.");
                                            popup.open(); // Открываем попап
                                        } else {
                                            console.error("Не удалось создать объект попапа.");
                                        }
                                    } else if (component.status === Component.Error) {
                                        console.error("Ошибка при загрузке компонента: " + component.errorString());
                                    } else {
                                        console.log("Компонент еще не готов.");
                                    }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                    source: "qrc:/images/addbuttplus.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }

                        ListModel {
                            id: foldersListModel
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
                                id: foldersListView  // добавим id

                                delegate: CustFoldButn {
                                    folderName: model.foldername
                                    buttonWidth: implicitWidth
                                    buttonHeight: 40
                                    isSelected: ListView.isCurrentItem  // подсвечивать выбранный

                                    Component.onCompleted: {
                                        console.log("Загружен в главное окно делегат с папкой:", model.foldername);
                                    }
                                }
                            }
                        }
                    }
                }

// ---------------- менеджер тудейс ------------------

                Item {
                    id: todayTasksView
                    width:  parent.width
                    height: 240

                    Rectangle {
                        color: "#2D292C"
                        radius: 8
                        anchors.fill: parent

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
                            height: 40
                            anchors.left: parent.left
                            anchors.leftMargin: 16

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Попытка вызвать менеджер задач");
                                    var component = Qt.createComponent("qrc:/popups/popTodoosManager.qml");
                                    if (component.status === Component.Ready) {
                                        console.log("Компонент успешно загружен.");

                                        var popup = component.createObject(parent);
                                        if (popup) {
                                            console.log("Попап успешно создан.");
                                            popup.open(); // Открываем попап
                                        } else {
                                            console.error("Не удалось создать объект попапа.");
                                        }
                                    } else if (component.status === Component.Error) {
                                        console.error("Ошибка при загрузке компонента: " + component.errorString());
                                    } else {
                                        console.log("Компонент еще не готов.");
                                    }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                    source: "qrc:/images/addbuttplus.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }

                        ListModel {
                            id: todoListModel
                        }

                        Item {
                            id: sdeer
                            anchors.top: plusminitodo.bottom
                            //anchors.topMargin:
                            width: parent.width * 0.9
                            height: parent.height * 0.79
                            anchors.horizontalCenter: parent.horizontalCenter

                            ListView {
                                anchors.fill: parent
                                model: todoListModel
                                spacing: 6
                                clip: true

                                delegate: CustChbxHome {
                                    todoName: model.todoname
                                    buttonWidth: sdeer.width
                                    buttonHeight: 32
                                    todoIndex: index  // ← передаём индекс

                                    onRequestDelete: function(i) {
                                        console.log("Удаление из модели:", i);
                                        todoListModel.remove(i);
                                    }
                                }
                            }
                        }
                    }
                }

// ---------------- менеджер записей ------------------

                Item {
                    id: newEntryPanel
                    width:  parent.width * 0.86
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 100

                    Rectangle {
                        color: "#2D292C"
                        radius: 8
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

                        Item {
                            anchors.top: headerwha.bottom
                            width: parent.width * 0.86
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.height * 0.46

                            Row {
                                height: parent.height
                                spacing: 12

                                Item {
                                    id: buttemote1
                                    width: height
                                    height: 45

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Попытка вызвать форму создания записи.");
                                            var component = Qt.createComponent("qrc:/popups/popEntryCreator.qml");
                                            if (component.status === Component.Ready) {
                                                console.log("Компонент успешно загружен.");

                                                var popup = component.createObject(parent);
                                                if (popup) {
                                                    console.log("Попап успешно создан.");
                                                    popup.open();
                                                } else {
                                                    console.error("Не удалось создать объект попапа.");
                                                }
                                            } else if (component.status === Component.Error) {
                                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                                            } else {
                                                console.log("Компонент еще не готов.");
                                            }
                                        }

                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/images/ehappy.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Item {
                                    id: buttemote2
                                    width: height
                                    height: 45

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Попытка вызвать менеджер задач");
                                            var component = Qt.createComponent("qrc:/popups/popEntryCreator.qml");
                                            if (component.status === Component.Ready) {
                                                console.log("Компонент успешно загружен.");

                                                var popup = component.createObject(parent);
                                                if (popup) {
                                                    console.log("Попап успешно создан.");
                                                    popup.open(); // Открываем попап
                                                } else {
                                                    console.error("Не удалось создать объект попапа.");
                                                }
                                            } else if (component.status === Component.Error) {
                                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                                            } else {
                                                console.log("Компонент еще не готов.");
                                            }
                                        }

                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/images/ecalm.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Item {
                                    id: buttemote3
                                    width: height
                                    height: 45

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Попытка вызвать менеджер задач");
                                            var component = Qt.createComponent("qrc:/popups/popEntryCreator.qml");
                                            if (component.status === Component.Ready) {
                                                console.log("Компонент успешно загружен.");

                                                var popup = component.createObject(parent);
                                                if (popup) {
                                                    console.log("Попап успешно создан.");
                                                    popup.open(); // Открываем попап
                                                } else {
                                                    console.error("Не удалось создать объект попапа.");
                                                }
                                            } else if (component.status === Component.Error) {
                                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                                            } else {
                                                console.log("Компонент еще не готов.");
                                            }
                                        }

                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/images/econfused.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Item {
                                    id: buttemote4
                                    width: height
                                    height: 45

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Попытка вызвать менеджер задач");
                                            var component = Qt.createComponent("qrc:/popups/popEntryCreator.qml");
                                            if (component.status === Component.Ready) {
                                                console.log("Компонент успешно загружен.");

                                                var popup = component.createObject(parent);
                                                if (popup) {
                                                    console.log("Попап успешно создан.");
                                                    popup.open(); // Открываем попап
                                                } else {
                                                    console.error("Не удалось создать объект попапа.");
                                                }
                                            } else if (component.status === Component.Error) {
                                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                                            } else {
                                                console.log("Компонент еще не готов.");
                                            }
                                        }

                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/images/eupset.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Item {
                                    id: buttemote5
                                    width: height
                                    height: 45

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Попытка вызвать менеджер задач");
                                            var component = Qt.createComponent("qrc:/popups/popEntryCreator.qml");
                                            if (component.status === Component.Ready) {
                                                console.log("Компонент успешно загружен.");

                                                var popup = component.createObject(parent);
                                                if (popup) {
                                                    console.log("Попап успешно создан.");
                                                    popup.open(); // Открываем попап
                                                } else {
                                                    console.error("Не удалось создать объект попапа.");
                                                }
                                            } else if (component.status === Component.Error) {
                                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                                            } else {
                                                console.log("Компонент еще не готов.");
                                            }
                                        }

                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/images/etear.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

// ---------------- менеджер фильтрации записей по дате

                Item {
                    id: monthSwitchButton
                }

// ---------------- менеджер отображения записей ------

                Item {
                    id:entryFeed
                }
            }
        }
    }

    Connections {
        target: todoUser
        onTodoosLoadedSuccess: function(todoos) {
            console.log("Данные загружены:", todoos);
            todoListModel.clear();
            for (let i = 0; i < todoos.length; ++i) {
                todoListModel.append({
                    todoname: todoos[i]  // todoos[i] — это просто строка
                });
                console.log("Элемент списка:", todoos[i])
            }
        }
    }

    Connections {
        target: foldersUser
        onFoldersLoadedSuccess: function(folders) {
            console.log("Данные загружены:", folders);
            foldersListModel.clear();
            for (let i = 0; i < folders.length; ++i) {
                foldersListModel.append({
                    foldername: folders[i].name,
                    itemCount: folders[i].itemCount
                });
            }
        }
        onClearFolderList: {
            foldersListModel.clear();
        }
    }

    Component.onCompleted: {
        foldersUser.loadFolder();
        todoUser.loadTodo();
    }
}
