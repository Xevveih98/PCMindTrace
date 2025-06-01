import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import QtQuick.Layouts

Popup {
    id: exitPopup
    width: Screen.width * 0.93
    height: 140
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

    property string folderName: ""
    signal deleteClicked()

    Item {
        id: oberInputFieldsEmpty
        anchors.centerIn: parent
        width: parent.width * 0.86
        height: parent.height * 0.7

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Text {
                text: "Удаление папки"
                Layout.fillWidth: true
                color: "#D9D9D9"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                textFormat: Text.RichText
                text: "Вы уверены, что хотите <b><font color='#DA446A'>удалить папку</font></b>? Все записи, находящиеся в ней, <b><font color='#DA446A'>безвозвратно</font></b> исчезнут!"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: 14
                color: "#D9D9D9"
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
                foldersUser.deleteFolder(folderName);
                folderName = ""
                exitPopup.close();
            }
        }
    }
}
