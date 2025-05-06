import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0

Rectangle {
    id: pageSettings
    color: "green"

    ScrollView {
        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

            Column {
                spacing: 20
                Label {
                    text: "Настройки"
                    font.pixelSize: 24
                    color: "#d9d9d9"
                    font.bold: true
                    anchors.left: parent.left
                    anchors.margins: 26
                }

                Column {
                    anchors.margins: 10
                    spacing: 4
                    Label {
                        text: "Аккаунт"
                        font.pixelSize: 22
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: 26
                    }

                    CustSettingsButtomOn {
                        buttonText: "Изменить пароль"
                        iconSource: "qrc:/images/calendar.png"
                        popupTarget: settingsPopup
                    }

                    CustSettingsButtomOn {
                        buttonText: "Изменить почту"
                        iconSource: "qrc:/images/calendar.png"
                        popupTarget: settingsPopup
                    }
                    CustSettingsButtomOn {
                        buttonText: "Выйти из аккаунта"
                        iconSource: "qrc:/images/calendar.png"
                        popupTarget: settingsPopup
                    }
                    CustSettingsButtomOn {
                        buttonText: "Удалить аккаунт"
                        iconSource: "qrc:/images/calendar.png"
                        popupTarget: settingsPopup
                    }


                }
            }
        }
    }
}
