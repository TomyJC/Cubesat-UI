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

    // Escaneo inicial
    escanearPuertos();
}

QStringList SerialManager::puertosDisponibles() const
{
    return m_puertos;
}

bool SerialManager::conectado() const
{
    return m_conectado;
}

bool SerialManager::conectar(const QString &puerto, int baudrate)
{
    if (m_conectado)
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

    setConectado(true);
    m_scanTimer.stop();
    return true;
}

void SerialManager::desconectar()
{
    if (m_serial.isOpen())
        m_serial.close();

    setConectado(false);
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
    if (!m_conectado)
        escanearPuertos();
}

void SerialManager::setConectado(bool c)
{
    if (m_conectado != c) {
        m_conectado = c;
        emit conectadoCambiado();
    }
}
