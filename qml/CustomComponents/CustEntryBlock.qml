import QtQuick 2.15
import QtQuick.Layouts
import CustomComponents

Item {
    id: papao
    width: parent.width
    height: headeroblo.height + container.implicitHeight + container2.implicitHeight + 20

    property string entryTitle
    property string entryContent
    property var entryDate
    property var entryTime
    property int entryMood
    property var tagItems
    property var activityItems
    property var emotionItems

    Rectangle {
        anchors.fill: parent
        radius: 18
        color: "#2D292C"

        Item {
            id: headeroblo
            width: parent.width * 0.94
            height: 56
            anchors.top: parent.top
            //anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                id: iconhef
                width: 42
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 36
                    height: 36
                    source: Utils.getIconPathById(iconModelMood, papao.entryMood)
                    fillMode: Image.PreserveAspectFit
                }
            }

            Item {
                width: parent.width * 0.71
                height: 38
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: iconhef.right

                Text {
                    text: entryTitle
                    font.bold: true
                    font.pointSize: 14
                    width: parent.width
                    color: "#d9d9d9"
                    wrapMode: Text.Wrap
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                anchors.right: parent.right
                width: 70
                height: 35
                anchors.verticalCenter: parent.verticalCenter

                Column {
                    width: parent.width
                    spacing: 2

                    Text {
                        text: entryDate
                        font.pixelSize: 11
                        color: "#686A71"
                        anchors.right: parent.right
                    }

                    Text {
                        text: entryTime
                        font.pixelSize: 11
                        color: "#686A71"
                        anchors.right: parent.right
                    }
                }
            }
        }

        Column {
            id: container
            width: parent.width * 0.8
            spacing: 10
            anchors.left: parent.left
            anchors.leftMargin: 58
            anchors.top: headeroblo.bottom

            Text {
                text: entryContent
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                width: parent.width
                color: "#d9d9d9"
            }
        }

        Column {
            id: container2
            spacing: 6
            width: parent.width * 0.94
            anchors.top: container.bottom
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                width: parent.width
                height: emotionsListModel.count > 0 ? 40 : 0

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.03
                    height: parent.height * 1.01
                    color: "#262326"
                    radius: 8
                }

                ListView {
                    id: emotionsView
                    width: parent.width
                    height: parent.height
                    orientation: ListView.Horizontal
                    spacing: 6
                    clip: true
                    model: ListModel {
                        id: emotionsListModel
                    }

                    delegate: CustEmotButn {
                        emotionText: model.label
                        iconPath: Utils.getIconPathById(iconModelEmotion, model.iconId)
                        buttonWidth: implicitWidth
                        buttonHeight: 40
                    }

                    Component.onCompleted: {
                        emotionsListModel.clear()
                        for (let i = 0; i < emotionItems.length; i++) {
                            emotionsListModel.append(emotionItems[i])
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: activitiesListModel.count > 0 ? 40 : 0

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.03
                    height: parent.height * 1.01
                    color: "#262326"
                    radius: 8
                }

                ListView {
                    id: activitiesView
                    width: parent.width
                    height: parent.height
                    orientation: ListView.Horizontal
                    spacing: 6
                    clip: true
                    model: ListModel {
                        id: activitiesListModel
                    }

                    delegate: CustActvButn {
                        activityText: model.label
                        iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
                        buttonWidth: implicitWidth
                        buttonHeight: 40
                    }

                    Component.onCompleted: {
                        activitiesListModel.clear()
                        for (let i = 0; i < activityItems.length; i++) {
                            activitiesListModel.append(activityItems[i])
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: tagsListModel.count > 0 ? 40 : 0

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.03
                    height: parent.height * 1.01
                    color: "#262326"
                    radius: 8
                }

                ListView {
                    id: tagsView
                    width: parent.width
                    height: parent.height
                    orientation: ListView.Horizontal
                    spacing: 6
                    clip: true
                    model: ListModel {
                        id: tagsListModel
                    }

                    delegate: CustTagButon {
                        tagText: model.label
                        buttonWidth: implicitWidth
                    }

                    Component.onCompleted: {
                        tagsListModel.clear()
                        for (let i = 0; i < tagItems.length; i++) {
                            tagsListModel.append(tagItems[i])
                        }
                    }
                }
            }
        }
    }

    IconModelAct {
        id: iconModelActivity
    }
    IconModelEmo {
        id: iconModelEmotion
    }
    IconModelMod {
        id: iconModelMood
    }

}
