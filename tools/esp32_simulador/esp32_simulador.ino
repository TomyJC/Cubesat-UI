// =============================================================================
// ESP32 Simulador de Telemetría TELSTAR
//
// Genera frames seriales de 105 bytes idénticos al protocolo TELSTAR
// para probar la estación terrena sin necesidad de hardware LoRa.
//
// Simula una misión completa:
//   STANDBY (5s) → ASCENSO (20s) → DESCENSO (~40s) → ATERRIZAJE
//
// Conexión: USB del ESP32 → COM del PC
// Baudrate: 115200 (configurable abajo)
// Frecuencia: ~3 Hz (un paquete cada 333ms)
// =============================================================================

#include <math.h>

// ===================== CONFIGURACIÓN =====================
const long BAUDRATE       = 115200;  // Debe coincidir con la estación terrena
const int  INTERVALO_MS   = 333;     // 333ms ≈ 3 Hz (igual que LoRa real)
const float ALTITUD_MAX   = 500.0f;  // Metros de apogeo
// =========================================================

// Constantes del protocolo
const uint8_t SOF_BYTE = 0xAA;
const uint8_t EOF_BYTE = 0x55;

// Estados de misión
const uint8_t ESTADO_STANDBY    = 0;
const uint8_t ESTADO_ASCENSO    = 1;
const uint8_t ESTADO_DESCENSO   = 2;
const uint8_t ESTADO_ATERRIZAJE = 3;

// =========================================================================
// Struct del paquete de telemetría (99 bytes, idéntico a TelemetryPacket.h)
//
// IMPORTANTE: El orden y tamaño de cada campo DEBE coincidir exactamente
// con lo que espera la estación terrena. No cambiar sin actualizar ambos.
// =========================================================================
#pragma pack(push, 1)
struct TelemetryPacket {
    // Byte [0] — Start of Frame
    uint8_t  sof;           // 0xAA

    // Payload [1..95] — 95 bytes, 34 campos
    uint16_t pktId;         // ID de paquete (se incrementa cada envío)
    uint32_t tMis;          // Tiempo de misión (ms desde boot)
    uint8_t  estado;        // 0=STANDBY, 1=ASCENSO, 2=DESCENSO, 3=ATERRIZAJE
    uint8_t  gpsFix;        // 0=sin fix, 1+=con fix
    float    lat;           // Latitud
    float    lon;           // Longitud
    uint8_t  satN;          // Número de satélites GPS
    float    alt;           // Altitud (m)
    float    tempExt;       // Temperatura externa BME280 (°C)
    float    pres;          // Presión BME280 (hPa)
    float    humExt;        // Humedad externa BME280 (%)
    float    tempInt;       // Temperatura interna AHT21 (°C)
    float    humInt;        // Humedad interna AHT21 (%)
    uint8_t  ensOk;         // ENS160 estado (0=no listo, 1=listo)
    uint16_t eco2;          // CO2 equivalente (ppm)
    uint16_t tvoc;          // VOC total (ppb)
    uint8_t  aqi;           // Índice calidad aire (1-5)
    float    accX;          // Aceleración X (g)
    float    accY;          // Aceleración Y (g)
    float    accZ;          // Aceleración Z (g)
    float    gyroX;         // Giroscopio X (°/s)
    float    gyroY;         // Giroscopio Y (°/s)
    float    gyroZ;         // Giroscopio Z (°/s)
    float    magX;          // Magnetómetro X (µT)
    float    magY;          // Magnetómetro Y (µT)
    float    magZ;          // Magnetómetro Z (µT)
    uint8_t  para;          // Paracaídas: 0=cerrado, 1=abierto
    uint16_t servo;         // Ángulo servo (°)
    uint8_t  camSt;         // Cámara: 0=apagada, 1=encendida, 2=grabando
    float    volt;          // Voltaje batería (V)
    float    cpuT;          // Temperatura CPU ESP32 (°C)

    // Bytes [96..97] — Checksum (suma de bytes [1..95], little-endian)
    uint16_t checksum;

    // Byte [98] — End of Frame
    uint8_t  eof;           // 0x55
};
#pragma pack(pop)

// Frame serial completo: paquete + datos de radio (105 bytes)
#pragma pack(push, 1)
struct SerialFrame {
    TelemetryPacket packet;
    int16_t rssi;           // RSSI en dBm
    float   snr;            // SNR en dB
};
#pragma pack(pop)

// Verificar tamaños en tiempo de compilación
static_assert(sizeof(TelemetryPacket) == 99, "TelemetryPacket debe ser 99 bytes");
static_assert(sizeof(SerialFrame) == 105, "SerialFrame debe ser 105 bytes");

