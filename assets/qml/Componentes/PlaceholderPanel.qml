import QtQuick

Rectangle {
    id: root

    property string texto: "PENDIENTE"

    color: Theme.fondoPlaceholder
    border.color: Theme.bordeSuave
    radius: Theme.radioGrande

    Text {
        anchors.centerIn: parent
        text: root.texto
        font.italic: true
        font.pixelSize: Theme.fuenteBody
        horizontalAlignment: Text.AlignHCenter
        color: Theme.textoClaro
    }
}
