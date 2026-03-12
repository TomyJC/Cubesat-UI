import QtQuick
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "VELOCIDAD DE DESCENSO"
    icono: "⬇️"

    // Propiedades de datos (listas para backend)
    property real velocidad: 0.0
    property bool datosDisponibles: false

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: Theme.espaciadoPequeno

        // Valor grande centrado
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 2
            visible: root.datosDisponibles

            Text {
                text: "V DESC"
                font.pixelSize: Theme.fuenteCaption
                font.letterSpacing: 1.5
                color: Theme.textoClaro
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    text: root.velocidad.toFixed(2)
                    font.pixelSize: Theme.fuenteH2
                    font.bold: true
                    font.family: Theme.fuenteMono
                    color: Theme.textoCyan
                }

                Text {
                    text: "m/s"
                    font.pixelSize: Theme.fuenteSmall
                    color: Theme.textoClaro
                    Layout.alignment: Qt.AlignBottom
                }
            }
        }

        PlaceholderPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            texto: "GRÁFICA DE VELOCIDAD\nDE DESCENSO"
        }
    }
}
