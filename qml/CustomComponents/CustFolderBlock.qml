import QtQuick 2.15
import QtQuick.Layouts

Item {
    id: folderinfo
    height: 50

    property string folderName: ""
    property int itemCount: 0

    signal deleteClicked()
    signal editClicked()

    Rectangle {
        id: gw3
        anchors.fill: folderinfo
        color: "#221F22"
        border.color: "#4D4D4D"
        border.width: 1
        radius: 8

        Item {
            id: convewq
            width: folderinfo.width * 0.9
            height: folderinfo.height * 0.8
            anchors.centerIn: gw3

            Text {
                id: foldernameitem
                text: folderinfo.folderName
                font.pointSize: 16
                color: "#D9D9D9"
                anchors.left: parent.left
            }

            Item{
                height: parent.height
                width: 56
                anchors.right: convewq.right
                anchors.leftMargin: parent.width * 0.5

                Row {
                    height: parent.height
                    width: parent.width
                    spacing: 12

                    Image {
                        source: "qrc:/images/delete.png"
                        fillMode: Image.PreserveAspectFit
                        width: 22
                        height: 22
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                deleteClicked()
                                console.log("Удалить папку")
                            }
                        }
                    }

                    Image {
                        source: "qrc:/images/settings.png"
                        fillMode: Image.PreserveAspectFit
                        width: 20
                        height: 20
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                editClicked()
                                console.log("Изменить папку")
                            }
                        }
                    }
                }

            }

            Item {
                width: parent.width * 0.3
                height: 20
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Row {
                    height: parent.height * 0.5
                    width: parent.width
                    spacing: 2

                    Text {
                        text: "Количество записей:"
                        font.pointSize: 11
                        color: "#686A71"
                    }

                    Text {
                        text: folderinfo.itemCount
                        font.pointSize: 11
                        color: "#686A71"
                    }
                }
            }
        }
    }
}
