import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Drawer {
    id: drawer
    width: 280
    edge: Qt.LeftEdge

    //SEÑALES
    signal opcionSeleccionada(string opcion)

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // HEADER DEL DRAWER
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "#2196F3"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text: "TELSTAR📡"
                        font.pixelSize: 20
                        font.bold: true
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "GROUND STATION"
                        font.pixelSize: 11
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // OPCIONES DEL MENÚ
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: menuModel
                delegate: menuDelegate
            }

            // FOOTER
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: "#e0e0e0"

                Text {
                    anchors.centerIn: parent
                    text: "©2026 PUCP"
                    font.pixelSize: 10
                    color: "#666"
                }
            }
        }
    }

    // MODELO DE OPCIONES DEL MENÚ
    ListModel {
        id: menuModel
        ListElement { nombre: "Telemetria"; icono: "📊" }
        ListElement { nombre: "Historial"; icono: "💾" }
        ListElement { nombre: "Configuración"; icono: "⚙" }
        ListElement { nombre: "Ayuda"; icono: "❓" }
    }

    // DELEGADO PARA CADA ITEM DEL MENÚ
    Component {
        id: menuDelegate

        Rectangle {
            width: ListView.view.width
            height: 50
            color: mouseArea.containsMouse ? "#e3f2fd" : "transparent"

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
                    font.pixelSize: 14
                    color: "#333"
                }

                Item { Layout.fillWidth: true }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    drawer.opcionSeleccionada(nombre)
                    drawer.close()
                }
            }

            // LÍNEA SEPARADORA
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#e0e0e0"
            }
        }
    }
}
