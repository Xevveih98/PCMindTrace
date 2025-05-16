// CustomTextField.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import CustomComponents

Item {
    id: root

    property alias text: inputField.text
    property alias placeholderText: inputField.placeholderText
    property alias font: inputField.font
    property alias inputMethodHints: inputField.inputMethodHints
    property real customWidth: 0
    property real customHeight: 0

    width: customWidth > 0 ? customWidth : implicitWidth
    height: customHeight > 0 ? customHeight : implicitHeight

    signal tagConfirmed(string tag)

    ListModel {
        id: tagListModel
    }

    Item {
        anchors.fill: parent

        Item {
            id: contenttype
            width: parent.width
            height: 30

            TextField {
                id: inputField
                anchors.fill: parent
                font.pixelSize: 12
                color: "#D9D9D9"
                placeholderText: "Начните перечислять свои теги"
                placeholderTextColor: "#a9a9a9"
                wrapMode: Text.NoWrap
                maximumLength: 200
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                background: Rectangle {
                    color: "#292729"
                    border.color: "#4D4D4D"
                    border.width: 1
                    radius: 6
                }
                padding: 10
                onAccepted: confirmCurrentTag()
            }
        }

        Item {
            anchors.top: contenttype.bottom
            anchors.topMargin: 15
            width: parent.width
            height: parent.height * 0.5

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 1.02
                height: parent.height * 1.03
                color: "#262326"
                radius: 8

                Text {
                    anchors.centerIn: parent
                    text: "Добавьте новые теги"
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
                    width: amascroll.width   // 💡 Ключевой момент
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

    function confirmCurrentTag() {
        let raw = inputField.text.trim()
        if (raw.length > 0) {
            let parts = raw.split(" ")
            for (let i = 0; i < parts.length; ++i) {
                let tag = parts[i].trim()
                if (tag.length > 0 && !tagExists(tag)) {
                    tagListModel.append({ tag: tag })
                }
            }
            inputField.clear()
        }
    }

    function tagExists(tag) {
        for (let i = 0; i < tagListModel.count; ++i)
            if (tagListModel.get(i).tag === tag)
                return true
        return false
    }

    function getTags() {
        let tags = []
        for (let i = 0; i < tagListModel.count; ++i)
            tags.push(tagListModel.get(i).tag)
        return tags
    }

    function setTags(tagArray) {
        tagListModel.clear();
        for (let i = 0; i < tagArray.length; ++i) {
            tagListModel.append({ tag: tagArray[i].tag });
        }
    }

    function loadTagsFromServer(tags) {
        console.log("Loading tags into model:", tags)
        setTags(tags)
    }
}
