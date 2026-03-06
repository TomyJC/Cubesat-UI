import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "Vistas"
import "Layout"

ApplicationWindow {
    id: mainWindow
    visible: true
    // Adaptar al tamaño de pantalla disponible
    width:  Math.min(1600, Screen.desktopAvailableWidth * 0.95)
    height: Math.min(900, Screen.desktopAvailableHeight * 0.92)
    minimumWidth:  1024
    minimumHeight: 600
    color: Theme.fondoApp
    title: "TELSTAR — Ground Station"

    // ===== Mensaje de inicio =====
    Component.onCompleted: {
        vistaTelemetria.panelConsola.agregarLog("========================================")
        vistaTelemetria.panelConsola.agregarLog("  TELSTAR — ESTACIÓN TERRENA INICIADA")
        vistaTelemetria.panelConsola.agregarLog("========================================")
        vistaTelemetria.panelConsola.agregarLog("Esperando conexión...")
    }

    // ===== Menú lateral =====
    MenuDrawer {
        id: menuDrawer
        height: mainWindow.height

        onOpcionSeleccionada: function(vista) {
            console.log("Navegar a:", vista)
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

            onSolicitudConectar: {
                console.log("Solicitud de conexión")

                if (encabezado.esSimulacion) {
                    simulador.iniciar()
                    // En simulación, pasar directo a "conectado" (estadoConexion=2)
                    encabezado.estadoConexion = 2
                } else {
                    vistaTelemetria.panelConsola.agregarLog(
                        "[SERIAL] Conectando a " + encabezado.puertoSeleccionado +
                        " @ " + encabezado.baudrateSeleccionado + " baud...")
                    serialManager.conectar(encabezado.puertoSeleccionado,
                                           parseInt(encabezado.baudrateSeleccionado))
                }
                csvWriter.iniciarSesion("datos")
            }

            onSolicitudDesconectar: {
                console.log("Solicitud de desconexión")

                if (encabezado.esSimulacion) {
                    simulador.detener()
                } else {
                    serialManager.desconectar()
                }
                csvWriter.finalizarSesion()
                telemetry.resetear()
                encabezado.estadoConexion = 0
                vistaTelemetria.panelConsola.agregarLog("[SERIAL] Desconectado")
                vistaTelemetria.panelConsola.agregarLog("Esperando conexión...")
            }

            onAbrirMenu: menuDrawer.open()
        }

        // Contenido — Vista de telemetría
        VistaTelemetria {
            id: vistaTelemetria
            Layout.fillWidth: true
            Layout.fillHeight: true

            estadoMision: telemetry.estado
            estadoParacaidas: telemetry.estadoParacaidas
            tiempoMision: telemetry.tiempoMision
            paquetesRecibidos: telemetry.paquetesRecibidos
            estaConectado: serialManager.conectado
            segundosTranscurridos: encabezado.segundosTranscurridos
        }
    }

    // ===== Conexiones con el backend =====
    Connections {
        target: telemetry

        function onLogAgregado(tipo, mensaje) {
            vistaTelemetria.panelConsola.agregarLog(mensaje)
        }
    }

    Connections {
        target: serialManager

        function onErrorConexion(mensaje) {
            console.log("Error serial:", mensaje)
            vistaTelemetria.panelConsola.agregarLog("[ERROR] " + mensaje)
            encabezado.estadoConexion = 0
        }

        function onEstadoConexionCambiado() {
            // Sincronizar estado del backend → encabezado
            encabezado.estadoConexion = serialManager.estadoConexion
            if (serialManager.estadoConexion === 2) {
                vistaTelemetria.panelConsola.agregarLog("[SERIAL] ¡Conexión confirmada!")
            }
        }
    }
}
