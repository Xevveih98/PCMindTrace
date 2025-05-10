import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0
import "../CustomComponents"

Popup {
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
        radius: 10
        border.color: "#474448"
        border.width: 1
    }

    Column {
        width: parent.width * 0.91
        anchors.centerIn: parent
        spacing: 6

        Text {
            id: header
            text: "Управление папками"
            color: "#D9D9D9"
            font.pixelSize: 22
            font.bold: true
            wrapMode: Text.Wrap
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: text1
            text: "Добавьте новую папку или удалите старую"
            color: "#D9D9D9"
            font.pixelSize: 15
            wrapMode: Text.Wrap
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: textfieldinputrow
            height: 40
            width: parent.width

            RowLayout {
                spacing: 16
                height: 30
                anchors.centerIn: parent

                Item {
                    width: textfieldinputrow.width * 0.68
                    height: parent.height
                    Layout.alignment: Qt.AlignHCenter

                    TextField {
                        id: folderNameInput
                        anchors.fill: parent
                        font.pixelSize: 12
                        color: "#D9D9D9"
                        placeholderText: "Название папки"
                        placeholderTextColor: "#a9a9a9"
                        wrapMode: Text.NoWrap
                        maximumLength: 30
                        padding: 10
                        horizontalAlignment: TextInput.AlignLeft
                        verticalAlignment: TextInput.AlignVCenter
                        background: Rectangle {
                            color: "#292729"
                            border.color: "#4D4D4D"
                            border.width: 1
                            radius: 6
                        }
                    }
                }

                Item {
                    width: height
                    height: parent.height
                    Layout.alignment: Qt.AlignCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const name = folderNameInput.text.trim()
                            if (name.length > 0) {
                                foldersUser.saveFolder(name) // Сохраняем папку
                                folderNameInput.text = "" // Очищаем поле
                            }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                            source: "qrc:/images/addbuttplus.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }

        ListModel {
            id: foldersListModel
        }

        Item {
            id: foldersView
            width: parent.width
            height: parent.height * 0.77

            ListView {
                anchors.fill: parent
                model: foldersListModel
                spacing: 6
                clip: true


                delegate: CustFoldBlok {
                    width: ListView.view.width
                    folderName: model.name
                    itemCount: model.itemCount

                    Component.onCompleted: {
                        console.log("Загружен делегат с папкой:", model.name, "и количеством элементов:", model.itemCount);
                    }

                    onDeleteClicked: {
                        console.log("Удалить папку:", model.name);
                        foldersUser.deleteFolder(name); // Удаляем папку
                    }

                    onEditClicked: {
                        console.log("Изменить папку:", model.name);
                    }
                }
            }
        }
    }

    onOpened: {
        foldersUser.loadFolder() // Загружаем папки при открытии попапа
    }

    Connections {
        target: foldersUser    
        onFoldersLoadedSuccess: function(folders) {
            console.log("Данные загружены:", folders);
            foldersListModel.clear();
            for (let i = 0; i < folders.length; ++i) {
                foldersListModel.append({
                    name: folders[i].name,
                    itemCount: folders[i].itemCount
                });
                console.log("Данные загружены:", folders);
            }
        }

        onFolderSavedSuccess: {
            console.log("Папка успешно сохранена. Перезагрузка папок...");
            foldersUser.loadFolder(); // После сохранения перезагружаем папки
        }

        onFolderDeletedSuccess: {
            console.log("Папка успешно удалена. Перезагрузка папок...");
            foldersUser.loadFolder(); // После удаления перезагружаем папки
        }
    }
}
