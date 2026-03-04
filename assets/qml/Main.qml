import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "Vistas"
import "Layout"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1600
    height: 900
    color: Theme.fondoApp
    title: "TELSTAR — Ground Station"

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

            onConexionCambiada: function(conectado) {
                console.log("Conexión:", conectado ? "Conectado" : "Desconectado")

                if (conectado) {
                    if (encabezado.esSimulacion) {
                        // Modo simulación: generar datos falsos
                        simulador.iniciar()
                    } else {
                        // Modo real: conectar al puerto serial
                        serialManager.conectar(encabezado.puertoSeleccionado,
                                               parseInt(encabezado.baudrateSeleccionado))
                    }
                    csvWriter.iniciarSesion("datos")
                } else {
                    if (encabezado.esSimulacion) {
                        simulador.detener()
                    } else {
                        serialManager.desconectar()
                    }
                    csvWriter.finalizarSesion()
                    telemetry.resetear()
                }
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
            vistaTelemetria.panelConsola.agregarLog(
                "[ERROR] " + mensaje
            )
            encabezado.estaConectado = false
        }

        function onConectadoCambiado() {
            encabezado.estaConectado = serialManager.conectado
        }
    }
}
