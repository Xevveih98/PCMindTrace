import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: parent.width
    height: 30

    property string titleText: ""  // Текст заголовка

    // Фон заголовка
    Rectangle {
        width: parent.width
        height: parent.height
        color: "transparent"
    }

    // Текст заголовка
    Text {
        text: titleText
        color: "#D9D9D9"
        font.pixelSize: 22
        font.bold: true
        anchors.centerIn: parent
    }
}
