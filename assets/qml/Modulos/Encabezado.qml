import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 1600
    height: 80
    color: "white"
    border.color: "black"
    border.width: 2

    // SEÑALES
    signal cambioPuerto(string puerto)
    signal cambioBaudrate(string baudrate)
    signal conexionCambiada(bool conectado)
    signal abrirMenu()

    // PROPIEDADES
    property bool estaConectado: false
    property int segundosTranscurridos: 0
    property string tiempoMision: {
            let total = segundosTranscurridos
            let h = Math.floor(total / 3600).toString().padStart(2, '0')
            let m = Math.floor((total % 3600) / 60).toString().padStart(2, '0')
            let s = (total % 60).toString().padStart(2, '0')
            return `T+ ${h}:${m}:${s}`
        }

    // HEADER PRINCIPAL
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        //BOTÓN DE MENÚ
        Rectangle {
            id: menuButton
            width: 40
            height: 40
            border.color: "black"
            border.width: 2
            radius: width / 2
            Layout.alignment: Qt.AlignVCenter
            color: menuMouseArea.pressed ? "#e0e0e0" : "white"

            Column {
                anchors.centerIn: parent
                spacing: 3
                Rectangle { width: 18; height: 2; color: "black" }
                Rectangle { width: 18; height: 2; color: "black" }
                Rectangle { width: 18; height: 2; color: "black" }
            }

            MouseArea {
                id: menuMouseArea
                anchors.fill: parent
                onClicked: root.abrirMenu()
            }
        }

        //TELSTAR + VERSIÓN
        ColumnLayout {
            spacing: -2
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "TELSTAR"
                font.pixelSize: 22
                font.bold: true
                color: "black"
            }

            RowLayout {
                spacing: 6
                Text {
                    text: "v1.0"
                    font.pixelSize: 12
                    color: "#555"
                }
                Rectangle {
                    width: 42; height: 18
                    color: "#4CAF50"
                    radius: 9
                    Text {
                        anchors.centerIn: parent
                        text: "PUCP"
                        color: "white"
                        font.pixelSize: 9
                        font.bold: true
                    }
                }
            }
        }

        //LOGO DE LA MISIÓN
        Image {
            id: missionLogo
            source: "qrc:/imagenes/SatelitePlaneta.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            sourceSize.height: 65

        }

        //ESPACIADOR
        Item { Layout.fillWidth: true }
        //TITULO DE EL HEADER
        Text {
            text: "GROUND STATION"
            font.pixelSize: 18
            font.letterSpacing: 2
            color: "#333"
            font.bold: true
        }
        //ESPACIADOR

        Item { Layout.fillWidth: true }

        //TEMPORIZADOR

        Text {
            text: root.tiempoMision
            font.family: "Consolas, monospace"
            font.pixelSize: 16
            color: "black"
        }

        //ESTADO DE CONEXION
        RowLayout {

            Rectangle {
                Layout.preferredHeight: 30
                Layout.preferredWidth: indicadorRow.implicitWidth + 20
                color: "white"
                border.color: "#cccccc"
                border.width: 1
                radius: 4

                RowLayout {
                    id: indicadorRow
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 10
                        height: 10
                        radius: 5
                        color: root.estaConectado ? "#4CAF50" : "#f44336"
                    }

                    Text {
                        text: root.estaConectado ? "CONECTADO" : "DESCONECTADO"
                        font.pixelSize: 11
                        font.bold: true
                        color: root.estaConectado ? "#4CAF50" : "#f44336"
                    }
                }
            }
        }
        //BOX-PUERTO
        ComboBox {
            id: comboPuerto
            model: ["COM1", "COM2", "COM3", "COM4"]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 100
            onCurrentTextChanged: root.cambioPuerto(currentText)
        }


        //BOX-BAUDRATE
        ComboBox {
            id: comboBaudrate
            model: ["9600", "115200", "230400"]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 100
            onCurrentTextChanged: root.cambioBaudrate(currentText)
        }

        //BOTON-ENCENDER/APAGAR
        Button {
            text: root.estaConectado ? "DESCONECTAR" : "CONECTAR"
            Layout.preferredHeight: 35
            Layout.preferredWidth: 90

            contentItem: Text {
                  text: parent.text
                  color: "black"
                  horizontalAlignment: Text.AlignHCenter
                  verticalAlignment: Text.AlignVCenter
              }

            onClicked: {

                root.estaConectado = !root.estaConectado
                root.conexionCambiada(root.estaConectado)

                 if (root.estaConectado) {  segundosTranscurridos = 0 }

            }

        }
    }

    //TIMER
    Timer {
        running: root.estaConectado
        interval: 1000
        repeat: true
        onTriggered: root.segundosTranscurridos++
    }


}
