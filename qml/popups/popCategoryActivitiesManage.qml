import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents
import "../CustomComponents"

Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.6
    modal: true
    focus: true
    dim: true
    padding: 0
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    anchors.centerIn: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#181718"
        opacity: 0.9
    }
    background: Rectangle {
        color: "#2D292C"
        radius: 10
        border.color: "#474448"
        border.width: 1
    }

    Item {
        anchors.fill: parent

        Item {
            width: parent.width * 0.9
            height: parent.height * 0.93
            anchors.centerIn: parent

            // Заголовки
            Text {
                id: header
                text: "Управление активностями"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите иконку и дайте название вашей активности."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: header.bottom
                anchors.topMargin: 14
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: text2
                text: "Чтобы убрать активность - намите на неё."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: text1.bottom
                anchors.topMargin: 1
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            Row {
                id: rowcontent
                anchors.top: text2.bottom
                anchors.topMargin: 18
                height: 50
                spacing: 7

                Item {
                    id: iconSelector
                    width: height
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    property string selectedIconId: ""
                    property string selectedIconPath: "qrc:/icons/add.png" // начальная иконка

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Иконка нажата")
                            var component = Qt.createComponent("qrc:/popups/popIconPicker.qml")
                            if (component.status === Component.Ready) {
                                var popup = component.createObject(parent, {
                                    x: parent.mapToItem(null, 0, 0).x - 34,
                                    y: parent.mapToItem(null, 0, 0).y - 240
                                })
                                if (popup) {
                                    popup.iconSelected.connect(function(iconId, iconPath) {
                                        console.log("Получена иконка ID:", iconId)
                                        iconSelector.selectedIconId = iconId
                                        iconSelector.selectedIconPath = iconPath
                                    })
                                    popup.open()
                                } else {
                                    console.error("Не удалось создать объект popup")
                                }
                            } else {
                                console.error("Ошибка загрузки компонента:", component.errorString())
                            }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            source: iconSelector.selectedIconPath
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Item {
                    width: 200; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    TextField {
                        id: activityNameInput
                        anchors.fill: parent
                        font.pixelSize: 12
                        color: "#D9D9D9"
                        placeholderText: "Название активности"
                        placeholderTextColor: "#a9a9a9"
                        wrapMode: Text.NoWrap
                        maximumLength: 30
                        padding: 10
                        horizontalAlignment: TextInput.AlignLeft
                        verticalAlignment: TextInput.AlignVCenter
                        background: Rectangle {
                            color: "#292729"
                            border.color: "#4D4D4D"
                            border.width: 1
                            radius: 6
                        }
                    }
                }

                Item {
                    width: height; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {

                        property string activityName: activityNameInput.text
                        property string selectedIconId: iconSelector.selectedIconId
                        property string selectedIconPath: iconSelector.selectedIconPath

                        anchors.fill: parent
                        onClicked: {
                            console.log("Сохраняется активность с иконкой:", selectedIconId, "и названием:", activityName)

                            // Проверка на пустой запрос
                            if (activityName.trim() === "" || selectedIconId === "") {
                                console.log("Название активности или иконка не выбраны");
                                return; // Не отправляем пустой запрос
                            }

                            // Проверка на дублирование активности
                            for (let i = 0; i < activityListModel.count; i++) {
                                if (activityListModel.get(i).activity === activityName) {
                                    console.log("Эта активность уже существует");
                                    return; // Если такая активность уже есть, не добавляем
                                }
                            }

                            categoriesUser.saveActivity(selectedIconId, activityName)
                            // После успешного добавления очищаем поле ввода и сбрасываем иконку
                            iconSelector.selectedIconId = "";
                            iconSelector.selectedIconPath = "qrc:/icons/add.png"; // возвращаем стандартную иконку
                            activityNameInput.text = ""; // очищаем текстовое поле
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            source: "qrc:/images/addbuttplus.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            ListModel {
                id: activityListModel
            }

            Item {
                anchors.top: rowcontent.bottom
                anchors.topMargin: 15
                width: parent.width
                height: parent.height * 0.5

                ScrollView {
                    id: amascroll
                    width: parent.width
                    height: parent.height
                    z: 1

                    Flow {
                        width: amascroll.width
                        spacing: 6

                        Repeater {
                            model: activityListModel
                            delegate: CustActvButn {
                                activityText: model.activity
                                iconPath: getIconPathById(model.iconId)
                                buttonWidth: implicitWidth
                                buttonHeight: 43
                                onClicked: {
                                    categoriesUser.deleteActivity(model.activity);
                                    activityListModel.remove(index);
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: buttAdmit
            color: "#474448"
            radius: 8
            width: parent.width
            height: 50
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Подтвердить"
                font.pixelSize: 18
                color: "#D9D9D9"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    managerPopup.close()
                }
            }
        }
    }

    onOpened: {
        categoriesUser.loadActivity()
    }

    Connections {
        target: categoriesUser

        onActivitySavedSuccess: {
            console.log("Активность успешно сохранена, перезагружаем список");
            categoriesUser.loadActivity();
        }

        onActivityLoadedSuccess: function(activities) {
            console.log("Данные загружены:", activities);
            activityListModel.clear();
            for (let i = 0; i < activities.length; ++i) {
                activityListModel.append({
                    activity: activities[i].activity,
                    iconId: activities[i].iconId
                });
            }
        }
    }

    ListModel {
        id: iconModel
        ListElement { iconId: 1; path: "qrc:/icons/sleeping.png" }
        ListElement { iconId: 2; path: "qrc:/icons/bike.png" }
        ListElement { iconId: 3; path: "qrc:/icons/che.png" }
        ListElement { iconId: 4; path: "qrc:/icons/chess.png" }
        ListElement { iconId: 5; path: "qrc:/icons/communicat.png" }
        ListElement { iconId: 6; path: "qrc:/icons/communication.png" }
        ListElement { iconId: 7; path: "qrc:/icons/endurance.png" }
        ListElement { iconId: 8; path: "qrc:/icons/exercis.png" }
        ListElement { iconId: 9; path: "qrc:/icons/friends.png" }
        ListElement { iconId: 10; path: "qrc:/icons/game-control.png" }
        ListElement { iconId: 11; path: "qrc:/icons/game-controller.png" }
        ListElement { iconId: 12; path: "qrc:/icons/guitar.png" }
        ListElement { iconId: 13; path: "qrc:/icons/handshake.png" }
        ListElement { iconId: 14; path: "qrc:/icons/headphones.png" }
        ListElement { iconId: 15; path: "qrc:/icons/helmet.png" }
        ListElement { iconId: 16; path: "qrc:/icons/love-message.png" }
        ListElement { iconId: 17; path: "qrc:/icons/manwithlaptop.png" }
        ListElement { iconId: 18; path: "qrc:/icons/microphone.png" }
        ListElement { iconId: 19; path: "qrc:/icons/problem-statement.png" }
        ListElement { iconId: 20; path: "qrc:/icons/pull-up.png" }
        ListElement { iconId: 21; path: "qrc:/icons/relationship.png" }
        ListElement { iconId: 22; path: "qrc:/icons/relaxation.png" }
        ListElement { iconId: 23; path: "qrc:/icons/rest.png" }
        ListElement { iconId: 24; path: "qrc:/icons/running.png" }
        ListElement { iconId: 25; path: "qrc:/icons/shower.png" }
        ListElement { iconId: 26; path: "qrc:/icons/sleepin.png" }
        ListElement { iconId: 27; path: "qrc:/icons/strength-training.png" }
        ListElement { iconId: 28; path: "qrc:/icons/suitcase.png" }
        ListElement { iconId: 29; path: "qrc:/icons/task.png" }
        ListElement { iconId: 30; path: "qrc:/icons/tent.png" }
        ListElement { iconId: 31; path: "qrc:/icons/videogames.png" }
        ListElement { iconId: 32; path: "qrc:/icons/watching.png" }
        ListElement { iconId: 33; path: "qrc:/icons/working-hours.png" }
    }

    function getIconPathById(iconId) {
        console.log("Поиск иконки по ID:", iconId); // Добавьте логирование
        for (let i = 0; i < iconModel.count; ++i) {
            if (iconModel.get(i).iconId === iconId) {
                console.log("Иконка найдена:", iconModel.get(i).path); // Логируем путь
                return iconModel.get(i).path;
            }
        }
        return "qrc:/icons/add.png"; // запасной вариант
    }
}
