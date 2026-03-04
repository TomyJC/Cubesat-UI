import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

Rectangle {
    id: root
    width: 1600
    height: Theme.alturaEncabezado
    color: Theme.fondoTarjeta
    border.color: "black"
    border.width: Theme.bordeAncho

    // Señales
    signal cambioPuerto(string puerto)
    signal cambioBaudrate(string baudrate)
    signal conexionCambiada(bool conectado)
    signal abrirMenu()

    // Propiedades
    property bool estaConectado: false
    property int segundosTranscurridos: 0
    property string puertoSeleccionado: comboPuerto.currentText
    property string baudrateSeleccionado: comboBaudrate.currentText
    property string tiempoMision: {
        let total = segundosTranscurridos
        let h = Math.floor(total / 3600).toString().padStart(2, '0')
        let m = Math.floor((total % 3600) / 60).toString().padStart(2, '0')
        let s = (total % 60).toString().padStart(2, '0')
        return `T+ ${h}:${m}:${s}`
    }

    // Header principal
    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.margen
        spacing: 15

        // Botón de menú
        Rectangle {
            id: menuButton
            width: 40
            height: 40
            border.color: "black"
            border.width: Theme.bordeAncho
            radius: width / 2
            Layout.alignment: Qt.AlignVCenter
            color: menuMouseArea.pressed ? Theme.hoverGris : Theme.fondoTarjeta

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

        // TELSTAR + Versión
        ColumnLayout {
            spacing: -2
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "TELSTAR"
                font.pixelSize: Theme.fuenteH1
                font.bold: true
                color: "black"
            }

            RowLayout {
                spacing: 6

                Text {
                    text: "v1.0"
                    font.pixelSize: Theme.fuenteBody
                    color: Theme.textoMedio
                }

                Rectangle {
                    width: 42; height: 18
                    color: Theme.exito
                    radius: 9
                    Text {
                        anchors.centerIn: parent
                        text: "PUCP"
                        color: Theme.textoBlanco
                        font.pixelSize: Theme.fuenteCaption
                        font.bold: true
                    }
                }
            }
        }

        // Logo de la misión
        Image {
            id: missionLogo
            source: "../../Imagenes/SatelitePlaneta.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            sourceSize.height: 65
        }

        // Espaciador
        Item { Layout.fillWidth: true }

        // Título
        Text {
            text: "GROUND STATION"
            font.pixelSize: Theme.fuenteH2
            font.letterSpacing: 2
            color: Theme.textoOscuro
            font.bold: true
        }

        // Espaciador
        Item { Layout.fillWidth: true }

        // Temporizador
        Text {
            text: root.tiempoMision
            font.family: Theme.fuenteMono
            font.pixelSize: 16
            color: "black"
        }

        // Indicador de conexión
        Rectangle {
            Layout.preferredHeight: 30
            Layout.preferredWidth: indicadorRow.implicitWidth + 20
            color: Theme.fondoTarjeta
            border.color: Theme.bordeSuave
            border.width: Theme.bordeAnchoPequeno
            radius: Theme.radioPequeno

            RowLayout {
                id: indicadorRow
                anchors.centerIn: parent
                spacing: 8

                IndicadorLED {
                    activo: root.estaConectado
                    etiqueta: root.estaConectado ? "CONECTADO" : "DESCONECTADO"
                }
            }
        }

        // Selector de puerto (dinámico desde serialManager)
        ComboBox {
            id: comboPuerto
            model: typeof serialManager !== "undefined" ? serialManager.puertosDisponibles : ["COM1"]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 100
            onCurrentTextChanged: root.cambioPuerto(currentText)
        }

        // Selector de baudrate
        ComboBox {
            id: comboBaudrate
            model: ["9600", "115200", "230400"]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 100
            onCurrentTextChanged: root.cambioBaudrate(currentText)
        }

        // Botón conectar/desconectar
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
                if (root.estaConectado) { segundosTranscurridos = 0 }
            }
        }
    }

    // Timer de misión
    Timer {
        running: root.estaConectado
        interval: 1000
        repeat: true
        onTriggered: root.segundosTranscurridos++
    }
}
