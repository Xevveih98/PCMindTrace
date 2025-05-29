import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0
import QtQuick.Layouts
import CustomComponents

Item {
    id: pagePinCode

    property int pinLength: 4
    property string enteredPin: ""

    Rectangle {
        anchors.fill: parent
        color: "#181718"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        CustPageHead {
            id: header
            Layout.fillWidth: true
            titleText: "Введите PIN-код"
        }

        Item {
            Layout.preferredHeight: 70
            Layout.alignment: Qt.AlignCenter

            Row {
                id: pinDots
                spacing: 20
                anchors.centerIn: parent

                Repeater {
                    model: 4
                    delegate: Rectangle {
                        border.width: 3
                        border.color: "#DA446A"
                        width: 18
                        height: 18
                        radius: width / 2
                        color: index < pagePinCode.enteredPin.length ? "#DA446A" : "transparent"
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
                        color: "#181718"
                        radius: 100
                        visible: modelData !== "⌫"

                        property color defaultColor: "#181718"
                        property color pressedColor: "#282728"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (enteredPin.length < pinLength) {
                                    enteredPin += modelData;
                                    console.log("вводимое хз", enteredPin)
                                    if (enteredPin.length === pinLength) {
                                        checkPinCode(enteredPin);
                                        console.log("весь пин", enteredPin)
                                    }
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
                                    enteredPin = enteredPin.slice(0, -1);
                                    errorMessage = "";
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

        Item {
            Layout.preferredHeight: eopw.height
            Layout.fillWidth: true

            Row {
                id: eopw
                spacing: 5
                anchors.centerIn: parent

                Text {
                    text: "Забыли Pin-Code?"
                    font.pixelSize: 12
                    color: "#D9D9D9"
                }

                Text {
                    text: "Войдите заново."
                    font.pixelSize: 12
                    color: "#DA446A"
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            AppSave.clearUser();
                            pageLoader.source = "qrc:/pages/AuthWindow.qml";
                        }
                    }
                }
            }
        }
    }

    function checkPinCode(pin) {
        var savedPin = AppSave.loadPinCode();
        console.log("пин", AppSave.loadPinCode())
        if (pin === savedPin) {
            pageLoader.source = "qrc:/pages/mainContent.qml";
        } else {
            enteredPin = "";
        }
    }
}
