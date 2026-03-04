# TELSTAR — Documentación Técnica de Telemetría
**CanSat · LoRa Ra-02 · 433 MHz**
**Versión 6 · Corregida**

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
| NEO-6M | GPS (LAT, LON, T_GPS, SAT_N) |
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
| ToA estimado | ~335 ms |
| Frecuencia de actualización | ~3 Hz |
| Alcance estimado | ~3–5 km |

### 2.1 Flujo de datos completo

```
ESP32 CanSat
  └─ Serializa 103 bytes
        ↓ RF 433 MHz · LoRa SF8/BW125
ESP32 Ground Station
  └─ LoRa.parsePacket(103 bytes)
  └─ LoRa.packetRssi() → RSSI (2 bytes)
  └─ LoRa.packetSnr()  → SNR  (4 bytes)
  └─ Serial.write(109 bytes totales)
        ↓ USB-Serial
PC — Backend C++/Qt
  └─ Lee 109 bytes del puerto serial
  └─ Valida SOF=0xAA · EOF=0x55 · CRC-16
  └─ Decodifica 35 campos
  └─ Calcula PITCH/ROLL/YAW (Madgwick)
  └─ Calcula V_DESC = ΔALT / ΔT_MIS
  └─ Guarda CSV + timestamp T_RX
        ↓ Señales Qt (QObject / Q_PROPERTY)
Frontend QML
  └─ Dashboard en tiempo real
  └─ Mapa GPS · Trayectoria
  └─ Alertas WARNING / CRITICAL
  └─ Cronómetro T_MISIÓN
```

---

## 3. Estructura del Paquete de Telemetría

**103 bytes totales · 35 campos · 11 bloques funcionales**
**SOF = 0xAA · EOF = 0x55 · Payload = 99 bytes · CRC = 2 bytes**

### 3.1 Tabla de campos

| # | Campo | Tipo | Bytes | Rango válido | Unidades | Resolución |
|---|---|---|---|---|---|---|
| **BLOQUE 1 · Control** |
| 1 | SOF | uint8 | 1 | 0xAA | — | — |
| 2 | PKT_ID | uint16 | 2 | 0 – 65 535 | — | 1 pkt |
| 3 | T_MIS | uint32 | 4 | 0 – 1 800 000 | ms | 1 ms |
| 4 | ESTADO | uint8 | 1 | 0 – 3 | — | — |
| **BLOQUE 2 · GPS NEO-6M** |
| 5 | GPS_FIX | uint8 | 1 | 0 – 2 | — | — |
| 6 | T_GPS | uint32 | 4 | 0 – 86 400 | s | 1 s |
| 7 | LAT | float32 | 4 | −90 – 90 | ° | 0.00001° |
| 8 | LON | float32 | 4 | −180 – 180 | ° | 0.00001° |
| 9 | SAT_N | uint8 | 1 | 0 – 24 | — | 1 sat |
| **BLOQUE 3 · Altitud Barométrica** |
| 10 | ALT | float32 | 4 | 0 – 1 000 | m | 0.01 m |
| **BLOQUE 4 · Sensores Externos BME280** |
| 11 | TEMP_EXT | float32 | 4 | −40 – 85 | °C | 0.01 °C |
| 12 | PRES | float32 | 4 | 300 – 1 100 | hPa | 0.01 hPa |
| 13 | HUM_EXT | float32 | 4 | 0 – 100 | % | 0.01 % |
| **BLOQUE 5 · Sensores Internos AHT21** |
| 14 | TEMP_INT | float32 | 4 | −40 – 80 | °C | 0.01 °C |
| 15 | HUM_INT | float32 | 4 | 0 – 100 | % | 0.01 % |
| **BLOQUE 6 · Calidad del Aire ENS160** |
| 16 | ENS_OK | uint8 | 1 | 0 – 1 | — | — |
| 17 | ECO2 | uint16 | 2 | 400 – 8 192 | ppm | 1 ppm |
| 18 | TVOC | uint16 | 2 | 0 – 65 000 | ppb | 1 ppb |
| 19 | AQI | uint8 | 1 | 1 – 5 | — | 1 |
| **BLOQUE 7 · IMU MPU-9250** |
| 20 | ACC_X | float32 | 4 | −16 – 16 | g | 0.001 g |
| 21 | ACC_Y | float32 | 4 | −16 – 16 | g | 0.001 g |
| 22 | ACC_Z | float32 | 4 | −16 – 16 | g | 0.001 g |
| 23 | GYRO_X | float32 | 4 | −2 000 – 2 000 | °/s | 0.061 °/s |
| 24 | GYRO_Y | float32 | 4 | −2 000 – 2 000 | °/s | 0.061 °/s |
| 25 | GYRO_Z | float32 | 4 | −2 000 – 2 000 | °/s | 0.061 °/s |
| 26 | MAG_X | float32 | 4 | −4 900 – 4 900 | µT | 0.15 µT |
| 27 | MAG_Y | float32 | 4 | −4 900 – 4 900 | µT | 0.15 µT |
| 28 | MAG_Z | float32 | 4 | −4 900 – 4 900 | µT | 0.15 µT |
| **BLOQUE 8 · Paracaídas** |
| 29 | PARA | uint8 | 1 | 0 – 1 | — | — |
| 30 | SERVO | uint16 | 2 | 0 – 180 | ° | 1° |
| **BLOQUE 9 · Cámara** |
| 31 | CAM_ST | uint8 | 1 | 0 – 2 | — | — |
| **BLOQUE 10 · Sistema EPS** |
| 32 | VOLT | float32 | 4 | 3.0 – 4.2 | V | 0.01 V |
| 33 | CPU_T | float32 | 4 | −40 – 125 | °C | 0.01 °C |
| **BLOQUE 11 · Integridad** |
| 34 | CRC | uint16 | 2 | 0x0000 – 0xFFFF | — | — |
| 35 | EOF | uint8 | 1 | 0x55 | — | — |

