import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    color: Theme.fondoTarjeta
    border.color: Theme.bordeOscuro
    border.width: Theme.bordeAncho
    radius: Theme.radio

    // Propiedades personalizables
    property string titulo: ""
    property string icono: ""
    property color colorTitulo: Theme.textoOscuro
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

            Text {
                text: root.icono
                font.pixelSize: Theme.fuenteH2
                visible: root.icono !== ""
            }

            Text {
                text: root.titulo
                font.pixelSize: Theme.fuenteH3
                font.bold: true
                color: root.colorTitulo
                Layout.fillWidth: true
            }
        }

        // Línea separadora
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.bordeSeparador
            visible: root.titulo !== ""
        }

        // Área de contenido
        Item {
            id: areaContenido
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
