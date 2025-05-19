import QtQuick
import PCMindTrace 1.0

Item {
    id: wrapper
    width: buttonWidth
    height: Math.max(buttonRect.implicitHeight, 80)

    property int buttonWidth: 200
    property string buttonText: "Button"
    property url iconSource: ""
    property Item popupTarget: null
    property url avatarSource: "qrc:/images/avatar.png"
    property string userName: userName
    property string userEmail: userEmail

    signal clicked()

    Rectangle {
        id: buttonRect
        width: wrapper.width
        height: wrapper.height
        color: "#2D292C"
        radius: 12
        border.width: 1
        border.color: "#474448"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (popupTarget) {
                    popupTarget.open()
                }
                wrapper.clicked()
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }

        // Контент внутри кнопки
        Item {
            anchors.fill: parent
            anchors.margins: 18

            // Аватар
            Image {
                id: avatar
                source: avatarSource
                width: 40
                height: 40
                anchors.left: parent.left
                anchors.top: parent.top
                fillMode: Image.PreserveAspectFit
                smooth: true
                clip: true
            }

            // Имя пользователя
            Text {
                id: nameText
                text: userName
                color: "#D9D9D9"
                font.pixelSize: 16
                anchors.left: avatar.right
                anchors.leftMargin: 12
                anchors.top: avatar.top
                anchors.right: parent.right
                elide: Text.ElideRight
            }

            // Почта пользователя
            Text {
                id: emailText
                text: userEmail
                color: "#B9B9B9"
                font.pixelSize: 13
                anchors.left: nameText.left
                anchors.top: nameText.bottom
                anchors.topMargin: 4
                anchors.right: parent.right
                elide: Text.ElideRight
            }

            // Стрелка справа
            Text {
                id: arrow
                text: ">"
                color: "#A9A9A9"
                font.pixelSize: 18
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }
    }

    Component.onCompleted: {
        if (AppSave.isUserLoggedIn()) {
            userName = AppSave.getSavedLogin()
            userEmail = AppSave.getSavedEmail()
        }
    }
}
