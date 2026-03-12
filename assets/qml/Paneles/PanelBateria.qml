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

    // Color de calidad de señal según RSSI
    function colorRssi(val) {
        if (val > -60) return Theme.exito
        if (val > -80) return Theme.advertencia
        return Theme.error
    }

    contenido: RowLayout {
        anchors.fill: parent
        spacing: Theme.margen

        // Gráfica de barra de batería (placeholder)
        PlaceholderPanel {
            Layout.preferredWidth: 60
            Layout.fillHeight: true
            texto: "GRÁFICA\nBARRA\nBATERÍA"
        }

        // Datos numéricos en grid 2x2
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 6
            columnSpacing: 12

            // ── Voltaje ──
            ColumnLayout {
                spacing: 1
                Text {
                    text: "VOLTAJE"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.textoClaro
                }
                RowLayout {
                    spacing: 3
                    Text {
                        text: root.voltaje >= 0 ? root.voltaje.toFixed(2) : "--"
                        font.pixelSize: Theme.fuenteH2
                        font.bold: true
                        font.family: Theme.fuenteMono
                        color: root.voltaje >= 3.5 ? Theme.exito
                             : root.voltaje >= 3.2 ? Theme.advertencia
                             : root.voltaje >= 0   ? Theme.error
                             : Theme.textoMedio
                    }
                    Text {
                        text: "V"
                        font.pixelSize: Theme.fuenteSmall
                        color: Theme.textoClaro
                        Layout.alignment: Qt.AlignBottom
                    }
                }
            }

            // ── CPU Temp ──
            ColumnLayout {
                spacing: 1
                Text {
                    text: "CPU TEMP"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.textoClaro
                }
                RowLayout {
                    spacing: 3
                    Text {
                        text: root.cpuTemp >= 0 ? root.cpuTemp.toFixed(1) : "--"
                        font.pixelSize: Theme.fuenteH2
                        font.bold: true
                        font.family: Theme.fuenteMono
                        color: Theme.textoValor
                    }
                    Text {
                        text: "°C"
                        font.pixelSize: Theme.fuenteSmall
                        color: Theme.textoClaro
                        Layout.alignment: Qt.AlignBottom
                    }
                }
            }

            // ── RSSI ──
            ColumnLayout {
                spacing: 1
                Text {
                    text: "RSSI"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.textoClaro
                }
                RowLayout {
                    spacing: 3
                    Text {
                        text: root.datosDisponibles ? root.rssi.toFixed(0) : "--"
                        font.pixelSize: Theme.fuenteH2
                        font.bold: true
                        font.family: Theme.fuenteMono
                        color: root.datosDisponibles ? colorRssi(root.rssi) : Theme.textoMedio
                    }
                    Text {
                        text: "dBm"
                        font.pixelSize: Theme.fuenteSmall
                        color: Theme.textoClaro
                        Layout.alignment: Qt.AlignBottom
                    }
                }
            }

            // ── SNR ──
            ColumnLayout {
                spacing: 1
                Text {
                    text: "SNR"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.textoClaro
                }
                RowLayout {
                    spacing: 3
                    Text {
                        text: root.datosDisponibles ? root.snr.toFixed(1) : "--"
                        font.pixelSize: Theme.fuenteH2
                        font.bold: true
                        font.family: Theme.fuenteMono
                        color: Theme.textoCyan
                    }
                    Text {
                        text: "dB"
                        font.pixelSize: Theme.fuenteSmall
                        color: Theme.textoClaro
                        Layout.alignment: Qt.AlignBottom
                    }
                }
            }
        }
    }
}
