import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0

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
        radius: 8
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        Text {
            text: "Управление папками"
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
            text: "Папки помогают <b><font color='#DA446A'>организовать</font></b> записи — добавляйте нужные, чтобы было проще находить их позже."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 12
            color: "#D9D9D9"
        }

        Item {
            Layout.preferredHeight: 50
            Layout.preferredWidth: parent.width*0.93
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                spacing: 7

                CustTxtFldEr {
                    id: catName
                    Layout.fillWidth: true
                    placeholderText: "Придумайте название новой папке"
                    maximumLength: 26
                    errorText: "* Ошибка"
                    errorVisible: false
                }

                Item {
                    width: 30
                    height: 30

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            let hasEmptyError = false;
                            hasEmptyError = Utils.validateEmptyField(catName) || hasEmptyError;
                            if (!hasEmptyError) {
                                foldersUser.saveFolder(catName.text.trim())
                                catName.text = ""
                            }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.height
                            height: parent.width
                            source: "qrc:/images/addbuttplus.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }

        Item {
            id: foldersView
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"
            }

            Item {
                id: mama
                width: parent.width *0.98
                height: parent.height * 0.98
                anchors.centerIn: parent

                ListView {
                    anchors.fill: parent
                    model: foldersListModel
                    spacing: 6
                    clip: true
                    delegate: CustFoldBlok {
                        width: ListView.view.width
                        folderName: model.foldername
                        itemCount: model.itemCount

                        Component.onCompleted: {
                            console.log("Загружен в менеджер папок делегат с папкой:", model.foldername, "и количеством элементов:", model.itemCount);
                        }

                        onDeleteClicked: {
                            console.log("Попытка создать компонент qrc:/popups/popFolderDeleteAdmit.qml");
                            var component = Qt.createComponent("qrc:/popups/popFolderDeleteAdmit.qml");
                            if (component.status === Component.Ready) {
                                console.log("Компонент успешно загружен.");
                                var popup = component.createObject(parent);
                                if (popup) {
                                    console.log("Попап успешно создан.");
                                    popup.folderName = model.foldername; // Передаем имя папки в попап
                                    popup.open(); // Открываем попап
                                } else {
                                    console.error("Не удалось создать объект попапа.");
                                }
                            } else if (component.status === Component.Error) {
                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                            } else {
                                console.log("Компонент еще не готов.");
                            }
                        }

                        onEditClicked: {
                            console.log("Попытка создать компонент popFolderChangeName.qml");
                            var component = Qt.createComponent("qrc:/popups/popFolderChangeName.qml");
                            if (component.status === Component.Ready) {
                                console.log("Компонент успешно загружен.");
                                var popup = component.createObject(parent);
                                if (popup) {
                                    console.log("Попап успешно создан.");
                                    popup.folderName = model.foldername; // Передаем имя папки в попап
                                    popup.open(); // Открываем попап
                                } else {
                                    console.error("Не удалось создать объект попапа.");
                                }
                            } else if (component.status === Component.Error) {
                                console.error("Ошибка при загрузке компонента: " + component.errorString());
                            } else {
                                console.log("Компонент еще не готов.");
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
            height: 40

            Text {
                text: "Подтвердить"
                font.pixelSize: 18
                color: "#D9D9D9"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    managerPopup.close()
                }
            }
        }
    }

    ListModel {
        id: foldersListModel
    }

    onOpened: {
        foldersListModel.clear();
        foldersUser.loadFolder()
    }

    Connections {
        target: foldersUser
        onFoldersLoadedSuccess: function(folders) {
            foldersListModel.clear();
            console.log("Данные загружены:", folders);
            for (let i = 0; i < folders.length; ++i) {
                foldersListModel.append({
                                            id: folders[i].id,
                                            foldername: folders[i].name,
                                            itemCount: folders[i].itemCount
                                        });
            }
        }
        onClearFolderList: {
            console.log("Папка успешно изменена. Перезагрузка папок...");
            foldersListModel.clear();  // Очищаем модель перед обновлением
        }
    }
}

