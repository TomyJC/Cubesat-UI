import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 180
    titulo: "ALTITUD"

    // Propiedades de datos (listas para backend)
    property real altitud: -1  // -1 = sin datos

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        Item { Layout.fillHeight: true }

        Text {
            text: root.altitud >= 0
                  ? "Altitud: " + root.altitud.toFixed(1) + " m"
                  : "Altitud: --"
            font.pixelSize: Theme.fuenteBody
            Layout.alignment: Qt.AlignHCenter
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "GRÁFICA DE BARRA\nALTITUD"
        }

        Item { Layout.fillHeight: true }
    }
}
