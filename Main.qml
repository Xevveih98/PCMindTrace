import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0

Window {
    id: mainLoader
    width: 411
    height: 914
    visible: true
    color: "#181718"

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: AppSave.isUserLoggedIn() ? "qrc:/pages/mainContent.qml" : "qrc:/pages/AuthWindow.qml"
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
        onLoginSuccess: {
            Qt.callLater(function() {
                refreshIndicator.visible = true
                refreshIndicator.opacity = 1
                showHideAnim.start()
                pageLoader.source = "qrc:/pages/mainContent.qml"
            })
        }
    }
}