// =========================================================================
// Variables globales de la simulación
// =========================================================================
uint16_t pktId       = 0;
uint32_t tMisInicio  = 0;       // millis() de cuando arrancó la misión
float    altitud     = 0.0f;
bool     paraAbierto = false;
uint8_t  estadoActual = ESTADO_STANDBY;

// =========================================================================
// conRuido() — Agrega variación aleatoria a un valor
//
// Hace que los datos simulados se vean más naturales. Por ejemplo:
//   conRuido(22.0, 0.3) → podría dar 21.85 o 22.12
// =========================================================================
float conRuido(float valor, float ruido) {
    float r = random(-1000, 1001) / 1000.0f;  // Número entre -1.0 y 1.0
    return valor + r * ruido;
}

// =========================================================================
// calcularChecksum() — Suma simple de los bytes del payload
//
// Suma los bytes [1..95] del paquete (todo el payload, sin SOF ni checksum ni EOF).
// El resultado es un uint16_t que se guarda en little-endian.
// =========================================================================
uint16_t calcularChecksum(const TelemetryPacket* pkt) {
    const uint8_t* bytes = (const uint8_t*)pkt;
    uint16_t suma = 0;

    // Sumar bytes del payload: posiciones [1] a [95] inclusive
    for (int i = 1; i <= 95; i++) {
        suma += bytes[i];
    }

    return suma;
}

// =========================================================================
// generarPaquete() — Crea un paquete simulado según el estado de la misión
// =========================================================================
void generarPaquete(SerialFrame* frame) {
    TelemetryPacket* pkt = &frame->packet;

    // Limpiar todo a ceros
    memset(frame, 0, sizeof(SerialFrame));

    // --- Protocolo ---
    pkt->sof = SOF_BYTE;
    pkt->eof = EOF_BYTE;

    // --- ID y tiempo de misión ---
    pkt->pktId = pktId;
    uint32_t tMis = millis() - tMisInicio;
    pkt->tMis = tMis;

    float segundos = tMis / 1000.0f;

    // =====================================================================
    // MÁQUINA DE ESTADOS — Controla la fase de la misión
    //
    //   0-5s:    STANDBY    → En tierra, esperando
    //   5-25s:   ASCENSO    → Sube hasta ALTITUD_MAX
    //   Hasta ~2m: DESCENSO → Baja con paracaídas
    //   < 2m:    ATERRIZAJE → En tierra
    // =====================================================================

    if (segundos < 5.0f) {
        // --- STANDBY: En tierra, esperando lanzamiento ---
        estadoActual = ESTADO_STANDBY;
        altitud = conRuido(0.0f, 0.3f);
        if (altitud < 0.0f) altitud = 0.0f;
    }
    else if (segundos < 25.0f) {
        // --- ASCENSO: Subiendo ---
        estadoActual = ESTADO_ASCENSO;
        float progreso = (segundos - 5.0f) / 20.0f;  // 0.0 → 1.0
        altitud = ALTITUD_MAX * sin(progreso * PI / 2.0f);
    }
    else if (altitud > 2.0f) {
        // --- DESCENSO: Bajando con paracaídas ---
        estadoActual = ESTADO_DESCENSO;
        paraAbierto = true;
        altitud -= conRuido(4.2f, 0.5f);  // ~12.5 m/s
        if (altitud < 0.0f) altitud = 0.0f;
    }
    else {
        // --- ATERRIZAJE: En tierra ---
        estadoActual = ESTADO_ATERRIZAJE;
        altitud = conRuido(0.0f, 0.2f);
        if (altitud < 0.0f) altitud = 0.0f;
    }

    pkt->estado = estadoActual;

    // =====================================================================
    // DATOS DE SENSORES SIMULADOS
    // =====================================================================

    // --- GPS: Ubicación fija en PUCP, Lima ---
    pkt->gpsFix = 1;
    pkt->lat    = conRuido(-12.0684f, 0.0001f);
    pkt->lon    = conRuido(-77.0794f, 0.0001f);
    pkt->satN   = 8;
    pkt->alt    = altitud;

    // --- BME280: Temperatura baja con altitud (gradiente ~6.5°C/km) ---
    float tempBase = 22.0f - (altitud * 0.0065f);
    pkt->tempExt = conRuido(tempBase, 0.3f);
    pkt->pres    = conRuido(1013.25f - (altitud * 0.12f), 0.5f);
    pkt->humExt  = conRuido(65.0f, 2.0f);

    // --- AHT21: Temperatura interior (más estable) ---
    pkt->tempInt = conRuido(28.0f, 0.5f);
    pkt->humInt  = conRuido(45.0f, 1.0f);

    // --- ENS160: Calidad del aire ---
    pkt->ensOk = 1;
    pkt->eco2  = 400 + random(0, 100);
    pkt->tvoc  = 50 + random(0, 30);
    pkt->aqi   = 1;  // Excelente

    // --- MPU-9250: Acelerómetro (en g) ---
    if (estadoActual == ESTADO_STANDBY || estadoActual == ESTADO_ATERRIZAJE) {
        pkt->accX = conRuido(0.0f, 0.02f);
        pkt->accY = conRuido(0.0f, 0.02f);
        pkt->accZ = conRuido(1.0f, 0.02f);   // 1g = gravedad
    } else if (estadoActual == ESTADO_ASCENSO) {
        pkt->accX = conRuido(0.1f, 0.1f);
        pkt->accY = conRuido(-0.05f, 0.1f);
        pkt->accZ = conRuido(2.5f, 0.3f);    // Aceleración fuerte
    } else {
        pkt->accX = conRuido(0.0f, 0.15f);
        pkt->accY = conRuido(0.0f, 0.15f);
        pkt->accZ = conRuido(0.8f, 0.1f);    // Caída con paracaídas
    }

    // --- MPU-9250: Giroscopio (°/s) ---
    if (estadoActual == ESTADO_ASCENSO) {
        pkt->gyroX = conRuido(5.0f, 10.0f);
        pkt->gyroY = conRuido(-3.0f, 8.0f);
        pkt->gyroZ = conRuido(2.0f, 5.0f);
    } else if (estadoActual == ESTADO_DESCENSO) {
        pkt->gyroX = conRuido(0.0f, 3.0f);
        pkt->gyroY = conRuido(0.0f, 3.0f);
        pkt->gyroZ = conRuido(15.0f, 5.0f);  // Gira sobre su eje
    } else {
        pkt->gyroX = conRuido(0.0f, 0.5f);
        pkt->gyroY = conRuido(0.0f, 0.5f);
        pkt->gyroZ = conRuido(0.0f, 0.5f);
    }

    // --- MPU-9250: Magnetómetro (µT) ---
    pkt->magX = conRuido(25.0f, 2.0f);
    pkt->magY = conRuido(-5.0f, 2.0f);
    pkt->magZ = conRuido(-40.0f, 2.0f);

    // --- Paracaídas y servo ---
    pkt->para  = paraAbierto ? 1 : 0;
    pkt->servo = paraAbierto ? 90 : 0;

    // --- Cámara (grabando durante la misión, encendida en standby) ---
    pkt->camSt = (estadoActual > 0) ? 2 : 1;

    // --- Batería (se descarga lentamente) ---
    float descarga = segundos * 0.001f;
    pkt->volt = conRuido(4.1f - descarga, 0.01f);
    if (pkt->volt < 3.0f) pkt->volt = 3.0f;

    // --- Temperatura CPU ---
    pkt->cpuT = conRuido(45.0f, 1.0f);

    // --- Checksum: suma de bytes del payload [1..95] ---
    pkt->checksum = calcularChecksum(pkt);

    // --- Datos de radio (simulados) ---
    frame->rssi = (int16_t)conRuido(-65.0f, 5.0f);
    frame->snr  = conRuido(9.0f, 1.0f);

    pktId++;
}

