import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "VELOCIDAD DE DESCENSO"

    // Propiedades de datos (listas para backend)
    property real velocidad: 0.0
    property bool datosDisponibles: false

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        Text {
            text: root.datosDisponibles
                  ? "Vel: " + root.velocidad.toFixed(2) + " m/s"
                  : "Vel: --"
            font.pixelSize: Theme.fuenteSmall
            font.family: Theme.fuenteMono
            Layout.alignment: Qt.AlignHCenter
            visible: root.datosDisponibles
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "GRÁFICA DE VELOCIDAD\nDE DESCENSO"
            radius: 20
        }
    }
}
