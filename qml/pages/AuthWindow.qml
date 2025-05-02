import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: mainAuthWindow
    width: parent.width
    height: parent.height

    StackView {
        id: stackViewAuthWindow
        width: parent.width * 0.9
        height: parent.height * 0.9
        anchors.centerIn: parent
        replaceEnter: null
        replaceExit: null
        initialItem: "qrc:/pages/Registration.qml"
    }
}
