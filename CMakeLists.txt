cmake_minimum_required(VERSION 3.16)

project(TELSTAR_OFFICIAL VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

# ─── Marcar Theme.qml como Singleton ───
set_source_files_properties(assets/qml/Theme.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_executable(appTELSTAR_OFFICIAL
    src/main.cpp
)

qt_add_qml_module(appTELSTAR_OFFICIAL
    URI TELSTAR_OFFICIAL

    QML_FILES
        # Raíz
        assets/qml/Main.qml
        assets/qml/Theme.qml
        assets/qml/Layout/Encabezado.qml
        assets/qml/Layout/MenuDrawer.qml

        # Componentes reutilizables
        assets/qml/Componentes/TarjetaDeDatos.qml
        assets/qml/Componentes/IndicadorLED.qml
        assets/qml/Componentes/PlaceholderPanel.qml

        # Paneles de datos
        assets/qml/Paneles/PanelEstadoMision.qml

        assets/qml/Paneles/PanelBateria.qml
        assets/qml/Paneles/PanelGeolocalizacion.qml
        assets/qml/Paneles/PanelSensores.qml
        assets/qml/Paneles/PanelAcelerometro.qml
        assets/qml/Paneles/PanelVelocidad.qml
        assets/qml/Paneles/PanelOrientacion.qml
        assets/qml/Paneles/PanelConsola.qml

        # Vistas
        assets/qml/Vistas/VistaTelemetria.qml

    RESOURCES
        assets/Imagenes/LogoTELSTAR.png
        assets/Imagenes/SatelitePlaneta.png
)

set_target_properties(appTELSTAR_OFFICIAL PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTELSTAR_OFFICIAL
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appTELSTAR_OFFICIAL
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
