#ifndef VIBRATIONUTILS_H
#define VIBRATIONUTILS_H

#include <QObject>

class VibrationUtils : public QObject
{
    Q_OBJECT
public:
    explicit VibrationUtils(QObject *parent = nullptr);

    Q_INVOKABLE void vibrate(int durationMs = 200);
};

#endif // VIBRATIONUTILS_H
