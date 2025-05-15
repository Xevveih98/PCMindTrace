import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents
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

    Item {
        width: parent.width * 0.91
        height: parent.height * 0.95
        anchors.centerIn: parent

        Rectangle {
            color: "red"
            anchors.fill: parent
        }

    }
}
