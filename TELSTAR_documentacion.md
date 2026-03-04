# TELSTAR — Documentación Técnica de Telemetría
**CanSat · LoRa Ra-02 · 433 MHz**
**Versión 7**

---

## 1. Hardware del Sistema

### 1.1 CanSat (Transmisor)

| Componente | Función |
|---|---|
| ESP32 | Microcontrolador principal |
| Ra-02 (SX1278) | Módulo LoRa transmisor 433 MHz |
| MPU-9250 | IMU 9 ejes (ACC + GYRO + AK8963 MAG) |
| BME280 | Temperatura, presión y humedad exterior |
| AHT21 | Temperatura y humedad interior |
| ENS160 | Calidad del aire (ECO2, TVOC, AQI) |
| NEO-6M | GPS (LAT, LON, SAT_N) |
| ESP32-CAM | Grabación de video en microSD (OV2640) |
| Micro Servo SG 1.5 | Despliegue del paracaídas |
| Li-ion 18650 | Alimentación · 3.0–4.2 V |

### 1.2 Estación Terrena (Receptor)

| Componente | Función |
|---|---|
| Ra-02 (SX1278) | Módulo LoRa receptor 433 MHz |
| ESP32 | Puente LoRa → USB-Serial al PC |
| Antena dipolo 433 MHz | Recepción omnidireccional |
| PC / Laptop | Backend C++/Qt + Frontend QML |

---

## 2. Enlace de Comunicación

| Parámetro | Valor |
|---|---|
| Frecuencia | 433 MHz |
| Modulación | LoRa (SX1278) |
| Spreading Factor | SF8 |
| Bandwidth | BW125 |
| Coding Rate | CR 4/5 |
| Potencia TX | Máxima Ra-02 |
| Sync Word | 0x12 |
| ToA estimado | ~335 ms |
| Frecuencia de actualización | ~3 Hz |
| Alcance estimado | ~3–5 km |

### 2.1 Flujo de datos completo

```
ESP32 CanSat
  └─ Lee sensores, serializa 99 bytes
        ↓ RF 433 MHz · LoRa SF8/BW125
ESP32 Ground Station
  └─ LoRa.parsePacket(99 bytes)
  └─ LoRa.packetRssi() → RSSI (2 bytes)
  └─ LoRa.packetSnr()  → SNR  (4 bytes)
  └─ Serial.write(105 bytes totales)
        ↓ USB-Serial
PC — Backend C++/Qt
  └─ Lee 105 bytes del puerto serial
  └─ Valida SOF=0xAA · EOF=0x55 · Checksum
  └─ Decodifica 34 campos
  └─ Calcula PITCH/ROLL/YAW (Madgwick)
  └─ Calcula V_DESC = ΔALT / ΔT_MIS
  └─ Guarda CSV + timestamp T_RX
        ↓ Señales Qt (QObject / Q_PROPERTY)
Frontend QML
  └─ Dashboard en tiempo real
```

---

## 3. Estructura del Paquete de Telemetría

**99 bytes totales · 34 campos · 11 bloques funcionales**
**SOF = 0xAA · EOF = 0x55 · Payload = 95 bytes · Checksum = 2 bytes**

### 3.1 Tabla de campos

