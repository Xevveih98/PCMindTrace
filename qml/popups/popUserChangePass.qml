import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

Popup {
    id: exitPopup
    width: Screen.width * 0.9
    height: 280
    modal: true
    focus: true
    dim: true
    padding: 0
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
                    text: "Старый пароль"
                    font.pixelSize: 12
                    color: "#D9D9D9"
                }

                CustTxtFldEr {
                    id: regOldPass
                    width: oberInputFieldsEmpty.width
                    placeholderText: "Введите старый пароль"
                    maximumLength: 64
                    errorText: "* Ошибка"
                    errorVisible: false

                    Connections {
                        target: authUser
                        onPasswordChangeFailed: function(message) {
                            regOldPass.errorText = message
                            regOldPass.errorVisible = true
                            regOldPass.triggerErrorAnimation()
                            VibrationUtils.vibrate(200)
                            console.log("СООБЩЕНИЕ", message)
                        }
                    }
                }
            }

            Column {
                spacing: 3

                Text {
                    text: "Проверка"
                    font.pixelSize: 12
                    color: "#D9D9D9"
                }

                CustTxtFldEr {
                    id: regNewPassCheck
                    width: oberInputFieldsEmpty.width
                    placeholderText: "Повторно введите новый пароль"
                    maximumLength: 64
                    errorText: "* Ошибка"
                    errorVisible: false
                }
            }

            Column {
                spacing: 3

                Text {
                    text: "Новый пароль"
                    font.pixelSize: 12
                    color: "#D9D9D9"
                }

                CustTxtFldEr {
                    id: regNewPass
                    width: oberInputFieldsEmpty.width
                    placeholderText: "Введите новый пароль"
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
                let hasError = false
                if (regOldPass.text.trim().length === 0) {
                    regOldPass.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                }

                let password = regNewPass.text.trim()
                let errors = []
                if (password.length === 0) {
                    regNewPass.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                } else {
                    if (/[а-яА-ЯёЁ]/.test(password)) {
                        errors.push("* Пароль не должен содержать русские буквы")
                    }
                    if (!/[a-zA-Z]/.test(password)) {
                        errors.push("* Пароль должен содержать хотя бы одну латинскую букву")
                    }
                    if (!/[-&]/.test(password)) {
                        errors.push("* Пароль должен содержать хотя бы один спецсимвол: '-' или '&'")
                    }
                    if (password.length < 8) {
                        errors.push("* Пароль должен содержать минимум 8 символов")
                    }

                    if (errors.length > 0) {
                        regNewPass.errorText = errors.join("<br>")
                        regNewPass.errorVisible = true
                        regNewPass.triggerErrorAnimation()
                        VibrationUtils.vibrate(200)
                        hasError = true
                    } else {
                        regNewPass.errorVisible = false
                    }
                }

                if (regNewPassCheck.text.trim().length === 0) {
                    regNewPassCheck.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                }

                if (regNewPass.text.trim() !== regNewPassCheck.text.trim()) {
                    regNewPassCheck.errorText = "* Пароли не совпадают"
                    regNewPassCheck.errorVisible = true
                    regNewPassCheck.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                } else {
                    regNewPassCheck.errorVisible = false
                }

                if (!hasError) {
                    authUser.changePassword(regOldPass.text, regNewPass.text);
                }
            }
        }
    }

    Connections {
        target: authUser
        onPasswordChangeSuccess: {
            Qt.callLater(function() {
                exitPopup.close();
            })
        }
    }
}
