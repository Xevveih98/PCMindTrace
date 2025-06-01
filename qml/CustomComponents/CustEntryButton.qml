import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents

Item {
    id: papao
    width: parent.width
    height: headeroblo.height + 20

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
            color: "#090809"
            radius: 100
        }
        Overlay.modal: Rectangle {
            color: "#090809"
            opacity: 0.3
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
        color: "#262326"

        Item {
            id: headeroblo
            width: parent.width * 0.94
            height: 56
            anchors.top: parent.top
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
    }

    IconModelMod {
        id: iconModelMood
    }
}
