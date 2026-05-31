// Sphere — a radial-gradient disc rendered through QtQuick.Shapes so the
// gradient is actually radial (Rectangle.gradient can only carry linear).
// Used for: chrome ball, volume knob, play button, screw heads.
//
// Properties tuned to evoke a lit sphere:
//   color0 — center (lit) color (top-left highlight side)
//   color1 — midtone
//   color2 — rim / shadow color
//   highlightOpacity — bright specular blob on top
//
// Place a child Item inside (e.g. an indicator dot) and it'll center.

import QtQuick
import QtQuick.Shapes

Item {
    id: sphere

    property real diameter: 32
    property color color0: "#f4f6fa"
    property color color1: "#a7b0bc"
    property color color2: "#1a1d22"
    property color rimColor: "#0a0b0d"
    property real highlightOpacity: 0.85
    property bool showHighlight: true

    implicitWidth: diameter
    implicitHeight: diameter

    Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            strokeColor: sphere.rimColor
            strokeWidth: 1
            fillGradient: RadialGradient {
                centerX: sphere.diameter * 0.35
                centerY: sphere.diameter * 0.30
                centerRadius: sphere.diameter * 0.78
                focalX: sphere.diameter * 0.35
                focalY: sphere.diameter * 0.30
                GradientStop { position: 0.00; color: sphere.color0 }
                GradientStop { position: 0.45; color: sphere.color1 }
                GradientStop { position: 1.00; color: sphere.color2 }
            }
            startX: sphere.diameter; startY: sphere.diameter / 2
            PathArc {
                x: 0; y: sphere.diameter / 2
                radiusX: sphere.diameter / 2; radiusY: sphere.diameter / 2
                direction: PathArc.Clockwise
            }
            PathArc {
                x: sphere.diameter; y: sphere.diameter / 2
                radiusX: sphere.diameter / 2; radiusY: sphere.diameter / 2
                direction: PathArc.Clockwise
            }
        }
    }

    // Specular highlight — small elliptical glow upper-left.
    Shape {
        anchors.fill: parent
        antialiasing: true
        visible: sphere.showHighlight
        opacity: sphere.highlightOpacity

        ShapePath {
            strokeWidth: 0
            fillGradient: RadialGradient {
                centerX: sphere.diameter * 0.32
                centerY: sphere.diameter * 0.22
                centerRadius: sphere.diameter * 0.32
                GradientStop { position: 0.00; color: "#ffffff" }
                GradientStop { position: 0.55; color: Qt.rgba(1, 1, 1, 0.0) }
            }
            startX: sphere.diameter; startY: sphere.diameter / 2
            PathArc {
                x: 0; y: sphere.diameter / 2
                radiusX: sphere.diameter / 2; radiusY: sphere.diameter / 2
                direction: PathArc.Clockwise
            }
            PathArc {
                x: sphere.diameter; y: sphere.diameter / 2
                radiusX: sphere.diameter / 2; radiusY: sphere.diameter / 2
                direction: PathArc.Clockwise
            }
        }
    }

    // Children placed inside Sphere render on top of the body and highlight.
    // That's fine for small indicator pips or button glyphs.
}
