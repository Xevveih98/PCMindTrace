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
        radius: 18
        color: tagButton.selected ? "#221F22" : "#181718"
        border.width: 1
        border.color: tagButton.selected ? "#5B5B5B" : "#4D4D4D"
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
