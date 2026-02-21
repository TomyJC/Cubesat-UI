import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "ACELERÓMETRO"

    // Propiedades de datos (listas para backend)
    property real accelX: 0.0
    property real accelY: 0.0
    property real accelZ: 0.0
    property bool datosDisponibles: false

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        // Datos numéricos
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.margen
            visible: root.datosDisponibles

            Text {
                text: "X: " + root.accelX.toFixed(2)
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }
            Text {
                text: "Y: " + root.accelY.toFixed(2)
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }
            Text {
                text: "Z: " + root.accelZ.toFixed(2)
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "GRÁFICA DE ACELERÓMETRO\n(X, Y, Z)"
            radius: 20
        }
    }
}
