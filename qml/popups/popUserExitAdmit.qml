import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0

Popup {
    id: exitPopup
    width: 250
    height: 100
    modal: true
    focus: true
    dim: true  // автоматическое затемнение заднего фона
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    anchors.centerIn: Overlay.overlay
    Overlay.modeless: Rectangle {
            color: "#11272de7"
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
            text: "Вы уверены, что хотите выйти?"
            color: "#D9D9D9"
            font.pixelSize: 14
            wrapMode: Text.Wrap
            width: parent.width

        }
    }

    Rectangle {
        id: buttAuthCreateCheck
        color: "#474448"
        radius: 8
        width: parent.width + 15
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
                exitPopup.close();
                AppSave.clearUser();
                Qt.callLater(function() {
                    pageLoader.source = "qrc:/pages/AuthWindow.qml";
                });
            }
        }
    }
}
