import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: wrapper
    width: buttonWidth
    height: Math.max(buttonRect.implicitHeight, 36)

    // Настраиваемая ширина кнопки
    property int buttonWidth: 120
    property string buttonText: "Button"
    property url iconSource: ""
    property Item popupTarget: null

    signal clicked()

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
                if (popupTarget) {
                    popupTarget.open()
                }
                wrapper.clicked()
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
