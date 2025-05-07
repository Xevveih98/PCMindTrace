import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0

Popup {
    id: exitPopup
    width: 250
    height: 150
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
        padding: 20

        Text {
            text: "Вы уверены, что хотите выйти?"
            color: "#D9D9D9"
            font.pixelSize: 14
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            text: "Подтвердить"
            width: 200
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                exitPopup.close();
                AppSave.clearLogin();
                Qt.callLater(function() {
                    pageLoader.source = "qrc:/pages/AuthWindow.qml";
                });
            }
        }
    }
}
