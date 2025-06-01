import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0
Popup {
    property string entryTitle
    property string entryContent
    property var entryDate
    property var entryTime
    property int entryMood
    property var tagItems
    property var activityItems
    property var emotionItems
    property int entryId
    property var foldersList: []
    property int selectedIconId: entryMood

    id: managerPopup
    width: Screen.width * 0.93
    height: Screen.height * 0.93
    modal: true
    focus: true
    dim: true
    padding: 0
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    anchors.centerIn: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#181718"
        opacity: 0.9
    }
    background: Rectangle {
        color: "#2D292C"
        radius: 8
    }

    Item {
        width: parent.width * 0.93
        height: parent.height
        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 4
            }

            Item {
                id: headermaininfo
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                Item {
                    id: iconemote
                    height: parent.height
                    width: height

                    Item {
                        width: 44
                        height: 44
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            anchors.fill: parent
                            onClicked: moodPopup.open()
                        }

                        Image {
                            anchors.fill: parent
                            anchors.margins: 4
                            source: Utils.getIconPathById(iconModelMood, managerPopup.selectedIconId)
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Popup {
                        id: moodPopup
                        width: 260
                        height: 60
                        modal: true
                        focus: true
                        dim: true
                        closePolicy: Popup.CloseOnPressOutside
                        x: iconemote.x
                        y: iconemote.y + iconemote.height + 2
                        Overlay.modal: Rectangle {
                            color: "#181718"
                            opacity: 0.9
                        }
                        background: Rectangle {
                            color: "#2D292C"
                            radius: 8
                        }

                        Item {
                            anchors.centerIn: parent
                            width: parent.width * 0.92
                            height: parent.height * 0.94

                            Row {
                                anchors.fill: parent
                                spacing: 10

                                Repeater {
                                    model: iconModelMood
                                    delegate: Item {
                                        width: 36
                                        height: 36

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                managerPopup.selectedIconId = model.iconId;
                                                moodPopup.close();
                                            }

                                            Image {
                                                anchors.fill: parent
                                                source: model.path
                                                fillMode: Image.PreserveAspectFit
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    anchors.left: iconemote.right
                    width: parent.width - iconemote.width
                    height: parent.height

                    Column {
                        width: parent.width
                        spacing: 0
                        Text  {
                            text: "Название записи"
                            font.pixelSize: 12
                            color: "#d9d9d9"
                        }
                        CustTxtFldEr {
                            id: catName
                            width: parent.width
                            placeholderText: "Введите заголовок"
                            maximumLength: 34
                            errorText: "* Ошибка"
                            errorVisible: false
                            Component.onCompleted: {
                                catName.text = managerPopup.entryTitle
                            }
                            onTextChanged: {
                                managerPopup.entryTitle = text
                            }
                        }
                    }
                    Text {
                        id: entryDateTake
                        font.pixelSize: 11
                        anchors.right: parent.right
                        color: "#616161"
                        text: Utils.formatTodayDate()
                    }
                }
            }



            Item{
                id: deckheadpart
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text{
                    id: dexregwq
                    text: "Содержание записи"
                    font.pixelSize: 12
                    color: "#d9d9d9"
                }

                Rectangle {
                    id: entryDesc
                    width: parent.width
                    anchors.top: dexregwq.bottom
                    anchors.topMargin: 2
                    height: parent.height - 12
                    color: "#292729"
                    border.color: "#4D4D4D"
                    border.width: 1
                    radius: 2

                    Flickable {
                        id: flick
                        anchors.fill: parent
                        contentHeight: textEdit.contentHeight
                        clip: true

                        function ensureVisible(r) {
                            if (contentX >= r.x)
                                contentX = r.x;
                            else if (contentX + width <= r.x + r.width)
                                contentX = r.x + r.width - width;
                            if (contentY >= r.y)
                                contentY = r.y;
                            else if (contentY + height <= r.y + r.height)
                                contentY = r.y + r.height - height;
                        }

                        TextEdit {
                            id: textEdit
                            width: flick.width
                            textFormat: TextEdit.RichText
                            color: "#d9d9d9"
                            font.pixelSize: 11
                            wrapMode: TextEdit.WrapAnywhere
                            Keys.onReturnPressed: insert("\n")
                            padding: 6
                            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

                            Component.onCompleted: {
                                textEdit.text = managerPopup.entryContent
                            }

                            onTextChanged: {
                                managerPopup.entryContent = text
                            }
                        }
                    }

                    Text {
                        id: placeholder
                        anchors.fill: parent
                        anchors.margins: 8
                        font.pixelSize: 11
                        text: "Напишите, как прошел ваш день"
                        color: "#4d4d4d"
                        opacity: (!textEdit.text && !textEdit.activeFocus) ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }
            }

            Item{
                width: 1
                height: 1
            }

            Item {
                id: tegheaderaw
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                Column {
                    width: parent.width
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Item {
                        id: headegeatag
                        width: parent.width
                        height: 20

                        Text{
                            id: tagchoose
                            text: "Теги"
                            font.pixelSize: 15
                            font.bold: true
                            color: "#d9d9d9"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item {
                            height: parent.height
                            width: height
                            anchors.right: parent.right

                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: "qrc:/images/addcategoru.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Попытка создать компонент popAddEntryTag.qml");
                                   var component = Qt.createComponent("qrc:/popups/popAddEntryTag.qml");
                                   if (component.status === Component.Ready) {
                                       console.log("Компонент успешно загружен.");
                                       var popup = component.createObject(parent);
                                       if (popup) {
                                           console.log("Попап успешно создан.");

                                           popup.tagsConfirmed.connect(function(selectedTags) {
                                               console.log("Получены теги из попапа:", selectedTags);
                                               tagviewma.setSelectedTags(selectedTags);
                                           });

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
                        }
                    }

                    Item {
                        id: tagviewma
                        width: parent.width
                        height: 40

                        property var selectedTags: []

                        ListModel {
                            id: tagsListModel
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#262326"
                            radius: 8

                            Text {
                                anchors.centerIn: parent
                                text: "Список тегов пустует.."
                                color: "#4d4d4d"
                                font.pixelSize: 11
                                font.italic: true
                                visible: tagsListModel.count === 0
                            }

                            Item {
                                width: parent.width*0.97
                                height: parent.height
                                anchors.centerIn: parent

                                ListView {
                                    anchors.fill: parent
                                    model: tagsListModel
                                    spacing: 6
                                    orientation: ListView.Horizontal
                                    clip: true

                                    delegate: CustTagButon {
                                        tagText: model.tag
                                        buttonWidth: implicitWidth
                                        Component.onCompleted: {
                                            console.log("Загружен в главное окно делегат с тегом:", model.tag);
                                        }
                                    }
                                }
                            }
                        }

                        function setSelectedTags(tagArray) {
                            tagsListModel.clear()
                            let fullTagObjects = []
                            for (let i = 0; i < tagArray.length; ++i) {
                                let tagObj = {
                                    id: tagArray[i].id,
                                    tag: tagArray[i].tag
                                }
                                tagsListModel.append(tagObj)
                                fullTagObjects.push(tagObj)
                            }
                            selectedTags = fullTagObjects
                        }
                    }
                }
            }

            Item {
                id: headeractivitiew
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                Column {
                    width: parent.width
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Item {
                        id: headegacri
                        width: parent.width
                        height: 20

                        Text{
                            id: acitw
                            text: "События"
                            font.pixelSize: 15
                            font.bold: true
                            color: "#d9d9d9"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item {
                            height: parent.height
                            width: height
                            anchors.right: parent.right

                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: "qrc:/images/addcategoru.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Попытка создать компонент popAddEntryActivity.qml");
                                    var component = Qt.createComponent("qrc:/popups/popAddEntryActivity.qml");
                                    if (component.status === Component.Ready) {
                                        var popup = component.createObject(parent);
                                        if (popup) {
                                            popup.activitiesConfirmed.connect(function(selectedActivities) {
                                                console.log("Получены активности из попапа:", selectedActivities);
                                                tagviwma.setSelectedActivities(selectedActivities);
                                            });
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
                    }

                    Item {
                        id: tagviwma
                        width: parent.width
                        height: 40

                        property var selectedActivities: []

                        ListModel {
                            id: activitiesListModel
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#262326"
                            radius: 8

                            Text {
                                anchors.centerIn: parent
                                text: "Список событий пустует.."
                                color: "#4d4d4d"
                                font.pixelSize: 11
                                font.italic: true
                                visible: activitiesListModel.count === 0
                            }

                            Item {
                                width: parent.width*0.97
                                height: parent.height
                                anchors.centerIn: parent

                                ListView {
                                    anchors.fill: parent
                                    model: activitiesListModel
                                    spacing: 6
                                    orientation: ListView.Horizontal
                                    clip: true
                                    delegate: CustActvButn {
                                        activityText: model.activity
                                        iconPath: Utils.getIconPathById(iconModelActivity, model.iconId)
                                        buttonWidth: implicitWidth
                                        Component.onCompleted: {
                                            console.log("Загружен в главное окно делегат с активностью:", model.activity);
                                        }
                                    }
                                }
                            }
                        }

                        function setSelectedActivities(activityArray) {
                            activitiesListModel.clear()
                            let fullActivityObjects = []
                            for (let i = 0; i < activityArray.length; ++i) {
                                let obj = {
                                    id: activityArray[i].id,
                                    activity: activityArray[i].activity,
                                    iconId: activityArray[i].iconId
                                }
                                activitiesListModel.append(obj)
                                fullActivityObjects.push(obj)
                            }
                            selectedActivities = fullActivityObjects
                        }
                    }
                }
            }

            Item {
                id: headeremot
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                Column {
                    width: parent.width
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Item {
                        id: headega32
                        width: parent.width
                        height: 20

                        Text{
                            id: emottttttt
                            text: "Впечатления"
                            font.pixelSize: 15
                            font.bold: true
                            color: "#d9d9d9"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item {
                            height: parent.height
                            width: height
                            anchors.right: parent.right

                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: "qrc:/images/addcategoru.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Попытка создать компонент popAddEntryEmotions.qml");
                                    var component = Qt.createComponent("qrc:/popups/popAddEntryEmotion.qml");
                                    if (component.status === Component.Ready) {
                                        var popup = component.createObject(parent);
                                        if (popup) {
                                            popup.emotionsConfirmed.connect(function(selectedEmotions) {
                                                console.log("Получены активности из попапа:", selectedEmotions);
                                                wmro.setSelectedEmotions(selectedEmotions);
                                            });
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
                    }

                    Item {
                        id: wmro
                        width: parent.width
                        height: 40

                        property var selectedEmotions: []

                        ListModel {
                            id: emotionsListModel
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "#262326"
                            radius: 8

                            Text {
                                anchors.centerIn: parent
                                text: "Список впечатлений пустует.."
                                color: "#4d4d4d"
                                font.pixelSize: 11
                                font.italic: true
                                visible: emotionsListModel.count === 0
                            }

                            Item {
                                width: parent.width*0.97
                                height: parent.height
                                anchors.centerIn: parent

                                ListView {
                                    anchors.fill: parent
                                    model: emotionsListModel
                                    spacing: 6
                                    orientation: ListView.Horizontal
                                    clip: true
                                    delegate: CustEmotButn {
                                        emotionText: model.emotion
                                        iconPath: Utils.getIconPathById(iconModelEmotion, model.iconId)
                                        buttonWidth: implicitWidth
                                        Component.onCompleted: {
                                            console.log("Загружен в главное окно делегат с активностью:", model.emotion);
                                        }
                                    }
                                }
                            }
                        }

                        function setSelectedEmotions(emotionArray) {
                            emotionsListModel.clear()
                            for (let i = 0; i < emotionArray.length; ++i) {
                                emotionsListModel.append({
                                                             id: emotionArray[i].id,
                                                             iconId: emotionArray[i].iconId,
                                                             emotion: emotionArray[i].emotion
                                                         })
                            }
                            selectedEmotions = emotionArray
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
                    spacing: 20

                    Item {
                        width: 156
                        height: 30

                        Row {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                id: ewwqqwqw
                                color: "#d9d9d9"
                                text: "Закрыть"
                                font.pixelSize: 14
                                font.bold: true
                            }

                            Image {
                                width: 20
                                height: 20
                                source: "qrc:/images/quitw.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Отмена создания записи");
                                managerPopup.close();
                            }
                        }
                    }

                    Item {
                        width: 156
                        height: 30

                        Rectangle {
                            anchors.fill: parent
                            color: "#AD464B"
                            radius: 100
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 6

                            Image {
                                width: 20
                                height: 20
                                source: "qrc:/images/continueq.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                id: fwewefw
                                color: "#d9d9d9"
                                text: "Продолжить"
                                font.pixelSize: 14
                                font.bold: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Selected entry ID:", managerPopup.entryId)

                               var tagIds = tagviewma.selectedTags.map(t => t.id)
                               var activityIds = tagviwma.selectedActivities.map(a => a.id)
                               var emotionIds = wmro.selectedEmotions.map(e => e.id)

                               var component = Qt.createComponent("qrc:/popups/popEntryChooseFolder.qml")

                               if (component.status !== Component.Ready) {
                                   console.error("Ошибка при загрузке компонента: " + component.errorString())
                                   return
                               }

                               console.log("Компонент успешно загружен.")

                               var popupProps = {
                                   mode: "edit",
                                   entryId: managerPopup.entryId,
                                   entryHeaderText: catName.text,
                                   entryContentText: textEdit.text,
                                   entryDate: managerPopup.entryDate,
                                   selectedMoodId: managerPopup.selectedIconId,
                                   selectedTags: tagIds,
                                   selectedActivities: activityIds,
                                   selectedEmotions: emotionIds,
                                   parentPopup: managerPopup,
                                   foldersList: managerPopup.foldersList
                               }

                               var popup = component.createObject(parent, popupProps)

                               if (popup) {
                                   console.log("Попап выбора папки успешно создан.")
                                   popup.open()
                               } else {
                                   console.error("Не удалось создать объект попапа.")
                               }
                            }
                        }
                    }
                }
            }
        }
    }

    IconModelAct {
        id: iconModelActivity
    }
    IconModelEmo {
        id: iconModelEmotion
    }
    IconModelMod {
        id: iconModelMood
    }


    function loadTags(sourceArray, targetModel) {
        targetModel.clear()
        tagviewma.selectedTags = []
        for (let i = 0; i < sourceArray.length; ++i) {
            const item = sourceArray[i]
            const obj = {
                id: item.id,
                iconId: item.iconId !== undefined ? item.iconId : 0,
                tag: item.label
            }
            targetModel.append(obj)
            tagviewma.selectedTags.push(obj)
        }
    }

    function loadActivities(sourceArray, targetModel) {
        targetModel.clear()
        tagviwma.selectedActivities = []
        for (let i = 0; i < sourceArray.length; ++i) {
            const item = sourceArray[i]
            const obj = {
                id: item.id,
                iconId: item.iconId !== undefined ? item.iconId : 0,
                activity: item.label
            }
            targetModel.append(obj)
            tagviwma.selectedActivities.push(obj)
        }
    }

    function loadEmotions(sourceArray, targetModel) {
        targetModel.clear()
        wmro.selectedEmotions = []
        for (let i = 0; i < sourceArray.length; ++i) {
            const item = sourceArray[i]
            const obj = {
                id: item.id,
                iconId: item.iconId !== undefined ? item.iconId : 0,
                emotion: item.label
            }
            targetModel.append(obj)
            wmro.selectedEmotions.push(obj)  // Добавляем сразу в selectedEmotions.map
        }
    }

    Component.onCompleted: {
        console.log("tagItems:", tagItems)
        console.log("activityItems:", activityItems)
        console.log("emotionItems:", emotionItems)

        loadTags(tagItems, tagsListModel)
        loadActivities(activityItems, activitiesListModel)
        loadEmotions(emotionItems, emotionsListModel)
    }

    onVisibleChanged: {
        if (visible) {
            catName.text = entryTitle
            textEdit.text = entryContent
        }
    }
}
