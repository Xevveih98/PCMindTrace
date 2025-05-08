// CustomTextField.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    id: root

    // Делаем ширину и высоту настраиваемыми извне
    property alias text: inputField.text
    property alias placeholderText: inputField.placeholderText
    property alias font: inputField.font
    property alias inputMethodHints: inputField.inputMethodHints
    property alias tagWidth: inputField.width
    property alias tagHeight: inputField.height

    width: 200
    height: 40

    signal tagConfirmed(string tag)

    ListModel {
        id: tagListModel
    }

    ColumnLayout {
        spacing: 6
        width: root.width

        Flow {
            width: parent.width
            height: implicitHeight  // ⬅️ Добавь это!
            spacing: 6

            Repeater {
                model: tagListModel
                delegate: Button {
                    text: model.tag
                    onClicked: {
                        categoriesUser.deleteTag(model.tag);
                        tagListModel.remove(index);
                    }
                }
            }
        }

        // Кастомный TextField в стиле старого кода
        Item {
            width: 300
            height: 260

            Rectangle {
                id: background
                anchors.fill: parent
                color: "#292729"
                border.color: "#4D4D4D"
                border.width: 1
                radius: 6
            }

            TextField {
                id: inputField
                width: root.width
                height: root.height
                anchors.margins: 8
                background: null
                color: "#d9d9d9"
                font.pixelSize: 12
                placeholderText: "Начните перечислять свои теги"
                palette.placeholderText: "#a9a9a9"
                wrapMode: Text.Wrap

                onAccepted: confirmCurrentTag()
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
        tagListModel.clear()
        for (let i = 0; i < tagArray.length; ++i)
            tagListModel.append({ tag: tagArray[i] })
    }

    function loadTagsFromServer(tags) {
        console.log("Loading tags into model:", tags)
        setTags(tags)
    }
}
