import QtQuick
import QtQuick.Layouts
import "../Componentes"
import "../Paneles"

Item {
    id: root

    property string estadoMision:       "STANDBY"
    property string estadoParacaidas:   "CERRADO"
    property string tiempoMision:       "00:00:00"
    property int    paquetesRecibidos:  0
    property bool   estaConectado:      false
    property int    segundosTranscurridos: 0

    property alias panelEstadoMision: _panelEstadoMision
    property alias panelConsola:      _panelConsola

    // ─────────────────────────────────────────────
    //  ROOT: dos filas verticales
    // ─────────────────────────────────────────────
    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: Theme.margenPequeno
        spacing:         Theme.espaciado

        // ═══════════════════════════════════════════
        //  FILA SUPERIOR  (70 % de la altura)
        // ═══════════════════════════════════════════
        RowLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.68
            spacing: Theme.espaciado

            // ── COLUMNA IZQUIERDA (20 %) ────────────
            ColumnLayout {
                Layout.fillHeight:      true
                Layout.preferredWidth:  parent.width * 0.20
                Layout.minimumWidth:    220
                spacing:                Theme.espaciado

                PanelEstadoMision {
                    id:                   _panelEstadoMision
                    Layout.fillWidth:     true
                    Layout.fillHeight:    true
                    Layout.preferredHeight: 0.65
                    estado:               root.estadoMision
                    estadoParacaidas:     root.estadoParacaidas
                    tiempoMision:         root.tiempoMision
                    paquetesRecibidos:    root.paquetesRecibidos
                    // Bindings al backend
                    servo:                typeof telemetry !== "undefined" ? telemetry.servo : 0
                    gpsFix:               typeof telemetry !== "undefined" ? telemetry.gpsFix : "--"
                    ens160Estado:         typeof telemetry !== "undefined" ? telemetry.ens160Estado : "--"
                    camaraEstado:         typeof telemetry !== "undefined" ? telemetry.camaraEstado : "APAGADA"
                    altitud:              typeof telemetry !== "undefined" ? telemetry.altitud : 0.0
                    altitudMaxima:        typeof telemetry !== "undefined" ? telemetry.altitudMaxima : 500.0
                    altitudDisponible:    typeof telemetry !== "undefined" ? telemetry.altitudDisponible : false
                }

                PanelBateria {
                    Layout.fillWidth:     true
                    Layout.fillHeight:    true
                    Layout.preferredHeight: 0.35
                    voltaje:              typeof telemetry !== "undefined" ? telemetry.voltaje : -1
                    corriente:            typeof telemetry !== "undefined" ? telemetry.corriente : -1
                    rssi:                 typeof telemetry !== "undefined" ? telemetry.rssi : -1
                    cpuLoad:              typeof telemetry !== "undefined" ? telemetry.cpuLoad : -1
                    cpuTemp:              typeof telemetry !== "undefined" ? telemetry.cpuTemp : -1
                }
            }

            // ── COLUMNA CENTRAL (55 %) ──────────────
            ColumnLayout {
                Layout.fillHeight:     true
                Layout.preferredWidth: parent.width * 0.55
                Layout.minimumWidth:   500
                spacing:               Theme.espaciado

                PanelGeolocalizacion {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                    latitud:           typeof telemetry !== "undefined" ? telemetry.latitud : 0.0
                    longitud:          typeof telemetry !== "undefined" ? telemetry.longitud : 0.0
                    datosDisponibles:  typeof telemetry !== "undefined" ? telemetry.datosGeoDisponibles : false
                    camaraGrabando:    typeof telemetry !== "undefined" ? telemetry.camaraGrabando : false
                }

                PanelSensores {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                    tempInterna:       typeof telemetry !== "undefined" ? telemetry.tempInterna : -999
                    tempExterna:       typeof telemetry !== "undefined" ? telemetry.tempExterna : -999
                    presion:           typeof telemetry !== "undefined" ? telemetry.presion : -1
                    humedad:           typeof telemetry !== "undefined" ? telemetry.humedad : -1
                    humedadInterna:    typeof telemetry !== "undefined" ? telemetry.humedadInterna : -1
                    eco2:              typeof telemetry !== "undefined" ? telemetry.eco2 : -1
                    tvoc:              typeof telemetry !== "undefined" ? telemetry.tvoc : -1
                    aqi:               typeof telemetry !== "undefined" ? telemetry.aqi : -1
                    magX:              typeof telemetry !== "undefined" ? telemetry.magX : 0.0
                    magY:              typeof telemetry !== "undefined" ? telemetry.magY : 0.0
                    magZ:              typeof telemetry !== "undefined" ? telemetry.magZ : 0.0
                }
            }

            // ── COLUMNA DERECHA (25 %) ──────────────
            PanelOrientacion {
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.25
                Layout.minimumWidth:   200
                pitch:                 typeof telemetry !== "undefined" ? telemetry.pitch : 0.0
                roll:                  typeof telemetry !== "undefined" ? telemetry.roll : 0.0
                yaw:                   typeof telemetry !== "undefined" ? telemetry.yaw : 0.0
                esEstable:             typeof telemetry !== "undefined" ? telemetry.esEstable : true
                velocidadAngular:      typeof telemetry !== "undefined" ? telemetry.velocidadAngular : 0.0
                datosDisponibles:      typeof telemetry !== "undefined" ? telemetry.datosOrientDisponibles : false
            }
        }

        // ═══════════════════════════════════════════
        //  FILA INFERIOR  (30 % de la altura)
        // ═══════════════════════════════════════════
        RowLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.32
            spacing: Theme.espaciado

            // Acelerómetro ─ 25 %
            PanelAcelerometro {
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.30
                accelX:                typeof telemetry !== "undefined" ? telemetry.accelX : 0.0
                accelY:                typeof telemetry !== "undefined" ? telemetry.accelY : 0.0
                accelZ:                typeof telemetry !== "undefined" ? telemetry.accelZ : 0.0
                datosDisponibles:      typeof telemetry !== "undefined" ? telemetry.datosAccelDisponibles : false
            }

            // Velocidad de descenso ─ 25 %
            PanelVelocidad {
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.30
                velocidad:             typeof telemetry !== "undefined" ? telemetry.velocidad : 0.0
                datosDisponibles:      typeof telemetry !== "undefined" ? telemetry.datosVelDisponibles : false
            }

            // Consola / Log ─ 50 %
            PanelConsola {
                id:                    _panelConsola
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.40
            }
        }
    }
}
