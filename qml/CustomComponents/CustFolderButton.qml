import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
    id: folderButton
    property string folderName: "Папка"
    property alias buttonWidth: folderButton.width
    property alias buttonHeight: folderButton.height
    property bool isSelected: false

    width: buttonWidth
    height: buttonHeight
    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        radius: 18
        color: folderButton.isSelected ? "#3A162A" : "#1F1B1F"
        border.width: folderButton.isSelected ? 1 : 0
        border.color: folderButton.isSelected ? "#DA446A" : "transparent"
    }

    contentItem: Text {
        id: foldernameitem
        text: folderName
        color: "#d9d9d9"
        font.pixelSize: 14
        font.bold: folderButton.isSelected
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
    }

    onClicked: {
        console.log("Нажата папка:", folderName)
        ListView.view.currentIndex = index
    }
}
