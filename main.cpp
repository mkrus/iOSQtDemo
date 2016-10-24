#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#ifdef Q_OS_IOS
#include "mytextview.h"
#endif

#include "appmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    AppManager appMgr;

#ifdef Q_OS_IOS
    qmlRegisterType<MyTextView>("MyTextView", 1, 0, "MyTextView");
#endif

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("_appMgr", &appMgr);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
