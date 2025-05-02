import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0

Rectangle {
    id: pageLogIn
    color: "#181718"

    Row {
        id: rowLogHeader
        spacing: 10
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
        height: parent.height * 0.36
        radius: 8
        z: 2
        anchors {
            top: rowLogHeader.bottom
            topMargin: 10
        }

        Item {
            id: oberInputFieldsEmpty
            width: parent.width
            height: parent.height
            anchors{
                top: parent.top
                left: parent.left
                topMargin: parent.height * 0.14
                leftMargin: parent.width * 0.08
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.fill: parent
                spacing: 12

                Column {
                    spacing: 6

                    Text {
                        text: "Логин"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    TextField {
                        id: loginInput
                        width: oberInputFieldsEmpty.width
                        height: 30
                        font.pixelSize: 11
                        color: "#D9D9D9"
                        placeholderText: ""
                        maximumLength: 120
                        wrapMode: Text.NoWrap
                        horizontalAlignment: TextInput.AlignLeft
                        verticalAlignment: TextInput.AlignVCenter
                        background: Rectangle {
                            color: "#292729"
                            border.color: "#4D4D4D"
                            border.width: 1
                            radius: 0
                        }
                        padding: 10
                    }
                }

                Column {
                    spacing: 6
                    Text {
                        text: "Пароль"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    TextField {
                        id: passInput
                        width: oberInputFieldsEmpty.width
                        height: 30
                        font.pixelSize: 6
                        color: "#D9D9D9"
                        placeholderText: ""
                        maximumLength: 64
                        wrapMode: Text.NoWrap
                        echoMode: TextInput.Password
                        horizontalAlignment: TextInput.AlignLeft
                        verticalAlignment: TextInput.AlignVCenter
                        background: Rectangle {
                            color: "#292729"
                            border.color: "#4D4D4D"
                            border.width: 1
                            radius: 0
                        }
                        padding: 10
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
        height: parent.height * 0.070
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
           anchors.topMargin: 20
        }

        MouseArea {
            anchors.fill: buttAuthCheck
            onClicked: {
                onClicked: {
                    if (loginInput.text === "" || passInput.text === "") {
                        console.log("Введите логин и пароль")
                        return
                    }

                    const success = AuthViewModel.loginUser(loginInput.text, passInput.text)
                    if (success) {
                        console.log("Вход успешен")
                        AppViewModelBackend.switchToMain()
                    } else {
                        console.log("Неверный логин или пароль")
                    }
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
            color: "#957EBD"
            font.underline: true
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
            color: "#957EBD"
            font.underline: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).push("Recovery.qml")

            }
        }
    }

    Item {
        id: iemgog
        width: parent.width
        height: parent.height * 0.061
        anchors {
            top: rowAuthPassRecoveryOffer.bottom
            topMargin: parent.height * 0.2
            left: rowAuthPassRecoveryOffer.left
        }

        Item {
            id: imgGoogleIcon
            width: 62
            height: 62
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            z: 2
            Image {
               anchors.fill: parent
               source: "qrc:/images/GoogleIcon.png"
               fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            color: "#474448"
            radius: 8
            width: pageLogIn.width - 24
            height: pageLogIn.height * 0.065
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            z:1

            Text {
               text: "Войти через аккаунт Google"
               font.pixelSize: 16
               color: "#D9D9D9"
               anchors.left: parent.left
               anchors.leftMargin: 62
               anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
