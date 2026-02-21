import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "Vistas"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1600
    height: 900
    color: Theme.fondoApp
    title: "TELSTAR — Ground Station"

    // ===== Estado global de la aplicación =====
    property string estadoMision: "STANDBY"
    property string estadoParacaidas: "CERRADO"
    property int paquetesRecibidos: 0

    // ===== Menú lateral =====
    MenuDrawer {
        id: menuDrawer
        height: mainWindow.height

        onOpcionSeleccionada: function(vista) {
            console.log("Navegar a:", vista)
            // Futuro: stackView.replace(vistaComponente)
        }
    }

    // ===== Layout principal =====
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.margenPequeno
        spacing: 0

        // Header
        Encabezado {
            id: encabezado
            Layout.fillWidth: true

            onCambioPuerto: function(puerto) {
                console.log("Puerto seleccionado:", puerto)
            }

            onCambioBaudrate: function(baudrate) {
                console.log("Baudrate seleccionado:", baudrate)
            }

            onConexionCambiada: function(conectado) {
                console.log("Conexión:", conectado ? "Conectado" : "Desconectado")

                if (conectado) {
                    mainWindow.estadoMision = "ASCENSO"
                } else {
                    mainWindow.estadoMision = "STANDBY"
                    mainWindow.estadoParacaidas = "CERRADO"
                    mainWindow.paquetesRecibidos = 0
                }
            }

            onAbrirMenu: menuDrawer.open()
        }

        // Contenido — Vista de telemetría (futura StackView)
        VistaTelemetria {
            id: vistaTelemetria
            Layout.fillWidth: true
            Layout.fillHeight: true

            estadoMision: mainWindow.estadoMision
            estadoParacaidas: mainWindow.estadoParacaidas
            tiempoMision: encabezado.tiempoMision
            paquetesRecibidos: mainWindow.paquetesRecibidos
            estaConectado: encabezado.estaConectado
            segundosTranscurridos: encabezado.segundosTranscurridos
        }
    }

    // ===== Timer para simular datos en desarrollo =====
    Timer {
        interval: 1000
        running: encabezado.estaConectado
        repeat: true

        onTriggered: {
            mainWindow.paquetesRecibidos++

            // Log en consola
            vistaTelemetria.panelConsola.agregarLog(
                "[" + Qt.formatTime(new Date(), "hh:mm:ss") + "] Paquete #" +
                mainWindow.paquetesRecibidos + " recibido"
            )

            // Transición de estado simulada
            if (encabezado.segundosTranscurridos > 10 && mainWindow.estadoMision === "ASCENSO") {
                mainWindow.estadoMision = "DESCENSO"
                mainWindow.estadoParacaidas = "ABIERTO"
            }
        }
    }
}