| # | Campo | Tipo | Bytes | Rango válido | Unidades |
|---|---|---|---|---|---|
| **BLOQUE 1 · Control** |
| 1 | SOF | uint8 | 1 | 0xAA | — |
| 2 | PKT_ID | uint16 | 2 | 0 – 65 535 | — |
| 3 | T_MIS | uint32 | 4 | 0 – 1 800 000 | ms |
| 4 | ESTADO | uint8 | 1 | 0 – 3 | — |
| **BLOQUE 2 · GPS NEO-6M** |
| 5 | GPS_FIX | uint8 | 1 | 0 – 2 | — |
| 6 | LAT | float32 | 4 | −90 – 90 | ° |
| 7 | LON | float32 | 4 | −180 – 180 | ° |
| 8 | SAT_N | uint8 | 1 | 0 – 24 | — |
| **BLOQUE 3 · Altitud Barométrica** |
| 9 | ALT | float32 | 4 | 0 – 1 000 | m |
| **BLOQUE 4 · Sensores Externos BME280** |
| 10 | TEMP_EXT | float32 | 4 | −40 – 85 | °C |
| 11 | PRES | float32 | 4 | 300 – 1 100 | hPa |
| 12 | HUM_EXT | float32 | 4 | 0 – 100 | % |
| **BLOQUE 5 · Sensores Internos AHT21** |
| 13 | TEMP_INT | float32 | 4 | −40 – 80 | °C |
| 14 | HUM_INT | float32 | 4 | 0 – 100 | % |
| **BLOQUE 6 · Calidad del Aire ENS160** |
| 15 | ENS_OK | uint8 | 1 | 0 – 1 | — |
| 16 | ECO2 | uint16 | 2 | 400 – 8 192 | ppm |
| 17 | TVOC | uint16 | 2 | 0 – 65 000 | ppb |
| 18 | AQI | uint8 | 1 | 1 – 5 | — |
| **BLOQUE 7 · IMU MPU-9250** |
| 19 | ACC_X | float32 | 4 | −16 – 16 | g |
| 20 | ACC_Y | float32 | 4 | −16 – 16 | g |
| 21 | ACC_Z | float32 | 4 | −16 – 16 | g |
| 22 | GYRO_X | float32 | 4 | −2 000 – 2 000 | °/s |
| 23 | GYRO_Y | float32 | 4 | −2 000 – 2 000 | °/s |
| 24 | GYRO_Z | float32 | 4 | −2 000 – 2 000 | °/s |
| 25 | MAG_X | float32 | 4 | −4 900 – 4 900 | µT |
| 26 | MAG_Y | float32 | 4 | −4 900 – 4 900 | µT |
| 27 | MAG_Z | float32 | 4 | −4 900 – 4 900 | µT |
| **BLOQUE 8 · Paracaídas** |
| 28 | PARA | uint8 | 1 | 0 – 1 | — |
| 29 | SERVO | uint16 | 2 | 0 – 180 | ° |
| **BLOQUE 9 · Cámara** |
| 30 | CAM_ST | uint8 | 1 | 0 – 2 | — |
| **BLOQUE 10 · Sistema EPS** |
| 31 | VOLT | float32 | 4 | 3.0 – 4.2 | V |
| 32 | CPU_T | float32 | 4 | −40 – 125 | °C |
| **BLOQUE 11 · Integridad** |
| 33 | CHECKSUM | uint16 | 2 | 0x0000 – 0xFFFF | — |
| 34 | EOF | uint8 | 1 | 0x55 | — |

### 3.2 Conteo de bytes

```
BLOQUE 1  · Control             →   8 bytes  (1+2+4+1)
BLOQUE 2  · GPS                 →  10 bytes  (1+4+4+1)
BLOQUE 3  · Altitud             →   4 bytes  (4)
BLOQUE 4  · BME280              →  12 bytes  (4+4+4)
BLOQUE 5  · AHT21               →   8 bytes  (4+4)
BLOQUE 6  · ENS160              →   6 bytes  (1+2+2+1)
BLOQUE 7  · IMU MPU-9250        →  36 bytes  (4×9)
BLOQUE 8  · Paracaídas          →   3 bytes  (1+2)
BLOQUE 9  · Cámara              →   1 byte   (1)
BLOQUE 10 · EPS                 →   8 bytes  (4+4)
BLOQUE 11 · Integridad          →   3 bytes  (2+1)
                                  ─────────
TOTAL                           →  99 bytes
SOF (1) + Payload (95) + Checksum (2) + EOF (1) = 99 bytes
```

### 3.3 Orden de transmisión

```
<SOF> <PKT_ID> <T_MIS> <ESTADO>
<GPS_FIX> <LAT> <LON> <SAT_N>
<ALT>
<TEMP_EXT> <PRES> <HUM_EXT>
<TEMP_INT> <HUM_INT>
<ENS_OK> <ECO2> <TVOC> <AQI>
<ACC_X> <ACC_Y> <ACC_Z>
<GYRO_X> <GYRO_Y> <GYRO_Z>
<MAG_X> <MAG_Y> <MAG_Z>
<PARA> <SERVO>
<CAM_ST>
<VOLT> <CPU_T>
<CHECKSUM> <EOF>
```

### 3.4 Descripción de campos clave

**ESTADO**
- `0` = STANDBY (Esperando lanzamiento)
- `1` = ASCENSO (En vuelo)
- `2` = DESCENSO (Paracaídas abierto)
- `3` = ATERRIZAJE (En tierra)

**GPS_FIX**
- `0` = Sin señal
- `1` = Fix 2D
- `2` = Fix 3D

**ENS_OK**
- `0` = Calentando — ECO2, TVOC y AQI no son confiables
- `1` = Listo para medición

**AQI (escala UBA)**
- `1` = Excelente · `2` = Buena · `3` = Moderada · `4` = Pobre · `5` = Malsana

**CAM_ST**
- `0` = Apagada · `1` = Encendida · `2` = Grabando en microSD

**SOF / EOF**
- `SOF = 0xAA` (10101010) — evita confusión con byte de relleno UART (0xFF)
- `EOF = 0x55` (01010101) — complemento exacto de SOF

**Checksum**
- Suma simple de todos los bytes del payload (bytes [1..95])
- Resultado almacenado como uint16 little-endian en bytes [96..97]
- Algoritmo: `checksum = (byte1 + byte2 + ... + byte95) & 0xFFFF`
- LoRa ya incluye CRC interno a nivel de radio; este checksum es una segunda verificación

---

## 4. Gestión de Tiempos