// =========================================================================
// setup() — Inicialización
// =========================================================================
void setup() {
    Serial.begin(BAUDRATE);

    // Esperar a que el puerto serial esté listo
    while (!Serial) {
        delay(10);
    }

    // Semilla aleatoria desde pin analógico sin conectar (ruido)
    randomSeed(analogRead(0));

    tMisInicio = millis();

    // Mensaje de inicio (esto no afecta la recepción porque la estación
    // terrena busca el byte SOF 0xAA para sincronizar)
    Serial.println();
    Serial.println("=== TELSTAR ESP32 Simulador ===");
    Serial.println("Enviando frames de 105 bytes a 3 Hz");
    Serial.print("Baudrate: ");
    Serial.println(BAUDRATE);
    Serial.println("Iniciando en 2 segundos...");
    Serial.println();

    delay(2000);
    tMisInicio = millis();  // Reiniciar tiempo de misión después del delay
}

// =========================================================================
// loop() — Bucle principal: genera y envía un frame cada 333ms
// =========================================================================
void loop() {
    SerialFrame frame;

    // Generar el paquete simulado
    generarPaquete(&frame);

    // Enviar los 105 bytes crudos por serial
    Serial.write((const uint8_t*)&frame, sizeof(SerialFrame));

    // Esperar hasta el siguiente ciclo (~3 Hz)
    delay(INTERVALO_MS);
}
