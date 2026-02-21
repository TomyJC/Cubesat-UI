import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property bool activo: false
    property string etiqueta: ""
    property color colorActivo: Theme.exito
    property color colorInactivo: Theme.error

    spacing: 8

    Rectangle {
        width: 10
        height: 10
        radius: 5
        color: root.activo ? root.colorActivo : root.colorInactivo
    }

    Text {
        text: root.etiqueta
        font.pixelSize: Theme.fuenteBody
        font.bold: true
        color: root.activo ? root.colorActivo : root.colorInactivo
    }
}
