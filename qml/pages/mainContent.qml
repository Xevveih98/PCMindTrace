import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Item {
    id: mainAuthWindow
    width: parent.width * 0.94
    height: parent.height * 0.92
    anchors.centerIn: parent

    // Список пунктов меню
    ListModel {
        id: menuModel
        ListElement { title: "Главная страница"; page: "qrc:/pages/Home.qml" }
        ListElement { title: "Календарь"; page: "qrc:/pages/Calendar.qml" }
        ListElement { title: "Настройки"; page: "qrc:/pages/Settings.qml" }
    }

    Drawer {
        id: sideMenu
        width: parent.width * 0.4
        height: parent.height
        edge: Qt.LeftEdge
        interactive: true
        dragMargin: 300

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Label {
                text: "Меню"
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter
            }

            ListView {
                id: menuList
                model: menuModel
                delegate: ItemDelegate {
                    width: parent.width
                    text: model.title
                    onClicked: {
                        stackViewMainContent.push(model.page)
                        sideMenu.close()
                    }
                }
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    StackView {
        id: stackViewMainContent
        anchors.fill: parent
        replaceEnter: null
        replaceExit: null
        initialItem: "qrc:/pages/Settings.qml"
    }
}
