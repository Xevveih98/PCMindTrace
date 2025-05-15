import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents

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

    Item {
        anchors.fill: parent

        Item {
            width: parent.width * 0.9
            height: parent.height * 0.93
            anchors.centerIn: parent

            Text {
                id: header
                text: "Управление эмоциями"
                color: "#D9D9D9"
                font.pixelSize: 22
                font.bold: true
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: text1
                text: "Выберите иконку и дайте название вашей эмоции."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: header.bottom
                anchors.topMargin: 14
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                id: text2
                text: "Чтобы убрать эмоцию — нажмите на неё."
                color: "#D9D9D9"
                font.pixelSize: 15
                anchors.top: text1.bottom
                anchors.topMargin: 1
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignLeft
            }

            Row {
                id: rowcontent
                anchors.top: text2.bottom
                anchors.topMargin: 18
                height: 50
                spacing: 7

                Item {
                    id: iconSelector
                    width: height
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    property string selectedIconId: ""
                    property string selectedIconPath: "qrc:/icons/add.png"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Иконка нажата")
                            var component = Qt.createComponent("qrc:/popups/popIconPicker2.qml")
                            if (component.status === Component.Ready) {
                                var popup = component.createObject(parent, {
                                    x: parent.mapToItem(null, 0, 0).x - 34,
                                    y: parent.mapToItem(null, 0, 0).y - 240
                                })
                                if (popup) {
                                    popup.iconSelected.connect(function(iconId, iconPath) {
                                        iconSelector.selectedIconId = iconId
                                        iconSelector.selectedIconPath = iconPath
                                    })
                                    popup.open()
                                }
                            }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            source: iconSelector.selectedIconPath
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Item {
                    width: 200; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    TextField {
                        id: emotionNameInput
                        anchors.fill: parent
                        font.pixelSize: 12
                        color: "#D9D9D9"
                        placeholderText: "Название эмоции"
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
                    width: height; height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {

                        property string emotionName: emotionNameInput.text
                        property string selectedIconId: iconSelector.selectedIconId
                        property string selectedIconPath: iconSelector.selectedIconPath

                        anchors.fill: parent
                        onClicked: {
                            console.log("Сохраняется эмоция с иконкой:", selectedIconId, "и названием:", emotionName)

                            if (emotionName.trim() === "" || selectedIconId === "") {
                                console.log("Название эмоции или иконка не выбраны");
                                return;
                            }

                            for (let i = 0; i < emotionListModel.count; i++) {
                                if (emotionListModel.get(i).emotion === emotionName) {
                                    console.log("Эта эмоция уже существует");
                                    return;
                                }
                            }

                            categoriesUser.saveEmotion(selectedIconId, emotionName)
                            iconSelector.selectedIconId = "";
                            iconSelector.selectedIconPath = "qrc:/icons/add.png";
                            emotionNameInput.text = "";
                        }

                        Image {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            source: "qrc:/images/addbuttplus.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            ListModel {
                id: emotionListModel
            }

            Item {
                anchors.top: rowcontent.bottom
                anchors.topMargin: 15
                width: parent.width
                height: parent.height * 0.5

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 1.02
                    height: parent.height * 1.03
                    color: "#262326"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "Добавьте новые эмоции"
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: emotionListModel.count === 0
                    }
                }

                ScrollView {
                    id: emoscr
                    width: parent.width
                    height: parent.height
                    z: 1

                    Flow {
                        width: emoscr.width
                        spacing: 6

                        Repeater {
                            model: emotionListModel
                            delegate: CustEmotButn {
                                emotionText: model.emotion
                                iconPath: Utils.getIconPathById(iconModelEmotion, model.iconId)
                                buttonWidth: implicitWidth
                                buttonHeight: 43
                                onClicked: {
                                    categoriesUser.deleteEmotion(model.emotion);
                                    emotionListModel.remove(index);
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
                    managerPopup.close()
                }
            }
        }
    }

    onOpened: {
        categoriesUser.loadEmotion()
    }

    Connections {
        target: categoriesUser

        onEmotionSavedSuccess: {
            categoriesUser.loadEmotion();
        }

        onEmotionLoadedSuccess: function(emotions) {
            emotionListModel.clear();
            for (let i = 0; i < emotions.length; ++i) {
                emotionListModel.append({
                    emotion: emotions[i].emotion,
                    iconId: emotions[i].iconId
                });
            }
        }
    }

    IconModelEmo {
        id: iconModelEmotion
    }

    function getIconPathById(iconId) {
        for (let i = 0; i < iconModel.count; ++i) {
            if (iconModel.get(i).iconId === iconId) {
                return iconModel.get(i).path;
            }
        }
        return "qrc:/icons/add.png";
    }
}
