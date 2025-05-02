import QtQuick
import QtQuick.Controls

Window {
    id: mainLoader
    width:411 //Screen.width
    height: 914 //Screen.height
    visible: true
    color: "darkblue"

    Loader {
        id: authWindowLoader
        anchors.fill: parent  // Занимает всю площадь окна
        source: "qrc:/pages/AuthWindow.qml"  // Путь к файлу AuthWindow.qml

        onLoaded: {
            console.log("📱 width", mainLoader.width)
            console.log("📱 height", mainLoader.height)
        }
    }
}


// Я разрабатываю декстоп приложение на Qt, используя Qt Creator 6.9.0 с CMake и C++. В качестве базы данных - sqlLite. Я работаю с архитектурой mvvm.
// Напиши мне код для регистрации, входа и восстановления пароля учитывая заданную архитектуру(model view viewModel - мои папки для этих файлов)
// поля для ввода в Registration.qml:
// LoginInput - логин
// EmailInput - почта
// PassInput - пароль
// поля для ввода в Login.qml:
// LoginInput - логин
// PassInput - пароль
// поля для ввода в Recovery.qml
// EmailInput - почта
// NewPassInput - новый пароль
// NewPassCheckInput - повторение нового пароля

