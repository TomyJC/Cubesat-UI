#include "TelemetryData.h"
#include <QDateTime>
#include <cmath>
#include <cstring>

TelemetryData::TelemetryData(QObject *parent)
    : QObject(parent)
{
    std::memset(&m_pkt, 0, sizeof(m_pkt));
}

// ── Getters: PanelEstadoMision ──────────────────────────

QString TelemetryData::estado() const
{
    return estadoToString(m_pkt.estado);
}

QString TelemetryData::estadoParacaidas() const
{
    return m_pkt.para ? QStringLiteral("ABIERTO") : QStringLiteral("CERRADO");
}

QString TelemetryData::tiempoMision() const
{
    if (m_paquetesRecibidos == 0)
        return QStringLiteral("T+ 00:00:00");

    // T_MIS está en ms desde boot del ESP32
    int total = static_cast<int>(m_pkt.tMis / 1000);

    int h = total / 3600;
    int m = (total % 3600) / 60;
    int s = total % 60;

    return QStringLiteral("T+ %1:%2:%3")
        .arg(h, 2, 10, QChar('0'))
        .arg(m, 2, 10, QChar('0'))
        .arg(s, 2, 10, QChar('0'));
}

int TelemetryData::paquetesRecibidos() const { return m_paquetesRecibidos; }
int TelemetryData::servo() const { return m_pkt.servo; }

QString TelemetryData::gpsFix() const
{
    if (m_paquetesRecibidos == 0) return QStringLiteral("--");
    return m_pkt.gpsFix > 0
        ? QStringLiteral("%1 SAT").arg(m_pkt.satN)
        : QStringLiteral("SIN FIX");
}

QString TelemetryData::ens160Estado() const
{
    if (m_paquetesRecibidos == 0) return QStringLiteral("--");
    return m_pkt.ensOk ? QStringLiteral("LISTO") : QStringLiteral("NO LISTO");
}

QString TelemetryData::camaraEstado() const
{
    if (m_paquetesRecibidos == 0) return QStringLiteral("APAGADA");
    return camaraToString(m_pkt.camSt);
}

double TelemetryData::altitud() const { return m_pkt.alt; }
double TelemetryData::altitudMaxima() const { return m_altitudMaxima; }
bool TelemetryData::altitudDisponible() const { return m_tieneAlDato; }

// ── Getters: PanelBateria ───────────────────────────────

double TelemetryData::voltaje() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.volt : 0.0;
}

double TelemetryData::rssi() const
{
    return m_paquetesRecibidos > 0 ? static_cast<double>(m_rssi) : 0.0;
}

double TelemetryData::cpuTemp() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.cpuT : 0.0;
}



// ── Getters: PanelGeolocalizacion ───────────────────────

double TelemetryData::latitud() const { return m_pkt.lat; }
double TelemetryData::longitud() const { return m_pkt.lon; }
bool TelemetryData::datosGeoDisponibles() const { return m_pkt.gpsFix > 0; }
bool TelemetryData::camaraGrabando() const { return m_pkt.camSt == 2; }

// ── Getters: PanelSensores ──────────────────────────────

double TelemetryData::tempInterna() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.tempInt : 0.0;
}

double TelemetryData::tempExterna() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.tempExt : 0.0;
}

double TelemetryData::presion() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.pres : 0.0;
}

double TelemetryData::humedad() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.humExt : 0.0;
}

double TelemetryData::humedadInterna() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.humInt : 0.0;
}

int TelemetryData::eco2() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.eco2 : 0;
}

int TelemetryData::tvoc() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.tvoc : 0;
}

int TelemetryData::aqi() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.aqi : 0;
}

double TelemetryData::magX() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.magX : 0.0;
}

double TelemetryData::magY() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.magY : 0.0;
}

double TelemetryData::magZ() const
{
    return m_paquetesRecibidos > 0 ? m_pkt.magZ : 0.0;
}

// ── Getters: PanelAcelerometro ──────────────────────────

double TelemetryData::accelX() const { return m_pkt.accX; }
double TelemetryData::accelY() const { return m_pkt.accY; }
double TelemetryData::accelZ() const { return m_pkt.accZ; }
bool TelemetryData::datosAccelDisponibles() const { return m_paquetesRecibidos > 0; }

// ── Getters: PanelVelocidad ─────────────────────────────

double TelemetryData::velocidad() const { return m_vDesc.velocidad(); }
bool TelemetryData::datosVelDisponibles() const { return m_vDesc.disponible(); }

// ── Getters: PanelOrientacion ───────────────────────────

double TelemetryData::pitch() const { return m_pitch; }
double TelemetryData::roll() const { return m_roll; }
double TelemetryData::yaw() const { return m_yaw; }

