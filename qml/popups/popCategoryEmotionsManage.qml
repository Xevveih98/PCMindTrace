import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents 1.0
import QtQuick.Layouts

Popup {
    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.8
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
    onOpened: {
        categoriesUser.loadEmotion()
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        Text {
            text: "Управление впечатлениями"
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
            text: "Выберите <b><font color='#DA446A'>иконку</font></b> и дайте <b><font color='#DA446A'>название</font></b> впечатлению. Чтобы <b><font color='#DA446A'>убрать</font></b> впечатление - намите на него."
            Layout.preferredWidth: parent.width*0.93
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: "#D9D9D9"
        }

        Item {
            Layout.preferredHeight: 50
            Layout.preferredWidth: parent.width*0.93
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                spacing: 7

                Item {
                    id: iconSelector
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    property string selectedIconId: ""
                    property string selectedIconPath: "qrc:/icons/add.png"

                    Image {
                        anchors.centerIn: parent
                        width: 30
                        height: 30
                        source: iconSelector.selectedIconPath
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var component = Qt.createComponent("qrc:/popups/popIconPicker2.qml")
                            if (component.status === Component.Ready) {
                                var popup = component.createObject(parent, {
                                                                       x: iconSelector.mapToItem(null, 0, 0).x - 34,
                                                                       y: iconSelector.mapToItem(null, 0, 0).y - 135
                                                                   })
                                if (popup) {
                                    popup.iconSelected.connect(function(iconId, iconPath) {
                                        console.log("Получена иконка ID:", iconId)
                                        iconSelector.selectedIconId = iconId
                                        iconSelector.selectedIconPath = iconPath
                                    })
                                    popup.open()
                                } else {
                                    console.error("Не удалось создать объект popup")
                                }
                            } else {
                                console.error("Ошибка загрузки компонента:", component.errorString())
                            }
                        }
                    }
                }

                CustTxtFldEr {
                    id: catName
                    Layout.fillWidth: true
                    placeholderText: "Дайте название впечатлению"
                    maximumLength: 34
                    errorText: "* Ошибка"
                    errorVisible: false
                }

                Item {
                    width: 30
                    height: 30

                    MouseArea {
                        property string emotionName: catName.text
                        property string selectedIconId: iconSelector.selectedIconId
                        property string selectedIconPath: iconSelector.selectedIconPath
                        anchors.fill: parent
                        onClicked: {
                            console.log("Сохраняется активность с иконкой:", selectedIconId, "и названием:", emotionName)

                            if (emotionName.trim() === "" || selectedIconId === "") {
                                catName.errorVisible = true
                                VibrationUtils.vibrate(200)
                                catName.errorText = "* Название активности или иконка не выбраны";
                                return;
                            }
                            for (let i = 0; i < emotionListModel.count; i++) {
                                if (emotionListModel.get(i).emotion === emotionName) {
                                    catName.errorVisible = true
                                    VibrationUtils.vibrate(200)
                                    catName.errorText = "* Эта активность уже существует";
                                    return;
                                }
                            }
                            categoriesUser.saveEmotion(selectedIconId, emotionName)
                            iconSelector.selectedIconId = "";
                            iconSelector.selectedIconPath = "qrc:/icons/add.png";
                            catName.text = "";
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
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"


                Text {
                    anchors.centerIn: parent
                    text: "Добавьте новые впечатления.."
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
                            delegate: CustActvButn {
                                activityText: model.emotion
                                iconPath: Utils.getIconPathById(iconModelEmotion, model.iconId)
                                buttonWidth: implicitWidth
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
                    managerPopup.close()
                }
            }
        }
    }

    IconModelEmo {
        id: iconModelEmotion
    }
    ListModel {
        id: emotionListModel
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
}
