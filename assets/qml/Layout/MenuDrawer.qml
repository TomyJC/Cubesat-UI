import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Drawer {
    id: drawer
    width: 280
    edge: Qt.LeftEdge

    // Señales
    signal opcionSeleccionada(string opcion)

    Rectangle {
        anchors.fill: parent
        color: Theme.fondoOscuro

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // Header del drawer
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#0d2137" }
                    GradientStop { position: 1.0; color: "#0a1628" }
                }

                // Línea inferior cyan
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Qt.rgba(0, 0.898, 1, 0.3)
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text: "TELSTAR 📡"
                        font.pixelSize: 20
                        font.bold: true
                        color: Theme.textoCyan
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "GROUND STATION"
                        font.pixelSize: 11
                        color: Theme.textoMedio
                        font.letterSpacing: 2
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Opciones del menú
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: menuModel
                delegate: menuDelegate
                clip: true
            }

            // Footer
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: Qt.rgba(0, 0, 0, 0.3)

                Text {
                    anchors.centerIn: parent
                    text: "© 2026 PUCP"
                    font.pixelSize: Theme.fuenteSmall
                    color: Theme.textoClaro
                }
            }
        }
    }

    // Modelo de opciones
    ListModel {
        id: menuModel
        ListElement { nombre: "Telemetría"; icono: "📊"; vista: "telemetria" }
        ListElement { nombre: "Historial";  icono: "💾"; vista: "historial"  }
        ListElement { nombre: "Configuración"; icono: "⚙"; vista: "configuracion" }
        ListElement { nombre: "Ayuda";      icono: "❓"; vista: "ayuda"      }
    }

    // Delegado para cada item
    Component {
        id: menuDelegate

        Rectangle {
            width: ListView.view.width
            height: 50
            color: mouseArea.containsMouse ? Theme.hoverClaro : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 15

                Text {
                    text: icono
                    font.pixelSize: 20
                }

                Text {
                    text: nombre
                    font.pixelSize: Theme.fuenteH3
                    color: Theme.textoOscuro
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    drawer.opcionSeleccionada(vista)
                    drawer.close()
                }
            }

            // Línea separadora
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.bordeSeparador
            }
        }
    }
}
