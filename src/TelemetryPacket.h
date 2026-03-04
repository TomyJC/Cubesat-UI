#ifndef TELEMETRYPACKET_H
#define TELEMETRYPACKET_H

#include <cstdint>

// Constantes del protocolo
constexpr uint8_t  SOF_BYTE    = 0xAA;
constexpr uint8_t  EOF_BYTE    = 0x55;
constexpr int      PACKET_SIZE = 99;   // SOF(1) + Payload(95) + CRC(2) + EOF(1)
constexpr int      FRAME_SIZE  = 105;  // Packet(99) + RSSI(2) + SNR(4)
constexpr int      PAYLOAD_START = 1;
constexpr int      PAYLOAD_END   = 95; // bytes [1..95] inclusive
constexpr int      CRC_OFFSET    = 96;
constexpr int      EOF_OFFSET    = 98;

// Struct del paquete de telemetría LoRa (99 bytes)
// Orden y tamaños exactos del protocolo TELSTAR
#pragma pack(push, 1)
struct TelemetryPacket {
    // Byte [0] — Start of Frame
    uint8_t  sof;           // 0xAA

    // Payload [1..95] — 95 bytes
    uint16_t pktId;         // ID de paquete
    uint32_t tMis;          // Tiempo de misión (ms desde boot ESP32)
    uint8_t  estado;        // 0=STANDBY, 1=ASCENSO, 2=DESCENSO, 3=ATERRIZAJE
    uint8_t  gpsFix;        // 0=sin fix, 1+=con fix
    float    lat;           // Latitud
    float    lon;           // Longitud
    uint8_t  satN;          // Número de satélites
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

    // Bytes [96..97] — CRC-16 (little-endian, sobre bytes [1..95])
    uint16_t crc16;

    // Byte [98] — End of Frame
    uint8_t  eof;           // 0x55
};
#pragma pack(pop)

static_assert(sizeof(TelemetryPacket) == 99,
              "TelemetryPacket debe ser exactamente 99 bytes");

// Struct del frame serial completo (105 bytes)
// El ESP32 Ground agrega RSSI y SNR después del paquete LoRa
#pragma pack(push, 1)
struct SerialFrame {
    TelemetryPacket packet;
    int16_t rssi;           // RSSI en dBm (entero)
    float   snr;            // SNR en dB
};
#pragma pack(pop)

static_assert(sizeof(SerialFrame) == 105,
              "SerialFrame debe ser exactamente 105 bytes");

#endif // TELEMETRYPACKET_H
