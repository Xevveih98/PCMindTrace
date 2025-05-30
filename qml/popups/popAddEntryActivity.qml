import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

Popup {

    property var selectedActivities: []
    signal activitiesConfirmed(var selectedActivities)

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
        radius: 8
    }

    Item {
        anchors.fill: parent

        Item {
            width: parent.width * 0.9
            height: parent.height * 0.93
            anchors.centerIn: parent

            Text {
                id: header
                text: "Выбор активностей"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите активности, которые хотите добавить."
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
                text: "Чтобы убрать активность - нажмите на неё."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: text1.bottom
                anchors.topMargin: 1
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            ListModel {
                id: activityListModel
            }

            Item {
                anchors.top: text2.bottom
                anchors.topMargin: 15
                width: parent.width
                height: parent.height * 0.66

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.02
                    height: parent.height * 1.03
                    color: "#262326"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "Пользовательский список пуст.."
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
                                id: actBtn
                                activityText: model.activity
                                iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
                                buttonWidth: implicitWidth
                                buttonHeight: 43
                                selected: managerPopup.selectedActivities.some(a => a.id === model.id)
                                onClicked: {
                                    let idx = managerPopup.selectedActivities.findIndex(a => a.id === model.id)
                                    if (idx === -1) {
                                        managerPopup.selectedActivities.push({
                                            id: model.id,
                                            activity: model.activity,
                                            iconId: model.iconId
                                        })
                                    } else {
                                        managerPopup.selectedActivities.splice(idx, 1)
                                    }

                                    selected = !selected

                                    // Debug
                                    console.log("Обновленные selectedActivities:")
                                    for (let i = 0; i < managerPopup.selectedActivities.length; ++i) {
                                        console.log("  id:", managerPopup.selectedActivities[i].id,
                                                    "activity:", managerPopup.selectedActivities[i].activity,
                                                    "iconId:", managerPopup.selectedActivities[i].iconId)
                                    }
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
                    activitiesConfirmed(managerPopup.selectedActivities)
                    managerPopup.close()
                }
            }
        }
    }

    function setActivities(activityArray) {
        activityListModel.clear();
        selectedActivities = [];
        for (let i = 0; i < activityArray.length; ++i) {
            activityListModel.append({
                id: activityArray[i].id,
                activity: activityArray[i].activity,
                iconId: activityArray[i].iconId
            });
        }
    }

    function loadActivitiesFromServer(activities) {
        console.log("Данные загружены:", activities);
        setActivities(activities);
    }

    onOpened: {
        categoriesUser.loadActivity();
    }

    Connections {
        target: categoriesUser
        onActivityLoadedSuccess: function(activities) {
            loadActivitiesFromServer(activities);
        }
    }

    IconModelAct {
        id: iconModelActivity
    }
}
