#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "SerialManager.h"
#include "PacketParser.h"
#include "TelemetryData.h"
#include "CsvWriter.h"
#include "DataSimulator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Backend objects
    SerialManager serialManager;
    PacketParser packetParser;
    TelemetryData telemetry;
    CsvWriter csvWriter;
    DataSimulator simulador;

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

    // PacketParser::paqueteValido → SerialManager::confirmarConexion
    // (Transiciona de CONECTANDO a CONECTADO al recibir primer paquete válido)
    QObject::connect(&packetParser, &PacketParser::paqueteValido,
                     &serialManager, &SerialManager::confirmarConexion);

    // DataSimulator::paqueteValido → TelemetryData (misma señal que PacketParser)
    QObject::connect(&simulador, &DataSimulator::paqueteValido,
                     &telemetry, &TelemetryData::onPaqueteValido);

    // DataSimulator::logAgregado → TelemetryData (para mostrar en consola)
    QObject::connect(&simulador, &DataSimulator::logAgregado,
                     &telemetry, &TelemetryData::logAgregado);

    // Expose to QML
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("serialManager", &serialManager);
    engine.rootContext()->setContextProperty("telemetry", &telemetry);
    engine.rootContext()->setContextProperty("csvWriter", &csvWriter);
    engine.rootContext()->setContextProperty("simulador", &simulador);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TELSTAR_OFFICIAL", "Main");

    return app.exec();
}