### 3.2 Conteo de bytes

```
BLOQUE 1  · Control             →   8 bytes  (1+2+4+1)
BLOQUE 2  · GPS                 →  14 bytes  (1+4+4+4+1)
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
TOTAL                           → 103 bytes
SOF (1) + Payload (99) + CRC (2) + EOF (1) = 103 bytes
```

### 3.3 Orden de transmisión

```
<SOF> <PKT_ID> <T_MIS> <ESTADO>
<GPS_FIX> <T_GPS> <LAT> <LON> <SAT_N>
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
<CRC> <EOF>
```

### 3.4 Descripción de campos clave

**ESTADO**
- `0` = STANDBY (Inicialización)
- `1` = ASCENSO (En vuelo)
- `2` = DESCENSO
- `3` = ATERRIZAJE (Tierra)

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

**CRC-16**
- Calculado sobre el payload completo (PKT_ID → CPU_T = 99 bytes, índices 1..99)
- Verificado por el receptor antes de procesar cualquier dato

---

## 4. Gestión de Tiempos

| Variable | Fuente | ¿En paquete? | Propósito |
|---|---|---|---|
| T_MIS | millis() ESP32 | ✅ uint32 4B | Detectar reinicios ESP32. Base para V_DESC |
| T_GPS | Reloj GPS UTC | ✅ uint32 4B | Referencia absoluta. Base para T_MISIÓN |
| T_RX | Reloj PC | ❌ añade la UI | Fallback si GPS_FIX=0. Mide latencia LoRa |
| T_MISIÓN | T_GPS[n] − T_GPS[launch] | ❌ calcula la UI | Cronómetro visible al operador |

> **Procedimiento pre-lanzamiento:** encender el sistema ≥ 3 minutos antes del lanzamiento para que el NEO-6M adquiera fix GPS y el ENS160 complete su calentamiento (ENS_OK = 1).

---

## 5. Campos Calculados en Tierra

Estos valores **no se transmiten** — se calculan en el backend C++/Qt a partir de los datos recibidos:

