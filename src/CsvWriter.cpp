#include "CsvWriter.h"
#include <QDir>
#include <QDateTime>

CsvWriter::CsvWriter(QObject *parent)
    : QObject(parent)
{
}

CsvWriter::~CsvWriter()
{
    finalizarSesion();
}

bool CsvWriter::grabando() const { return m_grabando; }
QString CsvWriter::archivoActual() const { return m_archivoActual; }

bool CsvWriter::iniciarSesion(const QString &directorio)
{
    finalizarSesion();

    QDir dir(directorio);
    if (!dir.exists())
        dir.mkpath(".");

    QString nombre = QStringLiteral("TELSTAR_%1.csv")
        .arg(QDateTime::currentDateTime().toString("yyyy-MM-dd_HH-mm-ss"));

    m_archivoActual = dir.filePath(nombre);
    m_file.setFileName(m_archivoActual);

    if (!m_file.open(QIODevice::WriteOnly | QIODevice::Text))
        return false;

    m_stream.setDevice(&m_file);
    escribirEncabezado();
    m_grabando = true;
    emit grabandoCambiado();
    return true;
}

void CsvWriter::finalizarSesion()
{
    if (!m_grabando) return;

    m_stream.flush();
    m_file.close();
    m_grabando = false;
    emit grabandoCambiado();
}

void CsvWriter::escribirPaquete(TelemetryPacket pkt, int16_t rssi, float snr)
{
    if (!m_grabando) return;

    // T_RX con precisión de milisegundos
    QString tRx = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss.zzz");

    m_stream << tRx << ","
             << pkt.pktId << ","
             << pkt.tMis << ","
             << pkt.estado << ","
             << pkt.gpsFix << ","
             << QString::number(pkt.lat, 'f', 6) << ","
             << QString::number(pkt.lon, 'f', 6) << ","
             << pkt.satN << ","
             << QString::number(pkt.alt, 'f', 2) << ","
             << QString::number(pkt.tempExt, 'f', 2) << ","
             << QString::number(pkt.pres, 'f', 2) << ","
             << QString::number(pkt.humExt, 'f', 2) << ","
             << QString::number(pkt.tempInt, 'f', 2) << ","
             << QString::number(pkt.humInt, 'f', 2) << ","
             << pkt.ensOk << ","
             << pkt.eco2 << ","
             << pkt.tvoc << ","
             << pkt.aqi << ","
             << QString::number(pkt.accX, 'f', 4) << ","
             << QString::number(pkt.accY, 'f', 4) << ","
             << QString::number(pkt.accZ, 'f', 4) << ","
             << QString::number(pkt.gyroX, 'f', 4) << ","
             << QString::number(pkt.gyroY, 'f', 4) << ","
             << QString::number(pkt.gyroZ, 'f', 4) << ","
             << QString::number(pkt.magX, 'f', 2) << ","
             << QString::number(pkt.magY, 'f', 2) << ","
             << QString::number(pkt.magZ, 'f', 2) << ","
             << pkt.para << ","
             << pkt.servo << ","
             << pkt.camSt << ","
             << QString::number(pkt.volt, 'f', 3) << ","
             << QString::number(pkt.cpuT, 'f', 1) << ","
             << pkt.checksum << ","
             << rssi << ","
             << QString::number(snr, 'f', 2) << ","
             // Campos calculados (vacíos por ahora, se pueden agregar)
             << ","  // V_DESC placeholder
             << ","  // PITCH placeholder
             << ","  // ROLL placeholder
             << ","  // YAW placeholder
             << ","  // ESTADO_STR placeholder
             << "\n";

    m_stream.flush();
}

void CsvWriter::escribirEncabezado()
{
    m_stream << "T_RX,"
             << "PKT_ID,T_MIS,ESTADO,GPS_FIX,"
             << "LAT,LON,SAT_N,ALT,"
             << "TEMP_EXT,PRES,HUM_EXT,"
             << "TEMP_INT,HUM_INT,"
             << "ENS_OK,ECO2,TVOC,AQI,"
             << "ACC_X,ACC_Y,ACC_Z,"
             << "GYRO_X,GYRO_Y,GYRO_Z,"
             << "MAG_X,MAG_Y,MAG_Z,"
             << "PARA,SERVO,CAM_ST,"
             << "VOLT,CPU_T,CHECKSUM,"
             << "RSSI,SNR,"
             << "V_DESC,PITCH,ROLL,YAW,ESTADO_STR"
             << "\n";
}
