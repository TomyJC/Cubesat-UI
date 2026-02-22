import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 320
    titulo: "ORIENTACIÓN"
    icono: "🧭"

    // Propiedades de datos (listas para backend)
    property real pitch: 0.0
    property real roll: 0.0
    property real yaw: 0.0
    property bool esEstable: true
    property real velocidadAngular: 0.0
    property bool datosDisponibles: false

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciado

        // Cubo 3D (placeholder)
        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            texto: "CUBO 3D\nORIENTACIÓN"
        }

        // Datos de orientación
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.espaciadoPequeno

            Text {
                text: root.datosDisponibles
                      ? "Pitch: " + root.pitch.toFixed(1) + "°  Roll: " + root.roll.toFixed(1) + "°  Yaw: " + root.yaw.toFixed(1) + "°"
                      : "Pitch: --   Roll: --   Yaw: --"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }

            RowLayout {
                spacing: Theme.espaciado

                Text {
                    text: "Estado: " + (root.datosDisponibles
                          ? (root.esEstable ? "Estable" : "Inestable")
                          : "--")
                    font.pixelSize: Theme.fuenteSmall
                }

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: root.datosDisponibles
                           ? (root.esEstable ? Theme.exito : Theme.error)
                           : Theme.neutro
                }
            }

            Text {
                text: root.datosDisponibles
                      ? "Vel. Angular: " + root.velocidadAngular.toFixed(1) + " °/s"
                      : "Vel. Angular: --"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
            }
        }
    }
}
