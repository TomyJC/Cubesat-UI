import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "GEOLOCALIZACIÓN"
    icono: "🌍"

    // Propiedades de datos (listas para backend)
    property real latitud: 0.0
    property real longitud: 0.0
    property bool datosDisponibles: false
    property bool camaraGrabando: true

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.datosDisponibles
                      ? "LAT " + root.latitud.toFixed(6) + "   LON " + root.longitud.toFixed(6)
                      : "LAT --          LON --"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
                color: root.datosDisponibles ? Theme.textoCyan : Theme.textoClaro
                Layout.fillWidth: true
            }

            // Indicador REC — badge elegante
            Rectangle {
                visible: root.camaraGrabando
                Layout.alignment: Qt.AlignRight
                width: recRow.implicitWidth + 16
                height: 24
                radius: 12
                color: Qt.rgba(1, 0.278, 0.341, 0.15)
                border.color: Qt.rgba(1, 0.278, 0.341, 0.4)
                border.width: 1

                RowLayout {
                    id: recRow
                    anchors.centerIn: parent
                    spacing: 5

                    Rectangle {
                        width: 8; height: 8; radius: 4
                        color: Theme.error

                        SequentialAnimation on opacity {
                            running: root.camaraGrabando
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.2; duration: 500 }
                            NumberAnimation { to: 1.0; duration: 500 }
                        }
                    }

                    Text {
                        text: "REC"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                        color: Theme.error
                    }
                }
            }
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "MAPA GPS"
        }
    }
}
