#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "operation.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;


    QQmlContext* context=engine.rootContext();
    Operation *operator_user = new Operation();


    context->setContextProperty("operator_user",operator_user);

    context->setContextProperty("xml_operation",operator_user->getXMLOperation());


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
