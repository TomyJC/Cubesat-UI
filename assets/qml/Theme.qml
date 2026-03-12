pragma Singleton
import QtQuick

QtObject {
    // ===== COLORES — TEMA OSCURO AEROESPACIAL =====

    // Fondos
    readonly property color fondoApp:           "#0a0e17"
    readonly property color fondoTarjeta:        "#111827"
    readonly property color fondoTarjetaBorde:   Qt.rgba(0, 0.898, 1, 0.12)
    readonly property color fondoPlaceholder:    "#0d1520"
    readonly property color fondoConsola:        "#060a10"
    readonly property color fondoOscuro:         "#080c14"
    readonly property color superficieOscura:    "#162230"
    readonly property color fondoEncabezado:     "#0f1520"
    readonly property color fondoInput:          "#1a2332"

    // Acentos
    readonly property color acentoCyan:    "#00e5ff"
    readonly property color acentoAzul:    "#3b82f6"
    readonly property color acento:        "#00e5ff"

    // Estados
    readonly property color exito:       "#00ff88"
    readonly property color advertencia: "#ff9f43"
    readonly property color error:       "#ff4757"
    readonly property color neutro:      "#4a5568"

    // Texto
    readonly property color textoOscuro:   "#e0e6ed"
    readonly property color textoMedio:    "#8899aa"
    readonly property color textoClaro:    "#4a5568"
    readonly property color textoBlanco:   "#ffffff"
    readonly property color textoConsola:  "#00ff88"
    readonly property color textoCyan:     "#00e5ff"
    readonly property color textoValor:    "#e0e6ed"

    // Bordes
    readonly property color bordeOscuro:     Qt.rgba(0, 0.898, 1, 0.15)
    readonly property color bordeSuave:      Qt.rgba(0.4, 0.5, 0.6, 0.2)
    readonly property color bordeSeparador:  Qt.rgba(0.4, 0.5, 0.6, 0.15)

    // Interacción
    readonly property color hoverClaro:  Qt.rgba(0, 0.898, 1, 0.08)
    readonly property color hoverGris:   Qt.rgba(1, 1, 1, 0.06)

    // Glow
    readonly property color glowCyan:    Qt.rgba(0, 0.898, 1, 0.3)
    readonly property color glowVerde:   Qt.rgba(0, 1, 0.53, 0.3)
    readonly property color glowRojo:    Qt.rgba(1, 0.278, 0.341, 0.3)

    // Ejes (para acelerómetro / orientación)
    readonly property color ejeX: "#ff6b6b"
    readonly property color ejeY: "#51cf66"
    readonly property color ejeZ: "#339af0"

    // ===== TIPOGRAFÍA =====
    readonly property int fuenteH1:      22
    readonly property int fuenteH2:      18
    readonly property int fuenteH3:      14
    readonly property int fuenteBody:    12
    readonly property int fuenteSmall:   10
    readonly property int fuenteCaption: 9
    readonly property int fuenteValorGrande: 32
    readonly property string fuenteMono: "Consolas, Courier, monospace"

    // ===== DIMENSIONES =====
    readonly property int radio:              8
    readonly property int radioGrande:        10
    readonly property int radioPequeno:       4
    readonly property int bordeAncho:         1
    readonly property int bordeAnchoPequeno:  1
    readonly property int margen:             10
    readonly property int margenPequeno:      5
    readonly property int espaciado:          10
    readonly property int espaciadoPequeno:   5

    // Encabezado
    readonly property int alturaEncabezado: 80

    // ===== FUNCIONES DE ESTADO =====
    function colorEstadoMision(estado) {
        switch(estado) {
            case "STANDBY":    return neutro
            case "ASCENSO":    return acentoAzul
            case "DESCENSO":   return advertencia
            case "ATERRIZAJE": return exito
            case "ERROR":      return error
            default:           return neutro
        }
    }
}
