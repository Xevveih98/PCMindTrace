import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Rectangle {
    id: pageResearchScreen
    color: "#181718"

    property var selectedTags: []
    property var selectedEmotions: []
    property var selectedActivities: []

    ListModel {id: tagsListModel}ListModel {id: activitiesListModel}ListModel {id: emotionsListModel}
    IconModelAct {id: iconModelActivity} IconModelEmo {id: iconModelEmotion}

    CustPageHead {
        id: header
        width: parent.width
        titleText: "Поиск"
    }

    Item {
        id: itemcore
        width: parent.width * 0.93
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom

        ColumnLayout {
            id: eda
            anchors.fill: parent
            spacing: 4

            Item {
                Layout.fillWidth: parent
                Layout.preferredHeight: 30

                Rectangle {
                    id: backgroundRect
                    anchors.fill: parent
                    color: "#292729"
                    border.color: "#4D4D4D"
                    border.width: 1
                    radius: 8
                }

                TextField {
                    id: searchbar
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    width: parent.width * 0.84
                    height: parent.height
                    font.pixelSize: 12
                    color: "#D9D9D9"
                    maximumLength: 56
                    wrapMode: Text.NoWrap
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    background: null
                    padding: 6

                    Keys.onReturnPressed: {
                        const rawText = searchbar.text.trim()
                        if (rawText.length === 0) return;

                        const words = rawText.split(/\s+|,|;|\.|\n/).filter(w => w.length > 0);
                        entriesUser.loadUserEntriesByKeywords(words);
                        console.log("searchModel count:", entriesUser.searchModel.count);
                    }
                }


                Text {
                    id: placeholder
                    anchors.verticalCenter: searchbar.verticalCenter
                    anchors.left: searchbar.left
                    anchors.leftMargin: 10
                    color: "#474448"
                    font.pixelSize: 11
                    text: "Введите ключевые слова или предложение"
                    visible: searchbar.text.length === 0 && !searchbar.activeFocus
                    z: 1
                }

                Rectangle {
                    id: poloska
                    color: "#474448"
                    height: parent.height * 0.71
                    anchors.verticalCenter: parent.verticalCenter
                    width: 2
                    anchors.left: searchbar.right
                }

                Item {
                    anchors.left: poloska.right
                    anchors.leftMargin: 6
                    width: 38
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            entriesUser.clearSearchModel()
                            const rawText = searchbar.text.trim()
                            if (rawText.length === 0) return;
                            const words = rawText.split(/\s+|,|;|\.|\n/).filter(w => w.length > 0);
                            entriesUser.loadUserEntriesByKeywords(words);
                        }
                    }

                    Image {
                        id: searchIcon
                        source: "qrc:/images/lupa.png"
                        width: 17
                        height: 17
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 30

                Text{
                    color: "#d9d9d9"
                    text: "Фильтровать по категориям:"
                    font.pixelSize: 14
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "#262326"

                    Text {
                        anchors.centerIn: parent
                        text: "Пользовательский список пуст.."
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: tagsListModel.count === 0
                    }
                }

                Item {
                    width: parent.width*0.97
                    height: parent.height
                    anchors.centerIn: parent

                    ListView {
                        id: tagsListView
                        anchors.fill: parent
                        model: tagsListModel
                        spacing: 6
                        orientation: ListView.Horizontal
                        clip: true
                        delegate: CustTagButon {
                            tagText: model.tag
                            buttonWidth: implicitWidth
                            selected: qselected
                            property bool qselected: false
                            onClicked: {
                                qselected = !qselected
                                if (selected) {
                                    if (!selectedTags.includes(model.tagid)) {
                                        selectedTags.push(model.tagid)
                                    }
                                } else {
                                    let index = selectedTags.indexOf(model.tagid)
                                    if (index !== -1) {
                                        selectedTags.splice(index, 1)
                                    }
                                }
                                console.log("Selected selectedAactivities:", selectedTags)
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "#262326"

                    Text {
                        anchors.centerIn: parent
                        text: "Пользовательский список пуст.."
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: emotionsListModel.count === 0
                    }
                }

                Item {
                    width: parent.width*0.97
                    height: parent.height
                    anchors.centerIn: parent

                    ListView {
                        id: emotionsListView
                        anchors.fill: parent
                        model: emotionsListModel
                        spacing: 6
                        orientation: ListView.Horizontal
                        clip: true
                        delegate: CustEmotButn {
                            emotionText: model.emotion
                            iconPath: Utils.getIconPathById(iconModelEmotion, model.iconId)
                            buttonWidth: implicitWidth
                            selected: qselected
                            property bool qselected: false
                            onClicked: {
                                qselected = !qselected
                                if (selected) {
                                    if (!selectedEmotions.includes(model.emoid)) {
                                        selectedEmotions.push(model.emoid)
                                    }
                                } else {
                                    let index = selectedEmotions.indexOf(model.emoid)
                                    if (index !== -1) {
                                        selectedEmotions.splice(index, 1)
                                    }
                                }
                                console.log("Selected emotions:", selectedEmotions)
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "#262326"

                    Text {
                        anchors.centerIn: parent
                        text: "Пользовательский список пуст.."
                        color: "#4d4d4d"
                        font.pixelSize: 11
                        font.italic: true
                        visible: activitiesListModel.count === 0
                    }
                }

                Item {
                    width: parent.width*0.97
                    height: parent.height
                    anchors.centerIn: parent

                    ListView {
                        id: activitiesListView
                        anchors.fill: parent
                        model: activitiesListModel
                        spacing: 6
                        orientation: ListView.Horizontal
                        clip: true
                        delegate: CustActvButn {
                            activityText: model.activity
                            iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
                            buttonWidth: implicitWidth
                            selected: qselected
                            property bool qselected: false
                            onClicked: {
                                qselected = !qselected
                                if (selected) {
                                    if (!selectedActivities.includes(model.actid)) {
                                        selectedActivities.push(model.actid)
                                    }
                                } else {
                                    let index = selectedActivities.indexOf(model.actid)
                                    if (index !== -1) {
                                        selectedActivities.splice(index, 1)
                                    }
                                }
                                console.log("Selected selectedActivities:", selectedActivities)
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                Row {
                    height: 30
                    anchors.centerIn: parent
                    spacing: 50

                    Item {
                        width: 120
                        height: 30

                        Text{
                            color: "#d9d9d9"
                            text: "Очистить"
                            font.pixelSize: 14
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        MouseArea{
                           anchors.fill: parent
                           onClicked: {
                               console.log("Очищаем фильтры")
                               pageResearchScreen.resetAllFilters()
                           }
                       }
                    }

                    Item {
                        width: 120
                        height: 30

                        Rectangle {
                            anchors.fill: parent
                            color: "#AD464B"
                            radius: 100
                        }

                        Text{
                            color: "#d9d9d9"
                            text: "Фильтровать"
                            font.pixelSize: 14
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                console.log("фильтровать")
                                entriesUser.loadUserEntriesByTags(selectedTags, selectedEmotions, selectedActivities)
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 10
            }

            Text{
                id: textag
                color: "#d9d9d9"
                text: "Найденные записи"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                color: "#474448"
                height: 2
                Layout.preferredWidth: 280
                Layout.alignment: Qt.AlignHCenter
            }

            Flickable {
                id: flickable
                Layout.fillHeight: true
                Layout.fillWidth: true
                contentWidth: width
                contentHeight: entryColumn.height + 70
                flickableDirection: Flickable.VerticalFlick
                clip: true

                Column {
                    id: entryColumn
                    width: parent.width
                    spacing: 10

                    Repeater {
                        model: entriesUser.searchModel
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
                        }
                        visible: entriesUser.searchModel.count > 0
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 100
            anchors.centerIn: parent
            visible: entriesUser.searchModel.count === 0

            Column {
                spacing: 8
                width: parent.width
                anchors.centerIn: parent

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
                    visible: entriesUser.searchModel.count === 0
                }
            }
        }
    }

    Component.onCompleted: {
        entriesUser.clearSearchModel()
        categoriesUser.loadTags()
        categoriesUser.loadActivity()
        categoriesUser.loadEmotion()
    }

    Connections {
        target: categoriesUser
        onTagsLoaded: function (tags) {
            tagsListModel.clear();
            for (var i = 0; i < tags.length; i++) {
                tagsListModel.append({
                    tagid: tags[i].id,
                    tag: tags[i].tag
                });
            }
            console.log("Tags loaded into model:", tagsListModel.count)
        }
        onActivityLoadedSuccess: function (activities) {
            activitiesListModel.clear();
            for (var i = 0; i < activities.length; i++) {
                activitiesListModel.append({
                    actid: activities[i].id,
                    activity: activities[i].activity,
                    iconId: activities[i].iconId
                });
            }
            console.log("Activities loaded into model:", activitiesListModel.count)
        }
        onEmotionLoadedSuccess: function (emotions) {
            emotionsListModel.clear();
            for (var i = 0; i < emotions.length; i++) {
                emotionsListModel.append({
                    emoid: emotions[i].id,
                    emotion: emotions[i].emotion,
                    iconId: emotions[i].iconId
                });
            }
            console.log("Emotions loaded into model:", emotionsListModel.count)
        }
    }

    function resetAllFilters() {
            // Очищаем списки выбранных элементов
            selectedTags = []
            selectedEmotions = []
            selectedActivities = []

            // Сбрасываем визуальное состояние всех делегатов
            resetTagsDelegateSelection()
            resetEmotionsDelegateSelection()
            resetActivitiesDelegateSelection()

            // Очищаем поле поиска
            searchbar.text = ""
            entriesUser.clearSearchModel()
        }

        function resetTagsDelegateSelection() {
            for (var i = 0; i < tagsListModel.count; i++) {
                var item = tagsListView.itemAtIndex(i)
                if (item) item.qselected = false
            }
        }

        function resetEmotionsDelegateSelection() {
            for (var i = 0; i < emotionsListModel.count; i++) {
                var item = emotionsListView.itemAtIndex(i)
                if (item) item.qselected = false
            }
        }

        function resetActivitiesDelegateSelection() {
            for (var i = 0; i < activitiesListModel.count; i++) {
                var item = activitiesListView.itemAtIndex(i)
                if (item) item.qselected = false
            }
        }
}
