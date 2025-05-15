import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents

Popup {
    property Popup parentPopup

    id: managerFolderPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.4
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
        width: parent.width * 0.91
        height: parent.height * 0.95
        anchors.centerIn: parent

        Column {
            width: parent.width
            anchors.top: parent.top
            spacing: 6

            Text {
                id: header
                text: "Выбор папки"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите папку для сохранения записи."
                color: "#D9D9D9"
                font.pixelSize: 15
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            ListModel {
                id: foldersListModel
            }

            Item {
                id: foldersView
                width: parent.width
                height: parent.height * 0.77

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.02
                    height: parent.height * 1.03
                    color: "#262326"
                    radius: 8
                }

                ListView {
                    anchors.fill: parent
                    model: foldersListModel
                    spacing: 6
                    clip: true
                    delegate: CustFoldVart {
                        width: ListView.view.width
                        height: 40
                        folderName: model.foldername
                        isSelected: ListView.isCurrentItem
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
                managerFolderPopup.close()
            }
        }
    }

    onOpened: {
        foldersUser.loadFolder()
    }

    Connections {
        target: foldersUser
        onFoldersLoadedSuccess: function(folders) {
            foldersListModel.clear();
            console.log("Данные загружены:", folders);
            for (let i = 0; i < folders.length; ++i) {
                foldersListModel.append({
                    foldername: folders[i].name,
                });
            }
        }
    }
}
