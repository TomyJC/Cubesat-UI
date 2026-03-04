import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "BATERÍA / CONECTIVIDAD"
    icono: "🔋"

    // Propiedades de datos
    property real voltaje: -1
    property real rssi: 0
    property real snr: 0
    property real cpuTemp: -1
    property bool datosDisponibles: false

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
                text: root.cpuTemp >= 0 ? "CPU Temp: " + root.cpuTemp.toFixed(1) + " °C" : "CPU Temp: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.datosDisponibles ? "RSSI: " + root.rssi.toFixed(0) + " dBm" : "RSSI: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.datosDisponibles ? "SNR: " + root.snr.toFixed(1) + " dB" : "SNR: --"
                font.pixelSize: Theme.fuenteSmall
            }
        }
    }
}
