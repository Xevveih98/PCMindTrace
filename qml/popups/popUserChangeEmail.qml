import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0

Popup {
    id: exitPopup
    width: Screen.width * 0.9
    height: Screen.height * 0.16
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
        id: columnpop
        spacing: 4
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }
        width: parent.width * 0.85

        Text {
            text: "Почта"
            font.pixelSize: 12
            color: "#D9D9D9"
        }

        TextField {
            id: regEmail
            height: 30
            font.pixelSize: 11
            color: "#D9D9D9"
            placeholderText: ""
            maximumLength: 120
            wrapMode: Text.NoWrap
            horizontalAlignment: TextInput.AlignLeft
            verticalAlignment: TextInput.AlignVCenter
            background: Rectangle {
                color: "#292729"
                border.color: "#4D4D4D"
                border.width: 1
            }
            anchors.left: parent.left
            anchors.right: parent.right
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
                authUser.changeEmail(regEmail.text)
                exitPopup.close();
            }
        }
    }
}
