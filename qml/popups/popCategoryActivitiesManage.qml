import QtQuick 2.15
import QtQuick.Controls 2.15
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

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.02
                    height: parent.height * 1.03
                    color: "#262326"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "Добавьте новые активности"
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: activityListModel.count === 0
                    }
                }

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
                                iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
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

    IconModelAct {
        id: iconModelActivity
    }
}
