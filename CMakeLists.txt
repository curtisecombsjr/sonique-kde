cmake_minimum_required(VERSION 3.25)
project(sonique-kde
    VERSION 0.1.0
    DESCRIPTION "From-scratch KDE/Qt6 reimagining of Sonique 1.x"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# ECM gives us KDE's CMake helpers + Qt detection nicety.
find_package(ECM 6.0 REQUIRED NO_MODULE)
list(APPEND CMAKE_MODULE_PATH ${ECM_MODULE_PATH})
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

set(QT_MIN_VERSION 6.8)
find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    Multimedia
)

set(KF_MIN_VERSION 6.0)
find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS
    CoreAddons
    Config
)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(sonique-kde
    src/main.cpp
    src/AudioEngine.h
    src/AudioEngine.cpp
)

qt_add_qml_module(sonique-kde
    URI app.sonique
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/AmpView.qml
        qml/VisView.qml
        qml/components/RingButton.qml
        qml/components/LcdReadout.qml
        qml/components/MetallicPod.qml
        qml/components/MetallicWell.qml
        qml/components/CircularVisualizer.qml
        qml/components/NumberLcd.qml
        qml/components/CenterConsole.qml
        qml/components/Sphere.qml
    RESOURCES
        assets/skin/vis-pod.png
)

# The auto-generated QML type registration TU does `#include <AudioEngine.h>`
# (angle brackets), so src/ must be on the include path.
target_include_directories(sonique-kde PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(sonique-kde PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Multimedia
    KF6::CoreAddons
    KF6::ConfigCore
    KF6::ConfigGui
)

# Force the FFmpeg backend so 24/32-bit + 96 kHz PCM works regardless of distro default.
# This is a runtime hint baked into the binary's environment via target compile def
# is wishful — actually we set it in main() via qputenv. Keeping note here.

install(TARGETS sonique-kde ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
