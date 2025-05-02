import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0

Rectangle {
    id: pageRegistration
    color: "#181718"

    Row {
        id: rowRegHeader
        spacing: 10
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
        height: parent.height * 0.36
        radius: 8
        z: 2
        anchors {
            top: rowRegHeader.bottom
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
                        text: "Почта"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    TextField {
                        id: emailInput
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
                        //placeholderText: ""
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
        id: buttAuthCreateCheck
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
           text: "Зарегистрироваться"
           font.pixelSize: 16
           color: "#D9D9D9"
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
           anchors.topMargin: 20
        }

        MouseArea {
            anchors.fill: buttAuthCreateCheck
            onClicked: {
                console.log("Клик по кнопке сработал");
               if (loginInput.text === "" || emailInput.text === "" || passInput.text === "") {
                   console.log("Пожалуйста, заполните все поля");
                   return;
               }

               const success = AuthViewModel.registerUser(
                   loginInput.text,
                   emailInput.text,
                   passInput.text
               )

               if (success) {
                   console.log("Регистрация успешна")
               } else {
                   console.log("Ошибка при регистрации")
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
            color: "#957EBD"
            font.underline: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).push("Login.qml")
            }
        }
    }

    Item {
        id: iemgog
        width: parent.width
        height: parent.height * 0.061
        anchors {
            top: rowAuthLoginOffer.bottom
            topMargin: parent.height * 0.2
            left: rowAuthLoginOffer.left
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
            id: buttgog
            color: "#474448"
            radius: 8
            width: parent.width - 24
            height: parent.height
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
