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

    // Colores según estado
    property color colorEstado: {
        switch(estado) {
            case "STANDBY": return "#9E9E9E"
            case "ASCENSO": return "#2196F3"
            case "DESCENSO": return "#FF9800"
            case "ATERRIZAJE": return "#4CAF50"
            case "ERROR": return "#f44336"
            default: return "#9E9E9E"
        }
    }

    contenido: ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // ESTADO PRINCIPAL (Grande y destacado)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: colorEstado
            radius: 8

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2

                Text {
                    text: "ESTADO"
                    font.pixelSize: 10
                    color: "white"
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: estado
                    font.pixelSize: 22
                    color: "white"
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Animación de pulsación cuando está activo
            SequentialAnimation on opacity {
                running: estado !== "STANDBY"
                loops: Animation.Infinite
                NumberAnimation { to: 0.7; duration: 800 }
                NumberAnimation { to: 1.0; duration: 800 }
            }
        }

        // INFORMACIÓN DETALLADA
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 15

            // Paracaídas
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "🪂"
                    font.pixelSize: 16
                }

                ColumnLayout {
                    spacing: 2

                    Text {
                        text: "Paracaídas"
                        font.pixelSize: 9
                        color: "#666"
                    }

                    Text {
                        text: estadoParacaidas
                        font.pixelSize: 12
                        font.bold: true
                        color: estadoParacaidas === "ABIERTO" ? "#4CAF50" : "#666"
                    }
                }
            }

            // Tiempo de Misión
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "⏱️"
                    font.pixelSize: 16
                }

                ColumnLayout {
                    spacing: 2

                    Text {
                        text: "Tiempo Misión"
                        font.pixelSize: 9
                        color: "#666"
                    }

                    Text {
                        text: tiempoMision
                        font.pixelSize: 12
                        font.bold: true
                        font.family: "Courier"
                    }
                }
            }

            // Paquetes Recibidos
            RowLayout {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                spacing: 8

                Text {
                    text: "📦"
                    font.pixelSize: 16
                }

                ColumnLayout {
                    spacing: 2

                    Text {
                        text: "Paquetes Recibidos"
                        font.pixelSize: 9
                        color: "#666"
                    }

                    Text {
                        text: paquetesRecibidos.toString()
                        font.pixelSize: 12
                        font.bold: true
                        color: paquetesRecibidos > 0 ? "#4CAF50" : "#666"
                    }
                }
            }
        }
    }
}
