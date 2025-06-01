import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents 1.0
import QtQuick.Layouts

Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.8
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
        radius: 8
    }
    onOpened: {
        categoriesUser.loadActivity()
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        Text {
            text: "Управление событиями"
            color: "#D9D9D9"
            font.pixelSize: 20
            font.bold: true
            wrapMode: Text.Wrap
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }


        Text {
            textFormat: Text.RichText
            text: "Выберите <b><font color='#DA446A'>иконку</font></b> и дайте <b><font color='#DA446A'>название</font></b> вашего события. Чтобы <b><font color='#DA446A'>убрать</font></b> событие - намите на него."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: "#D9D9D9"
        }

        Item {
            Layout.preferredHeight: 50
            Layout.preferredWidth: parent.width*0.93
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                spacing: 7

                Item {
                    id: iconSelector
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    property string selectedIconId: ""
                    property string selectedIconPath: "qrc:/icons/add.png"

                    Image {
                        anchors.centerIn: parent
                        width: 30
                        height: 30
                        source: iconSelector.selectedIconPath
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var component = Qt.createComponent("qrc:/popups/popIconPicker.qml")
                            if (component.status === Component.Ready) {
                                var popup = component.createObject(parent, {
                                                                       x: iconSelector.mapToItem(null, 0, 0).x - 34,
                                                                       y: iconSelector.mapToItem(null, 0, 0).y - 135
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
                    }
                }

                CustTxtFldEr {
                    id: catName
                    Layout.fillWidth: true
                    placeholderText: "Дайте название событию"
                    maximumLength: 34
                    errorText: "* Ошибка"
                    errorVisible: false
                }

                Item {
                    width: 30
                    height: 30

                    MouseArea {
                        property string activityName: catName.text
                        property string selectedIconId: iconSelector.selectedIconId
                        property string selectedIconPath: iconSelector.selectedIconPath
                        anchors.fill: parent
                        onClicked: {
                            console.log("Сохраняется активность с иконкой:", selectedIconId, "и названием:", activityName)

                            if (activityName.trim() === "" || selectedIconId === "") {
                                catName.errorVisible = true
                                VibrationUtils.vibrate(200)
                                catName.errorText = "* Название активности или иконка не выбраны";
                                return;
                            }
                            for (let i = 0; i < activityListModel.count; i++) {
                                if (activityListModel.get(i).activity === activityName) {
                                    catName.errorVisible = true
                                    VibrationUtils.vibrate(200)
                                    catName.errorText = "* Эта активность уже существует";
                                    return;
                                }
                            }
                            categoriesUser.saveActivity(selectedIconId, activityName)
                            iconSelector.selectedIconId = "";
                            iconSelector.selectedIconPath = "qrc:/icons/add.png";
                            catName.text = "";
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.height
                            height: parent.width
                            source: "qrc:/images/addbuttplus.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"

                Text {
                    anchors.centerIn: parent
                    text: "Добавьте новые события.."
                    color: "#4d4d4d"
                    font.pixelSize: 11
                    font.italic: true
                    visible: activityListModel.count === 0
                }
            }

            Item{
                width: parent.width * 0.97
                height: parent.height * 0.99
                anchors.centerIn: parent

                Flickable {
                    width: parent.width
                    height: parent.height
                    contentWidth: parent.width
                    contentHeight: flowContent.implicitHeight
                    clip: true

                    Flow {
                        id: flowContent
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: activityListModel
                            delegate: CustActvButn {
                                activityText: model.activity
                                iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
                                buttonWidth: implicitWidth
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
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignBottom

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

    IconModelAct {
        id: iconModelActivity
    }

    ListModel {
        id: activityListModel
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
}
