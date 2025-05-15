import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

Popup {

    property var selectedTags: []
    signal tagsConfirmed(var selectedTags)
    
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
                text: "Добавление тегов"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите теги, которые хотите добавить."
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
                text: "Чтобы убрать тег - намите на него."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: text1.bottom
                anchors.topMargin: 1
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            ListModel {
                id: tagListModel
            }

            Item {
                anchors.top: text2.bottom
                anchors.topMargin: 15
                width: parent.width
                height: parent.height * 0.7

                Rectangle {
                    anchors.fill: parent
                    color: "#262326"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "Пользовательский список пуст.."
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: tagListModel.count === 0
                    }

                    ScrollView {
                        id: amascroll
                        width: parent.width
                        height: parent.height
                        z: 1

                        Flow {
                            width: amascroll.width
                            spacing: 6

                            Repeater {
                                model: tagListModel
                                delegate: CustTagButon {
                                    tagText: model.tag
                                    buttonWidth: implicitWidth
                                    selected: managerPopup.selectedTags.indexOf(model.tag) !== -1
                                    onClicked: {
                                        let idx = managerPopup.selectedTags.indexOf(model.tag)
                                        if (idx === -1)
                                            managerPopup.selectedTags.push(model.tag)
                                        else
                                            managerPopup.selectedTags.splice(idx, 1)
                                        selected = !selected
                                    }
                                }
                            }
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
                    tagsConfirmed(managerPopup.selectedTags)
                    managerPopup.close()
                }
            }            
        }
    }

    function setTags(tagArray) {
        tagListModel.clear()
        selectedTags = []
        for (let i = 0; i < tagArray.length; ++i) {
            tagListModel.append({ tag: tagArray[i] })
        }
    }

    function loadTagsFromServer(tags) {
        console.log("Loading tags into model:", tags)
        setTags(tags)
    }

    onOpened: {
        categoriesUser.loadTags()
    }

    Connections {
        target: categoriesUser
        onTagsLoaded: {
            loadTagsFromServer(tags)
        }
    }
}
