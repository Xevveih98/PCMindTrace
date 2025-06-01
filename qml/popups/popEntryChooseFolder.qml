import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents

Popup {
    property string entryHeaderText
    property string entryContentText
    property int selectedMoodId
    property var selectedTags
    property string entryDateCreate
    property var selectedActivities
    property var selectedEmotions
    property var parentPopup
    property int selectedFolderId: -1
    property int entryId
    property var entryDate
    property string mode
    property var foldersList: []

    id: managerFolderPopup
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
            text: "Выбор папки"
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
            text: "Выберите папку, в которой будет <b><font color='#DA446A'>сохранена</font></b> запись."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 12
            color: "#D9D9D9"
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
                    id: lio
                    anchors.fill: parent
                    model: foldersListModel
                    spacing: 6
                    clip: true
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 150
                    delegate: CustFoldVart {
                        width: ListView.view.width
                        height: 40
                        folderName: model.foldername
                        isSelected: ListView.isCurrentItem
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                lio.currentIndex = index
                                managerFolderPopup.selectedFolderId = model.id
                                console.log("Selected folder ID:", model.id)
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
                    console.log("Selected folder ID:", managerFolderPopup.selectedFolderId)
                    let entryDateToSave = (mode === "edit" && entryDate) ? entryDate : entryDateCreate;

                    let entryData = {
                        title: entryHeaderText,
                        content: entryContentText,
                        date: entryDateToSave,
                        moodId: selectedMoodId,
                        tags: selectedTags,
                        activities: selectedActivities,
                        emotions: selectedEmotions,
                        folder: managerFolderPopup.selectedFolderId,
                        id: entryId
                    }

                    console.log("Режим:", mode)
                    console.log("Отправка записи:", JSON.stringify(entryData, null, 2))

                    if (mode === "edit") {
                        entriesUser.updateEntryFromQml(entryData)
                    } else {
                        entriesUser.saveEntryFromQml(entryData)
                    }

                    managerFolderPopup.close()

                    if (parentPopup) {
                        parentPopup.close()
                    }
                    managerPopup.close()
                }
            }
        }
    }

    onOpened: {
        foldersListModel.clear()
        for (let i = 0; i < foldersList.length; ++i) {
            foldersListModel.append({
                                        id: foldersList[i].id,
                                        foldername: foldersList[i].name,
                                    })
        }
        if (foldersList.length > 0) {
            lio.currentIndex = 0;
            managerFolderPopup.selectedFolderId = foldersList[0].id;
            console.log("Установлена папка по умолчанию:", foldersList[0].id);
        }
    }

    ListModel {
        id: foldersListModel
    }
}





