import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents

Item {
    width: 42
    height: 90

    required property var modelmonth
    required property int currentMonth
    required property var locale

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#262326"
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Item {
            width: 28
            height: 23

            Image {
                width: 20
                height: 20
                anchors.centerIn: parent
                source: modelmonth.month === currentMonth
                        ? "qrc:/images/minus-circle.png"
                        : "qrc:/images/minus-circle-shade.png"
            }
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: modelmonth.month === currentMonth ? 1 : 0.2
            text: locale.toString(modelmonth.date, "d")
            color: "#d9d9d9"
            font.pixelSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            let selectedDate = Qt.formatDate(modelmonth.date, "yyyy-MM-dd");
            console.log("Выбрана дата:", selectedDate);
            entriesUser.loadUserEntriesByDate(selectedDate);
            var component = Qt.createComponent("qrc:/popups/popEntryFeedByDate.qml");
            if (component.status === Component.Ready) {
                var popup = component.createObject(parent);
                if (popup) {
                    popup.open();
                } else {
                    console.error("Не удалось создать объект попапа.");
                }
            } else if (component.status === Component.Error) {
                console.error("Ошибка при загрузке компонента: " + component.errorString());
            }
        }
    }
}
