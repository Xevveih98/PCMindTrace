import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import QtQuick.Layouts
import CustomComponents

Popup {
    id: managerPopup
    width: Screen.width * 0.76
    height: Screen.height * 0.56
    modal: true
    focus: true
    dim: true
    padding: 0
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    anchors.centerIn: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#181718"
        opacity: 0.9
    }
    background: Rectangle {
        color: "#2D292C"
        radius: 8
        border.color: "#474448"
        border.width: 1
    }

    property int pinLength: 4
    property string enteredPin: ""
    property string firstPin: ""
    property int step: 1
    property string infoText: "Придумайте Pin-код"

    signal pinCodeSet()

    onEnteredPinChanged: {
        if (enteredPin.length === pinLength) {
            if (step === 1) {
                firstPin = enteredPin;
                enteredPin = "";
                step = 2;
                infoText = "Повторите Pin-код";
            } else if (step === 2) {
                if (enteredPin === firstPin) {
                    AppSave.savePinCode(enteredPin);
                    pinCodeSet();
                    managerPopup.close();
                } else {
                    enteredPin = "";
                    infoText = "Попробуйте ещё раз";
                }
            }
        }
    }

    Item {
        id: oberInputFieldsEmpty
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.8

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Text {
                id: headerText
                text: infoText
                Layout.fillWidth: true
                color: "#D9D9D9"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                Layout.preferredHeight: 70
                Layout.alignment: Qt.AlignCenter

                Row {
                    id: pinDots
                    spacing: 20
                    anchors.centerIn: parent

                    Repeater {
                        model: pinLength
                        delegate: Rectangle {
                            border.width: 3
                            border.color: "#DA446A"
                            width: 18
                            height: 18
                            radius: width / 2
                            color: index < managerPopup.enteredPin.length ? "#DA446A" : "transparent"
                        }
                    }
                }
            }

            Grid {
                columns: 3
                spacing: 17
                Layout.alignment: Qt.AlignCenter

                Repeater {
                    model: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫" ]

                    delegate: Item {
                        width: 60
                        height: 60

                        Rectangle {
                            id: digitButton
                            anchors.fill: parent
                            color: "#2D292C"
                            radius: 100
                            visible: modelData !== "⌫"

                            property color defaultColor: "#2D292C"
                            property color pressedColor: "#403A3E"

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (enteredPin.length < pinLength) {
                                        enteredPin += modelData
                                    }
                                    glowAnim.restart()
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: "#d9d9d9"
                                    font.pixelSize: 22
                                    font.bold: true
                                }
                            }

                            SequentialAnimation {
                                id: glowAnim
                                running: false
                                ColorAnimation {
                                    target: digitButton
                                    property: "color"
                                    to: digitButton.pressedColor
                                    duration: 80
                                }
                                PauseAnimation { duration: 50 }
                                ColorAnimation {
                                    target: digitButton
                                    property: "color"
                                    to: digitButton.defaultColor
                                    duration: 200
                                }
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            visible: modelData === "⌫"
                            color: "transparent"
                            radius: 100

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (enteredPin.length > 0) {
                                        enteredPin = enteredPin.slice(0, -1)
                                    }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/images/remove.png"
                                    width: 30
                                    height: 30
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
