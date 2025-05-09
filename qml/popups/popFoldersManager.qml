import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0
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

    Column {
        width: parent.width * 0.91
        anchors.centerIn: parent
        spacing: 6

        Text {
            id: header
            text: "Управление папками"
            color: "#D9D9D9"
            font.pixelSize: 22
            font.bold: true
            wrapMode: Text.Wrap
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: text1
            text: "Добавьте новую папку или удалите старую"
            color: "#D9D9D9"
            font.pixelSize: 15
            wrapMode: Text.Wrap
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: textfieldinputrow
            height: 40
            width: parent.width

            RowLayout {
                spacing: 16
                height: 30
                anchors.centerIn: parent

                Item {
                    width: textfieldinputrow.width * 0.68
                    height: parent.height
                    Layout.alignment: Qt.AlignHCenter

                    TextField {
                        id: folderNameInput
                        anchors.fill: parent
                        font.pixelSize: 12
                        color: "#D9D9D9"
                        placeholderText: "Название папки"
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
                    width: height
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.alignment: Qt.AlignHCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Кнопка нажата")
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
            }
        }

        ListModel {
            id: foldersListModel
        }

        Item {
            id: foldersView
            width: parent.width
            height: parent.height * 0.77

            Rectangle {
                anchors.fill: parent
                color: "red"
            }

            ListView {
                width: parent.width
                height: parent.height
                model: foldersListModel

                delegate: CustFoldBlock {
                    width: ListView.view.width
                    height: 43 // фиксированная высота

                    CustActvButn {
                        activityText: model.activity
                        iconPath: getIconPathById(model.iconId)
                        buttonWidth: implicitWidth
                        buttonHeight: 43
                        onClicked: {
                            categoriesUser.deleteActivity(model.activity);
                            foldersListModel.remove(index);
                        }
                    }
                }
            }
        }
    }
}
