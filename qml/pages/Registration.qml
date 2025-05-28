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
                        maximumLength: 64
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
                let hasError = false

                if (regLogin.text.trim().length === 0) {
                    regLogin.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                }

                let email = regEmail.text.trim()
                if (email.length === 0) {
                    regEmail.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    regEmail.errorText = "* Некорректный формат email"
                    regEmail.errorVisible = true
                    regEmail.triggerErrorAnimation()
                    VibrationUtils.vibrate(200)
                    hasError = true
                } else {
                    regEmail.errorVisible = false
                }

                let password = regPassword.text.trim()
                let errors = []

                if (password.length === 0) {
                    regPassword.triggerErrorAnimation()
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
                        regPassword.errorText = errors.join("<br>")
                        regPassword.errorVisible = true
                        regPassword.triggerErrorAnimation()
                        VibrationUtils.vibrate(200)
                        hasError = true
                    } else {
                        regPassword.errorVisible = false
                    }
                }

                if (!hasError) {
                    authUser.registerUser(regLogin.text, regEmail.text, password)
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
