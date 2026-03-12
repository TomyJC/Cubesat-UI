import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Componentes"

TarjetaDeDatos {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    titulo: "ESTADO DE LA MISIÓN"
    icono: "🚀"

    property string estado: "STANDBY"
    property string estadoParacaidas: "CERRADO"
    property string tiempoMision: "00:00:00"
    property int paquetesRecibidos: 0
    property int servo: 0
    property string gpsFix: "--"
    property string ens160Estado: "--"
    property string camaraEstado: "APAGADA"
    property real altitud: 0.0
    property real altitudMaxima: 500.0
    property bool altitudDisponible: false

    property real _porcentaje: altitudDisponible
                               ? Math.min(altitud / altitudMaxima, 1.0)
                               : 0.0

    contenido: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 2
        spacing: 6

        // ── Badge de estado ──────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 44
            radius: Theme.radio
            color: Theme.colorEstadoMision(root.estado)

            RowLayout {
                anchors.centerIn: parent
                spacing: 8

                // Indicador pulsante
                Rectangle {
                    width: 8; height: 8; radius: 4
                    color: Theme.textoBlanco
                    opacity: 0.9

                    SequentialAnimation on opacity {
                        running: root.estado !== "STANDBY"
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.2; duration: 700; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 700; easing.type: Easing.InOutSine }
                    }
                }

                Column {
                    spacing: 1
                    Text {
                        text: "ESTADO"
                        font.pixelSize: Theme.fuenteCaption
                        color: Qt.rgba(1, 1, 1, 0.7)
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.letterSpacing: 1.5
                    }
                    Text {
                        text: root.estado
                        font.pixelSize: Theme.fuenteH2
                        color: Theme.textoBlanco
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            SequentialAnimation on opacity {
                running: root.estado !== "STANDBY"
                loops: Animation.Infinite
                NumberAnimation { to: 0.88; duration: 1100; easing.type: Easing.InOutSine }
                NumberAnimation { to: 1.0;  duration: 1100; easing.type: Easing.InOutSine }
            }
        }

        // ── Tabla de datos ───────────────────────
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 4
            columnSpacing: 8

            // ── Paracaídas ──
            Text { text: "🪂  Paracaídas"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Text {
                text: root.estadoParacaidas
                font.pixelSize: Theme.fuenteSmall; font.bold: true
                font.family: Theme.fuenteMono
                color: root.estadoParacaidas === "ABIERTO" ? Theme.exito : Theme.textoMedio
                Layout.alignment: Qt.AlignRight
            }

            // ── Servo ──
            Text { text: "⚙  Servo"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Text {
                text: root.servo + "°"
                font.pixelSize: Theme.fuenteSmall; font.bold: true
                font.family: Theme.fuenteMono
                color: Theme.textoValor
                Layout.alignment: Qt.AlignRight
            }

            // ── Tiempo ──
            Text { text: "⏱  Tiempo"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Text {
                text: root.tiempoMision
                font.pixelSize: Theme.fuenteSmall; font.bold: true
                font.family: Theme.fuenteMono
                color: Theme.textoCyan
                Layout.alignment: Qt.AlignRight
            }

            // ── Paquetes ──
            Text { text: "📦  Paquetes"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Text {
                text: root.paquetesRecibidos.toString()
                font.pixelSize: Theme.fuenteSmall; font.bold: true
                font.family: Theme.fuenteMono
                color: root.paquetesRecibidos > 0 ? Theme.exito : Theme.textoClaro
                Layout.alignment: Qt.AlignRight
            }

            // ── GPS Fix ──
            Text { text: "📡  GPS Fix"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Text {
                text: root.gpsFix
                font.pixelSize: Theme.fuenteSmall; font.bold: true
                font.family: Theme.fuenteMono
                color: Theme.textoValor
                Layout.alignment: Qt.AlignRight
            }

            // ── ENS160 ──
            Text { text: "🌫  ENS160"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Text {
                text: root.ens160Estado
                font.pixelSize: Theme.fuenteSmall; font.bold: true
                font.family: Theme.fuenteMono
                color: root.ens160Estado === "LISTO" ? Theme.exito : Theme.textoClaro
                Layout.alignment: Qt.AlignRight
            }

            // ── Cámara ──
            Text { text: "📷  Cámara"; font.pixelSize: Theme.fuenteSmall; color: Theme.textoClaro; Layout.fillWidth: true }
            Row {
                Layout.alignment: Qt.AlignRight
                spacing: 5

                Rectangle {
                    visible: root.camaraEstado === "GRABANDO"
                    width: 7; height: 7; radius: 3.5
                    color: Theme.error
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on opacity {
                        running: root.camaraEstado === "GRABANDO"
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.2; duration: 500 }
                        NumberAnimation { to: 1.0; duration: 500 }
                    }
                }

                Text {
                    text: root.camaraEstado
                    font.pixelSize: Theme.fuenteSmall; font.bold: true
                    font.family: Theme.fuenteMono
                    color: root.camaraEstado === "GRABANDO" ? Theme.exito : Theme.textoClaro
                }
            }
        }

        // ── Separador ───────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.bordeSeparador
        }

        // ── Altitud relativa ─────────────────────
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            // ── Etiqueta ─────────────────────────
            Text {
                text: "ALTITUD RELATIVA"
                font.pixelSize: Theme.fuenteCaption
                font.bold: true
                font.letterSpacing: 1.5
                color: Theme.textoClaro
                Layout.alignment: Qt.AlignHCenter
            }

            // ── Valor de altitud ─────────────────
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    text: root.altitudDisponible ? root.altitud.toFixed(1) : "--"
                    font.pixelSize: 28
                    font.bold: true
                    font.family: Theme.fuenteMono
                    color: Theme.textoCyan
                }

                Text {
                    text: "m"
                    font.pixelSize: Theme.fuenteH3
                    color: Theme.textoMedio
                    Layout.alignment: Qt.AlignBottom
                }
            }

            // ── Barra de progreso ───────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 6
                radius: 3
                color: Qt.rgba(0, 0.898, 1, 0.1)

                Rectangle {
                    width: parent.width * root._porcentaje
                    height: parent.height
                    radius: 3
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Theme.acento }
                        GradientStop { position: 1.0; color: Theme.acentoAzul }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }
}
