#include "DataSimulator.h"
#include <cmath>
#include <cstring>
#include <QRandomGenerator>

// =============================================================================
// Constructor — Configura el timer que genera paquetes a ~3 Hz
// =============================================================================
DataSimulator::DataSimulator(QObject *parent)
    : QObject(parent)
{
    // Cada 333ms se genera un paquete (3 paquetes por segundo, igual que LoRa)
    connect(&m_timer, &QTimer::timeout, this, &DataSimulator::generarPaquete);
    m_timer.setInterval(333);
}

bool DataSimulator::activo() const { return m_activo; }

// =============================================================================
// iniciar() — Arranca la simulación desde cero
// =============================================================================
void DataSimulator::iniciar()
{
    // Resetear todo al estado inicial
    m_pktId = 0;
    m_tMis = 0;
    m_estado = 0;  // STANDBY
    m_altitud = 0.0f;
    m_paraAbierto = false;

    m_activo = true;
    m_timer.start();
    emit activoCambiado();
}

// =============================================================================
// detener() — Para la simulación
// =============================================================================
void DataSimulator::detener()
{
    m_timer.stop();
    m_activo = false;
    emit activoCambiado();
}

// =============================================================================
// conRuido() — Agrega un poco de variación aleatoria a un valor
//
// Esto hace que los datos se vean más "reales" en la UI, en vez de ser
// números perfectamente fijos. Por ejemplo, la temperatura va a oscilar
// un poquito alrededor del valor base.
// =============================================================================
float DataSimulator::conRuido(float valor, float ruido)
{
    // QRandomGenerator genera un double entre 0 y 1.
    // Lo convertimos a un rango de -ruido a +ruido.
    float r = QRandomGenerator::global()->generateDouble() * 2.0f - 1.0f;
    return valor + r * ruido;
}

