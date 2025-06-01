import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

Button {
    id: activityButton
    property string activityText: "Default"
    property string iconPath: ""
    property alias buttonWidth: activityButton.width
    property bool selected: false

    height: 40
    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: 100
        color: activityButton.selected ? "#3A162A" : "#181718"
        border.width: activityButton.selected ? 1 : 0
        border.color: activityButton.selected ? "#DA446A" : "transparent"
    }

    contentItem: Row {
        spacing: 8
        anchors.centerIn: parent
        height: parent.height

        Item {
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter

            Image {
                source: iconPath
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }

        Text {
            text: activityText
            color: "#d9d9d9"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    onHoveredChanged: {}
}
