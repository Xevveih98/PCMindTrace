import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Rectangle {
    id: pageHomeScreen
    color: "#181718"
    property int selectedFolderId: -1

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

        Flickable {
            id: flickable
            anchors.fill: parent
            contentWidth: width
            contentHeight: eda.height + 70
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: eda
                width: parent.width
                spacing: 12

// ---------------- менеджер папок -----------------

                Item {
                    id: folderTabs
                    width: parent.width
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
                                id: foldersListView

                                delegate: CustFoldButn {
                                    folderName: model.foldername
                                    buttonWidth: implicitWidth
                                    buttonHeight: 40
                                    isSelected: ListView.isCurrentItem
                                    onClicked: {
                                        pageHomeScreen.selectedFolderId = model.id;
                                        pageHomeScreen.loadEntriesForCurrentFilter();
                                    }

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
                            width: parent.width * 0.9
                            height: parent.height * 0.77
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width * 1.02
                                height: parent.height * 1.03
                                color: "#262326"
                                radius: 8

                                Text {
                                    anchors.centerIn: parent
                                    text: "Список задач пуст.."
                                    color: "#4d4d4d"
                                    font.pixelSize: 11
                                    font.italic: true
                                    visible: todoListModel.count === 0
                                }
                            }

                            ListView {
                                anchors.fill: parent
                                model: todoListModel
                                spacing: 6
                                clip: true

                                delegate: CustChbxHome {
                                    todoName: model.todoname
                                    buttonWidth: sdeer.width
                                    buttonHeight: 32
                                    todoIndex: index

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

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                console.log("Выбран iconId:", model.iconId);
                                                var component = Qt.createComponent("qrc:/popups/popEntryCreator.qml");
                                                if (component.status === Component.Ready) {
                                                    var popup = component.createObject(parent, {
                                                        selectedIconId: model.iconId,
                                                        foldersList: pageHomeScreen.folderu
                                                    });
                                                    if (popup) {
                                                        popup.open();
                                                    } else {
                                                        console.error("Не удалось создать объект попапа.");
                                                    }
                                                } else if (component.status === Component.Error) {
                                                    console.error("Ошибка при загрузке компонента: " + component.errorString());
                                                }
                                            }

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

// ---------------- менеджер фильтрации записей по дате

                Item {
                    id: monthSwitchButton
                    width: contro.implicitWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 60

                    property var monthsNom: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
                    property int selectedYear: new Date().getFullYear()
                    property int selectedMonth: new Date().getMonth() + 1
                    property var today: new Date()

                    Row {
                        id: contro
                        height: 30
                        spacing: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width

                        // Левая стрелка
                        Item {
                            id: leftArrowItem
                            width: 40
                            height: parent.height

                            Image {
                                width: 30
                                height: 30
                                anchors.centerIn: parent
                                source: "qrc:/images/left-arrow.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (monthSwitchButton.selectedMonth === 1) {
                                        monthSwitchButton.selectedMonth = 12;
                                        monthSwitchButton.selectedYear--;
                                    } else {
                                        monthSwitchButton.selectedMonth--;
                                    }
                                    monthSwitchButton.updateDisplay();
                                }
                            }
                        }

                        Item {
                            width: 160
                            height: parent.height

                            Text {
                                id: monthYearText
                                color: "#d9d9d9"
                                text: ""
                                font.pixelSize: 18
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Item {
                            id: rightArrowItem
                            width: 40
                            height: parent.height

                            Image {
                                id: rightArrowImage
                                width: 30
                                height: 30
                                anchors.centerIn: parent
                                source: "qrc:/images/right-arrow(2).png"
                                fillMode: Image.PreserveAspectFit
                                opacity: rightArrowArea.enabled ? 1.0 : 0.4
                            }

                            MouseArea {
                                id: rightArrowArea
                                anchors.fill: parent
                                enabled: !(monthSwitchButton.selectedYear === monthSwitchButton.today.getFullYear() &&
                                           monthSwitchButton.selectedMonth === (monthSwitchButton.today.getMonth() + 1))
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                                onClicked: {
                                    if (!enabled)
                                        return;

                                    if (monthSwitchButton.selectedMonth === 12) {
                                        monthSwitchButton.selectedMonth = 1;
                                        monthSwitchButton.selectedYear++;
                                    } else {
                                        monthSwitchButton.selectedMonth++;
                                    }
                                    monthSwitchButton.updateDisplay();
                                }
                            }
                        }
                    }

                    function updateDisplay() {
                        var monthName = monthsNom[selectedMonth - 1];
                        monthYearText.text = monthName + " " + selectedYear;
                        pageHomeScreen.loadEntriesForCurrentFilter();
                        rightArrowArea.enabled = !(selectedYear === today.getFullYear() && selectedMonth === (today.getMonth() + 1));
                        rightArrowImage.opacity = rightArrowArea.enabled ? 1.0 : 0.25;
                        rightArrowArea.cursorShape = rightArrowArea.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor;
                    }

                    Component.onCompleted: updateDisplay()
                }



// ---------------- менеджер отображения записей ------

                Item {
                    id:entryFeed
                    width:  parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitHeight: entryColumn.implicitHeight

                    Column {
                        id: entryColumn
                        width: parent.width
                        spacing: 10

                        Repeater {
                            model: entriesUser.entryUserModel
                            delegate: CustEntrBlok {
                                width: entryColumn.width
                                entryTitle: model.title
                                entryContent: model.content
                                entryDate: model.date
                                entryTime: model.time
                                entryMood: model.moodId
                                tagItems: model.tags
                                activityItems: model.activities
                                emotionItems: model.emotions
                                entryId: model.id
                                foldersList: pageHomeScreen.folderu
                            }
                            visible: entriesUser.entryUserModel.count > 0
                        }
                    }

                    Item {
                        width: 80
                        //height: 80
                        anchors.centerIn: parent
                        visible: entriesUser.entryUserModel.count === 0

                        Column {
                            spacing: 8
                            width: parent.width

                            Image {
                                width: 60
                                height: 60
                                source: "qrc:/images/noentries.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                id: emptyText
                                text: "Записи не найдены.."
                                font.italic: true
                                font.bold: true
                                font.pixelSize: 14
                                color: "#616161"
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: entriesUser.entryUserModel.count === 0
                            }
                        }
                    }
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
                    todoname: todoos[i]
                });
                console.log("Элемент списка:", todoos[i])
            }
        }
    }

    property var folderu: []

    Connections {
        target: foldersUser
        onFoldersLoadedSuccess: function(folders) {
            console.log("Данные загружены:", folders);

            folderu = folders;

            foldersListModel.clear();
            for (let i = 0; i < folders.length; ++i) {
                foldersListModel.append({
                    id: folders[i].id,
                    foldername: folders[i].name,
                    itemCount: folders[i].itemCount
                });
            }

            if (folders.length > 0) {
                pageHomeScreen.selectedFolderId = folders[0].id;
                pageHomeScreen.loadEntriesForCurrentFilter();
            }
        }

        onClearFolderList: {
            foldersListModel.clear();
            folderu = [];
        }
    }

    Component.onCompleted: {
        entriesUser.entryUserModel.clear()
        entriesUser.entryUserModel
        foldersUser.loadFolder();
        todoUser.loadTodo();
        entriesUser.loadUserEntries(selectedFolderId,
                                    monthSwitchButton.selectedYear,
                                    monthSwitchButton.selectedMonth);
        pageHomeScreen.loadEntriesForCurrentFilter();
    }

    IconModelMod {
        id: iconModelMood
    }

    function loadEntriesForCurrentFilter() {
        if (selectedFolderId === -1) {
            console.log("Папка не выбрана, записи не загружаем");
            return;
        }
        console.log("Загрузка записей для папки", selectedFolderId,
                    "за", monthSwitchButton.selectedMonth, monthSwitchButton.selectedYear);
        entriesUser.loadUserEntries(selectedFolderId,
                                   monthSwitchButton.selectedYear,
                                   monthSwitchButton.selectedMonth);
    }
}
