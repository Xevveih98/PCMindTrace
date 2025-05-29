import QtQuick
import QtQuick.Controls

Item {
    id: refreshIndicator
    opacity: 0
    visible: false
    height: 30
    width: 200
    anchors.horizontalCenter: parent.horizontalCenter
    y: 20

    property string notificationTitle: "Регистрация прошла успешно!"

    Rectangle {
        color: "#2D292C"
        anchors.fill: parent
        border.width: 1
        border.color: "#3E3A40"
        radius: 16
    }

    Text {
        anchors.centerIn: parent
        color: "#d9d9d9"
        font.bold: true
        font.pixelSize: 14
        text: refreshIndicator.notificationTitle
    }

    SequentialAnimation on y {
        id: showHideAnim
        running: false
        PropertyAnimation { to: 50; duration: 300; easing.type: Easing.OutCubic }
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

    function triggerAnimation() {
        visible = true
        opacity = 1
        showHideAnim.stop()
        showHideAnim.start()
    }
}
