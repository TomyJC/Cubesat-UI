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

public:
    // Estados de conexión serial
    enum EstadoConexion {
        Desconectado = 0,   // Puerto cerrado
        Conectando   = 1,   // Puerto abierto, esperando primer paquete válido
        Conectado    = 2    // Paquete válido recibido, comunicación activa
    };
    Q_ENUM(EstadoConexion)

    Q_PROPERTY(QStringList puertosDisponibles READ puertosDisponibles NOTIFY puertosActualizados)
    Q_PROPERTY(int estadoConexion READ estadoConexion NOTIFY estadoConexionCambiado)
    // Mantener "conectado" como propiedad derivada para VistaTelemetria
    Q_PROPERTY(bool conectado READ conectado NOTIFY estadoConexionCambiado)

    explicit SerialManager(QObject *parent = nullptr);

    QStringList puertosDisponibles() const;
    int estadoConexion() const;
    bool conectado() const;

    Q_INVOKABLE bool conectar(const QString &puerto, int baudrate);
    Q_INVOKABLE void desconectar();
    Q_INVOKABLE void escanearPuertos();

public slots:
    // Llamado cuando llega el primer paquete válido → pasa de Conectando a Conectado
    void confirmarConexion();

signals:
    void datosRecibidos(const QByteArray &datos);
    void errorConexion(const QString &mensaje);
    void puertosActualizados();
    void estadoConexionCambiado();

private slots:
    void onDatosDisponibles();
    void onErrorSerial(QSerialPort::SerialPortError error);
    void onEscaneoTimer();
    void onTimeoutConexion();

private:
    QSerialPort m_serial;
    QTimer m_scanTimer;
    QTimer m_timeoutTimer;          // Timeout para recibir primer paquete
    QStringList m_puertos;
    EstadoConexion m_estado = Desconectado;

    static const int TIMEOUT_CONEXION_MS = 8000;  // 8 segundos para recibir datos

    void setEstado(EstadoConexion nuevoEstado);
};

#endif // SERIALMANAGER_H
