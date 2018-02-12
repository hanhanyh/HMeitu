#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include"hannetwork.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<HanNetWork>("Han.HanNetWork",1,0,"HanNetwork");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
