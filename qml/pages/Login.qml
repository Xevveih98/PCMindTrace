import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0
import CustomComponents

Rectangle {
    id: pageLogIn
    color: "#181718"

    Row {
        id: rowLogHeader
        spacing: 10
        height: 70
        anchors.horizontalCenter: parent.horizontalCenter
        Column {
            spacing: 5

            Text {
               text: "Вход"
               font.pixelSize: 24
               color: "#D9D9D9"
            }

            Text {
               text: "Войдите в свой аккаунт"
               font.pixelSize: 12
               color: "#B9B9B9"
            }
        }

        Item {
           width: 62
           height: 62

           Image {
               anchors.fill: parent
               source: "qrc:/images/AuthWRegistrationMainIcon.png"
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
        anchors.top: rowLogHeader.bottom

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
                        text: "Логин"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    CustTxtFldEr {
                        id: regLogin
                        width: oberInputFieldsEmpty.width
                        placeholderText: "Введите логин"
                        maximumLength: 64
                        errorText: "* Ошибка"
                        errorVisible: false
                    }
                }

                Column {
                    spacing: 3
                    Text {
                        text: "Пароль"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    CustTxtFldEr {
                        id: regPassword
                        width: oberInputFieldsEmpty.width
                        placeholderText: "Введите пароль"
                        maximumLength: 64
                        errorText: "* Ошибка"
                        errorVisible: false

                        Connections {
                            target: authUser
                            onRegistrationFailed: function(message) {
                                regPassword.errorText = message
                                regPassword.errorVisible = true
                                regPassword.triggerErrorAnimation()
                                VibrationUtils.vibrate(200)
                                console.log("СООБЩЕНИЕ", message)
                            }
                        }
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
        id: buttAuthCheck
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
           text: "Войти"
           font.pixelSize: 16
           color: "#D9D9D9"
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
           anchors.topMargin: 18
        }

        MouseArea {
            anchors.fill: buttAuthCheck
            onClicked: {
                let hasError = false
                if (regLogin.text.trim().length === 0) {
                    regLogin.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                }
                if (regPassword.text.trim().length === 0) {
                    regPassword.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                }

                if (!hasError) {
                    authUser.loginUser(regLogin.text, regPassword.text)
                }
            }
        }
    }

    Row {
        id: rowAuthLoginOffer
        spacing: 5
        anchors {
            top: buttAuthCheck.bottom
            topMargin: 10
        }
        Text {
           text: "Нет аккаунта?"
           font.pixelSize: 14
           color: "#D9D9D9"
        }

        Text {
            text: "Создать новый."
            font.pixelSize: 14
            color: "#DA446A"
            font.bold: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).pop()
            }
        }
    }

    Row {
        id: rowAuthPassRecoveryOffer
        spacing: 5
        anchors {
            top: rowAuthLoginOffer.bottom
            topMargin: 10
        }
        Text {
           text: "Забыли пароль?"
           font.pixelSize: 14
           color: "#D9D9D9"
        }

        Text {
            text: "Восстановить аккаунт."
            font.pixelSize: 14
            color: "#DA446A"
            font.bold: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).push("Recovery.qml")

            }
        }
    }

    Connections {
        target: authUser
        onLoginFailed: function(loginError, passwordError) {
            regLogin.errorText = loginError
            regLogin.errorVisible = loginError !== ""
            if (loginError !== "") {
                regLogin.triggerErrorAnimation()
            }

            regPassword.errorText = passwordError
            regPassword.errorVisible = passwordError !== ""
            if (passwordError !== "") {
                regPassword.triggerErrorAnimation()
            }

            if (loginError !== "" || passwordError !== "") {
                VibrationUtils.vibrate(200)
            }

            console.log("Login error:", loginError, "Password error:", passwordError)
        }
    }
}
