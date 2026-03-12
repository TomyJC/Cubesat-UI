import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    // Estado: 0 = inactivo, 1 = intermedio (conectando), 2 = activo
    property int estado: 0
    property string etiqueta: ""
    property color colorActivo: Theme.exito
    property color colorIntermedio: Theme.advertencia
    property color colorInactivo: Theme.error

    // Color actual según el estado
    readonly property color _color: estado === 2 ? colorActivo
                                  : estado === 1 ? colorIntermedio
                                  : colorInactivo

    spacing: 8

    // Glow detrás del LED
    Rectangle {
        width: 18
        height: 18
        radius: 9
        color: root._color
        opacity: 0.25
        visible: root.estado > 0

        SequentialAnimation on opacity {
            running: root.estado === 1
            loops: Animation.Infinite
            NumberAnimation { to: 0.05; duration: 500 }
            NumberAnimation { to: 0.35; duration: 500 }
        }
    }

    Rectangle {
        id: led
        width: 10
        height: 10
        radius: 5
        color: root._color
        anchors.horizontalCenter: parent.children[0].horizontalCenter
        anchors.verticalCenter: parent.children[0].verticalCenter

        // Parpadeo cuando está en estado intermedio (CONECTANDO)
        SequentialAnimation on opacity {
            running: root.estado === 1
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
        // Restaurar opacidad cuando no está parpadeando
        onOpacityChanged: {
            if (root.estado !== 1)
                led.opacity = 1.0
        }
    }

    Text {
        text: root.etiqueta
        font.pixelSize: Theme.fuenteBody
        font.bold: true
        color: root._color
    }
}
