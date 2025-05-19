import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0

Popup {

    property string folderName: ""

    id: exitPopup
    width: Screen.width * 0.7
    height: Screen.height * 0.14
    modal: true
    padding: 0
    focus: true
    dim: true
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
        spacing: 16
        anchors.centerIn: parent
        width: parent.width
        padding: 20

        Text {
            text: "Вы уверены, что хотите удалить папку? Все записи в этой папке будут удалены."
            width: parent.width * 0.8
            color: "#D9D9D9"
            font.pixelSize: 14
            wrapMode: Text.Wrap
        }
    }

    Rectangle {
        id: buttAuthCreateCheck
        color: "#474448"
        radius: 8
        width: parent.width
        height: 40
        anchors {
            top: parent.bottom
            topMargin: -10
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Подтвердить"
            font.pixelSize: 16
            color: "#D9D9D9"
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                foldersUser.deleteFolder(folderName);
                folderName = ""
                exitPopup.close();
            }
        }
    }

    signal deleteClicked()
}
