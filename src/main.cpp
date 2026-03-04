#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "SerialManager.h"
#include "PacketParser.h"
#include "TelemetryData.h"
#include "CsvWriter.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Backend objects
    SerialManager serialManager;
    PacketParser packetParser;
    TelemetryData telemetry;
    CsvWriter csvWriter;

    // Cadena de señales:
    // SerialManager::datosRecibidos → PacketParser::procesarDatos
    QObject::connect(&serialManager, &SerialManager::datosRecibidos,
                     &packetParser, &PacketParser::procesarDatos);

    // PacketParser::paqueteValido → TelemetryData::onPaqueteValido
    QObject::connect(&packetParser, &PacketParser::paqueteValido,
                     &telemetry, &TelemetryData::onPaqueteValido);

    // PacketParser::paqueteInvalido → TelemetryData::onPaqueteInvalido
    QObject::connect(&packetParser, &PacketParser::paqueteInvalido,
                     &telemetry, &TelemetryData::onPaqueteInvalido);

    // PacketParser::paqueteValido → CsvWriter::escribirPaquete
    QObject::connect(&packetParser, &PacketParser::paqueteValido,
                     &csvWriter, &CsvWriter::escribirPaquete);

    // Expose to QML
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("serialManager", &serialManager);
    engine.rootContext()->setContextProperty("telemetry", &telemetry);
    engine.rootContext()->setContextProperty("csvWriter", &csvWriter);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TELSTAR_OFFICIAL", "Main");

    return app.exec();
}
