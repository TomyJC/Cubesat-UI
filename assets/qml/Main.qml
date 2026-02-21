import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "Modulos"
import "Modulos/Paneles"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1600
    height: 900
    color: "#f0f0f0"
    title: "UI-TELSTAR"

    //MENU-DESPEGABLE
    MenuDrawer {
        id: menuDrawer
        height: mainWindow.height
        onOpcionSeleccionada: function(opcion) {
            console.log("Cambiar a:", opcion)
        }
    }

    //ENCABEZADO
    Encabezado {
        id: encabezado
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5

        //EVENTOS
        onCambioPuerto: function(puerto) {
            console.log("Puerto seleccionado:", puerto)
        }

        onCambioBaudrate: function(baudrate) {
            console.log("Baudrate seleccionado:", baudrate)
        }

        onConexionCambiada: function(conectado) {
            console.log("Conexión:", conectado ? "Conectado" : "Desconectado")

            if (conectado) { panelEstadoMision.estado = "ASCENSO"}
            else {
                panelEstadoMision.estado = "STANDBY"
                panelEstadoMision.paquetesRecibidos = 0
            }
        }

        onAbrirMenu: menuDrawer.open()
    }

    //CONTENIDO PRINCIPAL - GRID DE 3 COLUMNAS
    GridLayout {
        anchors.top: encabezado.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5

        columns: 3
        rowSpacing: 10
        columnSpacing: 10

        // =================== COLUMNA 1 (Izquierda) ===================
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.20  // ← 20% del ancho
            Layout.minimumWidth: 220
            spacing: 10

            // Panel Estado de Misión
            EstadoMision {
                id: panelEstadoMision
                Layout.fillWidth: true

                estado: "STANDBY"
                estadoParacaidas: "CERRADO"
                tiempoMision: encabezado.tiempoMision
                paquetesRecibidos: 0
            }

            // Panel Altitud (placeholder por ahora)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                color: "white"
                border.color: "#333"
                border.width: 2
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: "ALTITUD"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e0e0e0"
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        text: "Altitud: --"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#f5f5f5"
                        border.color: "#ccc"

                        Text {
                            anchors.centerIn: parent
                            text: "GRÁFICA DE BARRA\nALTITUD"
                            font.italic: true
                            horizontalAlignment: Text.AlignHCenter
                            color: "#666"
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // Panel Batería (placeholder por ahora)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                border.color: "#333"
                border.width: 2
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: "BATERÍA/ESTADO DE\nCONECTIVIDAD"
                        font.pixelSize: 12
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e0e0e0"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.fillHeight: true
                            color: "#e0e0e0"
                            border.color: "#333"

                            Text {
                                anchors.centerIn: parent
                                text: "GRÁFICA\nBARRA\nBATERIA"
                                font.pixelSize: 9
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            Text { text: "Voltaje: --"; font.pixelSize: 10 }
                            Text { text: "Corriente: --"; font.pixelSize: 10 }
                            Text { text: "RSSI: --"; font.pixelSize: 10 }
                            Text { text: "CPU Load: --"; font.pixelSize: 10 }
                            Text { text: "CPU Temp: --"; font.pixelSize: 10 }
                        }
                    }
                }
            }
        }

        // =================== COLUMNA 2 (Centro - más ancha) ===================
        ColumnLayout {
               Layout.fillHeight: true
               Layout.preferredWidth: parent.width * 0.55  // ← 55% del ancho
               Layout.minimumWidth: 500
               spacing: 10

            // Panel Geolocalización
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                color: "white"
                border.color: "#333"
                border.width: 2
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "GEOLOCALIZACIÓN"
                            font.pixelSize: 14
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Cam"
                            Layout.preferredWidth: 50
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e0e0e0"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#f5f5f5"
                        border.color: "#ccc"
                        radius: 10

                        Text {
                            anchors.centerIn: parent
                            text: "GRÁFICA GPS/\nCAMARA(EN DECISION)"
                            font.italic: true
                            horizontalAlignment: Text.AlignHCenter
                            color: "#666"
                        }
                    }
                }
            }

            // Panel Sensores Ambientales
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                color: "white"
                border.color: "#333"
                border.width: 2
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 20

                    ColumnLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "SENSORES\nAMBIENTALES"
                            font.pixelSize: 12
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Item { Layout.fillHeight: true }

                        Text { text: "Temperatura Interna: --"; font.pixelSize: 10 }
                        Text { text: "Temperatura Externa: --"; font.pixelSize: 10 }
                        Text { text: "Presión: --"; font.pixelSize: 10 }
                        Text { text: "Humedad: --"; font.pixelSize: 10 }

                        Item { Layout.fillHeight: true }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "DATOS/SENSOR EXTRA"
                            font.pixelSize: 12
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Item { Layout.fillHeight: true }

                        Text {
                            text: "CCS811"
                            font.pixelSize: 24
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // Acelerómetro + Velocidad (en fila)
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                // Acelerómetro
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    border.color: "#333"
                    border.width: 2
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            text: "ACELEROMETRO"
                            font.pixelSize: 12
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#e0e0e0"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#f5f5f5"
                            border.color: "#ccc"
                            radius: 20

                            Text {
                                anchors.centerIn: parent
                                text: "GRÁFICA DE ACELEROMETRO\n(x,y,z)"
                                font.italic: true
                                horizontalAlignment: Text.AlignHCenter
                                color: "#666"
                            }
                        }
                    }
                }

                // Velocidad de Descenso
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    border.color: "#333"
                    border.width: 2
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            text: "VELOCIDAD DE DESCENSO"
                            font.pixelSize: 12
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#e0e0e0"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#f5f5f5"
                            border.color: "#ccc"
                            radius: 20

                            Text {
                                anchors.centerIn: parent
                                text: "Gráfica de velocidad\n(x,y,z)"
                                font.italic: true
                                horizontalAlignment: Text.AlignHCenter
                                color: "#666"
                            }
                        }
                    }
                }
            }
        }

        // =================== COLUMNA 3 (Derecha) ===================
        ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.20  // ← 20% del ancho
                Layout.minimumWidth: 220
                spacing: 10

            // Panel Orientación
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                color: "white"
                border.color: "#333"
                border.width: 2
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Text {
                        text: "ORIENTACIÓN"
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e0e0e0"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 180
                        color: "#f5f5f5"
                        border.color: "#ccc"
                        radius: 10

                        Text {
                            anchors.centerIn: parent
                            text: "GRÁFICA CUBO 3D"
                            font.italic: true
                            color: "#666"
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            text: "Pitch: --   Raw: --   Yall : --"
                            font.pixelSize: 10
                        }

                        RowLayout {
                            Text {
                                text: "Estado: Estable/Inestable"
                                font.pixelSize: 10
                            }
                            RadioButton { checked: true }
                        }

                        Text {
                            text: "Velocidad Angular: --"
                            font.pixelSize: 10
                        }
                    }
                }
            }

            // Panel Consola de Salida
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                border.color: "#333"
                border.width: 2
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 5

                    Text {
                        text: "CONSOLA DE SALIDA"
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e0e0e0"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#1e1e1e"
                        border.color: "#666"
                        radius: 10

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 5

                            TextArea {
                                id: consolaTexto
                                text: "Log de recepción de Datos:"
                                color: "#00ff00"
                                font.family: "Courier"
                                font.pixelSize: 10
                                readOnly: true
                                wrapMode: TextEdit.Wrap
                                background: Rectangle { color: "transparent" }
                            }
                        }
                    }
                }
            }
        }
    }

    // TIMER PARA SIMULAR DATOS
    Timer {
        interval: 1000
        running: encabezado.estaConectado
        repeat: true

        onTriggered: {
            panelEstadoMision.paquetesRecibidos++

            // Agregar log a consola
            consolaTexto.text += "\n[" + Qt.formatTime(new Date(), "hh:mm:ss") + "] Paquete #" + panelEstadoMision.paquetesRecibidos + " recibido"

            if (encabezado.segundosTranscurridos > 10 && panelEstadoMision.estado === "ASCENSO") {
                panelEstadoMision.estado = "DESCENSO"
                panelEstadoMision.estadoParacaidas = "ABIERTO"
            }
        }
    }
}
