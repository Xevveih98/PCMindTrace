import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Item {
    id: mainAuthWindow
    width: parent.width * 0.94
    height: parent.height * 0.92
    anchors.centerIn: parent
    property int menuListCurrentIndex: 0

    ListModel {
        id: menuModel
        ListElement { title: "Главная страница"; page: "qrc:/pages/Home.qml"; icon: "qrc:/images/homemenu.png" }
        ListElement { title: "Поиск"; page: "qrc:/pages/Research.qml"; icon: "qrc:/images/searchmenu.png" }
        ListElement { title: "Календарь"; page: "qrc:/pages/Calendar.qml"; icon: "qrc:/images/calendarmenu.png" }
        ListElement { title: "Настройки"; page: "qrc:/pages/Settings.qml"; icon: "qrc:/images/settingsmenu.png" }
    }

    Drawer {
        id: sideMenu
        width: parent.width * 0.68
        height: parent.height
        edge: Qt.LeftEdge
        interactive: true
        dim: true
        focus: true
        modal: true
        padding: 0
        dragMargin: 150
        Overlay.modal: Rectangle {
            visible: true
            color: "#181718"
            opacity: 0.05
        }
        background: Rectangle {
            color: "#2D292C"
            radius: 16
        }

        Item {
            id: namela
            width: parent.width
            height: 20

            Label {
                text: "Меню"
                font.pixelSize: 20
                color: "#d9d9d9"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Item {
            anchors.top: namela.bottom
            anchors.topMargin: 20
            width: parent.width
            height: parent.height * 0.7

            ColumnLayout {
                width: parent.width
                height: parent.height * 0.6
                spacing: 20

                CustMenuProf {
                    z: 2
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    Layout.maximumHeight: 100
                    buttonText: "Открыть профиль"
                    avatarSource: "qrc:/images/ecalm.png"
                    userName: "Эльвира Тимощенко"
                    userEmail: "elvira@example.com"
                    onClicked: {
                        console.log("Кнопка нажата!")
                    }
                }

                ColumnLayout {
                    id: menuButtons
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150

                    Repeater {
                        model: menuModel

                        Item {
                            Layout.fillWidth: true
                            Layout.leftMargin: 15
                            height: 32

                            property bool isSelected: index === menuListCurrentIndex

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    stackViewMainContent.replace(model.page)
                                    sideMenu.close()
                                    menuListCurrentIndex = index
                                }

                                Row {
                                    width: parent.width
                                    spacing: 15

                                    Image {
                                        source: model.icon
                                        width: 20
                                        height: 20
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    Text {
                                        text: model.title
                                        verticalAlignment: Text.AlignVCenter
                                        color: isSelected ? "#6EADE9" : "#d9d9d9"
                                        font.pixelSize: 16
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    StackView {
        id: stackViewMainContent
        anchors.fill: parent
        initialItem: "qrc:/pages/Calendar.qml"
    }
}
