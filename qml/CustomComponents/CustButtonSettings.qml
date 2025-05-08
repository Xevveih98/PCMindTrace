import QtQuick
import QtQuick.Controls

Item {
    id: wrapper
    width: buttonWidth
    height: Math.max(buttonRect.implicitHeight, 36)

    // Настраиваемая ширина кнопки
    property int buttonWidth: 120
    property string buttonText: "Button"
    property url iconSource: ""
    property url popupTarget: ""

    signal clicked()

    Loader {
        id: popupLoader
        active: false
        visible: false
        asynchronous: true
        source: popupTarget
        onLoaded: {
            if (item && item.open) item.open()
        }
    }

    Rectangle {
        id: buttonRect
        width: wrapper.width
        height: wrapper.height
        color: "#2D292C"
        radius: 12
        border.width: 1
        border.color: "#474448"

        Item {
            id: contentRow
            anchors.fill: parent
            anchors.margins: 18

            // Иконка
            Image {
                id: icon
                source: iconSource
                width: 20
                height: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                visible: iconSource !== ""
            }

            // Текст слева от иконки
            Text {
                id: label
                text: buttonText
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: 8
                visible: buttonText !== ""
            }

            // Стрелка справа
            Text {
                id: arrow
                text: ">"
                color: "#A9A9A9"
                font.pixelSize: 18
                font.bold: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (popupTarget !== "") {
                    popupLoader.active = false
                    popupLoader.active = true  // перезагрузка при повторных нажатиях
                }
                wrapper.clicked()
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
