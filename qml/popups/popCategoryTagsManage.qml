import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents 1.0
import QtQuick.Layouts

Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.8
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
    onOpened: {
        categoriesUser.loadTags()
    }


    Item {
        anchors.top: parent.top
        anchors.topMargin: 15
        width: parent.width * 0.9
        height: parent.height * 0.9
        anchors.horizontalCenter: parent.horizontalCenter

        ColumnLayout {
            anchors.fill: parent

            Text {
                text: "Управление тегами"
                color: "#D9D9D9"
                font.pixelSize: 20
                font.bold: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                textFormat: Text.RichText
                text: "Укажите теги через <b><font color='#DA446A'>пробел</font></b>. Чтобы <b><font color='#DA446A'>убрать</font></b> тег - намите на него."
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 14
                color: "#D9D9D9"
            }

            Item {
                Layout.preferredHeight: 50
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 7

                    CustTxtFldEr {
                        id: catName
                        Layout.fillWidth: true
                        placeholderText: "Дайте название впечатлению"
                        maximumLength: 64
                        errorText: "* Ошибка"
                        errorVisible: false
                        property string previousText: ""
                    }

                    Item {
                        width: 30
                        height: 30

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {

                            }

                            Image {
                                anchors.centerIn: parent
                                width: parent.height
                                height: parent.width
                                source: "qrc:/images/addbuttplus.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    color: "#262326"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "Добавьте новые теги.."
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: emotionListModel.count === 0
                    }
                }

                Item{
                    width: parent.width * 0.97
                    height: parent.height * 0.99
                    anchors.centerIn: parent

                    Flickable {
                        width: parent.width
                        height: parent.height
                        contentWidth: flowContent.implicitWidth
                        contentHeight: flowContent.implicitHeight
                        clip: true

                        Flow {
                            id: flowContent
                            width: parent.width
                            spacing: 6

                            Repeater {
                                model: tagListModel
                                delegate: CustTagButon {
                                    tagText: model.tag
                                    buttonWidth: implicitWidth
                                    onClicked: {
                                        categoriesUser.deleteTag(model.tag);
                                        tagListModel.remove(index);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: tagListModel
    }

    Rectangle {
        id: buttAdmit
        color: "#474448"
        radius: 8
        width: parent.width
        anchors.bottom: parent.bottom
        height: 40

        Text {
            text: "Подтвердить"
            font.pixelSize: 18
            color: "#D9D9D9"
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                managerPopup.close()
            }
        }
    }
}
