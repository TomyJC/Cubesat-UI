import QtQuick
import QtQuick.Layouts
import "../Componentes"
import "../Paneles"

Item {
    id: root

    // Propiedades de misión (vinculadas desde Main)
    property string estadoMision: "STANDBY"
    property string estadoParacaidas: "CERRADO"
    property string tiempoMision: "00:00:00"
    property int paquetesRecibidos: 0
    property bool estaConectado: false
    property int segundosTranscurridos: 0

    // Acceso público a sub-componentes
    property alias panelEstadoMision: _panelEstadoMision
    property alias panelConsola: _panelConsola

    GridLayout {
        anchors.fill: parent
        anchors.margins: Theme.margenPequeno

        columns: 3
        rowSpacing: Theme.espaciado
        columnSpacing: Theme.espaciado

        // =================== COLUMNA 1 (Izquierda - 20%) ===================
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.20
            Layout.minimumWidth: 220
            spacing: Theme.espaciado

            EstadoMision {
                id: _panelEstadoMision
                Layout.fillWidth: true
                estado: root.estadoMision
                estadoParacaidas: root.estadoParacaidas
                tiempoMision: root.tiempoMision
                paquetesRecibidos: root.paquetesRecibidos
            }

            PanelAltitud {
                Layout.fillWidth: true
            }

            PanelBateria {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        // =================== COLUMNA 2 (Centro - 55%) ===================
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.55
            Layout.minimumWidth: 500
            spacing: Theme.espaciado

            PanelGeolocalizacion {
                Layout.fillWidth: true
            }

            PanelSensores {
                Layout.fillWidth: true
            }

            // Acelerómetro + Velocidad (fila)
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.espaciado

                PanelAcelerometro {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                PanelVelocidad {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        // =================== COLUMNA 3 (Derecha - 20%) ===================
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.20
            Layout.minimumWidth: 220
            spacing: Theme.espaciado

            PanelOrientacion {
                Layout.fillWidth: true
            }

            PanelConsola {
                id: _panelConsola
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
