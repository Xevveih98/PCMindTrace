import QtQuick
import QtQuick.Controls

Item {
    id: mainAuthWindow
    width: parent.width * 0.94
    height: parent.height * 0.92
    anchors.centerIn: parent

    StackView {
        id: stackViewAuthWindow
        anchors.fill: parent
        replaceEnter: null
        replaceExit: null
        initialItem: "qrc:/pages/Home.qml"
    }
}
