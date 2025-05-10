import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Layouts

Button {
    id: folderButton
    property string folderName: "foldernameitem.text"
    property alias buttonWidth: folderButton.width
    property alias buttonHeight: folderButton.height

    width: buttonWidth
    height: buttonHeight
    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus
    onHoveredChanged: {}
    background: Rectangle {
        radius: 18
        color: "#1F1B1F"
    }

    contentItem: Text {
        id: foldernameitem
        text: folderName
        color: "#d9d9d9"
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
    }
}
