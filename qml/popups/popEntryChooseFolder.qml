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
    height: Screen.height * 0.4
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

    Item {
        width: parent.width * 0.91
        height: parent.height * 0.95
        anchors.centerIn: parent

        Column {
            width: parent.width
            anchors.top: parent.top
            spacing: 6

            Text {
                id: header
                text: "Выбор папки"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите папку для сохранения записи."
                color: "#D9D9D9"
                font.pixelSize: 15
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            ListModel {
                id: foldersListModel
            }

            Item {
                id: foldersView
                width: parent.width
                height: parent.height * 0.77

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.02
                    height: parent.height * 1.03
                    color: "#262326"
                    radius: 8
                }

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
    }

    Rectangle {
        id: buttAdmit
        color: "#474448"
        radius: 8
        width: parent.width
        height: 50
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

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
                let entryDateToSave = (mode === "edit" && entryDate) ? entryDate : Utils.formatTodayDate();

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
}
