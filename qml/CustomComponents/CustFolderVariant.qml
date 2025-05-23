import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
    id: folderButton

    property string folderName: ""
    property bool isSelected: false

    padding: 0
    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    background: Rectangle {
        anchors.fill: parent
        radius: 8
        color: folderButton.isSelected ? "#37262E" : "#1F1B1F"
        border.width: 1
        border.color: folderButton.isSelected ? "#9A5556" : "#4D4D4D"
    }

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Item {
            height: parent.height
            width: 38

            Image {
                source: "qrc:/images/foldervar.png"
                width: 20
                height: 20
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }
        }

        Text {
            text: folderName
            color: "#D9D9D9"
            font.pointSize: 16
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
}
