import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0

Item {
    id: root
    width: 50
    height: 26
    property bool checked: AppSave.loadSwitchState()
    signal toggled(bool checked)

    onCheckedChanged: {
        AppSave.clearSwitchState()
        AppSave.saveSwitchState(checked)
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.height * 0.5
        color: root.checked ? "#DA446A" : "#181718"
        anchors.centerIn: parent

        Rectangle {
            id: thumb
            width: height
            height: root.height * 0.78
            radius: 15
            color: root.checked ? "#D8C8BE" : "#575254"
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? parent.width - width - 4 : 4

            Behavior on x {
                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
            }


            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.checked = !root.checked
                root.toggled(root.checked)
            }
        }
    }
}
