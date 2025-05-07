import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 60
    height: 30

    // Кнопка с фоном, радиусом и текстом "Назад"
    Rectangle {
        width: parent.width
        height: parent.height
        color: "#2D292C"
        radius: 12

        Text {
            text: "Назад"
            color: "#D9D9D9"
            font.pixelSize: 16
            font.bold: true
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Логика для обработки клика на кнопку (например, переход на предыдущую страницу)
                console.log("Кнопка назад нажата")
            }
            cursorShape: Qt.PointingHandCursor
        }
    }
}
