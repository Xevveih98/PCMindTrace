import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: iconPicker
    signal iconSelected(string iconId, string iconPath)
    width: 260
    height: 164
    modal: false
    focus: true
    padding: 8
    background: Rectangle {
        color: "#292729"
        radius: 8
        border.width: 1
        border.color: "#4D4D4D"
    }

    ListModel {
        id: iconModel
        ListElement { iconId: 1; path: "qrc:/icons2/amaze.png" }
        ListElement { iconId: 2; path: "qrc:/icons2/angry(1).png" }
        ListElement { iconId: 3; path: "qrc:/icons2/angry.png" }
        ListElement { iconId: 4; path: "qrc:/icons2/apathy(1).png" }
        ListElement { iconId: 5; path: "qrc:/icons2/apathy.png" }
        ListElement { iconId: 6; path: "qrc:/icons2/complain.png" }
        ListElement { iconId: 7; path: "qrc:/icons2/cool.png" }
        ListElement { iconId: 8; path: "qrc:/icons2/cry.png" }
        ListElement { iconId: 9; path: "qrc:/icons2/crying(1).png" }
        ListElement { iconId: 10; path: "qrc:/icons2/cupid-arrow.png" }
        ListElement { iconId: 11; path: "qrc:/icons2/dove.png" }
        ListElement { iconId: 12; path: "qrc:/icons2/freezing.png" }
        ListElement { iconId: 13; path: "qrc:/icons2/hand.png" }
        ListElement { iconId: 14; path: "qrc:/icons2/happiness.png" }
        ListElement { iconId: 15; path: "qrc:/icons2/heart.png" }
        ListElement { iconId: 16; path: "qrc:/icons2/laugh.png" }
        ListElement { iconId: 17; path: "qrc:/icons2/love-song.png" }
        ListElement { iconId: 18; path: "qrc:/icons2/sticker.png" }
        ListElement { iconId: 19; path: "qrc:/icons2/stress.png" }
        ListElement { iconId: 20; path: "qrc:/icons2/suspicious.png" }
        ListElement { iconId: 21; path: "qrc:/icons2/thinking.png" }
        ListElement { iconId: 22; path: "qrc:/icons2/work-injury.png" }
    }


    GridView {
        id: grid
        anchors.fill: parent
        cellWidth: 38
        cellHeight: 38
        model: iconModel
        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Выбрана иконка ID:", model.iconId)
                    iconPicker.iconSelected(model.iconId, model.path)
                    iconPicker.close()
                }

                Image {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    source: model.path
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        // Добавим вертикальный скролл
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
        }

        clip: true
    }

}
