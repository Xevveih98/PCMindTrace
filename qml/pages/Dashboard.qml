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
            id: flickable
            anchors.fill: parent
            contentWidth: width
            contentHeight: eda.height + 70
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: eda
            }
        }
    }
}
