import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "BATERÍA / CONECTIVIDAD"

    // Propiedades de datos (listas para backend)
    property real voltaje: -1
    property real corriente: -1
    property real rssi: -1
    property real cpuLoad: -1
    property real cpuTemp: -1

    contenido: RowLayout {
        anchors.fill: parent
        spacing: Theme.margen

        // Gráfica de barra de batería (placeholder)
        PlaceholderPanel {
            Layout.preferredWidth: 60
            Layout.fillHeight: true
            texto: "GRÁFICA\nBARRA\nBATERÍA"
        }

        // Datos numéricos
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3

            Text {
                text: root.voltaje >= 0 ? "Voltaje: " + root.voltaje.toFixed(2) + " V" : "Voltaje: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.corriente >= 0 ? "Corriente: " + root.corriente.toFixed(2) + " A" : "Corriente: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.rssi >= 0 ? "RSSI: " + root.rssi.toFixed(0) + " dBm" : "RSSI: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.cpuLoad >= 0 ? "CPU Load: " + root.cpuLoad.toFixed(0) + "%" : "CPU Load: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.cpuTemp >= 0 ? "CPU Temp: " + root.cpuTemp.toFixed(1) + "°C" : "CPU Temp: --"
                font.pixelSize: Theme.fuenteSmall
            }
        }
    }
}
