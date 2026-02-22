import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    color: Theme.fondoOscuro
    border.color: Theme.bordeOscuro
    border.width: Theme.bordeAncho
    radius: Theme.radio

    // Propiedades de datos
    property real altitud: 0.0
    property real altitudMaxima: 500.0
    property bool datosDisponibles: false

    property real _porcentaje: datosDisponibles
                               ? Math.min(altitud / altitudMaxima, 1.0)
                               : 0.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.margen
        spacing: 6

        Item { Layout.fillHeight: true }

        // Valor grande
        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Text {
                text: root.datosDisponibles ? root.altitud.toFixed(1) : "--"
                font.pixelSize: 36
                font.bold: true
                color: Theme.textoBlanco
                anchors.baseline: unidadTexto.baseline
            }

            Text {
                id: unidadTexto
                text: "m"
                font.pixelSize: Theme.fuenteH3
                color: Theme.acentoCyan
            }
        }

        // Etiqueta
        Text {
            text: "ALTITUD RELATIVA"
            font.pixelSize: Theme.fuenteSmall
            font.bold: true
            color: "#8899aa"
            Layout.alignment: Qt.AlignHCenter
        }

        // Barra de progreso
        Rectangle {
            Layout.fillWidth: true
            height: 8
            radius: 4
            color: Theme.superficieOscura

            Rectangle {
                width: parent.width * root._porcentaje
                height: parent.height
                radius: 4
                color: Theme.acentoCyan

                Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }
        }

        Item { Layout.preferredHeight: 4 }
    }
}
