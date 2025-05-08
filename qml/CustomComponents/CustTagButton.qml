import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15  // нужно для отключения стилей, если используется

Button {
    id: tagButton
    property alias tagText: label.text
    property alias buttonWidth: tagButton.width

    width: buttonWidth
    height: 40
    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: 18
        color: "#181718"
        border.width: 0
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

    // Удаляем анимации нажатия
    //onPressedChanged: {}  // пустой обработчик
    onHoveredChanged: {}  // пустой обработчик
}
