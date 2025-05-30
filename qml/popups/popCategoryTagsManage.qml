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
        categoriesUser.loadTags()
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.preferredHeight: 10
            Layout.fillWidth: true
        }

        Text {
            text: "Управление тегами"
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
            text: "Теги помогают <b><font color='#DA446A'>быстро</font></b> находить записи — добавляйте как можно больше релевантных. Чтобы <b><font color='#DA446A'>убрать</font></b> тег, просто нажмите на него."
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

                CustTxtFldEr {
                    id: catName
                    Layout.fillWidth: true
                    placeholderText: "Дайте название тегу"
                    maximumLength: 34
                    errorText: "* Ошибка"
                    errorVisible: false
                    property string previousText: ""
                    onTextChanged: {
                        if (text !== previousText) {
                            let newText = text.replace(/\s+/g, "_");
                            previousText = newText;
                            text = newText;
                        }
                    }
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
                                categoriesUser.saveTag(catName.text.trim())
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
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#262326"

                Text {
                    anchors.centerIn: parent
                    text: "Добавьте новые теги.."
                    color: "#4d4d4d"
                    font.pixelSize: 11
                    font.italic: true
                    visible: tagListModel.count === 0
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
                            model: tagListModel
                            delegate: CustTagButon {
                                tagText: model.tag
                                buttonWidth: implicitWidth
                                onClicked: {
                                    categoriesUser.deleteTag(model.tag);
                                    tagListModel.remove(index);
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

    ListModel {
        id: tagListModel
    }

    Connections {
        target: categoriesUser
        onTagsSavedSuccess: {
            categoriesUser.loadTags()
            catName.text = ""
        }
        onTagsLoaded: function(tags) {
            tagListModel.clear();
            for (var i = 0; i < tags.length; ++i) {
                tagListModel.append({
                                        id: tags[i].id,
                                        tag: tags[i].tag
                                    });
            }
        }
        onTagsSavedFailed:function(message) {
            catName.errorText = message
            catName.errorVisible = true
            catName.triggerErrorAnimation()
            VibrationUtils.vibrate(200)
            console.log("СООБЩЕНИЕ", message)
        }
    }
}
