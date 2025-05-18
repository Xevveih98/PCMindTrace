import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents 1.0

Rectangle {
    id: pageResearchScreen
    color: "#181718"

    property var selectedTags: []

    CustPageHead {
        id: header
        headerWidth: parent.width
        titleText: "Поиск"
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
            contentHeight: eda.height + entryColumn.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: eda
                width: parent.width
                spacing: 12

// ------------------- поисковая строка ----------------

                Item {
                    width: parent.width
                    height: 36

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

// ------------------- выбор тегов ---------------------

                Item {
                    width: parent.width
                    height: 180

                    Item {
                        id: headersertag
                        width: parent.width
                        height: 23

                        Text{
                            color: "#d9d9d9"
                            text: "Фильтровать по тегам:"
                            font.pixelSize: 14
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Item {
                        id: butt
                        width: 100
                        height: 23
                        anchors.right: parent.right

                        Rectangle {
                            id: buttcleartags
                            color: "transparent"
                            radius: 8
                            width: parent.width
                            height: parent.height

                            Item {
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width * 0.7

                                Image {
                                    anchors.right: parent.right
                                    width: 14
                                    height: 14
                                    source: "qrc:/images/erase.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: "Очистить"
                                    font.pixelSize: 11
                                    color: "#D9D9D9"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    pageResearchScreen.selectedTags.splice(0, pageResearchScreen.selectedTags.length);
                                    console.log("Все теги сняты.");
                                }
                            }

                        }
                    }

                    Item {
                        id: tagsviewch
                        width: parent.width * 0.98
                        height: 40
                        anchors.top: headersertag.bottom
                        anchors.topMargin: 11
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 1.02
                            height: parent.height * 1.03
                            radius: 8
                            color: "#262326"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Пользовательский список пуст.."
                            color: "#4d4d4d"
                            font.pixelSize: 11
                            font.italic: true
                            visible: tagsListModel.count === 0
                        }

                        ListModel {
                            id: tagsListModel
                        }

                        ListView {
                            anchors.fill: parent
                            model: tagsListModel
                            spacing: 6
                            orientation: ListView.Horizontal
                            clip: true
                            delegate: CustTagButon {
                                tagText: model.tag
                                buttonWidth: implicitWidth
                                selected: pageResearchScreen.selectedTags.some(t => t.id === model.tagId) // ← исправлено
                                onClicked: {
                                    let index = pageResearchScreen.selectedTags.findIndex(t => t.id === model.tagId); // ← уже верно
                                    if (index === -1) {
                                        pageResearchScreen.selectedTags.push({
                                            id: Number(model.tagId), // ← на всякий случай явно
                                            tag: model.tag
                                        });
                                    } else {
                                        pageResearchScreen.selectedTags.splice(index, 1);
                                    }

                                    selected = !selected;

                                    console.log("Обновленные selectedTags:");
                                    for (let i = 0; i < pageResearchScreen.selectedTags.length; ++i) {
                                        console.log("  id:", pageResearchScreen.selectedTags[i].id, "tag:", pageResearchScreen.selectedTags[i].tag);
                                    }
                                }
                            }

                        }
                    }

                    Item {
                        id: filterbytags
                        width: 126
                        height: 30
                        anchors.right: parent.right
                        anchors.top: tagsviewch.bottom
                        anchors.topMargin: 11

                        Rectangle {
                            id: buttgetfiltertags
                            color: "#37262E"
                            border.color: "#9A5556"
                            border.width: 1
                            radius: 16
                            width: parent.width
                            height: parent.height

                            Item {
                                anchors.centerIn: parent
                                height: parent.height
                                width: parent.width * 0.76

                                Image {
                                    anchors.right: parent.right
                                    width: 14
                                    height: 14
                                    source: "qrc:/images/tagsfilter.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: "Фильтровать"
                                    font.pixelSize: 12
                                    font.bold: true
                                    color: "#D9D9D9"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    let tagIds = selectedTags.map(t => Number(t.id));
                                    console.log("Отправляем id-шники тегов:", tagIds);
                                    entriesUser.loadUserEntriesByTags(tagIds);

                                }
                            }
                        }
                    }

                    Item {
                        id: resuler
                        width: parent.width
                        height: 23
                        anchors.top: filterbytags.bottom
                        anchors.topMargin: 20

                        Text{
                            id: textag
                            color: "#d9d9d9"
                            text: "Найденные записи"
                            font.pixelSize: 18
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle {
                            color: "#474448"
                            height: 2
                            width: parent.width * 0.71
                            anchors.top: textag.bottom
                            anchors.topMargin: 11
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

// ------------ отображение отфильтрованных записей-----

                Item {
                    id:entryFeed
                    width:  parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 400

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

                    Item {
                        width: 80
                        height: 80
                        anchors.centerIn: parent
                        visible: entriesUser.searchModel.count === 0

                        Column {
                            spacing: 8
                            width: parent.width

                            Image {
                                width: 60
                                height: 60
                                source: "qrc:/images/noentries.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.horizontalCenter: parent
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
            }
        }
    }

    function setTags(tagArray) {
        tagsListModel.clear();
        for (let i = 0; i < tagArray.length; ++i) {
            tagsListModel.append({ tagId: tagArray[i].id, tag: tagArray[i].tag });
        }
    }

    function loadTagsFromServer(tags) {
        console.log("Loading tags into model:", tags)
        setTags(tags)

    }

    Component.onCompleted: {
        entriesUser.clearSearchModel()
        categoriesUser.loadTags()
    }

    Connections {
        target: categoriesUser
        onTagsLoaded: function(tags) {
            loadTagsFromServer(tags);
        }
    }
}
