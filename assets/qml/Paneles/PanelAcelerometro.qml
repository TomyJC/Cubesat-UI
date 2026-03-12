import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "ACELERÓMETRO"
    icono: "📐"

    // Propiedades de datos (listas para backend)
    property real accelX: 0.0
    property real accelY: 0.0
    property real accelZ: 0.0
    property bool datosDisponibles: false

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        // Datos numéricos con colores por eje
        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            visible: root.datosDisponibles

            // X
            RowLayout {
                spacing: 3
                Text { text: "X:"; font.pixelSize: Theme.fuenteSmall; font.bold: true; color: Theme.ejeX }
                Text {
                    text: root.accelX.toFixed(2)
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
                Text { text: "g"; font.pixelSize: Theme.fuenteCaption; color: Theme.textoClaro }
            }

            // Y
            RowLayout {
                spacing: 3
                Text { text: "Y:"; font.pixelSize: Theme.fuenteSmall; font.bold: true; color: Theme.ejeY }
                Text {
                    text: root.accelY.toFixed(2)
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
                Text { text: "g"; font.pixelSize: Theme.fuenteCaption; color: Theme.textoClaro }
            }

            // Z
            RowLayout {
                spacing: 3
                Text { text: "Z:"; font.pixelSize: Theme.fuenteSmall; font.bold: true; color: Theme.ejeZ }
                Text {
                    text: root.accelZ.toFixed(2)
                    font.pixelSize: Theme.fuenteSmall; font.family: Theme.fuenteMono; font.bold: true
                    color: Theme.textoValor
                }
                Text { text: "g"; font.pixelSize: Theme.fuenteCaption; color: Theme.textoClaro }
            }
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "GRÁFICA DE ACELERÓMETRO\n(X, Y, Z)"
        }
    }
}
