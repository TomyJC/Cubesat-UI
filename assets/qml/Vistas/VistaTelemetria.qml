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

    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: Theme.margenPequeno
        spacing:         Theme.espaciado

        // ═══════════════════════════════════════════
        //  FILA SUPERIOR  (70 %)
        // ═══════════════════════════════════════════
        RowLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            Layout.verticalStretchFactor: 7
            spacing: Theme.espaciado

            // ── COLUMNA IZQUIERDA ────────────
            ColumnLayout {
                Layout.fillHeight:             true
                Layout.fillWidth:              true
                Layout.horizontalStretchFactor: 2
                Layout.minimumWidth:           220
                spacing:                       Theme.espaciado

                EstadoMision {
                    id:                   _panelEstadoMision
                    Layout.fillWidth:     true
                    Layout.fillHeight:    true
                    Layout.verticalStretchFactor: 2
                    estado:               root.estadoMision
                    estadoParacaidas:     root.estadoParacaidas
                    tiempoMision:         root.tiempoMision
                    paquetesRecibidos:    root.paquetesRecibidos
                }

                PanelBateria {
                    Layout.fillWidth:     true
                    Layout.fillHeight:    true
                    Layout.verticalStretchFactor: 1
                }
            }

            // ── COLUMNA CENTRAL ──────────────
            ColumnLayout {
                Layout.fillHeight:             true
                Layout.fillWidth:              true
                Layout.horizontalStretchFactor: 5
                Layout.minimumWidth:           500
                spacing:                       Theme.espaciado

                PanelGeolocalizacion {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                }

                PanelSensores {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                }
            }

            // ── COLUMNA DERECHA ──────────────
            PanelOrientacion {
                Layout.fillHeight:             true
                Layout.fillWidth:              true
                Layout.horizontalStretchFactor: 2
                Layout.minimumWidth:           200
            }
        }

        // ═══════════════════════════════════════════
        //  FILA INFERIOR  (30 %)
        //  Acelerómetro │ Velocidad │ Consola
        // ═══════════════════════════════════════════
        RowLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            Layout.verticalStretchFactor: 3
            spacing: Theme.espaciado

            PanelAcelerometro {
                Layout.fillHeight:             true
                Layout.fillWidth:              true
                Layout.horizontalStretchFactor: 3
            }

            PanelVelocidad {
                Layout.fillHeight:             true
                Layout.fillWidth:              true
                Layout.horizontalStretchFactor: 3
            }

            PanelConsola {
                id:                            _panelConsola
                Layout.fillHeight:             true
                Layout.fillWidth:              true
                Layout.horizontalStretchFactor: 4
            }
        }
    }
}
