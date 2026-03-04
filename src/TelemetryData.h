#ifndef TELEMETRYDATA_H
#define TELEMETRYDATA_H

#include <QObject>
#include <QString>
#include "TelemetryPacket.h"
#include "VDescCalculator.h"
#include "MadgwickFilter.h"

class TelemetryData : public QObject
{
    Q_OBJECT

    // --- PanelEstadoMision ---
    Q_PROPERTY(QString estado READ estado NOTIFY datosActualizados)
    Q_PROPERTY(QString estadoParacaidas READ estadoParacaidas NOTIFY datosActualizados)
    Q_PROPERTY(QString tiempoMision READ tiempoMision NOTIFY datosActualizados)
    Q_PROPERTY(int paquetesRecibidos READ paquetesRecibidos NOTIFY datosActualizados)
    Q_PROPERTY(int servo READ servo NOTIFY datosActualizados)
    Q_PROPERTY(QString gpsFix READ gpsFix NOTIFY datosActualizados)
    Q_PROPERTY(QString ens160Estado READ ens160Estado NOTIFY datosActualizados)
    Q_PROPERTY(QString camaraEstado READ camaraEstado NOTIFY datosActualizados)
    Q_PROPERTY(double altitud READ altitud NOTIFY datosActualizados)
    Q_PROPERTY(double altitudMaxima READ altitudMaxima NOTIFY datosActualizados)
    Q_PROPERTY(bool altitudDisponible READ altitudDisponible NOTIFY datosActualizados)

    // --- PanelBateria ---
    Q_PROPERTY(double voltaje READ voltaje NOTIFY datosActualizados)
    Q_PROPERTY(double rssi READ rssi NOTIFY datosActualizados)
    Q_PROPERTY(double cpuTemp READ cpuTemp NOTIFY datosActualizados)
    Q_PROPERTY(double corriente READ corriente NOTIFY datosActualizados)
    Q_PROPERTY(double cpuLoad READ cpuLoad NOTIFY datosActualizados)

    // --- PanelGeolocalizacion ---
    Q_PROPERTY(double latitud READ latitud NOTIFY datosActualizados)
    Q_PROPERTY(double longitud READ longitud NOTIFY datosActualizados)
    Q_PROPERTY(bool datosGeoDisponibles READ datosGeoDisponibles NOTIFY datosActualizados)
    Q_PROPERTY(bool camaraGrabando READ camaraGrabando NOTIFY datosActualizados)

    // --- PanelSensores ---
    Q_PROPERTY(double tempInterna READ tempInterna NOTIFY datosActualizados)
    Q_PROPERTY(double tempExterna READ tempExterna NOTIFY datosActualizados)
    Q_PROPERTY(double presion READ presion NOTIFY datosActualizados)
    Q_PROPERTY(double humedad READ humedad NOTIFY datosActualizados)
    Q_PROPERTY(double humedadInterna READ humedadInterna NOTIFY datosActualizados)
    Q_PROPERTY(int eco2 READ eco2 NOTIFY datosActualizados)
    Q_PROPERTY(int tvoc READ tvoc NOTIFY datosActualizados)
    Q_PROPERTY(int aqi READ aqi NOTIFY datosActualizados)
    Q_PROPERTY(double magX READ magX NOTIFY datosActualizados)
    Q_PROPERTY(double magY READ magY NOTIFY datosActualizados)
    Q_PROPERTY(double magZ READ magZ NOTIFY datosActualizados)

    // --- PanelAcelerometro ---
    Q_PROPERTY(double accelX READ accelX NOTIFY datosActualizados)
    Q_PROPERTY(double accelY READ accelY NOTIFY datosActualizados)
    Q_PROPERTY(double accelZ READ accelZ NOTIFY datosActualizados)
    Q_PROPERTY(bool datosAccelDisponibles READ datosAccelDisponibles NOTIFY datosActualizados)

    // --- PanelVelocidad ---
    Q_PROPERTY(double velocidad READ velocidad NOTIFY datosActualizados)
    Q_PROPERTY(bool datosVelDisponibles READ datosVelDisponibles NOTIFY datosActualizados)

    // --- PanelOrientacion ---
    Q_PROPERTY(double pitch READ pitch NOTIFY datosActualizados)
    Q_PROPERTY(double roll READ roll NOTIFY datosActualizados)
    Q_PROPERTY(double yaw READ yaw NOTIFY datosActualizados)
    Q_PROPERTY(bool esEstable READ esEstable NOTIFY datosActualizados)
    Q_PROPERTY(double velocidadAngular READ velocidadAngular NOTIFY datosActualizados)
    Q_PROPERTY(bool datosOrientDisponibles READ datosOrientDisponibles NOTIFY datosActualizados)

    // --- Extra ---
    Q_PROPERTY(double snr READ snr NOTIFY datosActualizados)
    Q_PROPERTY(int paquetesInvalidos READ paquetesInvalidos NOTIFY datosActualizados)

public:
    explicit TelemetryData(QObject *parent = nullptr);

    // Getters
    QString estado() const;
    QString estadoParacaidas() const;
    QString tiempoMision() const;
    int paquetesRecibidos() const;
    int servo() const;
    QString gpsFix() const;
    QString ens160Estado() const;
    QString camaraEstado() const;
    double altitud() const;
    double altitudMaxima() const;
    bool altitudDisponible() const;

    double voltaje() const;
    double rssi() const;
    double cpuTemp() const;
    double corriente() const;
    double cpuLoad() const;

    double latitud() const;
    double longitud() const;
    bool datosGeoDisponibles() const;
    bool camaraGrabando() const;

    double tempInterna() const;
    double tempExterna() const;
    double presion() const;
    double humedad() const;
    double humedadInterna() const;
    int eco2() const;
    int tvoc() const;
    int aqi() const;
    double magX() const;
    double magY() const;
    double magZ() const;

    double accelX() const;
    double accelY() const;
    double accelZ() const;
    bool datosAccelDisponibles() const;

    double velocidad() const;
    bool datosVelDisponibles() const;

    double pitch() const;
    double roll() const;
    double yaw() const;
    bool esEstable() const;
    double velocidadAngular() const;
    bool datosOrientDisponibles() const;

    double snr() const;
    int paquetesInvalidos() const;

    Q_INVOKABLE void resetear();

public slots:
    void onPaqueteValido(TelemetryPacket pkt, int16_t rssi, float snr);
    void onPaqueteInvalido(quint32 bytesDescartados);

signals:
    void datosActualizados();
    void logAgregado(const QString &tipo, const QString &mensaje);

private:
    // Último paquete recibido
    TelemetryPacket m_pkt{};
    int16_t m_rssi = 0;
    float m_snr = 0.0f;

    // Contadores
    int m_paquetesRecibidos = 0;
    int m_paquetesInvalidos = 0;

    // Cálculos
    double m_altitudMaxima = 0.0;
    bool m_tieneAlDato = false;
    uint32_t m_tMisAnterior = 0;  // Para calcular dt real del Madgwick

    VDescCalculator m_vDesc;
    MadgwickFilter m_madgwick;
    bool m_tieneOrientacion = false;
    double m_pitch = 0.0, m_roll = 0.0, m_yaw = 0.0;

    static QString estadoToString(uint8_t estado);
    static QString camaraToString(uint8_t camSt);
};

#endif // TELEMETRYDATA_H
