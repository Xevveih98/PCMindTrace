import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents
import QtQuick.Layouts

Popup {
    id: exitPopup
    width: Screen.width * 0.93
    height: 120
    modal: true
    padding: 0
    focus: true
    dim: true
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    anchors.centerIn: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#181718"
        opacity: 0.9
    }
    background: Rectangle {
        color: "#2D292C"
        radius: 8
    }

    Item {
        id: oberInputFieldsEmpty
        anchors.centerIn: parent
        width: parent.width * 0.86
        height: parent.height * 0.86

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Text {
                text: "Название задачи"
                Layout.fillWidth: true
                color: "#D9D9D9"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            CustTxtFldEr {
                id: catName
                Layout.fillWidth: true
                placeholderText: "Введите вашу задачу"
                maximumLength: 64
                errorText: "* Ошибка"
                errorVisible: false
            }
        }
    }

    Rectangle {
        id: buttAuthCreateCheck
        color: "#474448"
        radius: 8
        width: parent.width
        height: 40
        anchors {
            top: parent.bottom
            topMargin: -10
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Подтвердить"
            font.pixelSize: 16
            color: "#D9D9D9"
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                let hasEmptyError = false;
                hasEmptyError = Utils.validateEmptyField(catName) || hasEmptyError;
                if (!hasEmptyError) {
                    todoUser.saveTodo(catName.text);
                    exitPopup.close();
                }
            }
        }
    }
}
