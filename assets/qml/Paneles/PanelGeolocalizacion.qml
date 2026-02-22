import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 280
    titulo: "GEOLOCALIZACIÓN"
    icono: "🌍"

    // Propiedades de datos (listas para backend)
    property real latitud: 0.0
    property real longitud: 0.0
    property bool datosDisponibles: false
    property bool camaraGrabando: false

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.datosDisponibles
                      ? "Lat: " + root.latitud.toFixed(6) + "  Lon: " + root.longitud.toFixed(6)
                      : "Lat: --  Lon: --"
                font.pixelSize: Theme.fuenteSmall
                font.family: Theme.fuenteMono
                Layout.fillWidth: true
            }

            // Indicador REC
            Row {
                visible: root.camaraGrabando
                spacing: 4
                Layout.alignment: Qt.AlignRight

                Rectangle {
                    width: 10; height: 10; radius: 5
                    color: Theme.error
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        running: root.camaraGrabando
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.2; duration: 500 }
                        NumberAnimation { to: 1.0; duration: 500 }
                    }
                }

                Text {
                    text: "REC"
                    font.pixelSize: Theme.fuenteSmall
                    font.bold: true
                    color: Theme.error
                    anchors.verticalCenter: parent.verticalCenter
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
