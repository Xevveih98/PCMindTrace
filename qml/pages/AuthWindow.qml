import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: mainAuthWindow
    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "#181718"
    }

    StackView {
        id: stackViewAuthWindow
        width: parent.width * 0.9
        height: 550
        anchors.centerIn: parent
        replaceEnter: null
        replaceExit: null
        initialItem: "qrc:/pages/Registration.qml"
    }

    Rectangle {
        id: refreshIndicator
        width: parent.width * 0.74
        height: 30
        radius: 16
        border.width: 1
        border.color: "#3E3A40"
        color: "#2D292C"
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30
        opacity: 0
        visible: false

        Text {
            anchors.centerIn: parent
            color: "#d9d9d9"
            font.bold: true
            font.pixelSize: 14
            text: "Регистрация прошла успешно!"
        }

        SequentialAnimation on y {
            id: showHideAnim
            running: false
            PropertyAnimation { to: 80; duration: 300; easing.type: Easing.OutCubic }
            PauseAnimation { duration: 1500 }
            PropertyAnimation { to: 0; duration: 300; easing.type: Easing.InCubic }
            onStopped: {
                refreshIndicator.visible = false
                refreshIndicator.opacity = 0
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

   Connections {
       target: authUser
       onRegistrationSuccess: {
           refreshIndicator.visible = true
           refreshIndicator.opacity = 1
           showHideAnim.start()
           stackViewAuthWindow.push("qrc:/pages/Login.qml")
       }
   }

   Connections {
       target: authUser
       onLoginSuccess: {
           Qt.callLater(function() {
               pageLoader.source = "qrc:/pages/mainContent.qml"
           })
       }
   }
}
