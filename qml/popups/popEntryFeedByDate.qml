import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

Popup {
    property var selectedEmotions: []
    signal emotionsConfirmed(var selectedEmotions)

    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.6
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
        anchors.fill: parent

        Item {
            width: parent.width * 0.9
            height: parent.height * 0.93
            anchors.centerIn: parent

            Text {
                id: header
                text: "Записи сделанные в этот день"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                id:entryFeed
                width:  parent.width
                anchors.top: header.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                height: 400

                ScrollView {
                    id: entryScroll
                    width: parent.width
                    height: parent.height

                    Column {
                        id: entryColumn
                        width: parent.width
                        spacing: 10

                        Repeater {
                            model: entriesUser.dateSearchModel
                            delegate: CustEntrBttn {
                                width: entryColumn.width
                                entryTitle: model.title
                                entryContent: model.content
                                entryDate: model.date
                                entryTime: model.time
                                entryMood: model.moodId
                                tagItems: model.tags
                                activityItems: model.activities
                                emotionItems: model.emotions
                                entryId: model.id
                            }
                            visible: entriesUser.dateSearchModel.count > 0
                        }
                    }
                }

                Item {
                    width: 80
                    height: 80
                    anchors.centerIn: parent
                    visible: entriesUser.dateSearchModel.count === 0

                    Column {
                        spacing: 8
                        width: parent.width

                        Image {
                            width: 60
                            height: 60
                            source: "qrc:/images/noentries.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            id: emptyText
                            text: "Записей в этот день нет.."
                            font.italic: true
                            font.bold: true
                            font.pixelSize: 14
                            color: "#616161"
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: entriesUser.dateSearchModel.count === 0
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        entriesUser.clearDateSearchModel()
    }
}
