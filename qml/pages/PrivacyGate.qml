import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents

Item {
    id: mainPrivacyGate
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
        initialItem: "qrc:/pages/PinCode.qml"
    }
}