// =============================================================================
// generarPaquete() — Se ejecuta cada 333ms y crea un paquete falso
//
// La simulación tiene 4 fases (igual que la misión real):
//
//   Tiempo 0-5s:    STANDBY    — En tierra, esperando
//   Tiempo 5-25s:   ASCENSO    — Sube hasta 500m
//   Tiempo 25-65s:  DESCENSO   — Baja con paracaídas (más lento)
//   Tiempo 65s+:    ATERRIZAJE — En tierra, datos estables
// =============================================================================
void DataSimulator::generarPaquete()
{
    TelemetryPacket pkt;
    std::memset(&pkt, 0, sizeof(pkt));

    // --- Protocolo ---
    pkt.sof = 0xAA;
    pkt.eof = 0x55;

    // --- ID y tiempo ---
    pkt.pktId = m_pktId;
    pkt.tMis = m_tMis;

    // --- Avanzar el tiempo simulado ---
    m_tMis += 333;  // 333ms por tick
    float segundos = m_tMis / 1000.0f;

    // =========================================================================
    // MÁQUINA DE ESTADOS — Controla la fase de la misión
    // =========================================================================

    if (segundos < 5.0f) {
        // --- STANDBY: En tierra, esperando lanzamiento ---
        m_estado = 0;
        m_altitud = conRuido(0.0f, 0.3f);  // Altitud ~0 con un poco de ruido GPS
    }
    else if (segundos < 25.0f) {
        // --- ASCENSO: Subiendo rápido ---
        m_estado = 1;

        // Progreso del ascenso: va de 0.0 a 1.0
        float progreso = (segundos - 5.0f) / 20.0f;

        // Curva de ascenso: sube rápido al inicio, se frena al final
        // La función seno da una curva suave y natural
        m_altitud = m_altMax * sin(progreso * M_PI / 2.0f);
    }
    else if (m_altitud > 2.0f) {
        // --- DESCENSO: Bajando con paracaídas ---
        m_estado = 2;
        m_paraAbierto = true;

        // Baja a ~12.5 m/s (más lento que ascenso por el paracaídas)
        m_altitud -= conRuido(4.2f, 0.5f);
        if (m_altitud < 0.0f) m_altitud = 0.0f;
    }
    else {
        // --- ATERRIZAJE: En tierra ---
        m_estado = 3;
        m_altitud = conRuido(0.0f, 0.2f);
    }

    pkt.estado = m_estado;

    // =========================================================================
    // DATOS DE SENSORES SIMULADOS
    // =========================================================================

    // --- GPS (ubicación fija en Lima, Perú + altitud variable) ---
    pkt.gpsFix = 1;
    pkt.lat  = conRuido(-12.0684f, 0.0001f);   // PUCP, Lima
    pkt.lon  = conRuido(-77.0794f, 0.0001f);
    pkt.satN = 8;
    pkt.alt  = m_altitud;

    // --- BME280: Temperatura baja con altitud (gradiente térmico ~6.5°C/km) ---
    float tempBase = 22.0f - (m_altitud * 0.0065f);
    pkt.tempExt = conRuido(tempBase, 0.3f);
    pkt.pres    = conRuido(1013.25f - (m_altitud * 0.12f), 0.5f);  // Presión baja con altitud
    pkt.humExt  = conRuido(65.0f, 2.0f);

    // --- AHT21: Temperatura interior (más estable que exterior) ---
    pkt.tempInt = conRuido(28.0f, 0.5f);
    pkt.humInt  = conRuido(45.0f, 1.0f);

    // --- ENS160: Calidad del aire ---
    pkt.ensOk = 1;
    pkt.eco2  = 400 + QRandomGenerator::global()->bounded(100);
    pkt.tvoc  = 50 + QRandomGenerator::global()->bounded(30);
    pkt.aqi   = 1;  // Excelente (estamos en el aire libre)

    // --- MPU-9250: Acelerómetro ---
    if (m_estado == 0 || m_estado == 3) {
        // En tierra: solo gravedad en Z
        pkt.accX = conRuido(0.0f, 0.02f);
        pkt.accY = conRuido(0.0f, 0.02f);
        pkt.accZ = conRuido(1.0f, 0.02f);  // 1g = gravedad
    } else if (m_estado == 1) {
        // Ascenso: aceleración fuerte hacia arriba
        pkt.accX = conRuido(0.1f, 0.1f);
        pkt.accY = conRuido(-0.05f, 0.1f);
        pkt.accZ = conRuido(2.5f, 0.3f);
    } else {
        // Descenso: movimiento suave con paracaídas
        pkt.accX = conRuido(0.0f, 0.15f);
        pkt.accY = conRuido(0.0f, 0.15f);
        pkt.accZ = conRuido(0.8f, 0.1f);
    }

    // --- MPU-9250: Giroscopio ---
    if (m_estado == 1) {
        // Ascenso: algo de rotación
        pkt.gyroX = conRuido(5.0f, 10.0f);
        pkt.gyroY = conRuido(-3.0f, 8.0f);
        pkt.gyroZ = conRuido(2.0f, 5.0f);
    } else if (m_estado == 2) {
        // Descenso con paracaídas: giro lento
        pkt.gyroX = conRuido(0.0f, 3.0f);
        pkt.gyroY = conRuido(0.0f, 3.0f);
        pkt.gyroZ = conRuido(15.0f, 5.0f);  // Gira un poco sobre su eje
    } else {
        pkt.gyroX = conRuido(0.0f, 0.5f);
        pkt.gyroY = conRuido(0.0f, 0.5f);
        pkt.gyroZ = conRuido(0.0f, 0.5f);
    }

    // --- MPU-9250: Magnetómetro ---
    pkt.magX = conRuido(25.0f, 2.0f);
    pkt.magY = conRuido(-5.0f, 2.0f);
    pkt.magZ = conRuido(-40.0f, 2.0f);

    // --- Paracaídas ---
    pkt.para = m_paraAbierto ? 1 : 0;
    pkt.servo = m_paraAbierto ? 90 : 0;

    // --- Cámara (grabando durante toda la misión excepto standby) ---
    pkt.camSt = (m_estado > 0) ? 2 : 1;

    // --- Batería (se descarga lentamente) ---
    float descarga = segundos * 0.001f;  // Pierde ~0.001V por segundo
    pkt.volt = conRuido(4.1f - descarga, 0.01f);
    if (pkt.volt < 3.0f) pkt.volt = 3.0f;

    // --- Temperatura CPU ---
    pkt.cpuT = conRuido(45.0f, 1.0f);

    // --- CRC (no importa para simulación, pero lo llenamos) ---
    pkt.crc16 = 0;

    // =========================================================================
    // Emitir el paquete (como si viniera de PacketParser)
    // =========================================================================
    int16_t rssi = (int16_t)conRuido(-65.0f, 5.0f);
    float snr = conRuido(9.0f, 1.0f);

    emit paqueteValido(pkt, rssi, snr);

    m_pktId++;
}
