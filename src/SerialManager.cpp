#include "SerialManager.h"

SerialManager::SerialManager(QObject *parent)
    : QObject(parent)
{
    connect(&m_serial, &QSerialPort::readyRead,
            this, &SerialManager::onDatosDisponibles);
    connect(&m_serial, &QSerialPort::errorOccurred,
            this, &SerialManager::onErrorSerial);

    // Escanear puertos cada 2 segundos cuando está desconectado
    connect(&m_scanTimer, &QTimer::timeout,
            this, &SerialManager::onEscaneoTimer);
    m_scanTimer.setInterval(2000);
    m_scanTimer.start();

    // Timer de timeout: si no llega paquete válido, desconectar
    m_timeoutTimer.setSingleShot(true);
    connect(&m_timeoutTimer, &QTimer::timeout,
            this, &SerialManager::onTimeoutConexion);

    // Escaneo inicial
    escanearPuertos();
}

QStringList SerialManager::puertosDisponibles() const
{
    return m_puertos;
}

int SerialManager::estadoConexion() const
{
    return static_cast<int>(m_estado);
}

bool SerialManager::conectado() const
{
    return m_estado == Conectado;
}

bool SerialManager::conectar(const QString &puerto, int baudrate)
{
    // Si ya estaba conectado/conectando, desconectar primero
    if (m_estado != Desconectado)
        desconectar();

    m_serial.setPortName(puerto);
    m_serial.setBaudRate(baudrate);
    m_serial.setDataBits(QSerialPort::Data8);
    m_serial.setParity(QSerialPort::NoParity);
    m_serial.setStopBits(QSerialPort::OneStop);
    m_serial.setFlowControl(QSerialPort::NoFlowControl);

    if (!m_serial.open(QIODevice::ReadOnly)) {
        emit errorConexion(m_serial.errorString());
        return false;
    }

    // Puerto abierto → estado CONECTANDO, esperando primer paquete válido
    setEstado(Conectando);
    m_scanTimer.stop();
    m_timeoutTimer.start(TIMEOUT_CONEXION_MS);
    return true;
}

void SerialManager::desconectar()
{
    m_timeoutTimer.stop();

    if (m_serial.isOpen())
        m_serial.close();

    setEstado(Desconectado);
    m_scanTimer.start();
}

void SerialManager::escanearPuertos()
{
    QStringList nuevos;
    const auto ports = QSerialPortInfo::availablePorts();
    for (const auto &info : ports)
        nuevos.append(info.portName());

    if (nuevos != m_puertos) {
        m_puertos = nuevos;
        emit puertosActualizados();
    }
}

void SerialManager::confirmarConexion()
{
    // Solo transicionar si estamos en CONECTANDO
    if (m_estado != Conectando)
        return;

    m_timeoutTimer.stop();
    setEstado(Conectado);
}

void SerialManager::onDatosDisponibles()
{
    const QByteArray datos = m_serial.readAll();
    if (!datos.isEmpty())
        emit datosRecibidos(datos);
}

void SerialManager::onErrorSerial(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::NoError)
        return;

    // Errores críticos que desconectan
    if (error == QSerialPort::ResourceError ||
        error == QSerialPort::DeviceNotFoundError) {
        emit errorConexion(m_serial.errorString());
        desconectar();
    }
}

void SerialManager::onEscaneoTimer()
{
    if (m_estado == Desconectado)
        escanearPuertos();
}

void SerialManager::onTimeoutConexion()
{
    // Pasaron 8 segundos sin recibir paquete válido
    emit errorConexion("Timeout: no se recibieron datos válidos en "
                       + QString::number(TIMEOUT_CONEXION_MS / 1000) + " segundos");
    desconectar();
}

void SerialManager::setEstado(EstadoConexion nuevoEstado)
{
    if (m_estado != nuevoEstado) {
        m_estado = nuevoEstado;
        emit estadoConexionCambiado();
    }
}
