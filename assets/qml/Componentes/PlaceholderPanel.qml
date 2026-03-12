import QtQuick

Rectangle {
    id: root

    property string texto: "PENDIENTE"

    color: Theme.fondoPlaceholder
    border.color: Theme.bordeSuave
    border.width: 1
    radius: Theme.radioGrande

    // Grid pattern (HUD style)
    Canvas {
        anchors.fill: parent
        anchors.margins: 1
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = Qt.rgba(0, 0.898, 1, 0.04)
            ctx.lineWidth = 1

            // Horizontal lines
            var step = 20
            for (var y = step; y < height; y += step) {
                ctx.beginPath()
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
                ctx.stroke()
            }
            // Vertical lines
            for (var x = step; x < width; x += step) {
                ctx.beginPath()
                ctx.moveTo(x, 0)
                ctx.lineTo(x, height)
                ctx.stroke()
            }
        }
    }

    // Crosshair center
    Rectangle {
        anchors.centerIn: parent
        width: 30
        height: 1
        color: Qt.rgba(0, 0.898, 1, 0.1)
    }
    Rectangle {
        anchors.centerIn: parent
        width: 1
        height: 30
        color: Qt.rgba(0, 0.898, 1, 0.1)
    }

    Text {
        anchors.centerIn: parent
        text: root.texto
        font.pixelSize: Theme.fuenteSmall
        font.family: Theme.fuenteMono
        font.letterSpacing: 2
        horizontalAlignment: Text.AlignHCenter
        color: Theme.textoClaro
        opacity: 0.6
    }
}
