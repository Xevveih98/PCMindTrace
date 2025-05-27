import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0
import QtCharts

Rectangle {
    id: pageCalendarScreen
    color: "#181718"

    property int daysInMonth: 31

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
            contentHeight: eda.height + 80
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: eda
                width: parent.width
                spacing: 12

                Item {
                    id: papcaledar
                    width: parent.width
                    height: 410
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        color: "#2D292C"
                        radius: 8
                        anchors.fill: parent

                        Item {
                            width: parent.width
                            height: parent.height * 0.94
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
                                    spacing: 0
                                    background: Rectangle {
                                        anchors.fill: parent
                                        //radius: 12
                                        color: "#262326"
                                    }



                                    delegate: CustDateIcon {
                                        modelmonth: model
                                        currentMonth: monthGrid.month
                                        locale: monthGrid.locale
                                        required property var model

                                        Connections {
                                            target: monthSwitchButton
                                            function onMonthChanged(dateString) {
                                                const dateStr = Qt.formatDate(model.date, "yyyy-MM-dd");
                                                entriesUser.loadUserEntriesMoodIdies(dateStr);
                                            }
                                        }

                                        function clearIcons() {
                                            for (let i = 0; i < idImages.length; i++) {
                                                idImages[i].visible = false;
                                            }
                                        }
                                    }

                                    Connections {
                                        target: monthSwitchButton
                                        function onMonthChanged(dateString) {
                                            console.log("Выбран новый месяц:", dateString);

                                            for (let i = 0; i < monthGrid.contentItem.children.length; i++) {
                                                const cell = monthGrid.contentItem.children[i];
                                                if (cell.clearIcons) {
                                                    cell.clearIcons();
                                                }
                                            }
                                        }
                                    }

                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                }
                            }
                        }
                    }
                }

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

                        var monthKeyCurrent = Utils.formatMonthKey(selectedYear, selectedMonth);
                        var prevInfo = Utils.getPreviousMonthKey(selectedYear, selectedMonth);
                        var monthKeyLast = prevInfo.key;

                        daysInMonth = Utils.getDaysInMonth(selectedYear, selectedMonth);
                        console.log("Дней в месяце:", daysInMonth);

                        monthChanged(monthKeyCurrent + "-01");
                        computeUser.loadEntriesByMonth(monthKeyLast, monthKeyCurrent);
                    }
                    signal monthChanged(string dateString)

                    Component.onCompleted: updateDisplay()
                }

                Item {
                    id: monthChart
                    width: parent.width
                    height: 240

                    Rectangle {
                        anchors.fill: parent
                        color: "#2D292C"
                        radius: 8
                    }

                    ColumnLayout {
                        id: sfesf
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.preferredWidth: parent.width * 0.9
                            height: 40
                            Layout.alignment: Qt.AlignHCenter

                            Column {
                                height: 28
                                width: parent.width
                                anchors.bottom: parent.bottom //anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    id: hanle
                                    color: "#d9d9d9"
                                    text: "Динамика настроения по дням"
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Row {
                                    spacing: 4
                                    anchors.left: parent.left

                                    Text {
                                        color: "#a1a1a1"
                                        text: "Всего было сделано записей:"
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        id: entryMonthCount
                                        color: "#a1a1a1"
                                        text: entryCurrentMonthModel.count
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        id: entryMonthTrend
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: entryCurrentMonthModel.count >= entryLastMonthModel.count ? "#519D65" : "#D24D57"

                                        text: {
                                            var diff = entryCurrentMonthModel.count - entryLastMonthModel.count;
                                            if (diff > 0) return "( +" + diff + " )";
                                            if (diff < 0) return "( " + diff + " )";
                                            return "( 0 )";
                                        }
                                    }
                                }
                            }
                        }


                        ChartView {
                            id: chart
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            antialiasing: true
                            legend.visible: false
                            backgroundColor: "transparent"
                            plotAreaColor: "#262326"
                            clip: false
                            property int daysInMonth: 31
                            animationOptions: ChartView.SeriesAnimations

                            ValueAxis {
                                id: axisX
                                min: 0.5
                                max: 31.4
                                color: "#616161"
                                tickType: ValueAxis.TicksDynamic
                                tickAnchor: 1
                                tickInterval: 3
                                labelFormat: "%.0f"
                                labelsColor: "#d9d9d9"
                                gridVisible: false
                            }

                            ValueAxis {
                                id: axisY
                                min: 0.5
                                max: 5.4
                                reverse: true
                                color:"transparent"
                                minorTickCount: 1
                                tickCount: 5
                                labelFormat: "%.0f"
                                labelsColor: "#2D292C"
                                gridVisible: false
                                minorGridVisible: true
                                minorGridLineColor: "#2D292C"
                            }

                            LineSeries {
                                id: prevMoodSeries
                                axisX: axisX
                                axisY: axisY
                                color: "#41414B"
                                pointsVisible: false
                                name: "Настроение (предыдущий месяц)"
                                Connections {
                                    target: entryLastMonthModel
                                    onCountChanged: {
                                        prevMoodSeries.clear();
                                        var dayToMood = entryLastMonthModel.averageMoodByDay();
                                        for (var day = 1; day <= daysInMonth; day++) {
                                            var mood = dayToMood[day.toString()];
                                            if (mood !== undefined) {
                                                prevMoodSeries.append(day, mood);
                                            }
                                        }
                                    }
                                }
                            }

                            LineSeries {
                                id: moodSeries
                                axisX: axisX
                                color: "#DA446A"
                                axisY: axisY
                                pointsVisible: true
                                name: "Настроение"
                                Connections {
                                    target: entryCurrentMonthModel
                                    onCountChanged: {
                                        moodSeries.clear();
                                        var dayToMood = entryCurrentMonthModel.averageMoodByDay();
                                        for (var day = 1; day <= daysInMonth; day++) {
                                            var mood = dayToMood[day.toString()];
                                            if (mood !== undefined) {
                                                moodSeries.append(day, mood);
                                            }
                                        }
                                    }
                                }
                            }


                            Column {
                                id: iconsOverlay
                                height: parent.height
                                anchors.left: chart.left
                                anchors.top: chart.top
                                anchors.leftMargin: 12
                                anchors.topMargin: 28
                                width: 40
                                spacing: 10

                                Repeater {
                                    model: 5
                                    delegate: Image {
                                        property int moodId: index + 1
                                        source: Utils.getIconPathById(iconModelMood, moodId)
                                        width: 18
                                        height: 18
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    id: monthMerge
                    width: parent.width
                    height: 270

                    property var moodStats: {}
                    property var stats: {}

                    Connections {
                        target: entryCurrentMonthModel
                        onCountChanged: {
                            monthMerge.moodStats = entryCurrentMonthModel.calculateMoodStats();
                            moodPrimaryMonthCount.text = monthMerge.moodStats.primaryCount;
                            moodPrimaryMonthStability.text = monthMerge.moodStats.stabilityText;
                            moodMidMonthCount.text = monthMerge.moodStats.avgMoodExact.toFixed(1);
                            moodIcon.source = Utils.getIconPathById(iconModelMood, monthMerge.moodStats.avgMoodRounded);
                            moodPrimaryMonthStability.color = monthMerge.moodStats.stabilityColor || "#519D65";
                        }
                    }

                    Connections {
                        target: entryLastMonthModel
                        onCountChanged: {
                            monthMerge.stats = entryLastMonthModel.calculateMoodStats();
                            moodMidLastMonthCount.text = monthMerge.stats.avgMoodExact.toFixed(1);
                            moodIconLastMonth.source = Utils.getIconPathById(iconModelMood, monthMerge.stats.avgMoodRounded);
                        }
                    }

                    ColumnLayout {
                        id: sfesfrrrrr
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.preferredWidth: parent.width * 0.9
                            height: 40
                            Layout.alignment: Qt.AlignHCenter

                            Column {
                                height: 28
                                width: parent.width
                                anchors.bottom: parent.bottom //anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    id: han
                                    color: "#d9d9d9"
                                    text: "Среднее настроение за месяц"
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Row {
                                    spacing: 4
                                    anchors.left: parent.left

                                    Text {
                                        color: "#a1a1a1"
                                        text: "Записей с этим настроением:"
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        id: moodPrimaryMonthCount
                                        color: "#a1a1a1"
                                        text: "у"
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        id: moodPrimaryMonthStability
                                        color: "#519D65"
                                        text: "у"
                                        font.bold: true
                                        font.pixelSize: 11
                                    }
                                }
                            }
                        }

                        Item {
                            Layout.preferredWidth: parent.width * 0.8
                            height: 120
                            Layout.alignment: Qt.AlignHCenter

                            Row {
                                anchors.fill: parent
                                spacing: 0

                                Item {
                                    width: parent.width * 0.5
                                    height: parent.height * 0.9

                                    Rectangle {
                                        width: 66
                                        height: 66
                                        anchors.centerIn: parent
                                        color: "#2D292C"
                                        radius: 100
                                    }

                                    Image {
                                        id: moodIcon
                                        source: "qrc:/images/nonemo.png"
                                        width: 50
                                        height: 50
                                        anchors.centerIn: parent
                                    }

                                    Text {
                                        id: moodMidMonthCount
                                        color: "#DA446A"
                                        text: "1,2"
                                        font.bold: true
                                        font.pixelSize: 18
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }

                                Item {
                                    width: parent.width * 0.5
                                    height: parent.height * 0.7
                                    anchors.verticalCenter: parent.verticalCenter

                                    Text {
                                        color: "#a1a1a1"
                                        text: "Прошлый месяц"
                                        font.pixelSize: 12
                                        anchors.top: parent.top
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Image {
                                        id: moodIconLastMonth
                                        source: "qrc:/images/nonemo.png"
                                        width: 30
                                        height: 30
                                        anchors.centerIn: parent
                                    }

                                    Text {
                                        id: moodMidLastMonthCount
                                        color: "#a1a1a1"
                                        text: "1,2"
                                        font.pixelSize: 14
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }

                        Item {
                            id: moodStatsContainer
                            Layout.fillWidth: true
                            height: 60
                            Layout.alignment: Qt.AlignHCenter

                            Row {
                                id: iconRow
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 18

                                // MoodId = 1
                                Item {
                                    width: 30
                                    height: 54
                                    Image {
                                        id: icon1
                                        width: 30
                                        height: width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: Utils.getIconPathById(iconModelMood, 1)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: count1
                                        color: "#a1a1a1"
                                        font.bold: true
                                        font.pixelSize: 14
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "0"
                                    }
                                }

                                // MoodId = 2
                                Item {
                                    width: 30
                                    height: 54
                                    Image {
                                        id: icon2
                                        width: 30
                                        height: width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: Utils.getIconPathById(iconModelMood, 2)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: count2
                                        color: "#a1a1a1"
                                        font.bold: true
                                        font.pixelSize: 14
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "0"
                                    }
                                }

                                // MoodId = 3
                                Item {
                                    width: 30
                                    height: 54
                                    Image {
                                        id: icon3
                                        width: 30
                                        height: width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: Utils.getIconPathById(iconModelMood, 3)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: count3
                                        color: "#a1a1a1"
                                        font.bold: true
                                        font.pixelSize: 14
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "0"
                                    }
                                }

                                // MoodId = 4
                                Item {
                                    width: 30
                                    height: 54
                                    Image {
                                        id: icon4
                                        width: 30
                                        height: width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: Utils.getIconPathById(iconModelMood, 4)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: count4
                                        color: "#a1a1a1"
                                        font.bold: true
                                        font.pixelSize: 14
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "0"
                                    }
                                }

                                // MoodId = 5
                                Item {
                                    width: 30
                                    height: 54
                                    Image {
                                        id: icon5
                                        width: 30
                                        height: width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        source: Utils.getIconPathById(iconModelMood, 5)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: count5
                                        color: "#a1a1a1"
                                        font.bold: true
                                        font.pixelSize: 14
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "0"
                                    }
                                }
                            }

                            Connections {
                                target: entryCurrentMonthModel
                                onCountChanged: {
                                    count1.text = entryCurrentMonthModel.countMood(1);
                                    count2.text = entryCurrentMonthModel.countMood(2);
                                    count3.text = entryCurrentMonthModel.countMood(3);
                                    count4.text = entryCurrentMonthModel.countMood(4);
                                    count5.text = entryCurrentMonthModel.countMood(5);
                                }
                            }
                        }
                    }
                }

                Item {
                    id: entryWeekPopular
                    width: parent.width
                    height: 250

                    Rectangle {
                        anchors.fill: parent
                        color: "#2D292C"
                        radius: 8
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.preferredWidth: parent.width * 0.9
                            height: 40
                            Layout.alignment: Qt.AlignHCenter

                            Column {
                                height: 28
                                width: parent.width
                                anchors.bottom: parent.bottom

                                Text {
                                    color: "#d9d9d9"
                                    text: "Среднее настроение по дням"
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Row {
                                    spacing: 4
                                    anchors.left: parent.left

                                    Text {
                                        color: "#a1a1a1"
                                        text: "Любимый день -"
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        id: lovday
                                        color: "#DA446A"
                                        text: "понедельник!"
                                        font.bold: true
                                        font.pixelSize: 12
                                    }

                                    Connections {
                                        target: entryCurrentMonthModel
                                        onCountChanged: {
                                            var res = entryCurrentMonthModel.averageMoodByWeekday();
                                            lovday.text = res.bestDay + "!";
                                        }
                                    }
                                }
                            }
                        }

                        ChartView {
                            id: chart2
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            antialiasing: true
                            legend.visible: false
                            backgroundColor: "transparent"
                            plotAreaColor: "#262326"
                            clip: false

                            BarCategoryAxis {
                                id: axisXc
                                categories: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                                labelsColor: "#d9d9d9"
                                gridVisible: false
                                color: "#616161"
                            }


                            ValueAxis {
                                id: axisYc
                                min: 0.5
                                max: 5.4
                                color: "transparent"
                                labelsVisible: true
                                minorTickCount: 1
                                tickCount: 5
                                labelFormat: "%.0f"
                                labelsColor: "#2D292C"
                                gridVisible: false
                                minorGridVisible: true
                                minorGridLineColor: "#2D292C"
                            }

                            BarSeries {
                                axisX: axisXc
                                axisY: axisYc

                                BarSet {
                                    id: moodBarSet
                                    borderWidth: 0
                                    borderColor: "transparent"
                                    color: "#DA446A"
                                    values: moodValues
                                    property var moodValues: []
                                }

                                Connections {
                                    target: entryCurrentMonthModel
                                    onCountChanged: {
                                        var vals = entryCurrentMonthModel.averageMoodByWeekday();
                                        moodBarSet.moodValues = vals.averages;
                                    }
                                }
                            }

                            Column {
                                id: iconsOverlay2
                                height: parent.height
                                anchors.left: chart2.left
                                anchors.top: chart2.top
                                anchors.leftMargin: 12
                                anchors.topMargin: 28
                                width: 40
                                spacing: 10

                                Repeater {
                                    model: 5
                                    delegate: Image {
                                        property int idd: index + 1
                                        source: Utils.getIconPathById(iconModelMood, idd)
                                        width: 18
                                        height: 18
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    id: entryDayPopular
                    width: parent.width
                    height: 70

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.preferredWidth: parent.width * 0.9
                            height: 40
                            Layout.alignment: Qt.AlignHCenter

                            Column {
                                height: 28
                                width: parent.width
                                anchors.bottom: parent.bottom

                                Text {
                                    color: "#d9d9d9"
                                    text: "Самый насыщенный день"
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Row {
                                    spacing: 4
                                    anchors.left: parent.left

                                    Text {
                                        color: "#a1a1a1"
                                        text: "Вспомните события"
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        id: daydateo
                                        color: "#DA446A"
                                        text: "12 ферваля 2024!"
                                        font.pixelSize: 12
                                        font.bold: true
                                    }

                                    Connections {
                                        target: entryCurrentMonthModel
                                        onCountChanged: {
                                            var richo = entryCurrentMonthModel.dateWithMostEntries();
                                            daydateo.text = richo.formattedDate;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Column {
                    id: entryColumn
                    width: parent.width
                    spacing: 10

                    Repeater {
                        model: entriesUser.dateSearchModel
                        delegate: CustEntrBlok {
                            width: entryColumn.width
                            entryTitle: model.title
                            entryContent: model.content
                            entryDate: model.date
                            entryTime: model.time
                            entryMood: model.moodId
                            tagItems: model.tags
                            activityItems: model.activities
                            emotionItems: model.emotions
                            entryId: model.id
                        }
                        visible: entriesUser.dateSearchModel.count > 0
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: 80
                    visible: entriesUser.dateSearchModel.count === 0

                    Column {
                        spacing: 8
                        width: parent.width

                        Image {
                            width: 60
                            height: 60
                            source: "qrc:/images/noentries.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            id: emptyText
                            text: "Записи не найдены.."
                            font.italic: true
                            font.bold: true
                            font.pixelSize: 14
                            color: "#616161"
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: entriesUser.dateSearchModel.count === 0
                        }
                    }
                }
            }

            onContentYChanged: {
                if  (!flickable.refreshing && contentY <= -60) {
                    flickable.refreshing = true
                    console.log("Обновление данных...")
                    monthSwitchButton.updateDisplay()
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

    Connections {
        target: entryCurrentMonthModel
        onCountChanged: {
            var richoraw = entryCurrentMonthModel.dateWithMostEntries();
            var datetoload = richoraw.rawDate;
            console.log("ПЕРЕДАВАЕМАЯ ДАТА (через Connections):", datetoload);
            entriesUser.loadUserEntriesByDate(datetoload);
        }
    }

    IconModelMod {
        id: iconModelMood
    }

    ListModel {
        id: iconModelPlaces
        ListElement { iconId: 1; path: "qrc:/images/best.png" }
        ListElement { iconId: 2; path: "qrc:/images/second.png" }
        ListElement { iconId: 3; path: "qrc:/images/third.png" }
    }
}
