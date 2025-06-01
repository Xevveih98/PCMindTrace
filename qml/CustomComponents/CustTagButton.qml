import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: tagButton
    property alias tagText: label.text
    property alias buttonWidth: tagButton.width
    property bool selected: false

    width: buttonWidth
    height: 40
    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: 100
        color: tagButton.selected ? "#3A162A" : "#181718"
        border.width: tagButton.selected ? 1 : 0
        border.color: tagButton.selected ? "#DA446A" : "transparent"
    }

    contentItem: Text {
        id: label
        text: "Default"
        color: "#d9d9d9"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
    }
}
