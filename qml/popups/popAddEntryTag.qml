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
        radius: 8
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
                    anchors.centerIn: parent
                    width: parent.width * 1.02
                    height: parent.height * 1.03
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
                                selected: managerPopup.selectedTags.some(t => t.id === model.id)
                                onClicked: {
                                    let index = managerPopup.selectedTags.findIndex(t => t.id === model.id)
                                    if (index === -1) {
                                       managerPopup.selectedTags.push({
                                           id: model.id,
                                           tag: model.tag
                                       })
                                    } else {
                                       managerPopup.selectedTags.splice(index, 1)
                                    }

                                    selected = !selected

                                    // Debug
                                    console.log("Обновленные selectedTags:")
                                    for (let i = 0; i < managerPopup.selectedTags.length; ++i) {
                                       console.log("  id:", managerPopup.selectedTags[i].id, "tag:", managerPopup.selectedTags[i].tag)
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
        tagListModel.clear();
        for (let i = 0; i < tagArray.length; ++i) {
            tagListModel.append({ id: tagArray[i].id, tag: tagArray[i].tag });
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
