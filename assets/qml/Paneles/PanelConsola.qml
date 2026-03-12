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
        // Auto-scroll al final
        consolaFlick.contentY = Math.max(0, consolaTexto.contentHeight - consolaFlick.height)
    }

    contenido: Rectangle {
        anchors.fill: parent
        color: Theme.fondoConsola
        border.color: Qt.rgba(0, 0.898, 1, 0.12)
        border.width: 1
        radius: Theme.radioPequeno

        Flickable {
            id: consolaFlick
            anchors.fill: parent
            anchors.margins: Theme.margenPequeno
            contentWidth: width
            contentHeight: consolaTexto.contentHeight
            clip: true
            flickableDirection: Flickable.VerticalFlick

            TextEdit {
                id: consolaTexto
                width: parent.width
                text: ""
                color: Theme.textoConsola
                font.family: Theme.fuenteMono
                font.pixelSize: Theme.fuenteSmall
                readOnly: true
                wrapMode: TextEdit.Wrap
                selectByMouse: true
            }
        }
    }
}
