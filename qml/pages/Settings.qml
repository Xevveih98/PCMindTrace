import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PCMindTrace 1.0
import CustomComponents 1.0

Rectangle {
    id: pageSettings
    color: "#181718"

    ScrollView {
        anchors.fill: parent

        CustPageHead {
            id: header
            width: parent.width
            titleText: "Настройки"
        }

        Item {
            id: itemcore
            width: parent.width * 0.82
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: header.bottom

            Column {
                spacing: 20
                width: parent.width

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: parent.width


                    Label {
                        text: "Профиль"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustProfHead {
                        buttonWidth: parent.width
                        buttonText: "Открыть профиль"
                        avatarSource: "qrc:/images/ecalm.png"
                        userName: AppSave.getSavedLogin()
                        userEmail: AppSave.getSavedEmail()
                        onClicked: {
                            console.log("Кнопка нажата!")
                        }
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Посмотреть статистику"
                        iconSource: "qrc:/images/DataRecovery.png"
                        //popupTarget: settingsPopupChangeEmail
                    }
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: parent.width

                    Label {
                        text: "Аккаунт"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Изменить пароль"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserChangePass.qml"
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Изменить почту"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserChangeEmail.qml"
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Выйти из аккаунта"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserExitAdmit.qml"
                    }
                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Удалить аккаунт"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popUserDeleteAdmit.qml"
                    }
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: parent.width

                    Label {
                        text: "Приватность"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "PIN-код"
                        iconSource: "qrc:/images/DataRecovery.png"
                        //popupTarget: "qrc:/popups/popPinCodeManager.qml"

                        CustChck {
                            id: mySwitch
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            property var pinPopup: null
                            property bool pinSetSuccessfully: false

                            onToggled: (value) => {
                                console.log("Переключатель:", value ? "Включен" : "Выключен")
                                if (value) {
                                    const component = Qt.createComponent("qrc:/popups/popPinCodeManager.qml");
                                    if (component.status === Component.Ready) {
                                        if (pinPopup) {
                                            pinPopup.open();
                                        } else {
                                            pinPopup = component.createObject(parent);
                                            if (pinPopup) {
                                                pinSetSuccessfully = false;
                                                pinPopup.open();
                                                pinPopup.pinCodeSet.connect(() => {
                                                    pinSetSuccessfully = true;
                                                    notify.notificationTitle = "PIN-код установлен!"
                                                    notify.triggerAnimation()
                                                    pinPopup.close();
                                                });

                                                pinPopup.onVisibleChanged.connect(() => {
                                                    if (!pinPopup.visible) {
                                                        if (!pinSetSuccessfully) {
                                                            AppSave.clearPinCode()
                                                            notify.notificationTitle = "PIN-код отменен"
                                                            notify.triggerAnimation()
                                                            mySwitch.checked = false;
                                                        }
                                                        pinPopup.destroy();
                                                        pinPopup = null;
                                                    }
                                                });
                                            } else {
                                                mySwitch.checked = false;
                                            }
                                        }
                                    } else {
                                        console.error("Ошибка загрузки компонента:", component.errorString());
                                        mySwitch.checked = false;
                                    }
                                } else {
                                    if (pinPopup) {
                                        pinPopup.close();
                                        pinPopup = null;
                                    }
                                }
                            }
                        }
                    }
                }

                Column {
                    anchors.margins: 10
                    spacing: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: parent.width

                    Label {
                        text: "Управление категориями"
                        font.pixelSize: 19
                        color: "#d9d9d9"
                        font.bold: true
                        anchors.left: parent.left
                        anchors.margins: -14
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Редактировать события"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popCategoryActivitiesManage.qml"
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Редактировать эмоции"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popCategoryEmotionsManage.qml"
                    }

                    CustButtSett {
                        buttonWidth: parent.width
                        buttonText: "Редактировать теги"
                        iconSource: "qrc:/images/DataRecovery.png"
                        popupTarget: "qrc:/popups/popCategoryTagsManage.qml"
                    }
                }
            }
        }
    }

    CustNtfyAntn {
        id: notify
        notificationTitle: "уведомление"
    }

    Connections {
        target: authUser
        onEmailChangeSuccess: {
            Qt.callLater(function() {
                notify.notificationTitle = "Удачная смена почты!"
                notify.triggerAnimation()
            })
        }
    }

    Connections {
        target: authUser
        onPasswordChangeSuccess: {
            Qt.callLater(function() {
                notify.notificationTitle = "Удачная смена пароля!"
                notify.triggerAnimation()
            })
        }
    }
}
