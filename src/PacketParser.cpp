#include "PacketParser.h"
#include <cstring>

PacketParser::PacketParser(QObject *parent)
    : QObject(parent)
{
}

void PacketParser::procesarDatos(const QByteArray &datos)
{
    m_buffer.append(datos);

    // Procesar todos los frames disponibles en el buffer
    while (buscarFrame()) {
        // buscarFrame emite señales internamente
    }

    // Limitar tamaño del buffer para evitar crecimiento infinito
    if (m_buffer.size() > FRAME_SIZE * 10) {
        quint32 descartados = m_buffer.size() - FRAME_SIZE * 2;
        m_buffer.remove(0, descartados);
        emit paqueteInvalido(descartados);
    }
}

bool PacketParser::buscarFrame()
{
    while (m_buffer.size() >= FRAME_SIZE) {
        // Buscar SOF
        int sofIdx = -1;
        // Cast a int para evitar underflow si m_buffer.size() < FRAME_SIZE
        for (int i = 0; i <= static_cast<int>(m_buffer.size()) - FRAME_SIZE; ++i) {
            if (static_cast<uint8_t>(m_buffer.at(i)) == SOF_BYTE) {
                sofIdx = i;
                break;
            }
        }

        if (sofIdx < 0)
            return false;

        // Descartar bytes anteriores al SOF
        if (sofIdx > 0) {
            emit paqueteInvalido(static_cast<quint32>(sofIdx));
            m_buffer.remove(0, sofIdx);
        }

        // Verificar que tenemos suficientes bytes para un frame completo
        if (m_buffer.size() < FRAME_SIZE)
            return false;

        const auto *raw = reinterpret_cast<const uint8_t *>(m_buffer.constData());

        // Verificar EOF en posición esperada
        if (raw[EOF_OFFSET] != EOF_BYTE) {
            // SOF falso — descartar este byte y seguir buscando
            emit paqueteInvalido(1);
            m_buffer.remove(0, 1);
            continue;
        }

        // Validar checksum sobre payload [1..95]
        uint16_t checksumCalculado = calcularChecksum(raw + PAYLOAD_START, PAYLOAD_END);
        uint16_t checksumRecibido;
        std::memcpy(&checksumRecibido, raw + CRC_OFFSET, sizeof(uint16_t));

        if (checksumCalculado != checksumRecibido) {
            emit paqueteInvalido(1);
            m_buffer.remove(0, 1);
            continue;
        }

        // Frame válido — extraer paquete + RSSI + SNR
        TelemetryPacket pkt;
        std::memcpy(&pkt, raw, PACKET_SIZE);

        int16_t rssi;
        float snr;
        std::memcpy(&rssi, raw + PACKET_SIZE, sizeof(int16_t));
        std::memcpy(&snr, raw + PACKET_SIZE + sizeof(int16_t), sizeof(float));

        // Consumir el frame del buffer
        m_buffer.remove(0, FRAME_SIZE);

        emit paqueteValido(pkt, rssi, snr);
        return true;
    }

    return false;
}

// Checksum: suma simple de todos los bytes del payload
uint16_t PacketParser::calcularChecksum(const uint8_t *data, int length)
{
    uint16_t suma = 0;
    for (int i = 0; i < length; ++i)
        suma += data[i];
    return suma;
}
