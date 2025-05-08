import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

Popup {
    id: exitPopup
    width: 369
    height: 400
    modal: true
    focus: true
    dim: true
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

    Column {
        spacing: 16
        anchors.centerIn: parent
        width: parent.width * 0.92

        Text {
            text: "Выпишите ваши теги через пробел для их дальнейшего удобного добавления в запись."
            color: "#D9D9D9"
            font.pixelSize: 14
            wrapMode: Text.Wrap
            width: parent.width
        }

        CustTextFild {
            id: tagInput
            width: parent.width
            height: 290
        }
    }

    Rectangle {
        id: buttAuthCreateCheck
        color: "#474448"
        radius: 8
        width: parent.width + 15
        height: 40
        anchors {
            top: parent.bottom
            topMargin: -10
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Подтвердить"
            font.pixelSize: 16
            color: "#D9D9D9"
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                tagInput.confirmCurrentTag()

                // Оборачиваем в Qt.callLater, чтобы дождаться обновления модели после удаления
                Qt.callLater(() => {
                    const tags = tagInput.getTags()
                    console.log("Final tags for saving:", tags)
                    categoriesUser.saveTags(tags)
                    exitPopup.close()
                })
            }
        }
    }

    onOpened: {
        categoriesUser.loadTags()
    }

    Connections {
        target: categoriesUser
        onTagsLoaded: (tags) => {
            tagInput.loadTagsFromServer(tags)
        }
    }
}
