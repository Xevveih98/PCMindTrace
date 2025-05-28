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
                spacing: 20

                Column {
                    spacing: 5

                    Text {
                        text: "Почта"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    TextField {
                        id: regEmail
                        width: oberInputFieldsEmpty.width
                        height: 30
                        font.pixelSize: 11
                        color: "#D9D9D9"
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

                        Text {
                            anchors.fill: regEmail
                            anchors.margins: 10
                            font.pixelSize: 11
                            text: "Введите почту аккаунта"
                            color: "#4d4d4d"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            opacity: (!regEmail.text && !regEmail.activeFocus) ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }
                }

                Column {
                    spacing: 5
                    Text {
                        text: "Придумайте новый пароль"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    TextField {
                        id: regPassword
                        width: oberInputFieldsEmpty.width
                        height: 30
                        font.pixelSize: 6
                        color: "#D9D9D9"
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

                        Text {
                            anchors.fill: regPassword
                            anchors.margins: 10
                            font.pixelSize: 11
                            text: "Придумайте новый пароль"
                            color: "#4d4d4d"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            opacity: (!regPassword.text && !regPassword.activeFocus) ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }
                }

                Column {
                    spacing: 5
                    Text {
                        text: "Повторите новый пароль"
                        font.pixelSize: 12
                        color: "#D9D9D9"
                    }

                    TextField {
                        id: regPasswordCheck
                        width: oberInputFieldsEmpty.width
                        height: 30
                        font.pixelSize: 6
                        color: "#D9D9D9"
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

                        Text {
                            anchors.fill: regPasswordCheck
                            anchors.margins: 10
                            font.pixelSize: 11
                            text: "Повторите новый пароль"
                            color: "#4d4d4d"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            opacity: (!regPasswordCheck.text && !regPasswordCheck.activeFocus) ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
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
               authUser.changePassword(regEmail.text, regPassword.text, regPasswordCheck.text)
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
            color: "#957EBD"
            font.underline: true
            MouseArea {
                anchors.fill: parent
                onClicked: (parent.StackView.view || stackViewAuthWindow).pop()
            }
        }
    }
}
