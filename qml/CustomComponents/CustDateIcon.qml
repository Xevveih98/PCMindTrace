import QtQuick

Item {
    id: nerjl
    width: 80
    height: 90

    function clearIcons() {
        for (let i = 0; i < idImages.length; i++) {
            idImages[i].visible = false;
        }
    }

    required property var modelmonth
    required property int currentMonth
    required property var locale
    property var idImages: [ko1, ko2, ko3]

    function iconForIndex(moodId) {
        return Utils.getIconPathById(iconModelMood, moodId);
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#262326"
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Item {
            width: 40
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: ko3
                width: parent.height; height: parent.height
                x: 0
                visible: false
                z: 0
            }
            Image {
                id: ko2
                width: parent.height; height: parent.height
                x: 4
                visible: false
                z: 1
            }
            Image {
                id: ko1
                width: parent.height; height: parent.height
                x: 8
                visible: false
                z: 2
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
            entriesUser.loadUserEntriesByDate(selectedDate);
            const component = Qt.createComponent("qrc:/popups/popEntryFeedByDate.qml");
            if (component.status === Component.Ready) {
                const popup = component.createObject(parent, {
                    datefromdg: selectedDate
                    });
                if (popup) {
                    popup.open();
                } else {
                }
            } else if (component.status === Component.Error) {
            }
        }
    }

    Connections {
        target: entriesUser
        function onMoodIdsLoadSuccess(moodIds, datet) {
            const cellDate = Qt.formatDate(modelmonth.date, "yyyy-MM-dd");
            if (datet !== cellDate)
                return;
            for (let i = 0; i < idImages.length; i++) {
                idImages[i].visible = false;
            }
            if (modelmonth.month !== currentMonth) {
                idImages[0].source = "qrc:/images/minus-circle-shade.png";
                idImages[0].visible = true;
                return;
            }

            if (!moodIds || moodIds.length === 0 || (moodIds.length === 1 && moodIds[0] === 0)) {
                idImages[0].source = "qrc:/images/minus-circle.png";
                idImages[0].visible = true;
                return;
            }

            for (let i = 0; i < moodIds.length && i < idImages.length; i++) {
                idImages[i].source = iconForIndex(moodIds[i]);
                idImages[i].visible = true;
            }
        }
    }


    Component.onCompleted: {
        const dateStr = Qt.formatDate(modelmonth.date, "yyyy-MM-dd");
        entriesUser.loadUserEntriesMoodIdies(dateStr);
    }

    IconModelMod {
        id: iconModelMood
    }
}
