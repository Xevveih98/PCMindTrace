import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

Popup {
    id: exitPopup
    width: Screen.width * 0.9
    height: 280
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
        border.color: "#474448"
        border.width: 1
    }

    Item {
        id: oberInputFieldsEmpty
        anchors.centerIn: parent
        width: parent.width * 0.86
        height: parent.height * 0.86

        Column {
            anchors.fill: parent
            spacing: 6

            Column {
                spacing: 3

                Text {
                    text: "Новая почта"
                    font.pixelSize: 12
                    color: "#D9D9D9"
                }

                CustTxtFldEr {
                    id: regEmail
                    width: oberInputFieldsEmpty.width
                    placeholderText: "Введите новую почту"
                    maximumLength: 64
                    errorText: "* Ошибка"
                    errorVisible: false
                }
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
                let hasFormatError = false;
                hasEmptyError = Utils.validateEmptyField(regEmail) || hasEmptyError;
                if (!hasEmptyError) {hasFormatError = Utils.validateEmailField(regEmail) || hasFormatError;}
                if (!hasEmptyError && !hasFormatError) {
                    authUser.changeEmail(regEmail.text); exitPopup.close();
                }
            }
        }
    }
}
