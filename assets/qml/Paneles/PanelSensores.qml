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
        case 1: return "#00ff88"    // verde — excelente
        case 2: return "#51cf66"    // verde claro — bueno
        case 3: return "#ff9f43"    // naranja — moderado
        case 4: return "#ff4757"    // rojo — pobre
        case 5: return "#c0392b"    // rojo oscuro — insalubre
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
                font.letterSpacing: 1.5
                color: Theme.textoClaro
            }

            Item { Layout.fillHeight: true }

            // ── Temperatura Interna ──
            RowLayout {
                spacing: 4
                Text { text: "T. Int:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.tempInterna > -999 ? root.tempInterna.toFixed(1) + " °C" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            // ── Temperatura Externa ──
            RowLayout {
                spacing: 4
                Text { text: "T. Ext:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.tempExterna > -999 ? root.tempExterna.toFixed(1) + " °C" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            // ── Humedad Interna ──
            RowLayout {
                spacing: 4
                Text { text: "Hum. Int:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.humedadInterna >= 0 ? root.humedadInterna.toFixed(1) + " %" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            // ── Humedad Externa ──
            RowLayout {
                spacing: 4
                Text { text: "Hum. Ext:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.humedad >= 0 ? root.humedad.toFixed(1) + " %" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            // ── Presión ──
            RowLayout {
                spacing: 4
                Text { text: "Presión:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.presion >= 0 ? root.presion.toFixed(1) + " hPa" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoCyan
                }
            }

            Item { Layout.fillHeight: true }
        }

        // ── Separador vertical ─────────────────
        Rectangle {
            Layout.fillHeight: true
            width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.3; color: Qt.rgba(0, 0.898, 1, 0.2) }
                GradientStop { position: 0.7; color: Qt.rgba(0, 0.898, 1, 0.2) }
                GradientStop { position: 1.0; color: "transparent" }
            }
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
                font.letterSpacing: 1.5
                color: Theme.textoClaro
            }

            Item { Layout.fillHeight: true }

            // AQI con indicador de color
            RowLayout {
                spacing: 6
                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: root.aqi > 0 ? root.colorAqi(root.aqi) : Theme.textoClaro

                    // Glow
                    Rectangle {
                        anchors.centerIn: parent
                        width: 18; height: 18; radius: 9
                        color: parent.color
                        opacity: 0.2
                        visible: root.aqi > 0
                    }
                }
                Text {
                    text: root.aqi > 0
                          ? "AQI: " + root.aqi + " — " + root.textoAqi(root.aqi)
                          : "AQI: --"
                    font.pixelSize: Theme.fuenteSmall
                    font.family: Theme.fuenteMono
                    color: root.aqi > 0 ? root.colorAqi(root.aqi) : Theme.textoMedio
                    font.bold: root.aqi > 0
                }
            }

            RowLayout {
                spacing: 4
                Text { text: "eCO₂:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.eco2 >= 0 ? root.eco2 + " ppm" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            RowLayout {
                spacing: 4
                Text { text: "TVOC:"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro }
                Text {
                    text: root.tvoc >= 0 ? root.tvoc + " ppb" : "--"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }

            Item { Layout.fillHeight: true }
        }

        // ── Separador vertical ─────────────────
        Rectangle {
            Layout.fillHeight: true
            width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.3; color: Qt.rgba(0, 0.898, 1, 0.2) }
                GradientStop { position: 0.7; color: Qt.rgba(0, 0.898, 1, 0.2) }
                GradientStop { position: 1.0; color: "transparent" }
            }
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
                font.letterSpacing: 1.5
                color: Theme.textoClaro
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                spacing: 4
                Text { text: "X:"; font.pixelSize: Theme.fuenteSmall; color: Theme.ejeX; font.bold: true }
                Text {
                    text: root.magX.toFixed(1) + " µT"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            RowLayout {
                spacing: 4
                Text { text: "Y:"; font.pixelSize: Theme.fuenteSmall; color: Theme.ejeY; font.bold: true }
                Text {
                    text: root.magY.toFixed(1) + " µT"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }
            RowLayout {
                spacing: 4
                Text { text: "Z:"; font.pixelSize: Theme.fuenteSmall; color: Theme.ejeZ; font.bold: true }
                Text {
                    text: root.magZ.toFixed(1) + " µT"
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
