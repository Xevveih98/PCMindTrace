import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0
import CustomComponents

Rectangle {
    id: pageRegistration
    color: "#181718"

    Row {
        id: rowRegHeader
        spacing: 10
        height: 70
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            spacing: 5

            Text {
               text: "Регистрация"
               font.pixelSize: 24
               color: "#D9D9D9"
            }

            Text {
               text: "Зарегистрируйте новый аккаунт"
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
        anchors.top: rowRegHeader.bottom

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
                        maximumLength: 30
                        errorText: "* Ошибка"
                        errorVisible: false
                    }

                    Connections {
                        target: authUser
                        onRegistrationFailed: function(message) {
                            regLogin.errorText = message
                            regLogin.errorVisible = true
                            regLogin.triggerErrorAnimation()
                            VibrationUtils.vibrate(200)
                            console.log("СООБЩЕНИЕ", message)
                        }
                    }
                }

                Column {
                    spacing: 3

                    Text {
                        text: "Почта"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    CustTxtFldEr {
                        id: regEmail
                        width: oberInputFieldsEmpty.width
                        placeholderText: "Введите почту"
                        maximumLength: 45
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
                        placeholderText: "Придумайте пароль"
                        maximumLength: 64
                        errorText: ""
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
        id: buttAuthCreateCheck
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
           text: "Зарегистрироваться"
           font.pixelSize: 16
           color: "#D9D9D9"
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
           anchors.topMargin: 18
        }

        MouseArea {
            anchors.fill: buttAuthCreateCheck
            onClicked: {
                let hasEmptyError = false;
                let hasFormatError = false;
                hasEmptyError = Utils.validateEmptyField(regLogin) || hasEmptyError;
                hasEmptyError = Utils.validateEmptyField(regEmail) || hasEmptyError;
                hasEmptyError = Utils.validateEmptyField(regPassword) || hasEmptyError;
                if (!hasEmptyError) {
                    hasFormatError = Utils.validateEmailField(regEmail) || hasFormatError;
                    hasFormatError = Utils.validatePasswordField(regPassword) || hasFormatError;
                }
                if (!hasEmptyError && !hasFormatError) {
                    authUser.registerUser(regLogin.text.trim(), regEmail.text.trim(), regPassword.text.trim())
                }
            }
        }

    }

    Row {
        id: rowAuthLoginOffer
        spacing: 5
        anchors {
            top: buttAuthCreateCheck.bottom
            topMargin: 10
        }
        Text {
           text: "Уже есть аккаунт?"
           font.pixelSize: 14
           color: "#D9D9D9"
        }

        Text {
            text: "Войдите."
            font.pixelSize: 14
            color: "#DA446A"
            font.bold: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).push("Login.qml")
            }
        }
    }
}
