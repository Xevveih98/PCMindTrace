import QtQuick

Item {
    id: wrapper
    property bool checked: false
    property alias buttonWidth: wrapper.width
    property alias buttonHeight: wrapper.height
    property color uncheckedColor: "#181718"
    property color checkedColor: "#242224"
    property color checkboxColorUnchecked: "#686A71"
    property color checkboxColorChecked: "transparent"
    property color textColorUnchecked: "#d9d9d9"
    property color textColorChecked: "#b9b9b9"
    property int boxSize: 18
    property string todoName: "Параметр"
    property int todoIndex: -1  // ← добавлено для удаления

    signal requestDelete(int index)

    width: buttonWidth
    height: buttonHeight

    Rectangle {
        id: checkboxBackground
        width: parent.width
        height: wrapper.height
        color: checked ? checkedColor : uncheckedColor
        border.width: 1
        border.color: "#474448"
        radius: 5
        anchors.centerIn: parent

        Rectangle {
            id: checkbox
            width: boxSize
            height: boxSize
            color: checkboxColorChecked
            border.width: 2
            border.color: checked ? checkboxColorChecked : checkboxColorUnchecked
            radius: 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10

            Image {
                source: checked ? "qrc:/images/checkmark.png" : ""
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }

        TextInput {
            text: todoName
            color: checked ? textColorChecked : textColorUnchecked
            font.pixelSize: 11
            wrapMode: Text.Wrap
            font.strikeout: checked
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: checkbox.right
            anchors.leftMargin: 10
            width: parent.width - checkbox.width - 30
            onTextChanged: todoName = text
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                checked = !checked;
                if (checked)
                    deleteTimer.restart();
            }
        }
    }

    Timer {
        id: deleteTimer
        interval: 400
        repeat: false
        onTriggered: {
            if (typeof todoUser !== "undefined" && todoUser.deleteTodo)
                todoUser.deleteTodo(todoName);
            requestDelete(todoIndex);  // удалить из модели
        }
    }
}