| Campo | Calculado desde | Algoritmo |
|---|---|---|
| V_DESC | ALT + T_MIS | `(ALT[n] − ALT[n-1]) / (T_MIS[n] − T_MIS[n-1]) × 1000` (resultado en m/s) |
| PITCH | ACC + GYRO + MAG | Filtro Madgwick |
| ROLL | ACC + GYRO + MAG | Filtro Madgwick |
| YAW | ACC + GYRO + MAG | Filtro Madgwick — MAG ancla YAW absoluto sin deriva |
| T_MISIÓN | T_GPS | `T_GPS_actual − T_GPS_lanzamiento` |
| RSSI | Ra-02 receptor | `LoRa.packetRssi()` — añadido por ESP32 al serial (2 bytes, int16) |
| SNR | Ra-02 receptor | `LoRa.packetSnr()` — añadido por ESP32 al serial (4 bytes, float) |

---

## 6. Struct C++ para ESP32

```cpp
#pragma pack(push, 1)
typedef struct {
    // BLOQUE 1 · Control
    uint8_t  SOF;        // 0xAA
    uint16_t PKT_ID;
    uint32_t T_MIS;
    uint8_t  ESTADO;

    // BLOQUE 2 · GPS
    uint8_t  GPS_FIX;
    uint32_t T_GPS;
    float    LAT;
    float    LON;
    uint8_t  SAT_N;

    // BLOQUE 3 · Altitud Barométrica
    float    ALT;

    // BLOQUE 4 · Sensores Externos (BME280)
    float    TEMP_EXT;
    float    PRES;
    float    HUM_EXT;

    // BLOQUE 5 · Sensores Internos (AHT21)
    float    TEMP_INT;
    float    HUM_INT;

    // BLOQUE 6 · Calidad del Aire (ENS160)
    uint8_t  ENS_OK;
    uint16_t ECO2;
    uint16_t TVOC;
    uint8_t  AQI;

    // BLOQUE 7 · IMU (MPU-9250 + AK8963)
    float    ACC_X,  ACC_Y,  ACC_Z;
    float    GYRO_X, GYRO_Y, GYRO_Z;
    float    MAG_X,  MAG_Y,  MAG_Z;

    // BLOQUE 8 · Paracaídas
    uint8_t  PARA;
    uint16_t SERVO;

    // BLOQUE 9 · Cámara
    uint8_t  CAM_ST;

    // BLOQUE 10 · Sistema / EPS
    float    VOLT;
    float    CPU_T;

    // BLOQUE 11 · Integridad
    uint16_t CRC;
    uint8_t  EOF_BYTE;  // 0x55
} TelemetryPacket_t;
#pragma pack(pop)

// Verificación en compilación — debe dar 103
static_assert(sizeof(TelemetryPacket_t) == 103, "ERROR: Tamaño de trama incorrecto");
```

---

## 7. Validación del Paquete (Qt C++)

```cpp
bool validatePacket(const QByteArray& data) {
    if (data.size() != 103) return false;

    // Verificar SOF y EOF
    if ((uint8_t)data[0] != 0xAA) return false;
    if ((uint8_t)data[102] != 0x55) return false;

    // Verificar CRC-16 (PKT_ID → CPU_T = bytes 1 a 99, 99 bytes de payload)
    uint16_t crc_calc = crc16(data.mid(1, 99));
    uint16_t crc_recv = (uint8_t)data[100] | ((uint8_t)data[101] << 8);
    return crc_calc == crc_recv;
}
```

### 7.1 Mapa de índices del paquete (103 bytes)

```
Byte [0]        → SOF (0xAA)
Bytes [1..99]   → Payload (99 bytes: PKT_ID → CPU_T)
Bytes [100..101] → CRC-16 (little-endian)
Byte [102]      → EOF (0x55)
```

---

## 8. Estación Terrena

### 8.1 Arquitectura de software

```
Backend C++/Qt
  ├── QSerialPort      → lectura USB-Serial (109 bytes)
  ├── PacketParser     → validación SOF · CRC-16 · EOF
  ├── TelemetryDecoder → decodificación 35 campos
  ├── MadgwickFilter   → PITCH · ROLL · YAW
  ├── VDescCalculator  → ΔALT / ΔT_MIS
  └── CsvWriter        → almacenamiento ~1 800 registros
        ↓ Señales Qt (Q_PROPERTY / NOTIFY)
Frontend QML
  ├── Dashboard        → todos los campos en tiempo real
  ├── MapView          → trayectoria GPS en vivo
  ├── AlertSystem      → WARNING · CRITICAL
  └── MissionTimer     → T_MISIÓN 00:00:00
```

