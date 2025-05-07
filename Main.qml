import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0

Window {
    id: mainLoader
    width: 411
    height: 914
    visible: true
    color: "darkblue"

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: AppSave.isUserLoggedIn() ? "qrc:/pages/mainContent.qml" : "qrc:/pages/AuthWindow.qml"
    }
}
