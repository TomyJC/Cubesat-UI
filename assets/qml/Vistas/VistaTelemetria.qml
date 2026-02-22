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
                    Layout.preferredHeight: 0.65          // más protagonismo
                    estado:               root.estadoMision
                    estadoParacaidas:     root.estadoParacaidas
                    tiempoMision:         root.tiempoMision
                    paquetesRecibidos:    root.paquetesRecibidos
                }

                PanelBateria {
                    Layout.fillWidth:     true
                    Layout.fillHeight:    true
                    Layout.preferredHeight: 0.35
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
                }

                PanelSensores {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                }
            }

            // ── COLUMNA DERECHA (25 %) ──────────────
            //    Orientación ocupa TODO el alto → más espacio visual
            PanelOrientacion {
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.25
                Layout.minimumWidth:   200
            }
        }

        // ═══════════════════════════════════════════
        //  FILA INFERIOR  (30 % de la altura)
        //  Acelerómetro │ Velocidad de descenso │ Log
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
            }

            // Velocidad de descenso ─ 25 %
            PanelVelocidad {
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.30
            }

            // Consola / Log ─ 50 % → el más ancho de la fila
            PanelConsola {
                id:                    _panelConsola
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: parent.width * 0.40
            }
        }
    }
}
