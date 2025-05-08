import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: iconPicker
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
        ListElement { iconId: 1; path: "qrc:/icons/sleeping.png" }
        ListElement { iconId: 2; path: "qrc:/icons/bike.png" }
        ListElement { iconId: 3; path: "qrc:/icons/che.png" }
        ListElement { iconId: 4; path: "qrc:/icons/chess.png" }
        ListElement { iconId: 5; path: "qrc:/icons/communicat.png" }
        ListElement { iconId: 6; path: "qrc:/icons/communication.png" }
        ListElement { iconId: 7; path: "qrc:/icons/endurance.png" }
        ListElement { iconId: 8; path: "qrc:/icons/exercis.png" }
        ListElement { iconId: 9; path: "qrc:/icons/friends.png" }
        ListElement { iconId: 10; path: "qrc:/icons/game-control.png" }
        ListElement { iconId: 11; path: "qrc:/icons/game-controller.png" }
        ListElement { iconId: 12; path: "qrc:/icons/guitar.png" }
        ListElement { iconId: 13; path: "qrc:/icons/handshake.png" }
        ListElement { iconId: 14; path: "qrc:/icons/headphones.png" }
        ListElement { iconId: 15; path: "qrc:/icons/helmet.png" }
        ListElement { iconId: 16; path: "qrc:/icons/love-message.png" }
        ListElement { iconId: 17; path: "qrc:/icons/manwithlaptop.png" }
        ListElement { iconId: 18; path: "qrc:/icons/microphone.png" }
        ListElement { iconId: 19; path: "qrc:/icons/problem-statement.png" }
        ListElement { iconId: 20; path: "qrc:/icons/pull-up.png" }
        ListElement { iconId: 21; path: "qrc:/icons/relationship.png" }
        ListElement { iconId: 22; path: "qrc:/icons/relaxation.png" }
        ListElement { iconId: 23; path: "qrc:/icons/rest.png" }
        ListElement { iconId: 24; path: "qrc:/icons/running.png" }
        ListElement { iconId: 25; path: "qrc:/icons/shower.png" }
        ListElement { iconId: 26; path: "qrc:/icons/sleepin.png" }
        ListElement { iconId: 27; path: "qrc:/icons/strength-training.png" }
        ListElement { iconId: 28; path: "qrc:/icons/suitcase.png" }
        ListElement { iconId: 29; path: "qrc:/icons/task.png" }
        ListElement { iconId: 30; path: "qrc:/icons/tent.png" }
        ListElement { iconId: 31; path: "qrc:/icons/videogames.png" }
        ListElement { iconId: 32; path: "qrc:/icons/watching.png" }
        ListElement { iconId: 33; path: "qrc:/icons/working-hours.png" }
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
