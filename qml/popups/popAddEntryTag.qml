import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents 1.0
import QtQuick.Layouts

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
    onOpened: {
        categoriesUser.loadTags()
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        Text {
            text: "Добавить теги"
            color: "#D9D9D9"
            font.pixelSize: 20
            font.bold: true
            wrapMode: Text.Wrap
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            textFormat: Text.RichText
            text: "Теги помогают <b><font color='#DA446A'>быстро</font></b> находить записи — добавляйте как можно больше релевантных. Чтобы <b><font color='#DA446A'>убрать</font></b> тег, просто нажмите на него."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: "#D9D9D9"
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"

                Text {
                    anchors.centerIn: parent
                    text: "Пользовательский список пуст.."
                    color: "#4d4d4d"
                    font.pixelSize: 11
                    font.italic: true
                    visible: tagListModel.count === 0
                }
            }

            Item{
                width: parent.width * 0.97
                height: parent.height * 0.99
                anchors.centerIn: parent

                Flickable {
                    width: parent.width
                    height: parent.height
                    contentWidth: parent.width
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
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignBottom

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

    ListModel {
        id: tagListModel
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

    Connections {
        target: categoriesUser
        onTagsLoaded: {
            loadTagsFromServer(tags)
        }
    }
}
