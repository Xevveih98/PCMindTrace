import QtQuick 2.15
import QtQuick.Controls 2.15
import PCMindTrace 1.0
import CustomComponents
import QtQuick.Layouts

Popup {
    id: exitPopup
    width: Screen.width * 0.93
    height: 120
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
        border.color: "#474448"
        border.width: 1
    }

    property string folderName: ""

    Item {
        id: oberInputFieldsEmpty
        anchors.centerIn: parent
        width: parent.width * 0.86
        height: parent.height * 0.86

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Text {
                text: "Изменение папки"
                Layout.fillWidth: true
                color: "#D9D9D9"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            CustTxtFldEr {
                id: catName
                Layout.fillWidth: true
                placeholderText: "Придумайте новое название папки"
                maximumLength: 26
                errorText: "* Ошибка"
                errorVisible: false
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
                hasEmptyError = Utils.validateEmptyField(catName) || hasEmptyError;
                if (!hasEmptyError) {
                    foldersUser.changeFolder(catName.text, folderName);
                    exitPopup.close();
                }
            }
        }
    }
}


// Popup {


//     id: exitPopup
//     width: Screen.width * 0.9
//     height: Screen.height * 0.16
//     modal: true
//     padding: 0
//     focus: true
//     dim: true
//     closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
//     anchors.centerIn: Overlay.overlay
//     Overlay.modal: Rectangle {
//         color: "#181718"
//         opacity: 0.9
//     }
//     background: Rectangle {
//         color: "#2D292C"
//         radius: 10
//         border.color: "#474448"
//         border.width: 1
//     }

//     Column {
//         id: columnpop
//         spacing: 4
//         anchors {
//             top: parent.top
//             horizontalCenter: parent.horizontalCenter
//             topMargin: 20
//         }
//         width: parent.width * 0.85

//         Text {
//             text: "Введите новое имя вашей папки"
//             font.pixelSize: 12
//             color: "#D9D9D9"
//         }

//         TextField {
//             id: folderNewName
//             height: 30
//             font.pixelSize: 11
//             color: "#D9D9D9"
//             placeholderText: ""
//             maximumLength: 120
//             wrapMode: Text.NoWrap
//             horizontalAlignment: TextInput.AlignLeft
//             verticalAlignment: TextInput.AlignVCenter
//             background: Rectangle {
//                 color: "#292729"
//                 border.color: "#4D4D4D"
//                 border.width: 1
//             }
//             anchors.left: parent.left
//             anchors.right: parent.right
//         }
//     }

//     Rectangle {
//         id: buttAuthCreateCheck
//         color: "#474448"
//         radius: 8
//         width: parent.width
//         height: 40
//         anchors {
//             top: parent.bottom
//             topMargin: -10
//             horizontalCenter: parent.horizontalCenter
//         }

//         Text {
//             text: "Подтвердить"
//             font.pixelSize: 16
//             color: "#D9D9D9"
//             anchors.centerIn: parent
//         }

//         MouseArea {
//             anchors.fill: parent
//             onClicked: {

//             }
//         }
//     }
// }
