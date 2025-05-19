import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: headertitle
    height: 50
    width: headerWidth

    property string headerWidth: headertitle.width
    property string titleText: ""

    Text {
        text: titleText
        color: "#D9D9D9"
        font.pixelSize: 20
        font.bold: true
        anchors.centerIn: parent
    }
}
