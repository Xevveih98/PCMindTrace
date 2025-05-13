import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents
import "../CustomComponents"

Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.93
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
        radius: 10
        border.color: "#474448"
        border.width: 1
    }

    Item {
        width: parent.width * 0.91
        height: parent.height * 0.95
        anchors.centerIn: parent

        Item {
            id: headermaininfo
            width: parent.width
            height: 48

            Item {
                id: iconemote
                height: parent.height
                width: height

                Rectangle {
                    width: 44
                    height: 44
                    color: "#616161"
                    radius: 100
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                anchors.left: iconemote.right
                width: parent.width - iconemote.width
                height: parent.height

                Text  {
                    text: "Название записи"
                    font.pixelSize: 11
                    color: "#d9d9d9"
                }

                Text  {
                    text: "14 февраля 2020"
                    font.pixelSize: 11
                    anchors.right: parent.right
                    color: "#616161"
                }

                TextField {
                    id: entryHeader
                    width: parent.width
                    anchors.bottom: parent.bottom
                    height: 30
                    font.pixelSize: 11
                    color: "#D9D9D9"
                    placeholderText: ""
                    maximumLength: 30
                    wrapMode: Text.NoWrap
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    background: Rectangle {
                        color: "#292729"
                        border.color: "#4D4D4D"
                        border.width: 1
                        radius: 8
                    }
                    padding: 10
                }
            }
        }

        Item{
            id: deckheadpart
            width: parent.width
            height: parent.height * 0.5
            anchors.top: headermaininfo.bottom
            anchors.topMargin: 8

            Text{
                id: dexregwq
                text: "Содержание записи"
                font.pixelSize: 11
                color: "#d9d9d9"
            }

            Rectangle {
                id: entryDesc
                width: parent.width
                anchors.top: dexregwq.bottom
                anchors.topMargin: 2
                height: parent.height - 12
                color: "#292729"
                border.color: "#4D4D4D"
                border.width: 1
                radius: 8

                Flickable {
                    id: flick
                    anchors.fill: parent
                    contentHeight: textEdit.contentHeight
                    clip: true

                    function ensureVisible(r) {
                        if (contentX >= r.x)
                            contentX = r.x;
                        else if (contentX + width <= r.x + r.width)
                            contentX = r.x + r.width - width;
                        if (contentY >= r.y)
                            contentY = r.y;
                        else if (contentY + height <= r.y + r.height)
                            contentY = r.y + r.height - height;
                    }

                    TextEdit {
                        id: textEdit
                        width: flick.width
                        textFormat: TextEdit.RichText
                        color: "#d9d9d9"
                        font.pixelSize: 11
                        wrapMode: TextEdit.WrapAnywhere
                        Keys.onReturnPressed: insert("\n")
                        padding: 6
                        //focus: false
                        onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                    }
                }

                Text {
                    id: placeholder
                    anchors.fill: parent
                    anchors.margins: 8
                    font.pixelSize: 11
                    text: "Введите текст..."
                    color: "#4d4d4d"
                    opacity: (!textEdit.text && !textEdit.activeFocus) ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }
        }

        Item {
            id: tegheaderaw
            width: parent.width
            height: 60
            anchors.top: deckheadpart.bottom
            anchors.topMargin: 14

            Item{
                id: headegeatag
                width: parent.width
                height: 30

                Text{
                    id: tagchoose
                    text: "Теги"
                    font.pixelSize: 15
                    font.bold: true
                    color: "#d9d9d9"
                }

                Item {
                    height: parent.height
                    width: height
                    anchors.right: parent.right

                    Image {
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        source: "qrc:/images/addbuttplus.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Item {
                id: tagviewma
                anchors.top: headegeatag.bottom
                anchors.topMargin: 1
                width: parent.width
                height: 30

                Rectangle {
                    anchors.fill: parent
                    color: "red"
                }
            }
        }

        Item {
            id: headeractivitiew
            width: parent.width
            height: 90
            anchors.top: tegheaderaw.bottom
            anchors.topMargin: 14

            Item{
                id: headegacri
                width: parent.width
                height: 30

                Text{
                    id: acitw
                    text: "Активности"
                    font.pixelSize: 15
                    font.bold: true
                    color: "#d9d9d9"
                }

                Item {
                    height: parent.height
                    width: height
                    anchors.right: parent.right

                    Image {
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        source: "qrc:/images/addbuttplus.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Item {
                id: tagviwma
                anchors.top: headegacri.bottom
                anchors.topMargin: 1
                width: parent.width
                height: 60

                Rectangle {
                    anchors.fill: parent
                    color: "red"
                }
            }
        }

        Item {
            id: headeremot
            width: parent.width
            height: 90
            anchors.top: headeractivitiew.bottom
            anchors.topMargin: 14

            Item{
                id: headega32
                width: parent.width
                height: 30

                Text{
                    id: emottttttt
                    text: "Эмоции"
                    font.pixelSize: 15
                    font.bold: true
                    color: "#d9d9d9"
                }

                Item {
                    height: parent.height
                    width: height
                    anchors.right: parent.right

                    Image {
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        source: "qrc:/images/addbuttplus.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Item {
                id: wmro
                anchors.top: headega32.bottom
                anchors.topMargin: 1
                width: parent.width
                height: 60

                Rectangle {
                    anchors.fill: parent
                    color: "red"
                }
            }
        }

        Item {
            id:bittchoo
            width: parent.width * 0.8
            anchors.horizontalCenter: parent.horizontalCenter
            height: 30
            anchors.bottom: parent.bottom

            Rectangle {
                id: bakcje
                width: 120
                height: parent.height
                color: "#181718"
                anchors.left: parent.left
                radius: 8

                Item {
                    width: 66
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Закрыть"
                        font.pixelSize: 12
                        font.bold: true
                        color: "#d9d9d9"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 10
                        height: 10
                        source: "qrc:/images/closebutt.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Rectangle {
                id: nefvy
                width: 120
                color: "#474448"
                height: parent.height
                anchors.right: parent.right
                radius: 8

                Item {
                    width: 86
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Продолжить"
                        font.pixelSize: 12
                        font.bold: true
                        color: "#d9d9d9"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 12
                        height: 12
                        source: "qrc:/images/right-arrow.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }
    }
}
