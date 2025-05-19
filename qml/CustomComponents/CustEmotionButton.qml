import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

Button {
    id: emotionButton
    property string emotionText: "Happiness"
    property string iconPath: "images/happy_icon.png"
    property alias buttonWidth: emotionButton.width
    property alias buttonHeight: emotionButton.height
    property bool selected: false

    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: 18
        color: emotionButton.selected ? "#37262E" : "#181718"
        border.width: 1
        border.color: emotionButton.selected ? "#9A5556" : "#4D4D4D"
    }

    contentItem: Row {
        spacing: 5
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
            text: emotionText
            color: "#d9d9d9"
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
        }
    }

    onHoveredChanged: {}
}
