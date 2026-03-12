import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

Rectangle {
    id: root
    width: 1600
    height: Theme.alturaEncabezado
    color: Theme.fondoEncabezado
    border.color: "transparent"
    border.width: 0

    // Línea inferior cyan
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Theme.acento }
            GradientStop { position: 0.5; color: Qt.rgba(0, 0.898, 1, 0.3) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Señales
    signal cambioPuerto(string puerto)
    signal cambioBaudrate(string baudrate)
    signal solicitudConectar()
    signal solicitudDesconectar()
    signal abrirMenu()

    // Estado de conexión: 0=Desconectado, 1=Conectando, 2=Conectado
    property int estadoConexion: 0
    property bool estaConectado: estadoConexion === 2
    property bool estaConectando: estadoConexion === 1
    property int segundosTranscurridos: 0
    property string puertoSeleccionado: comboPuerto.currentText
    property string baudrateSeleccionado: comboBaudrate.currentText
    property bool esSimulacion: comboPuerto.currentText === "SIMULADOR"
    property bool esNoConectado: comboPuerto.currentText === "No conectado"
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
            border.color: Theme.bordeOscuro
            border.width: 1
            radius: width / 2
            Layout.alignment: Qt.AlignVCenter
            color: menuMouseArea.pressed ? Theme.hoverGris : "transparent"

            Column {
                anchors.centerIn: parent
                spacing: 3
                Rectangle { width: 18; height: 2; color: Theme.textoMedio }
                Rectangle { width: 18; height: 2; color: Theme.textoMedio }
                Rectangle { width: 18; height: 2; color: Theme.textoMedio }
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
                color: Theme.textoCyan
                font.letterSpacing: 2
            }

            RowLayout {
                spacing: 6

                Text {
                    text: "v2.0"
                    font.pixelSize: Theme.fuenteBody
                    color: Theme.textoMedio
                }

                Rectangle {
                    width: 42; height: 18
                    radius: 9
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00c853" }
                        GradientStop { position: 1.0; color: "#00a844" }
                    }
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
            font.letterSpacing: 4
            color: Theme.textoMedio
            font.bold: true
        }

        // Espaciador
        Item { Layout.fillWidth: true }

        // Temporizador
        Text {
            text: root.tiempoMision
            font.family: Theme.fuenteMono
            font.pixelSize: 16
            color: Theme.textoCyan
        }

        // Indicador de conexión
        Rectangle {
            Layout.preferredHeight: 30
            Layout.preferredWidth: indicadorRow.implicitWidth + 20
            color: "transparent"
            border.color: Theme.bordeOscuro
            border.width: 1
            radius: Theme.radioPequeno

            RowLayout {
                id: indicadorRow
                anchors.centerIn: parent
                spacing: 8

                IndicadorLED {
                    estado: root.estadoConexion
                    etiqueta: root.estaConectado  ? "CONECTADO"
                            : root.estaConectando ? "CONECTANDO..."
                            : "DESCONECTADO"
                }
            }
        }

        // Selector de puerto
        ComboBox {
            id: comboPuerto
            model: {
                var puertos = ["No conectado", "SIMULADOR"]
                if (typeof serialManager !== "undefined") {
                    var reales = serialManager.puertosDisponibles
                    for (var i = 0; i < reales.length; i++)
                        puertos.push(reales[i])
                }
                return puertos
            }
            Layout.preferredHeight: 30
            Layout.preferredWidth: 130
            onCurrentTextChanged: root.cambioPuerto(currentText)

            background: Rectangle {
                color: Theme.fondoInput
                border.color: Theme.bordeOscuro
                border.width: 1
                radius: Theme.radioPequeno
            }
            contentItem: Text {
                text: comboPuerto.displayText
                color: Theme.textoOscuro
                font.pixelSize: Theme.fuenteBody
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        // Selector de baudrate
        ComboBox {
            id: comboBaudrate
            model: ["9600", "115200", "230400"]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 100
            onCurrentTextChanged: root.cambioBaudrate(currentText)

            background: Rectangle {
                color: Theme.fondoInput
                border.color: Theme.bordeOscuro
                border.width: 1
                radius: Theme.radioPequeno
            }
            contentItem: Text {
                text: comboBaudrate.displayText
                color: Theme.textoOscuro
                font.pixelSize: Theme.fuenteBody
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        // Botón conectar/desconectar
        Button {
            id: btnConectar
            text: root.estaConectado  ? "DESCONECTAR"
                : root.estaConectando ? "CANCELAR"
                : "CONECTAR"
            enabled: (!root.esNoConectado || root.estaConectado || root.estaConectando)
            Layout.preferredHeight: 35
            Layout.preferredWidth: 120

            contentItem: Text {
                text: parent.text
                color: parent.enabled ? Theme.textoBlanco : Theme.textoClaro
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fuenteSmall
                font.bold: true
                font.letterSpacing: 1
            }

            background: Rectangle {
                color: {
                    if (!btnConectar.enabled) return Theme.fondoInput
                    if (root.estaConectado || root.estaConectando) return Qt.rgba(1, 0.278, 0.341, 0.2)
                    return Qt.rgba(0, 0.898, 1, 0.15)
                }
                border.color: {
                    if (!btnConectar.enabled) return Theme.bordeOscuro
                    if (root.estaConectado || root.estaConectando) return Theme.error
                    return Theme.acento
                }
                border.width: 1
                radius: Theme.radioPequeno
            }

            onClicked: {
                if (root.estadoConexion === 0) {
                    segundosTranscurridos = 0
                    root.solicitudConectar()
                } else {
                    root.solicitudDesconectar()
                }
            }
        }
    }

    // Timer de misión (corre en CONECTANDO y CONECTADO)
    Timer {
        running: root.estadoConexion > 0
        interval: 1000
        repeat: true
        onTriggered: root.segundosTranscurridos++
    }
}
