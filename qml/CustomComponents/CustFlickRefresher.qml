// RefreshableFlickable.qml
import QtQuick
import QtQuick.Controls

Item {
    id: wrapper
    anchors.fill: parent

    signal refreshed()

    default property alias contentChildren: contentColumn.children

    property alias flickable: flickable
    property alias contentHeight: contentColumn.height

    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        clip: true
        contentHeight: contentColumn.height

        property bool refreshing: false

        Column {
            id: contentColumn
            width: flickable.width
            spacing: 12
        }

        onContentYChanged: {
            if (!refreshing && contentY <= -60) {
                refreshing = true
                console.log("Обновление данных...")
                wrapper.refreshed()
                refreshResetTimer.start()
            }
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
                    appearAnim.start()
            }
        }
    }
}

// использование
// CustFlkRfshr {
//     anchors.fill: parent/*
//     flickable.contentHeight: eda.height + entryColumn.height + 20*/
//     onRefreshed: {
//         monthSwitchButton.updateDisplay()
//         foldersUser.loadFolder();
//         todoUser.loadTodo();
//         entriesUser.loadUserEntries(selectedFolderId,
//                                     monthSwitchButton.selectedYear,
//                                     monthSwitchButton.selectedMonth);
//         refreshResetTimer.start()
//     }
// }
