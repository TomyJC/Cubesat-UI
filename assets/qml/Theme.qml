pragma Singleton
import QtQuick

QtObject {
    // ===== COLORES =====
    // Fondos
    readonly property color fondoApp: "#f0f0f0"
    readonly property color fondoTarjeta: "white"
    readonly property color fondoPlaceholder: "#f5f5f5"
    readonly property color fondoConsola: "#1e1e1e"
    readonly property color fondoOscuro: "#0f1923"
    readonly property color superficieOscura: "#162230"
    readonly property color acentoCyan: "#00e5ff"

    // Bordes
    readonly property color bordeOscuro: "#333333"
    readonly property color bordeSuave: "#cccccc"
    readonly property color bordeSeparador: "#e0e0e0"

    // Acentos / Estados
    readonly property color acento: "#2196F3"
    readonly property color exito: "#4CAF50"
    readonly property color advertencia: "#FF9800"
    readonly property color error: "#f44336"
    readonly property color neutro: "#9E9E9E"

    // Texto
    readonly property color textoOscuro: "#333333"
    readonly property color textoMedio: "#555555"
    readonly property color textoClaro: "#666666"
    readonly property color textoBlanco: "#ffffff"
    readonly property color textoConsola: "#00ff00"

    // Interacción
    readonly property color hoverClaro: "#e3f2fd"
    readonly property color hoverGris: "#e0e0e0"

    // ===== TIPOGRAFÍA =====
    readonly property int fuenteH1: 22
    readonly property int fuenteH2: 18
    readonly property int fuenteH3: 14
    readonly property int fuenteBody: 12
    readonly property int fuenteSmall: 10
    readonly property int fuenteCaption: 9
    readonly property string fuenteMono: "Consolas, Courier, monospace"

    // ===== DIMENSIONES =====
    readonly property int radio: 8
    readonly property int radioGrande: 10
    readonly property int radioPequeno: 4
    readonly property int bordeAncho: 2
    readonly property int bordeAnchoPequeno: 1
    readonly property int margen: 10
    readonly property int margenPequeno: 5
    readonly property int espaciado: 10
    readonly property int espaciadoPequeno: 5

    // Encabezado
    readonly property int alturaEncabezado: 80

    // ===== FUNCIONES DE ESTADO =====
    function colorEstadoMision(estado) {
        switch(estado) {
            case "STANDBY":    return neutro
            case "ASCENSO":    return acento
            case "DESCENSO":   return advertencia
            case "ATERRIZAJE": return exito
            case "ERROR":      return error
            default:           return neutro
        }
    }
}
