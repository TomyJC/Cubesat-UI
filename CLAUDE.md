# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
CanSat ground station (PUCP) — C++ backend + QML frontend, Qt 6.10.2 MinGW 64-bit, CMake 3.16+.
Receives 105-byte serial frames from ESP32 Ground (LoRa 433 MHz), decodes telemetry, displays real-time dashboard.

**Language convention**: Spanish for UI text and comments, English for code identifiers.

## Build Commands
```bash
# Configure (first time only)
/c/Qt/Tools/CMake_64/bin/cmake.exe -S . -B build -G "MinGW Makefiles" \
  -DCMAKE_PREFIX_PATH=/c/Qt/6.10.2/mingw_64

# Build
/c/Qt/Tools/CMake_64/bin/cmake.exe --build build/
```
No tests exist yet. No linter configured.

## Architecture

### Signal chain (main.cpp)
```
SerialManager::datosRecibidos → PacketParser::procesarDatos
PacketParser::paqueteValido   → TelemetryData::onPaqueteValido
PacketParser::paqueteValido   → CsvWriter::escribirPaquete
PacketParser::paqueteInvalido → TelemetryData::onPaqueteInvalido
```
Objects exposed to QML as context properties: `serialManager`, `telemetry`, `csvWriter`.

### Backend (src/)
| Class | Role |
|-------|------|
| `TelemetryPacket.h` | `#pragma pack(push,1)` structs: `TelemetryPacket` (99B), `SerialFrame` (105B) with static_assert |
| `SerialManager` | QSerialPort wrapper, port scanning every 2s, Q_INVOKABLE `conectar`/`desconectar` |
| `PacketParser` | Accumulates bytes in buffer, validates SOF/EOF/CRC-16 (CCITT-FALSE), emits valid/invalid |
| `TelemetryData` | Central model: ~44 Q_PROPERTYs (all emit single `datosActualizados` signal), owns `VDescCalculator` + `MadgwickFilter` |
| `VDescCalculator` | ΔALT/ΔT_MIS → m/s descent velocity |
| `MadgwickFilter` | AHRS quaternion filter (9DOF with mag, falls back to 6DOF), outputs pitch/roll/yaw in degrees |
| `CsvWriter` | Writes 40-column CSV with T_RX timestamp per session |

### Frontend (assets/qml/)
- QML Module URI: `TELSTAR_OFFICIAL` (registered in CMakeLists.txt)
- `Theme.qml` is a **singleton** — all colors/styles reference it. **Do not modify without asking first.**
- All data panels extend `Componentes/TarjetaDeDatos.qml` as their base container
- Panels bind to `telemetry.*` properties directly from context
- `Main.qml` → `Encabezado` (header) + `VistaTelemetria` (dashboard with 8 panels in 2-row grid: 68%/32%)

### Telemetry protocol (99 bytes)
```
[0]=SOF(0xAA) [1..95]=Payload(34 fields) [96..97]=CRC-16 LE [98]=EOF(0x55)
```
Serial frame adds 6 bytes after EOF: RSSI(int16) + SNR(float) = 105 bytes total.
Full protocol spec: `TELSTAR_documentacion.md`

## Key Conventions
- Struct fields always `#pragma pack(push, 1)` with static_assert on size
- Units: ACC in **g** (not m/s²), GYRO in °/s, MAG in µT
- T_MIS = milliseconds since ESP32 boot; used for dt calculations (Madgwick, V_DESC)
- Mission states: 0=STANDBY, 1=ASCENSO, 2=DESCENSO, 3=ATERRIZAJE
- Fields without a physical sensor (corriente, cpuLoad) return -1

## Rules
- **No git push** without explicit authorization
- **No modifying Theme.qml** without consulting first
- New QML files must be added to `qt_add_qml_module()` in CMakeLists.txt
- New C++ source files must be added to `qt_add_executable()` in CMakeLists.txt
