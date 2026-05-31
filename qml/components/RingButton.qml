// RingButton — a single glowing round transport button.
//
// The "ring" in the file name is the design language, not the geometry — each
// is one circle. They form the Sonique-style arc when laid out in a Row.

import QtQuick
import QtQuick.Controls.Basic

Item {
    id: btn
    width: primary ? 36 : 28
    height: width

    property string glyph: ""
    property bool primary: false
    signal clicked()

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        gradient: Gradient {
            GradientStop {
                position: 0
                color: primary ? "#3a4250" : "#2a2e35"
            }
            GradientStop {
                position: 1
                color: primary ? "#101620" : "#0e1014"
            }
        }
        border.color: hover.hovered
            ? "#9cf0ff"
            : (primary ? "#3da1ff" : "#3a4250")
        border.width: 1

        // Inner highlight ring for the glow.
        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: width / 2
            color: "transparent"
            border.color: Qt.rgba(0.6, 0.94, 1.0, hover.hovered ? 0.55 : 0.2)
            border.width: 1
        }

        Text {
            anchors.centerIn: parent
            text: glyph
            color: hover.hovered ? "#dff4ff" : "#9cf0ff"
            font.pixelSize: primary ? 16 : 12
        }

        HoverHandler { id: hover }
        TapHandler { onTapped: btn.clicked() }
    }

    Behavior on scale { NumberAnimation { duration: 80 } }
    scale: hover.hovered ? 1.06 : 1.0
}