| Variable | Fuente | ¿En paquete? | Propósito |
|---|---|---|---|
| T_MIS | millis() ESP32 | ✅ uint32 4B | Tiempo desde boot. Base para V_DESC y Madgwick dt |
| T_RX | Reloj PC | ❌ añade la UI | Timestamp de recepción. Escrito en CSV |

---

## 5. Campos Calculados en Tierra

Estos valores **no se transmiten** — se calculan en el backend C++/Qt:

| Campo | Calculado desde | Algoritmo |
|---|---|---|
| V_DESC | ALT + T_MIS | `(ALT[n] − ALT[n-1]) / (T_MIS[n] − T_MIS[n-1]) × 1000` → m/s |
| PITCH | ACC + GYRO + MAG | Filtro Madgwick 9DOF |
| ROLL | ACC + GYRO + MAG | Filtro Madgwick 9DOF |
| YAW | ACC + GYRO + MAG | Filtro Madgwick 9DOF — MAG ancla YAW absoluto |
| RSSI | Ra-02 receptor | `LoRa.packetRssi()` — 2 bytes int16, añadido por ESP32 Ground |
| SNR | Ra-02 receptor | `LoRa.packetSnr()` — 4 bytes float, añadido por ESP32 Ground |

---

## 6. Struct C++ (TelemetryPacket.h)

```cpp
#pragma pack(push, 1)
struct TelemetryPacket {
    uint8_t  sof;           // [0]      0xAA
    uint16_t pktId;         // [1..2]
    uint32_t tMis;          // [3..6]
    uint8_t  estado;        // [7]
    uint8_t  gpsFix;        // [8]
    float    lat;           // [9..12]
    float    lon;           // [13..16]
    uint8_t  satN;          // [17]
    float    alt;           // [18..21]
    float    tempExt;       // [22..25]
    float    pres;          // [26..29]
    float    humExt;        // [30..33]
    float    tempInt;       // [34..37]
    float    humInt;        // [38..41]
    uint8_t  ensOk;         // [42]
    uint16_t eco2;          // [43..44]
    uint16_t tvoc;          // [45..46]
    uint8_t  aqi;           // [47]
    float    accX, accY, accZ;      // [48..59]
    float    gyroX, gyroY, gyroZ;   // [60..71]
    float    magX, magY, magZ;      // [72..83]
    uint8_t  para;          // [84]
    uint16_t servo;         // [85..86]
    uint8_t  camSt;         // [87]
    float    volt;          // [88..91]
    float    cpuT;          // [92..95]
    uint16_t checksum;      // [96..97]
    uint8_t  eof;           // [98]    0x55
};
#pragma pack(pop)

static_assert(sizeof(TelemetryPacket) == 99);
```

---

## 7. Frame Serial USB (105 bytes)

El ESP32 Ground recibe el paquete LoRa y le agrega RSSI y SNR antes de enviarlo al PC:

```
Bytes [0..98]    → Paquete LoRa completo (99 bytes)
Bytes [99..100]  → RSSI (int16_t little-endian, en dBm)
Bytes [101..104] → SNR  (float little-endian, en dB)
```

---

## 8. Validación del Paquete (PacketParser.cpp)

```
1. Buscar SOF (0xAA) en el buffer
2. Verificar EOF (0x55) en posición [98]
3. Calcular checksum: suma de bytes [1..95]
4. Comparar con checksum recibido en bytes [96..97]
5. Si coincide → paquete válido
6. Si no → descartar byte y seguir buscando
```

---

## 9. Historial de Cambios

| Versión | Cambio | Motivo |
|---|---|---|
| v7 | T_GPS eliminado | Redundante con T_RX del PC |
| v7 | CRC-16 → Checksum (suma) | Más simple; LoRa ya tiene CRC interno |
| v7 | Paquete: 103 → 99 bytes | Eliminado T_GPS (4 bytes) |
| v7 | Frame serial: 109 → 105 bytes | Consecuencia de paquete más pequeño |
| v6 | CCS811 → ENS160 | ENS160 entrega ECO2, TVOC y AQI nativamente |
| v6 | SOF: 0xFF → 0xAA | 0xFF es byte de relleno UART |
| v6 | MAG_X/Y/Z reincorporado | Necesario para YAW absoluto sin deriva |

---

## 10. Notas Técnicas

- La cámara ESP32-CAM **no transmite imágenes por LoRa**. Graba localmente en microSD.
- RSSI y SNR **no van en la trama LoRa** — los mide el Ra-02 receptor y el ESP32 Ground los añade al serial.
- ACC en unidades **g** (no m/s²). GYRO en °/s. MAG en µT.
- `#pragma pack(1)` es obligatorio para evitar padding del compilador.
- Duración máxima de misión: 30 minutos → T_MIS máximo: 1 800 000 ms.
- Paquetes totales estimados a ~3 Hz: ~5 400 · CSV estimado: ~900 KB.
