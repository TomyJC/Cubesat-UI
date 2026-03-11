#ifndef CSVWRITER_H
#define CSVWRITER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include "TelemetryPacket.h"

class CsvWriter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool grabando READ grabando NOTIFY grabandoCambiado)
    Q_PROPERTY(QString archivoActual READ archivoActual NOTIFY grabandoCambiado)

public:
    explicit CsvWriter(QObject *parent = nullptr);
    ~CsvWriter();

    bool grabando() const;
    QString archivoActual() const;

    Q_INVOKABLE bool iniciarSesion(const QString &directorio);
    Q_INVOKABLE void finalizarSesion();

public slots:
    void escribirPaquete(TelemetryPacket pkt, int16_t rssi, float snr,
                         double vDesc, double pitch, double roll, double yaw,
                         const QString &estadoStr);

signals:
    void grabandoCambiado();

private:
    QFile m_file;
    QTextStream m_stream;
    bool m_grabando = false;
    QString m_archivoActual;

    void escribirEncabezado();
};

#endif // CSVWRITER_H
