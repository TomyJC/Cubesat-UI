import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "SENSORES AMBIENTALES"
    icono: "🌡️"

    // Propiedades de datos (conectadas al backend)
    property real tempInterna: -999
    property real tempExterna: -999
    property real presion: -1
    property real humedad: -1
    property real humedadInterna: -1

    // ENS160
    property int eco2: -1
    property int tvoc: -1
    property int aqi: -1

    // Magnetómetro
    property real magX: 0.0
    property real magY: 0.0
    property real magZ: 0.0

    // Sensor extra
    property string sensorExtra: "ENS160"

    // Color del AQI por nivel
    function colorAqi(nivel) {
        switch (nivel) {
        case 1: return "#4CAF50"    // verde — excelente
        case 2: return "#8BC34A"    // verde claro — bueno
        case 3: return "#FF9800"    // naranja — moderado
        case 4: return "#F44336"    // rojo — pobre
        case 5: return "#B71C1C"    // rojo oscuro — insalubre
        default: return Theme.textoClaro
        }
    }

    function textoAqi(nivel) {
        switch (nivel) {
        case 1: return "Excelente"
        case 2: return "Bueno"
        case 3: return "Moderado"
        case 4: return "Pobre"
        case 5: return "Insalubre"
        default: return "--"
        }
    }

    contenido: RowLayout {
        anchors.fill: parent
        spacing: 16

        // ── Columna 1: Ambiente ────────────────
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Text {
                text: "AMBIENTE"
                font.pixelSize: Theme.fuenteCaption
                font.bold: true
                font.letterSpacing: 1
                color: Theme.textoClaro
            }

            Item { Layout.fillHeight: true }

            Text {
                text: root.tempInterna > -999
                      ? "T. Interna: " + root.tempInterna.toFixed(1) + " °C"
                      : "T. Interna: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.tempExterna > -999
                      ? "T. Externa: " + root.tempExterna.toFixed(1) + " °C"
                      : "T. Externa: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.humedadInterna >= 0
                      ? "Hum. Int: " + root.humedadInterna.toFixed(1) + " %"
                      : "Hum. Int: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.humedad >= 0
                      ? "Hum. Ext: " + root.humedad.toFixed(1) + " %"
                      : "Hum. Ext: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.presion >= 0
                      ? "Presión: " + root.presion.toFixed(1) + " hPa"
                      : "Presión: --"
                font.pixelSize: Theme.fuenteSmall
            }

            Item { Layout.fillHeight: true }
        }

        // ── Separador vertical ─────────────────
        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Theme.bordeSeparador
            opacity: 0.5
        }

        // ── Columna 2: Calidad de Aire (ENS160) ──
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Text {
                text: "CALIDAD AIRE"
                font.pixelSize: Theme.fuenteCaption
                font.bold: true
                font.letterSpacing: 1
                color: Theme.textoClaro
            }

            Item { Layout.fillHeight: true }

            // AQI con indicador de color
            RowLayout {
                spacing: 6
                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: root.aqi > 0 ? root.colorAqi(root.aqi) : Theme.textoClaro
                }
                Text {
                    text: root.aqi > 0
                          ? "AQI: " + root.aqi + " — " + root.textoAqi(root.aqi)
                          : "AQI: --"
                    font.pixelSize: Theme.fuenteSmall
                    color: root.aqi > 0 ? root.colorAqi(root.aqi) : Theme.textoOscuro
                    font.bold: root.aqi > 0
                }
            }

            Text {
                text: root.eco2 >= 0
                      ? "eCO₂: " + root.eco2 + " ppm"
                      : "eCO₂: --"
                font.pixelSize: Theme.fuenteSmall
            }
            Text {
                text: root.tvoc >= 0
                      ? "TVOC: " + root.tvoc + " ppb"
                      : "TVOC: --"
                font.pixelSize: Theme.fuenteSmall
            }

            Item { Layout.fillHeight: true }
        }

        // ── Separador vertical ─────────────────
        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Theme.bordeSeparador
            opacity: 0.5
        }

        // ── Columna 3: Magnetómetro ───────────
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Text {
                text: "MAGNETÓMETRO"
                font.pixelSize: Theme.fuenteCaption
                font.bold: true
                font.letterSpacing: 1
                color: Theme.textoClaro
            }

            Item { Layout.fillHeight: true }

            Text {
                text: "MAG X: " + root.magX.toFixed(1) + " µT"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }
            Text {
                text: "MAG Y: " + root.magY.toFixed(1) + " µT"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }
            Text {
                text: "MAG Z: " + root.magZ.toFixed(1) + " µT"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }

            Item { Layout.fillHeight: true }
        }
    }
}
