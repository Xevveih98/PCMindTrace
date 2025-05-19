import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Rectangle {
    id: pageDashboardScreen
    color: "#181718"

    CustPageHead {
        id: header
        headerWidth: parent.width
        titleText: "Анализ"
    }

    Item {
        id: itemcore
        width: parent.width * 0.93
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom

        Flickable {
            property bool refreshing: false
            id: flickable
            anchors.fill: parent
            contentHeight: eda.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: eda
                width: parent.width
                spacing: 12
            }

            onContentYChanged: {
                if  (!flickable.refreshing && contentY <= -60) {
                    flickable.refreshing = true
                    console.log("Обновление данных...")
                    refreshPage()
                }
            }
            function refreshPage() {

                refreshResetTimer.start()

            }

            Timer {
                id: refreshResetTimer
                interval: 1100
                repeat: false
                onTriggered: {
                    flickable.refreshing = false
                }
            }
        }
    }

    Rectangle {
        id: refreshIndicator
        width: parent.width * 0.6
        radius: 16
        border.width: 1
        border.color: "#3E3A40"
        height: 30
        opacity: 0.0
        color: "#2D292C"
        anchors.horizontalCenter: parent.horizontalCenter
        y: 10
        z: 100
        visible: opacity > 0.0

        Text {
            anchors.centerIn: parent
            color: "#d9d9d9"
            font.bold: true
            font.pixelSize: 16
            text: "Страница обновлена!"
        }

        SequentialAnimation {
            id: appearAnim
            PropertyAnimation {
                target: refreshIndicator
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 100
            }

            PauseAnimation { duration: 900 }

            PropertyAnimation {
                target: refreshIndicator
                property: "opacity"
                to: 0.0
                duration: 400
            }
        }

        Connections {
            target: flickable
            onRefreshingChanged: {
                if (flickable.refreshing)
                    appearAnim.start();
            }
        }
    }
}
