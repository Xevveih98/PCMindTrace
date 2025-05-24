import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Rectangle {
    id: pageCalendarScreen
    color: "#181718"

    CustPageHead {
        id: header
        headerWidth: parent.width
        titleText: "Календарь"
    }

    Item {
        id: itemcore
        width: parent.width * 0.93
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom

        Flickable {
            property bool refreshing: false
            id: flickable
            anchors.fill: parent
            contentHeight: eda.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: eda
                width: parent.width
                spacing: 12

                Item {
                    id: monthSwitchButton
                    width: contro.implicitWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 50

                    property var monthsNom: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
                    property int selectedYear: new Date().getFullYear()
                    property int selectedMonth: new Date().getMonth() + 1
                    property var today: new Date()

                    Row {
                        id: contro
                        height: 30
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width

                        // Левая стрелка
                        Item {
                            id: leftArrowItem
                            width: 40
                            height: parent.height

                            Image {
                                width: 30
                                height: 30
                                anchors.centerIn: parent
                                source: "qrc:/images/left-arrow.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (monthSwitchButton.selectedMonth === 1) {
                                        monthSwitchButton.selectedMonth = 12;
                                        monthSwitchButton.selectedYear--;
                                    } else {
                                        monthSwitchButton.selectedMonth--;
                                    }
                                    monthSwitchButton.updateDisplay();
                                }
                            }
                        }

                        Item {
                            width: 150
                            height: parent.height

                            Text {
                                id: monthYearText
                                color: "#d9d9d9"
                                text: ""
                                font.pixelSize: 17
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Item {
                            id: rightArrowItem
                            width: 40
                            height: parent.height

                            Image {
                                id: rightArrowImage
                                width: 30
                                height: 30
                                anchors.centerIn: parent
                                source: "qrc:/images/right-arrow(2).png"
                                fillMode: Image.PreserveAspectFit
                                opacity: rightArrowArea.enabled ? 1.0 : 0.4
                            }

                            MouseArea {
                                id: rightArrowArea
                                anchors.fill: parent
                                enabled: !(monthSwitchButton.selectedYear === monthSwitchButton.today.getFullYear() &&
                                           monthSwitchButton.selectedMonth === (monthSwitchButton.today.getMonth() + 1))
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                                onClicked: {
                                    if (!enabled)
                                        return;

                                    if (monthSwitchButton.selectedMonth === 12) {
                                        monthSwitchButton.selectedMonth = 1;
                                        monthSwitchButton.selectedYear++;
                                    } else {
                                        monthSwitchButton.selectedMonth++;
                                    }
                                    monthSwitchButton.updateDisplay();
                                }
                            }
                        }
                    }

                    function updateDisplay() {
                        var monthName = monthsNom[selectedMonth - 1];
                        monthYearText.text = monthName + " " + selectedYear;
                        rightArrowArea.enabled = !(selectedYear === today.getFullYear() && selectedMonth === (today.getMonth() + 1));
                        rightArrowImage.opacity = rightArrowArea.enabled ? 1.0 : 0.25;
                        rightArrowArea.cursorShape = rightArrowArea.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor;
                    }

                    Component.onCompleted: updateDisplay()
                }

                Item {
                    id: papcaledar
                    width: parent.width
                    height: 270
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        color: "#2D292C"
                        radius: 8
                        anchors.fill: parent

                        Item {
                            width: parent.width * 0.9
                            height: parent.height * 0.9
                            anchors.centerIn: parent

                            ColumnLayout {
                                width: parent.width
                                height: parent.height

                                DayOfWeekRow {
                                    locale: Qt.locale("ru_RU")
                                    spacing: 8

                                    delegate: Text {
                                        text: shortName.toUpperCase()
                                        color: "#d9d9d9"
                                        font.pixelSize: 12
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        required property string shortName
                                    }
                                    Layout.fillWidth: true
                                }

                                MonthGrid {
                                    id: monthGrid
                                    month: monthSwitchButton.selectedMonth - 1
                                    year: monthSwitchButton.selectedYear
                                    locale: Qt.locale("ru_RU")

                                    delegate: Item {
                                            width: 40
                                            height: 40

                                            Text {
                                                anchors.centerIn: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                opacity: model.month === monthGrid.month ? 1 : 0.2
                                                text: monthGrid.locale.toString(model.date, "d")
                                                color: "#d9d9d9"
                                                font.pixelSize: 12
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    let selectedDate = Qt.formatDate(model.date, "yyyy-MM-dd");
                                                    console.log("Выбрана дата:", selectedDate);
                                                    entriesUser.loadUserEntriesByDate(selectedDate);
                                                    console.log("Попытка создать компонент popEntryFeedByDate.qml");
                                                    var component = Qt.createComponent("qrc:/popups/popEntryFeedByDate.qml");
                                                    if (component.status === Component.Ready) {
                                                        console.log("Компонент успешно загружен.");

                                                        var popup = component.createObject(parent);
                                                        if (popup) {
                                                            console.log("Попап успешно создан.");
                                                            popup.open();
                                                        } else {
                                                            console.error("Не удалось создать объект попапа.");
                                                        }
                                                    } else if (component.status === Component.Error) {
                                                        console.error("Ошибка при загрузке компонента: " + component.errorString());
                                                    } else {
                                                        console.log("Компонент еще не готов.");
                                                    }
                                                }
                                            }

                                            required property var model
                                        }

                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                }
                            }
                        }
                    }
                }
            }

            onContentYChanged: {
                if  (!flickable.refreshing && contentY <= -60) {
                    flickable.refreshing = true
                    console.log("Обновление данных...")
                    refreshPage()
                }
            }
            function refreshPage() {

                refreshResetTimer.start()

            }

            Timer {
                id: refreshResetTimer
                interval: 1100
                repeat: false
                onTriggered: {
                    flickable.refreshing = false
                }
            }
        }
    }

    Rectangle {
        id: refreshIndicator
        width: parent.width * 0.6
        radius: 16
        border.width: 1
        border.color: "#3E3A40"
        height: 30
        opacity: 0.0
        color: "#2D292C"
        anchors.horizontalCenter: parent.horizontalCenter
        y: 10
        z: 100
        visible: opacity > 0.0

        Text {
            anchors.centerIn: parent
            color: "#d9d9d9"
            font.bold: true
            font.pixelSize: 16
            text: "Страница обновлена!"
        }

        SequentialAnimation {
            id: appearAnim
            PropertyAnimation {
                target: refreshIndicator
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 100
            }

            PauseAnimation { duration: 900 }

            PropertyAnimation {
                target: refreshIndicator
                property: "opacity"
                to: 0.0
                duration: 400
            }
        }

        Connections {
            target: flickable
            onRefreshingChanged: {
                if (flickable.refreshing)
                    appearAnim.start();
            }
        }
    }
}
