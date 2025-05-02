import QtQuick 2.15

Item {
    width: parent.width
    height: 36

    property bool checked: false
    property color uncheckedColor: "#181718"  // Цвет фона для невыбранного состояния
    property color checkedColor: "#242224"    // Цвет фона для выбранного состояния
    property color checkboxColorUnchecked: "#686A71"  // Цвет чекбокса для невыбранного состояния
    property color checkboxColorChecked: "transparent"    // Цвет чекбокса для выбранного состояния
    property color textColorUnchecked: "#d9d9d9"  // Цвет текста для невыбранного состояния
    property color textColorChecked: "#b9b9b9"    // Цвет текста для выбранного состояния
    property int boxSize: 20   // Размер чекбокса
    property string labelText: "Параметр"  // Текст, который можно редактировать

    Rectangle {
        id: checkboxBackground
        width: parent.width
        height: 36
        color: checked ? checkedColor : uncheckedColor
        border.width: 1
        border.color: "#474448"
        radius: 5
        anchors.centerIn: parent

        // Чекбокс
        Rectangle {
            id: checkbox
            width: boxSize
            height: boxSize
            color: checked ? checkboxColorChecked : checkboxColorChecked
            border.width: 2
            border.color: checked ? checkboxColorChecked : checkboxColorUnchecked
            radius: 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            Item {
               width: boxSize
               height: boxSize
               // Галочка, показывается, когда checked = true
               Image {
                   source: checked ? "componentsImages/checkmark.png" : ""
                   anchors.fill: parent
                   fillMode: Image.PreserveAspectFit
               }
            }
        }

        // Редактируемый текст
        TextInput {
            text: labelText
            color: checked ? textColorChecked : textColorUnchecked
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: checkbox.right
            anchors.leftMargin: 10
            width: parent.width - checkbox.width - 30  // Редактируемый текст будет заполнять оставшееся пространство
            onTextChanged: labelText = text  // Сохраняем изменённый текст в свойство labelText
        }

        // MouseArea для отслеживания кликов
        MouseArea {
            anchors.fill: parent
            onClicked: {
                checked = !checked
            }
        }
    }
}
