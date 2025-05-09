import QtQuick 2.15

Item {
    id: folderinfo
    width: componentWidth
    height: 50
    property string folderName: "Название папки"
    property int itemCount: 0
    property int componentWidth: folderinfo.width


    Rectangle {
        anchors.fill: parent
        color: "#292729"
        border.color: "#4D4D4D"
        border.width: 1

        Text {
            text: folderinfo.folderName
            font.pointSize: 22
            color: "#D9D9D9"
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: folderinfo.itemCount
            font.pointSize: 16
            color: "#B9B9B9"
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 30
        }

        Image {
            source: "qrc:/icons/delete.png"
            anchors.centerIn: parent
            anchors.right: parent.right
            anchors.rightMargin: 15
            width: 20
            height: 20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // обработка клика на удалить
                    console.log("Удалить папку")
                }
            }
        }

        Image {
            source: "qrc:/icons/edit.png"
            anchors.centerIn: parent
            anchors.right: parent.right
            anchors.rightMargin: 45
            width: 20
            height: 20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // обработка клика на изменить
                    console.log("Изменить папку")
                }
            }
        }
    }
}
