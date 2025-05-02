import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0

Rectangle {
    id: pageHomeScreen
    color: "transparent"

    ScrollView {
        anchors.fill: parent

        Column {
            id: colDad
            spacing: 12
            width: parent.width

            Item {
                width: parent.width
                height: pageHomeScreen.height * 0.064

                Rectangle {
                    id: recFolders
                    color: "#090809"
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#363636"
                    radius: 8
                    anchors.margins: 4

                    Row {
                        id: rowFoldersContent
                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        // Кнопка для добавления новой папки
                        Rectangle {
                            id: buttAddFolder
                            color: "#181718"
                            width: recFolders.height * 0.8
                            height: recFolders.height * 0.8

                            MouseArea {
                                anchors.fill: buttAddFolder
                                onClicked: {
                                    //onClicked: {stackViewFormManager.replace("ManageFolders.qml"); stackViewFormManager.visible = true; stackViewFormManager.enabled = true}
                                    //console.log("Добавить новую папку");

                                    AuthViewModel.logout()
                                    AppViewModelBackend.switchToAuth()

                                }
                            }
                        }

                        // Первая папка "home"
                        Rectangle {
                            id: homeFolder
                            height: recFolders.height * 0.7
                            color: "#181718"
                            radius: 10
                            // ширина зависит от текста
                            width: textHome.contentWidth + 20

                            Text {
                                id: textHome
                                text: "home"
                                color: "#d9d9d9"
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            id: gymFolder
                            height: recFolders.height * 0.7
                            color: "#181718"
                            radius: 10
                            // ширина зависит от текста
                            width: textGym.contentWidth + 20

                            Text {
                                id: textGym
                                text: "gym trainings"
                                color: "#d9d9d9"
                                anchors.centerIn: parent
                            }
                        }

                    }
                }
            }

            Item {
                width: parent.width
                height: pageHomeScreen.height * 0.3

                Rectangle {
                    color: "#2D292C"
                    anchors.fill: parent
                    radius: 10
                    anchors.margins: 10

                    // Текст по центру
                    Text {
                        text: "Задачи на сегодня"
                        font.pixelSize: 16
                        color: "#D9D9D9"
                        anchors.horizontalCenter: parent.horizontalCenter  // Центрируем текст по всему прямоугольнику
                        anchors.top: parent.top  // Отступ слева
                        anchors.topMargin: 10  // Отступ справа
                    }

                    // Кнопка привязана к правому краю
                    Rectangle {
                        id: buttAddToDo
                        color: "#181718"
                        width: parent.height * 0.16 // или можно заменить на фиксированную ширину
                        height: parent.height * 0.16
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.top: parent.top  // Отступ слева
                        anchors.topMargin: 5// Отступ от правого края

                        MouseArea {
                            anchors.fill: buttAddToDo
                            onClicked: {
                                // Здесь будет появляться окно добавления новой задачи
                                console.log("Добавить новую задачу");
                                stackViewFormManager.replace("ManageToDoos.qml");
                                stackViewFormManager.visible = true;
                                stackViewFormManager.enabled = true;
                            }
                        }
                    }

                    Item {
                        anchors.top: buttAddToDo.bottom
                        anchors.topMargin: 4
                        width: parent.width * 0.92
                        height: parent.height * 0.3
                        anchors.horizontalCenter: parent.horizontalCenter

                        Column {
                            width: parent.width
                            spacing: 4
                            anchors.horizontalCenter: parent.horizontalCenter

                            // CustomCheckbox {
                            //     width: parent.width
                            //     anchors.horizontalCenter: parent.horizontalCenter
                            //     labelText: "убраться дома"

                            // }
                            // CustomCheckbox {
                            //     width: parent.width
                            //     anchors.horizontalCenter: parent.horizontalCenter
                            //     labelText: "постирать одежду"
                            // }

                            // CustomCheckbox {
                            //     width: parent.width
                            //     anchors.horizontalCenter: parent.horizontalCenter
                            //     labelText: "зайти в цветочный"
                            // }
                        }
                    }
                }
            }

            Item {
                width: parent.width * 0.88
                height: pageHomeScreen.height * 0.14
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    color: "#2D292C"
                    anchors.fill: parent
                    radius: 22

                    Column {
                        width: parent.width
                        spacing: 8
                        anchors.horizontalCenter: parent.horizontalCenter

                        Item {
                            width: parent.width
                            height: 50
                            Text {
                                text: "Как ваше настроение?"
                                font.pixelSize: 18
                                color: "#D9D9D9"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Item {
                            width: parent.width
                            height: 50

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 11

                                Item {
                                    width: 50
                                    height: 50

                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/images/happy.png"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Настроение: счастье")}
                                    }
                                }

                                Item {
                                    width: 50
                                    height: 50

                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/images/calm.png"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Настроение: спокойствие")}
                                    }
                                }

                                Item {
                                    width: 50
                                    height: 50

                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/images/confused.png"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Настроение: неопределенность")}
                                    }
                                }

                                Item {
                                    width: 50
                                    height: 50

                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/images/tear.png"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Настроение: печаль")}
                                    }
                                }

                                Item {
                                    width: 50
                                    height: 50

                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:/images/upset.png"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("Настроение: глубокая грусть")}
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: pageHomeScreen.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 16

                    // Кнопка "влево"
                    MouseArea {
                        id: leftArrow
                        width: 32
                        height: 32
                        onClicked: {
                            console.log("Откат на месяц назад")
                            // здесь можно уменьшить месяц
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "<"
                            font.bold: true
                            font.pixelSize: 24
                            color: "#b9b9b9"
                        }
                    }

                    // Название месяца
                    Text {
                        id: monthName
                        text: "Апрель"
                        font.pixelSize: 20
                        color: "#d9d9d9"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Кнопка "вправо"
                    MouseArea {
                        id: rightArrow
                        width: 32
                        height: 32
                        onClicked: {
                            console.log("Перекат на месяц вперед")
                            // здесь можно увеличить месяц
                        }

                        Text {
                            anchors.centerIn: parent
                            text: ">"
                            font.bold: true
                            font.pixelSize: 24
                            color: "#b9b9b9"
                        }
                    }
                }
            }

            // Text {
            //     text: "Записей пока что нет..."
            //     font.pixelSize: 16
            //     color: "#D9D9D9"
            //     anchors.horizontalCenter: parent.horizontalCenter
            // }

            Item {
                id: note
                width: parent.width
                height: childrenRect.height  // Автоматическая высота по содержимому

                Rectangle {
                    id: backgroundShadow
                    color: "#9BAA41"
                    width: parent.width * 0.96
                    height: 36  // Высота контента + отступы
                    anchors.top: parent.top
                    anchors.topMargin: -10
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 18
                    z: 1
                }

                Rectangle {
                    id: contentWrapper
                    color: "#2D292C"
                    width: parent.width
                    height: childrenRect.height + 40  // Высота контента + отступы
                    anchors.top: parent.top
                    radius: 18
                    z: 2

                    Item {
                        width: parent.width * 0.88
                        height: childrenRect.height + 20
                        anchors.centerIn: parent

                        Row {
                            spacing: 10
                            width: parent.width

                            // Иконка
                            Item {
                                width: 50
                                height: width  // Высота как у текстового блока или 50
                                //anchors.verticalCenter: parent.verticalCenter

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/images/calm.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            // Текстовый блок
                            Column {
                                id: textContent
                                width: parent.width - 70  // Ширина родителя минус иконка и отступы
                                spacing: 10

                                // Заголовок с датой и временем
                                RowLayout {
                                    width: parent.width
                                    height: 30

                                    Text {
                                        text: "14 апреля 2025"
                                        font.pixelSize: 11
                                        color: "#D9D9D9"
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Item { Layout.fillWidth: true }

                                    Text {
                                        text: "18:32"
                                        font.pixelSize: 12
                                        color: "#b9b9b9"
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }

                                // Основной текст
                                Text {
                                    width: parent.width
                                    text: "Сегодня было спокойно"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#D9D9D9"
                                    wrapMode: Text.Wrap
                                }

                                // Описание
                                Text {
                                    width: parent.width
                                    id: textDescription
                                    text: "Вот бы всегда было спокойно."
                                    font.pixelSize: 16
                                    color: "#D9D9D9"
                                    wrapMode: Text.Wrap
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    StackView {
        id: stackViewFormManager
        visible: false
        enabled: false
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        replaceEnter: null
        replaceExit: null
        background: Rectangle{
            color: "#141414"
            opacity: 0.8
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stackViewFormManager.visible = false;
                }
            }
        }
    }
}
