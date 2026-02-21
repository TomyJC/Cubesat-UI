import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 180
    titulo: "ESTADO DE LA MISIÓN"
    icono: "🚀"

    // Propiedades del panel
    property string estado: "STANDBY"
    property string estadoParacaidas: "CERRADO"
    property string tiempoMision: "00:00:00"
    property int paquetesRecibidos: 0

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Estado principal (grande y destacado)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.colorEstadoMision(root.estado)
            radius: Theme.radio

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2

                Text {
                    text: "ESTADO"
                    font.pixelSize: Theme.fuenteSmall
                    color: Theme.textoBlanco
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: root.estado
                    font.pixelSize: Theme.fuenteH1
                    color: Theme.textoBlanco
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Animación de pulsación cuando está activo
            SequentialAnimation on opacity {
                running: root.estado !== "STANDBY"
                loops: Animation.Infinite
                NumberAnimation { to: 0.7; duration: 800 }
                NumberAnimation { to: 1.0; duration: 800 }
            }
        }

        // Información detallada
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 15

            // Paracaídas
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text { text: "🪂"; font.pixelSize: 16 }

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Paracaídas"
                        font.pixelSize: Theme.fuenteCaption
                        color: Theme.textoClaro
                    }
                    Text {
                        text: root.estadoParacaidas
                        font.pixelSize: Theme.fuenteBody
                        font.bold: true
                        color: root.estadoParacaidas === "ABIERTO" ? Theme.exito : Theme.textoClaro
                    }
                }
            }

            // Tiempo de misión
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text { text: "⏱️"; font.pixelSize: 16 }

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Tiempo Misión"
                        font.pixelSize: Theme.fuenteCaption
                        color: Theme.textoClaro
                    }
                    Text {
                        text: root.tiempoMision
                        font.pixelSize: Theme.fuenteBody
                        font.bold: true
                        font.family: Theme.fuenteMono
                    }
                }
            }

            // Paquetes recibidos
            RowLayout {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                spacing: 8

                Text { text: "📦"; font.pixelSize: 16 }

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Paquetes Recibidos"
                        font.pixelSize: Theme.fuenteCaption
                        color: Theme.textoClaro
                    }
                    Text {
                        text: root.paquetesRecibidos.toString()
                        font.pixelSize: Theme.fuenteBody
                        font.bold: true
                        color: root.paquetesRecibidos > 0 ? Theme.exito : Theme.textoClaro
                    }
                }
            }
        }
    }
}
