// MetallicPod — the asymmetric teardrop pod body for Vis View, rendered
// with QtQuick.Shapes so the body fill is a proper LinearGradient
// (vertical, with multiple stops simulating brushed metal lighting), and
// with a MultiEffect drop shadow under it.
//
// Screws are now Spheres for proper roundness.

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: pod
    implicitWidth: 280
    implicitHeight: 460

    // Drop shadow under the body.
    MultiEffect {
        source: bodyShape
        anchors.fill: bodyShape
        shadowEnabled: true
        shadowBlur: 0.7
        shadowVerticalOffset: 4
        shadowHorizontalOffset: 0
        shadowColor: "#000000"
        shadowOpacity: 0.55
    }

    // The body shape itself.
    Shape {
        id: bodyShape
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            strokeColor: "#0a0b0d"
            strokeWidth: 1.5
            fillGradient: LinearGradient {
                x1: 0; y1: 0; x2: 0; y2: pod.height
                GradientStop { position: 0.00; color: "#4a5058" }
                GradientStop { position: 0.06; color: "#5a6068" }
                GradientStop { position: 0.18; color: "#2a2e35" }
                GradientStop { position: 0.50; color: "#1c1f24" }
                GradientStop { position: 0.82; color: "#2a2e35" }
                GradientStop { position: 0.94; color: "#404650" }
                GradientStop { position: 1.00; color: "#13151a" }
            }
            startX: 38; startY: 16
            PathLine { x: pod.width - 38; y: 16 }
            PathCubic {
                x: pod.width - 8; y: 140
                control1X: pod.width - 6; control1Y: 24
                control2X: pod.width - 6; control2Y: 80
            }
            PathCubic {
                x: pod.width - 10; y: 240
                control1X: pod.width - 4; control1Y: 180
                control2X: pod.width - 4; control2Y: 220
            }
            PathCubic {
                x: pod.width - 14; y: 400
                control1X: pod.width - 2; control1Y: 280
                control2X: pod.width - 4; control2Y: 360
            }
            PathCubic {
                x: pod.width / 2 + 28; y: pod.height - 12
                control1X: pod.width - 30; control1Y: pod.height - 16
                control2X: pod.width / 2 + 60; control2Y: pod.height - 10
            }
            PathLine { x: pod.width / 2 + 22; y: pod.height - 4 }
            PathLine { x: pod.width / 2 - 22; y: pod.height - 4 }
            PathLine { x: pod.width / 2 - 28; y: pod.height - 12 }
            PathCubic {
                x: 14; y: 400
                control1X: pod.width / 2 - 60; control1Y: pod.height - 10
                control2X: 30; control2Y: pod.height - 16
            }
            PathCubic {
                x: 10; y: 240
                control1X: 4; control1Y: 360
                control2X: 2; control2Y: 280
            }
            PathCubic {
                x: 8; y: 140
                control1X: 4; control1Y: 220
                control2X: 4; control2Y: 180
            }
            PathCubic {
                x: 38; y: 16
                control1X: 6; control1Y: 80
                control2X: 6; control2Y: 24
            }
        }
    }

    // Highlight stroke along the upper edge for a beveled look.
    Shape {
        anchors.fill: parent
        antialiasing: true
        opacity: 0.35
        ShapePath {
            strokeColor: "#c8d0dc"
            strokeWidth: 1
            fillColor: "transparent"
            startX: 40; startY: 18
            PathLine { x: pod.width - 40; y: 18 }
        }
    }

    // Screw heads as small spheres for true roundness.
    Repeater {
        model: [
            { x: 16, y: 16 },
            { x: pod.width - 32, y: 16 },
            { x: 4, y: pod.height / 2 - 8 },
            { x: pod.width - 20, y: pod.height / 2 - 8 },
            { x: 20, y: pod.height - 32 },
            { x: pod.width - 36, y: pod.height - 32 }
        ]
        delegate: Sphere {
            required property var modelData
            x: modelData.x; y: modelData.y
            diameter: 10
            color0: "#9098a4"
            color1: "#3a4048"
            color2: "#0a0c10"
            highlightOpacity: 0.55
            Rectangle {
                anchors.centerIn: parent
                width: 6; height: 1
                color: "#0a0b0d"
                opacity: 0.9
                rotation: 35
            }
        }
    }
}
