import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    color: Theme.fondoTarjeta
    border.color: Theme.fondoTarjetaBorde
    border.width: Theme.bordeAncho
    radius: Theme.radio

    // Propiedades personalizables
    property string titulo: ""
    property string icono: ""
    property color colorTitulo: Theme.textoCyan
    property color colorFondo: Theme.fondoTarjeta

    // Contenido inyectable
    property alias contenido: areaContenido.children

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.margen
        spacing: Theme.espaciado

        // Header de la tarjeta
        RowLayout {
            Layout.fillWidth: true
            visible: root.titulo !== ""
            spacing: 8

            Text {
                text: root.icono
                font.pixelSize: Theme.fuenteH3
                visible: root.icono !== ""
            }

            Text {
                text: root.titulo
                font.pixelSize: Theme.fuenteCaption
                font.bold: true
                font.letterSpacing: 1.5
                color: root.colorTitulo
                Layout.fillWidth: true
                opacity: 0.8
            }
        }

        // Línea separadora con gradiente simulado
        Rectangle {
            Layout.fillWidth: true
            height: 1
            visible: root.titulo !== ""
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Theme.acento }
                GradientStop { position: 0.3; color: Qt.rgba(0, 0.898, 1, 0.3) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // Área de contenido
        Item {
            id: areaContenido
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
        }
    }
}
