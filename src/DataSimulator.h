#ifndef DATASIMULATOR_H
#define DATASIMULATOR_H

#include <QObject>
#include <QTimer>
#include "TelemetryPacket.h"

// =============================================================================
// DataSimulator — Genera datos de telemetría falsos para probar la UI
//
// Simula una misión completa del CanSat:
//   1. STANDBY:    Datos estáticos en tierra (5 segundos)
//   2. ASCENSO:    Altitud sube hasta ~500m, aceleración fuerte
//   3. DESCENSO:   Altitud baja con paracaídas abierto
//   4. ATERRIZAJE: Altitud llega a 0, datos se estabilizan
//
// Uso desde QML:
//   simulador.iniciar()   → empieza a generar paquetes a 3 Hz
//   simulador.detener()   → para la simulación
// =============================================================================

class DataSimulator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool activo READ activo NOTIFY activoCambiado)

public:
    explicit DataSimulator(QObject *parent = nullptr);

    bool activo() const;

    Q_INVOKABLE void iniciar();
    Q_INVOKABLE void detener();

signals:
    // Misma señal que emite PacketParser — así se conecta igual
    void paqueteValido(TelemetryPacket pkt, int16_t rssi, float snr);
    void activoCambiado();
    void logAgregado(const QString &tipo, const QString &mensaje);

private slots:
    void generarPaquete();

private:
    QTimer m_timer;
    bool m_activo = false;

    // Estado de la simulación
    uint16_t m_pktId = 0;
    uint32_t m_tMis = 0;        // Tiempo de misión simulado (ms)
    uint8_t  m_estado = 0;      // Estado de misión actual
    float    m_altitud = 0.0f;  // Altitud actual simulada
    float    m_altMax = 500.0f; // Altitud máxima del vuelo
    bool     m_paraAbierto = false;

    // Genera un valor float con algo de ruido aleatorio
    float conRuido(float valor, float ruido);

    // Estado anterior (para detectar cambios y emitir logs)
    uint8_t m_estadoAnterior = 255;
};

#endif // DATASIMULATOR_H
