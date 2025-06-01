import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents
import QtQuick.Layouts

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
    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        Text {
            text: "Добавить события"
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
            text: "Добавьте события, чтобы показать, <b><font color='#DA446A'>как прошёл ваш день</font></b>. Нажмите на событие повторно, чтобы <b><font color='#DA446A'>удалить</font></b> его."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: "#D9D9D9"
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"

                Text {
                    anchors.centerIn: parent
                    text: "Пользовательский список пуст.."
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
                                id: actBtn
                                activityText: model.activity
                                iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
                                buttonWidth: implicitWidth
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
                    activitiesConfirmed(managerPopup.selectedActivities)
                    managerPopup.close()
                }
            }
        }
    }

    ListModel {
        id: activityListModel
    }



    IconModelAct {
        id: iconModelActivity
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
}
