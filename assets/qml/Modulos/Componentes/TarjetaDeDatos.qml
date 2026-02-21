import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: "white"
    border.color: "#333"
    border.width: 2
    radius: 8

    //PROPIEDADES PERZONALIZABLES
    property string titulo: ""
    property string icono: ""
    property color colorTitulo: "#333"
    property color colorFondo: "white"

    //CONTENIDO INCLUIDO
    property alias contenido: areaContenido.children

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // HEADER TARJETA
        RowLayout {
            Layout.fillWidth: true
            visible: titulo !== ""

            //ICONO
            Text {
                text: icono
                font.pixelSize: 18
                visible: icono !== ""
            }

            // TITULO
            Text {
                text: titulo
                font.pixelSize: 14
                font.bold: true
                color: colorTitulo
                Layout.fillWidth: true
            }
        }

        // Línea separadora
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#e0e0e0"
            visible: titulo !== ""
        }

        // CONTENIDO de la tarjeta
        Item {
            id: areaContenido
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
