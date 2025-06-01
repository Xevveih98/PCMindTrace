import QtQuick 2.15
import QtQuick.Controls 2.15
import CustomComponents

Popup {
    id: iconPicker
    signal iconSelected(string iconId, string iconPath)
    width: 260
    height: 164
    modal: true
    focus: true
    padding: 8
    Overlay.modal: Rectangle {
        color: "#181718"
        opacity: 0.9
    }
    background: Rectangle {
        color: "#292729"
        radius: 8
    }

    IconModelAct {
        id: iconModelActivity
    }

    GridView {
        id: grid
        anchors.fill: parent
        cellWidth: 38
        cellHeight: 38
        model: iconModelActivity
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
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
        }

        clip: true
    }
}
