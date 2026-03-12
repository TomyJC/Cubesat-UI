import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
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

        // Datos de orientación — valores grandes por eje
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Pitch
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text {
                    text: "PITCH"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.ejeX
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: root.datosDisponibles ? root.pitch.toFixed(1) + "°" : "--"
                    font.pixelSize: Theme.fuenteH3
                    font.bold: true
                    font.family: Theme.fuenteMono
                    color: Theme.textoValor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Roll
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text {
                    text: "ROLL"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.ejeY
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: root.datosDisponibles ? root.roll.toFixed(1) + "°" : "--"
                    font.pixelSize: Theme.fuenteH3
                    font.bold: true
                    font.family: Theme.fuenteMono
                    color: Theme.textoValor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Yaw
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text {
                    text: "YAW"
                    font.pixelSize: Theme.fuenteCaption
                    font.letterSpacing: 1
                    color: Theme.ejeZ
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: root.datosDisponibles ? root.yaw.toFixed(1) + "°" : "--"
                    font.pixelSize: Theme.fuenteH3
                    font.bold: true
                    font.family: Theme.fuenteMono
                    color: Theme.textoValor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Estado + Velocidad Angular
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.espaciado

            // Estado de estabilidad
            RowLayout {
                spacing: 6

                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: root.datosDisponibles
                           ? (root.esEstable ? Theme.exito : Theme.error)
                           : Theme.neutro

                    // Glow
                    Rectangle {
                        anchors.centerIn: parent
                        width: 18; height: 18; radius: 9
                        color: parent.color
                        opacity: 0.2
                        visible: root.datosDisponibles
                    }
                }

                Text {
                    text: root.datosDisponibles
                          ? (root.esEstable ? "ESTABLE" : "INESTABLE")
                          : "--"
                    font.pixelSize: Theme.fuenteSmall
                    font.bold: true
                    font.letterSpacing: 1
                    color: root.datosDisponibles
                           ? (root.esEstable ? Theme.exito : Theme.error)
                           : Theme.textoClaro
                }
            }

            Item { Layout.fillWidth: true }

            // Velocidad angular
            RowLayout {
                spacing: 3
                Text {
                    text: "ω:"
                    font.pixelSize: Theme.fuenteSmall
                    color: Theme.textoClaro
                }
                Text {
                    text: root.datosDisponibles
                          ? root.velocidadAngular.toFixed(1)
                          : "--"
                    font.pixelSize: Theme.fuenteSmall
                    font.bold: true
                    font.family: Theme.fuenteMono
                    color: Theme.textoCyan
                }
                Text {
                    text: "°/s"
                    font.pixelSize: Theme.fuenteSmall
                    color: Theme.textoClaro
                }
            }
        }
    }
}
