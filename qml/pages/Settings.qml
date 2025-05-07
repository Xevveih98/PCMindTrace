import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0

Rectangle {
    id: pageSettings
    color: "#181718"

    property var stackViewmc: stackViewMainContent

    ScrollView {
        anchors.fill: parent

        Item {
            id: itemcore
            width: parent.width * 0.82
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

            Column {
                spacing: 20

                CustPageHead {
                    titleText: "Настройки"
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10


                    Label {
                        text: "Профиль"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustProfHead {
                        buttonWidth: itemcore.width
                        buttonText: "Открыть профиль"
                        avatarSource: "qrc:/images/calm.png"
                        userName: "Эльвира Тимощенко"
                        userEmail: "elvira@example.com"
                        onClicked: {
                            console.log("Кнопка нажата!")
                        }
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Посмотреть статистику"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: settingsPopupChangeEmail
                    }
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    Label {
                        text: "Аккаунт"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Изменить пароль"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserChangePass.qml"
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Изменить почту"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserChangeEmail.qml"
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Выйти из аккаунта"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserExitAdmit.qml"
                    }
                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Удалить аккаунт"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserDeleteAdmit.qml"
                    }
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    Label {
                        text: "Приватность"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Настроить пароль"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: settingsPopupChangePass
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Настроить PIN-код"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: settingsPopupChangeEmail
                    }
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    Label {
                        text: "Управление категориями"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Редактировать активности"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: settingsPopupChangePass
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Редактировать эмоции"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: settingsPopupChangeEmail
                    }

                    CustButtSett {
                        buttonWidth: itemcore.width
                        buttonText: "Редактировать теги"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: settingsPopupChangeEmail
                    }
                }
            }
        }
    }
}
