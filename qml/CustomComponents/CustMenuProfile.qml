import QtQuick
import PCMindTrace 1.0

Item {
    id: wrapper

    property string buttonText: "Button"
    property url iconSource: ""
    property Item popupTarget: null
    property url avatarSource: "qrc:/images/avatar.png"
    property string userName: userName
    property string userEmail: userEmail

    signal clicked()

    Rectangle {
        id: buttonRect
        width: wrapper.width * 0.94
        height: wrapper.height
        color: "#3E3A40"
        radius: 20
        anchors.horizontalCenter: parent.horizontalCenter

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

        Item {
            anchors.fill: parent
            anchors.margins: 15

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

            Text {
                id: nameText
                text: userName
                color: "#D9D9D9"
                font.pixelSize: 16
                anchors.left: avatar.right
                anchors.leftMargin: 9
                anchors.top: avatar.top
                anchors.right: parent.right
                elide: Text.ElideRight
            }

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
        }
    }

    Component.onCompleted: {
        if (AppSave.isUserLoggedIn()) {
            userName = AppSave.getSavedLogin()
            userEmail = AppSave.getSavedEmail()
        }
    }
}
