import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 180
    titulo: "SENSORES AMBIENTALES"
    icono: "🌡️"

    // Propiedades de datos (listas para backend)
    property real tempInterna: -999
    property real tempExterna: -999
    property real presion: -1
    property real humedad: -1

    // Sensor extra
    property string sensorExtra: "CCS811"

    contenido: RowLayout {
        anchors.fill: parent
        spacing: 20

        // Datos ambientales
        ColumnLayout {
            Layout.fillWidth: true

            Item { Layout.fillHeight: true }

            Text {
                text: root.tempInterna > -999
                      ? "Temp. Interna: " + root.tempInterna.toFixed(1) + " °C"
                      : "Temp. Interna: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.tempExterna > -999
                      ? "Temp. Externa: " + root.tempExterna.toFixed(1) + " °C"
                      : "Temp. Externa: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.presion >= 0
                      ? "Presión: " + root.presion.toFixed(1) + " hPa"
                      : "Presión: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.humedad >= 0
                      ? "Humedad: " + root.humedad.toFixed(1) + " %"
                      : "Humedad: --"
                font.pixelSize: Theme.fuenteSmall
            }

            Item { Layout.fillHeight: true }
        }


    }
}
