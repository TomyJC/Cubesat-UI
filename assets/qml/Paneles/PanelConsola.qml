import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "CONSOLA DE SALIDA"
    icono: "💻"

    // API pública
    property alias textoConsola: consolaTexto.text

    function agregarLog(mensaje) {
        consolaTexto.text += "\n" + mensaje
    }

    contenido: Rectangle {
        anchors.fill: parent
        color: Theme.fondoConsola
        border.color: Theme.textoClaro
        radius: Theme.radioGrande

        ScrollView {
            anchors.fill: parent
            anchors.margins: Theme.margenPequeno

            TextArea {
                id: consolaTexto
                text: "Log de recepción de Datos:"
                color: Theme.textoConsola
                font.family: Theme.fuenteMono
                font.pixelSize: Theme.fuenteSmall
                readOnly: true
                wrapMode: TextEdit.Wrap
                background: Rectangle { color: "transparent" }
            }
        }
    }
}
