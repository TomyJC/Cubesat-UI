#ifndef PACKETPARSER_H
#define PACKETPARSER_H

#include <QObject>
#include <QByteArray>
#include "TelemetryPacket.h"

class PacketParser : public QObject
{
    Q_OBJECT

public:
    explicit PacketParser(QObject *parent = nullptr);

public slots:
    void procesarDatos(const QByteArray &datos);

signals:
    void paqueteValido(TelemetryPacket pkt, int16_t rssi, float snr);
    void paqueteInvalido(quint32 bytesDescartados);

private:
    QByteArray m_buffer;

    bool buscarFrame();
    static uint16_t calcularChecksum(const uint8_t *data, int length);
};

#endif // PACKETPARSER_H
