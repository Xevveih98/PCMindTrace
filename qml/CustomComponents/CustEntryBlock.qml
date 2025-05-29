import QtQuick 2.15
import QtQuick.Controls
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
    property int entryId

    property var foldersList: []

    MouseArea {
        id: clickArea
        anchors.fill: parent
        onClicked: (mouse) => {
            deletePopup.x = mouse.x
            deletePopup.y = mouse.y
            deletePopup.open()
        }
        z: 100
    }

    Popup {
        id: deletePopup
        modal: true
        focus: true
        dim: true
        padding: 0
        width: 120
        height: 72
        background: Rectangle {
            color: "#262326"
            radius: 14
            border.color: "#4D4D4D"
            border.width: 1
        }
        Overlay.modal: Rectangle {
            color: "#181718"
            opacity: 0.3
        }

        onClosed: {
            console.log("deletePopup закрыт");
        }

        contentItem: Item {
            width: parent.width
            height: parent.height

            Column {
                anchors.fill: parent

                Button {
                    text: "Изменить"
                    font.pixelSize: 12
                    font.bold: false
                    background: null
                    height: 35
                    contentItem: Text {
                        text: qsTr("Изменить")
                        color: "#d9d9d9"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        console.log("Попытка создать компонент popEntryChanger.qml");

                        // Выводим parent для дебага
                        console.log("Parent объекта:", parent);
                        if (parent) {
                            console.log("Parent typeName:", parent.toString ? parent.toString() : typeof parent);
                            // Если parent — Item или Object с доступными свойствами, попробуем вывести их
                            if ("objectName" in parent)
                                console.log("Parent.objectName:", parent.objectName);
                            if ("id" in parent)
                                console.log("Parent.id:", parent.id);
                        } else {
                            console.log("Parent отсутствует (null или undefined)");
                        }

                        var component = Qt.createComponent("qrc:/popups/popEntryChanger.qml");
                        if (component.status === Component.Ready) {
                            console.log("Компонент успешно загружен.");

                            var popup = component.createObject(parent, {
                                entryId: papao.entryId,
                                entryTitle: papao.entryTitle,
                                entryContent: papao.entryContent,
                                entryDate: papao.entryDate,
                                entryTime: papao.entryTime,
                                entryMood: papao.entryMood,
                                tagItems: papao.tagItems,
                                activityItems: papao.activityItems,
                                emotionItems: papao.emotionItems,
                                foldersList: papao.foldersList
                            });
                            if (popup) {
                                console.log("Попап успешно создан.");
                                console.log("▶▶ Передаём в попап:");
                                console.log("   entryId:", papao.entryId);
                                console.log("   entryTitle:", papao.entryTitle);
                                console.log("   entryContent:", papao.entryContent);
                                console.log("   entryDate:", papao.entryDate);
                                console.log("   entryTime:", papao.entryTime);
                                console.log("   entryMood:", papao.entryMood);
                                console.log("   tagItems:", JSON.stringify(papao.tagItems));
                                console.log("   activityItems:", JSON.stringify(papao.activityItems));
                                console.log("   emotionItems:", JSON.stringify(papao.emotionItems));

                                popup.open();
                            } else {
                                console.error("Не удалось создать объект попапа.");
                            }
                        } else if (component.status === Component.Error) {
                            console.error("Ошибка при загрузке компонента: " + component.errorString());
                        } else {
                            console.log("Компонент еще не готов.");
                        }
                        deletePopup.close()
                    }
                }

                Rectangle {
                    width: parent.width * 0.87
                    height: 1
                    color: "#4D4D4D"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    text: "Удалить"
                    font.pixelSize: 12
                    font.bold: false
                    background: null
                    height: 35
                    contentItem: Text {
                        text: qsTr("Удалить")
                        color: "#d9d9d9"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        entriesUser.deleteUserEntry(entryId)
                        deletePopup.close()
                    }
                }
            }
        }
    }



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
