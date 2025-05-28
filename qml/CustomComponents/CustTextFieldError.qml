import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    id: root
    property alias text: inputFill.text
    property alias maximumLength: inputFill.maximumLength
    property alias placeholderText: custPlaceholder.text
    property alias errorText: errorLabel.text
    property alias errorVisible: errorLabel.visible
    property color originalBorderColor: "#4D4D4D"
    property color errorBorderColor: "#C04753"
    property color borderColor: root.originalBorderColor

    height: 42

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TextField {
            id: inputFill
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.maximumHeight: 40
            font.pixelSize: 11
            color: "#D9D9D9"
            placeholderText: ""
            maximumLength: 120
            wrapMode: Text.NoWrap
            horizontalAlignment: TextInput.AlignLeft
            verticalAlignment: TextInput.AlignVCenter
            background: Rectangle {
                color: "#292729"
                border.color: root.borderColor
                border.width: 1
                radius: 0
            }
            padding: 10

            Text {
                id: custPlaceholder
                anchors.fill: inputFill
                anchors.margins: 10
                font.pixelSize: 11
                text: placeholderText
                color: "#4d4d4d"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                opacity: (!inputFill.text && !inputFill.activeFocus) ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
        }

        Text {
            id: errorLabel
            textFormat: Text.RichText
            text: errorText
            font.pixelSize: 11
            color: "#C04753"
            visible: errorVisible
            wrapMode: Text.WrapAnywhere
            Layout.preferredWidth: root.width
            //Layout.fillWidth: true
        }
    }

    SequentialAnimation {
        id: shakeAnimation
        running: false
        loops: 1

        NumberAnimation { target: root; property: "shakeOffset"; to: -8; duration: 50 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 8; duration: 50 }
        NumberAnimation { target: root; property: "shakeOffset"; to: -5; duration: 50 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 5; duration: 50 }
        NumberAnimation { target: root; property: "shakeOffset"; to: -2; duration: 50 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 0; duration: 50 }
    }

    ColorAnimation {
        id: borderAnim
        target: root
        property: "borderColor"
        duration: 800
        easing.type: Easing.OutQuint
    }

    function triggerErrorAnimation() {
        borderAnim.stop()
        root.borderColor = errorBorderColor
        borderAnim.from = errorBorderColor
        borderAnim.to = originalBorderColor
        borderAnim.start()
        shakeAnimation.start()
    }
    x: shakeOffset
    property int shakeOffset: 0
}
