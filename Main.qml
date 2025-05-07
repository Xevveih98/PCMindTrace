import QtQuick
import QtQuick.Controls
import PCMindTrace 1.0

Window {
    id: mainLoader
    width:411 //Screen.width
    height: 914 //Screen.height
    visible: true
    color: "darkblue"

    //property string currentPage: AuthViewModel.isUserLoggedIn() ? "qrc:/pages/mainContent.qml" : "qrc:/pages/AuthWindow.qml"

    Loader {
        id: authWindowLoader
        anchors.fill: parent
        source: "qrc:/pages/AuthWindow.qml"
        onLoaded: {
            console.log("📱 width", mainLoader.width)
            console.log("📱 height", mainLoader.height)
        }
    }

    // Connections {
    //     target: AppViewModelBackend
    //     onChangeScreen: {
    //         currentPage = newPage
    //     }
    // }

    // // Функции для переключения страниц, теперь их можно вызвать из ViewModel
    // function switchToAuth() {
    //     currentPage = "qrc:/pages/AuthWindow.qml"
    // }

    // function switchToMain() {
    //     currentPage = "qrc:/pages/mainContent.qml"
    // }
}
