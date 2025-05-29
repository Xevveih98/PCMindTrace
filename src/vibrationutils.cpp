#include "vibrationutils.h"

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QCoreApplication>
//#include <QAndroidActivity>
#endif

VibrationUtils::VibrationUtils(QObject *parent)
    : QObject(parent)
{
}

void VibrationUtils::vibrate(int durationMs)
{
#ifdef Q_OS_ANDROID
    QJniObject activity = QJniObject::callStaticObjectMethod(
        "org/qtproject/qt/android/QtNative",
        "activity",
        "()Landroid/app/Activity;"
        );

    if (activity.isValid()) {
        QJniObject context = activity.callObjectMethod("getApplicationContext", "()Landroid/content/Context;");
        QJniObject vibrator = context.callObjectMethod(
            "getSystemService",
            "(Ljava/lang/String;)Ljava/lang/Object;",
            QJniObject::fromString("vibrator").object<jstring>()
            );

        if (vibrator.isValid()) {
            vibrator.callMethod<void>("vibrate", "(J)V", static_cast<jlong>(durationMs));
        }
    }
#endif
}
