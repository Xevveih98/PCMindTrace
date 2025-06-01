import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import QtQuick.Layouts
import CustomComponents

Popup {
    id: exitPopup
    width: Screen.width * 0.9
    height: 200
    modal: true
    padding: 0
    focus: true
    dim: true
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

    Item {
        id: oberInputFieldsEmpty
        anchors.centerIn: parent
        width: parent.width * 0.93
        height: parent.height * 0.9

        ColumnLayout {
            anchors.fill: parent

            Text {
                text: "Управление профилем"
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
                text: "Выберите <b><font color='#DA446A'>аватарку</font></b> и придумайте <b><font color='#DA446A'>новый</font></b> логин."
                Layout.preferredWidth: parent.width*0.93
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 14
                color: "#D9D9D9"
            }

            Item {
                Layout.preferredHeight: 80
                Layout.preferredWidth: parent.width*0.9
                Layout.alignment: Qt.AlignHCenter

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    CustTxtFldEr {
                        id: regLogin
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        placeholderText: "Придумайте новый логин"
                        maximumLength: 25
                        errorText: "* Ошибка"
                        errorVisible: false
                    }
                }
            }
        }
    }

    Rectangle {
        id: buttAuthCreateCheck
        color: "#474448"
        radius: 8
        width: parent.width
        height: 40
        anchors {
            top: parent.bottom
            topMargin: -10
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Подтвердить"
            font.pixelSize: 16
            color: "#D9D9D9"
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                let hasEmptyError = false;
                hasEmptyError = Utils.validateEmptyField(regLogin) || hasEmptyError;
                if (!hasEmptyError) {
                    authUser.changeLogin(regLogin.text);
                }
            }
        }
    }
}