bool TelemetryData::esEstable() const
{
    return std::fabs(m_pitch) < 30.0 && std::fabs(m_roll) < 30.0;
}

double TelemetryData::velocidadAngular() const
{
    return std::sqrt(m_pkt.gyroX * m_pkt.gyroX +
                     m_pkt.gyroY * m_pkt.gyroY +
                     m_pkt.gyroZ * m_pkt.gyroZ);
}

bool TelemetryData::datosOrientDisponibles() const { return m_tieneOrientacion; }

// ── Extra ───────────────────────────────────────────────

double TelemetryData::snr() const { return m_snr; }
int TelemetryData::paquetesInvalidos() const { return m_paquetesInvalidos; }

// ── Slots ───────────────────────────────────────────────

void TelemetryData::onPaqueteValido(TelemetryPacket pkt, int16_t rssi, float snr)
{
    m_pkt = pkt;
    m_rssi = rssi;
    m_snr = snr;
    m_paquetesRecibidos++;

    // Tracking de altitud máxima
    m_tieneAlDato = true;
    if (pkt.alt > m_altitudMaxima)
        m_altitudMaxima = pkt.alt;

    // Calcular velocidad de descenso
    m_vDesc.update(pkt.alt, pkt.tMis);

    // Calcular dt real desde T_MIS (ms) para el filtro Madgwick
    float dt;
    if (m_paquetesRecibidos > 1 && pkt.tMis > m_tMisAnterior) {
        dt = static_cast<float>(pkt.tMis - m_tMisAnterior) / 1000.0f;
        // Clamp a rango razonable para evitar saltos por paquetes perdidos
        if (dt > 2.0f) dt = 2.0f;
    } else {
        dt = 0.333f; // Estimación inicial ~3 Hz
    }
    m_tMisAnterior = pkt.tMis;

    m_madgwick.update(pkt.accX, pkt.accY, pkt.accZ,
                      pkt.gyroX, pkt.gyroY, pkt.gyroZ,
                      pkt.magX, pkt.magY, pkt.magZ,
                      dt);

    m_pitch = m_madgwick.pitch();
    m_roll = m_madgwick.roll();
    m_yaw = m_madgwick.yaw();
    m_tieneOrientacion = true;

    emit datosActualizados();

    // Emitir paquete con valores calculados para el CSV
    emit paqueteParaCsv(pkt, rssi, snr,
                        m_vDesc.disponible() ? m_vDesc.velocidad() : 0.0,
                        m_pitch, m_roll, m_yaw,
                        estadoToString(pkt.estado));

    // Log para consola
    QString timestamp = QDateTime::currentDateTime().toString("hh:mm:ss.zzz");
    emit logAgregado(QStringLiteral("PKT"),
                     QStringLiteral("[%1] Paquete #%2 | Alt: %3m | RSSI: %4 dBm")
                         .arg(timestamp)
                         .arg(m_paquetesRecibidos)
                         .arg(pkt.alt, 0, 'f', 1)
                         .arg(rssi));
}

void TelemetryData::onPaqueteInvalido(quint32 bytesDescartados)
{
    m_paquetesInvalidos++;
    emit datosActualizados();

    QString timestamp = QDateTime::currentDateTime().toString("hh:mm:ss.zzz");
    emit logAgregado(QStringLiteral("ERR"),
                     QStringLiteral("[%1] Datos inválidos: %2 bytes descartados")
                         .arg(timestamp)
                         .arg(bytesDescartados));
}

void TelemetryData::resetear()
{
    std::memset(&m_pkt, 0, sizeof(m_pkt));
    m_rssi = 0;
    m_snr = 0.0f;
    m_paquetesRecibidos = 0;
    m_paquetesInvalidos = 0;
    m_altitudMaxima = 0.0;
    m_tieneAlDato = false;
    m_tMisAnterior = 0;
    m_tieneOrientacion = false;
    m_pitch = m_roll = m_yaw = 0.0;
    m_vDesc.reset();
    m_madgwick.reset();
    emit datosActualizados();
}

// ── Helpers ─────────────────────────────────────────────

QString TelemetryData::estadoToString(uint8_t estado)
{
    switch (estado) {
    case 0: return QStringLiteral("STANDBY");
    case 1: return QStringLiteral("ASCENSO");
    case 2: return QStringLiteral("DESCENSO");
    case 3: return QStringLiteral("ATERRIZAJE");
    default: return QStringLiteral("DESCONOCIDO");
    }
}

QString TelemetryData::camaraToString(uint8_t camSt)
{
    switch (camSt) {
    case 0: return QStringLiteral("APAGADA");
    case 1: return QStringLiteral("ENCENDIDA");
    case 2: return QStringLiteral("GRABANDO");
    default: return QStringLiteral("DESCONOCIDO");
    }
}
