import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0
import CustomComponents

Rectangle {
    id: pageRecovery
    color: "#181718"

    Row {
        id: rowAuthHeader
        spacing: 10
        height: 70
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            spacing: 5

            Text {
               text: "Восстановление"
               font.pixelSize: 24
               color: "#D9D9D9"
            }

            Text {
               text: "Придумайте новый пароль"
               font.pixelSize: 12
               color: "#B9B9B9"
            }
        }

        Item {
           width: 62
           height: 62

           Image {
               anchors.fill: parent
               source: "qrc:/images/DataRecovery.png"
               fillMode: Image.PreserveAspectFit
            }
        }
    }

    Rectangle {
        id: recInputFieldsBG
        color: "#2D292C"
        width: parent.width
        height: 280
        radius: 8
        z: 2
        anchors.top: rowAuthHeader.bottom

        Item {
            id: oberInputFieldsEmpty
            width: parent.width * 0.88
            height: parent.height * 0.8
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                spacing: 6

                Column {
                    spacing: 3

                    Text {
                        text: "Почта"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    CustTxtFldEr {
                        id: regEnail
                        width: oberInputFieldsEmpty.width
                        placeholderText: "Введите вашу почту"
                        maximumLength: 45
                        errorText: "* Ошибка"
                        errorVisible: false

                        Connections {
                            target: authUser
                            onPasswordRecoverFailed: function(message) {
                                regEnail.errorText = message
                                regEnail.errorVisible = true
                                regEnail.triggerErrorAnimation()
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
                        placeholderText: "Придумайте новый пароль"
                        maximumLength: 64
                        errorText: "* Ошибка"
                        errorVisible: false
                    }
                }
            }
        }
    }

    Rectangle {
        id: recHideline
        color: "#2D292C"
        width: parent.width
        height: 20
        z: 3
        anchors {
            top: recInputFieldsBG.bottom
            topMargin: -10
        }
    }

    Rectangle {
        id: buttPassCheck
        color: "#474448"
        radius: 8
        width: parent.width
        height: 50
        z: 1
        anchors {
            top: recHideline.bottom
            topMargin: -10
        }

        Text {
           text: "Восстановить"
           font.pixelSize: 16
           color: "#D9D9D9"
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
           anchors.topMargin: 18
        }

        MouseArea {
            anchors.fill: buttPassCheck
            onClicked: {
                let hasEmptyError = false;
                let hasFormatError = false;
                hasEmptyError = Utils.validateEmptyField(regEnail) || hasEmptyError;
                hasEmptyError = Utils.validateEmptyField(regNewPass) || hasEmptyError;
                hasEmptyError = Utils.validateEmptyField(regNewPassCheck) || hasEmptyError;
                if (!hasEmptyError) {
                    hasFormatError = Utils.validateEmailField(regEnail) || hasFormatError;
                    hasFormatError = Utils.validatePasswordField(regNewPass) || hasFormatError;
                    hasFormatError = Utils.validatePasswordMatch(regNewPass, regNewPassCheck) || hasFormatError;
                }
                if (!hasEmptyError && !hasFormatError) {
                    authUser.recoverPassword(regEnail.text, regNewPass.text);
                }
            }
        }
    }

    Row {
        id: rowPassRecoveryOffer
        spacing: 5
        anchors {
            top: buttPassCheck.bottom
            topMargin: 10
        }
        Text {
           text: "Вспомнили свои данные?"
           font.pixelSize: 14
           color: "#D9D9D9"
        }

        Text {
            text: "Вернуться."
            font.pixelSize: 14
            color: "#DA446A"
            font.bold: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).pop()
            }
        }
    }
}
