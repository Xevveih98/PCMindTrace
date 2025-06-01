import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents
import QtQuick.Layouts

Popup {
    property var selectedEmotions: []
    signal emotionsConfirmed(var selectedEmotions)

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
            text: "Добавить впечатления"
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
            text: "Впечатления помогают отразить <b><font color='#DA446A'>настроение</font></b> записи — выберите те, что лучше всего его передают. Чтобы <b><font color='#DA446A'>удалить</font></b> впечатление, просто нажмите на него."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: "#D9D9D9"
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"

                Text {
                    anchors.centerIn: parent
                    text: "Пользовательский список пуст.."
                    color: "#4d4d4d"
                    font.pixelSize: 11
                    font.italic: true
                    visible: emotionListModel.count === 0
                }
            }

            Item{
                width: parent.width * 0.97
                height: parent.height * 0.99
                anchors.centerIn: parent

                Flickable {
                    width: parent.width
                    height: parent.height
                    contentWidth: parent.width
                    contentHeight: flowContent.implicitHeight
                    clip: true

                    Flow {
                        id: flowContent
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: emotionListModel
                            delegate: CustEmotButn {
                                id: emoBtn
                                emotionText: model.emotion
                                iconPath: Utils.getIconPathById(iconModelEmotion, model.iconId)
                                buttonWidth: implicitWidth

                                selected: managerPopup.selectedEmotions.some(e => e.id === model.id)

                                onClicked: {
                                    let idx = managerPopup.selectedEmotions.findIndex(e => e.id === model.id)
                                    if (idx === -1) {
                                        managerPopup.selectedEmotions.push({
                                            id: model.id,
                                            emotion: model.emotion,
                                            iconId: model.iconId
                                        })
                                    } else {
                                        managerPopup.selectedEmotions.splice(idx, 1)
                                    }

                                    selected = !selected

                                    console.log("Обновленные selectedEmotions:")
                                    for (let i = 0; i < managerPopup.selectedEmotions.length; ++i) {
                                        console.log("id:", managerPopup.selectedEmotions[i].id,
                                                    "iconId:", managerPopup.selectedEmotions[i].iconId,
                                                    "emotion:", managerPopup.selectedEmotions[i].emotion)
                                    }
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
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignBottom

            Text {
                text: "Подтвердить"
                font.pixelSize: 18
                color: "#D9D9D9"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    emotionsConfirmed(managerPopup.selectedEmotions);
                    managerPopup.close()
                }
            }
        }
    }

    ListModel {
        id: emotionListModel
    }

    IconModelEmo {
        id: iconModelEmotion
    }


    function setEmotions(emotionArray) {
        emotionListModel.clear();
        selectedEmotions = [];
        for (let i = 0; i < emotionArray.length; ++i) {
            emotionListModel.append({
                id: emotionArray[i].id,
                emotion: emotionArray[i].emotion,
                iconId: emotionArray[i].iconId
            });
        }
    }

    function loadEmotionsFromServer(emotions) {
        console.log("Данные загружены:", emotions);
        setEmotions(emotions);
    }

    onOpened: {
        categoriesUser.loadEmotion();
    }

    Connections {
        target: categoriesUser
        onEmotionLoadedSuccess: function(emotions) {
            loadEmotionsFromServer(emotions);
        }
    }
}
