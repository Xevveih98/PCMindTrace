import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0


Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.6
    modal: true
    focus: true
    dim: true
    padding: 0
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    anchors.centerIn: Overlay.overlay
    Overlay.modeless: Rectangle {
        color: "#11272de7"
    }
    background: Rectangle {
        color: "#2D292C"
        radius: 10
        border.color: "#474448"
        border.width: 1
    }

    Item {
        anchors.fill: parent

        Item{
            width: parent.width * 0.9
            height: parent.height * 0.93
            anchors.centerIn: parent

            Text {
                id: header
                text: "Управление активностями"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите иконку и дайте название вашей активности."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: header.bottom
                anchors.topMargin: 14
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: text2
                text: "Чтобы убрать активность - намите на неё."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: text1.bottom
                anchors.topMargin: 1
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            Row {
                anchors.top: text2.bottom
                anchors.topMargin: 18
                height: 50
                spacing: 7

                Item {
                    width: height;
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Иконка нажата");
                            var component = Qt.createComponent("qrc:/popups/popIconPicker.qml");
                            if (component.status === Component.Ready) {
                                var popup = component.createObject(parent, {
                                    x: parent.mapToItem(null, 0, 0).x - 34,
                                    y: parent.mapToItem(null, 0, 0).y - 240  // чуть ниже элемента
                                });
                                if (popup) {
                                    popup.open();
                                } else {
                                    console.error("Не удалось создать объект popup");
                                }
                            } else {
                                console.error("Ошибка загрузки компонента:", component.errorString());
                            }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            source: "qrc:/icons/add.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Item {
                    width: 200; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    TextField {
                        id: inputField
                        anchors.fill: parent
                        font.pixelSize: 12
                        color: "#D9D9D9"
                        placeholderText: "Название активности"
                        placeholderTextColor: "#a9a9a9"
                        wrapMode: Text.NoWrap
                        maximumLength: 30
                        padding: 10
                        horizontalAlignment: TextInput.AlignLeft
                        verticalAlignment: TextInput.AlignVCenter
                        background: Rectangle {
                            color: "#292729"
                            border.color: "#4D4D4D"
                            border.width: 1
                            radius: 6
                        }
                    }
                }

                Item {
                    width: 1
                    height: 1
                }

                Item {
                    width: 1
                    height: 1
                }


                Item {
                    width: height; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Иконка нажата")
                        Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            source: "qrc:/icons/addbutt.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }

        Rectangle {
            id: buttAdmit
            color: "#474448"
            radius: 8
            width: parent.width
            height: 50
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Подтвердить"
                font.pixelSize: 18
                color: "#D9D9D9"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Qt.callLater(() => {
                        exitPopup.close()
                    })
                }
            }
        }
    }
}
