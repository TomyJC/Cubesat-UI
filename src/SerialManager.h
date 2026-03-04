#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>
#include <QStringList>

class SerialManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList puertosDisponibles READ puertosDisponibles NOTIFY puertosActualizados)
    Q_PROPERTY(bool conectado READ conectado NOTIFY conectadoCambiado)

public:
    explicit SerialManager(QObject *parent = nullptr);

    QStringList puertosDisponibles() const;
    bool conectado() const;

    Q_INVOKABLE bool conectar(const QString &puerto, int baudrate);
    Q_INVOKABLE void desconectar();
    Q_INVOKABLE void escanearPuertos();

signals:
    void datosRecibidos(const QByteArray &datos);
    void errorConexion(const QString &mensaje);
    void puertosActualizados();
    void conectadoCambiado();

private slots:
    void onDatosDisponibles();
    void onErrorSerial(QSerialPort::SerialPortError error);
    void onEscaneoTimer();

private:
    QSerialPort m_serial;
    QTimer m_scanTimer;
    QStringList m_puertos;
    bool m_conectado = false;

    void setConectado(bool c);
};

#endif // SERIALMANAGER_H
