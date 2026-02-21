import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 280
    titulo: "GEOLOCALIZACIÓN"

    // Propiedades de datos (listas para backend)
    property real latitud: 0.0
    property real longitud: 0.0
    property bool datosDisponibles: false

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

            Button {
                text: "Cam"
                Layout.preferredWidth: 50
            }
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "MAPA GPS /\nCÁMARA (EN DECISIÓN)"
        }
    }
}