### 8.2 Estructura del frame serial (109 bytes)

```
[103 bytes LoRa packet] [2 bytes RSSI (int16)] [4 bytes SNR (float)]
       ↑ SOF...EOF              ↑ packetRssi()        ↑ packetSnr()
```

### 8.3 Operadores

| Rol | Personas | Responsabilidades |
|---|---|---|
| Operador de Misión | 1 | Checklist pre-vuelo · Coordinación · Confirmar 1er paquete · INICIO/FIN · Alertas |
| Técnico de Sistemas | 1 | Ra-02 + ESP32 · CRC-16 <5% · Latencia USB · SF/BW · Reinicio de enlace |
| Analista de Datos | 1 | ENS_OK=1 · ESTADO 0→1→2→3 · AQI/ECO2/TVOC · Altitud post-vuelo · CSV + Reporte |
| **Total** | **3** | **1 estación terrena · 1 PC** |

---

## 9. Historial de Cambios

| Campo | Acción | Motivo | Δ Bytes |
|---|---|---|---|
| PITCH / ROLL / YAW | Eliminado | Calculados en tierra con filtro Madgwick | −12 |
| ORI_EST | Eliminado | Derivado de orientación, innecesario | −1 |
| HDOP | Eliminado | GPS_FIX + SAT_N suficiente | −2 |
| ALT_GPS | Eliminado | ALT barométrica más precisa para CanSat | −4 |
| VEL_X/Y/Z | Eliminado | V_DESC se calcula en tierra | −12 |
| MAG_X/Y/Z | Reincorporado | Necesario para YAW absoluto sin deriva | +12 |
| AQI | Añadido | Registro nativo del ENS160 (escala UBA 1–5) | +1 |
| TEMP_INT / HUM_INT | Añadido | Temperatura y humedad interior (AHT21) | +8 |
| CCS811 → ENS160 | Sensor cambiado | ENS160 entrega ECO2, TVOC y AQI nativamente | 0 |
| SOF: 0xFF → 0xAA | Corregido | 0xFF es byte de relleno UART | 0 |
| EOF: 0xFE → 0x55 | Corregido | Complemento de SOF, protocolo consistente | 0 |

**Versión inicial:** 111 bytes
**Versión final:** 103 bytes (−8 bytes, −7%)

### 9.1 Correcciones v6

| Error | Antes | Corregido |
|---|---|---|
| Tamaño total del paquete | 101 bytes | **103 bytes** (faltaba CRC en la ecuación) |
| static_assert | == 101 | **== 103** |
| validatePacket índices | data[100]=EOF, CRC en [99..100] | **data[102]=EOF, CRC en [100..101]** |
| CRC payload size | data.mid(1, 98) | **data.mid(1, 99)** |
| Bytes por serial | 107 | **109** (103 + RSSI(2) + SNR(4)) |
| Unidades ACC | m/s² | **g** (rango ±16g del MPU-9250) |
| Nombres ESTADO | Inconsistentes con UI | **Unificados** (STANDBY/ASCENSO/DESCENSO/ATERRIZAJE) |

---

## 10. Notas Técnicas

- La cámara ESP32-CAM **no transmite imágenes por LoRa**. Graba localmente en microSD.
- RSSI y SNR **no van en la trama LoRa** — los mide el Ra-02 receptor y el ESP32 los añade al serial tras el paquete de 103 bytes.
- El filtro Madgwick requiere MAG_X/Y/Z para calcular YAW absoluto sin deriva de giroscopio.
- `#pragma pack(1)` es obligatorio en la struct para evitar padding del compilador.
- El `static_assert` verifica en compilación que el tamaño sea exactamente 103 bytes.
- Duración máxima de misión: 30 minutos → T_MIS máximo: 1 800 000 ms.
- Paquetes totales estimados a ~3 Hz: ~5 400 · CSV estimado: ~900 KB – 1.2 MB.
- ACC en unidades **g** (no m/s²). Para convertir: 1g = 9.80665 m/s².
