#include <QObject>
#include <QQmlEngine>
#include <QQmlContext>

class CustomComponentsSingleton : public QObject {
    Q_OBJECT
public:
    static CustomComponentsSingleton* instance() {
        static CustomComponentsSingleton instance;
        return &instance;
    }
private:
    CustomComponentsSingleton() = default;  // Конструктор по умолчанию
    CustomComponentsSingleton(const CustomComponentsSingleton&) = delete;
    CustomComponentsSingleton& operator=(const CustomComponentsSingleton&) = delete;
};
