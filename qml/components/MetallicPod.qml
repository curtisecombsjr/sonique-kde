// MetallicPod — the asymmetric teardrop pod body for Vis View.
//
// Shape outline approximates the reference: bulges around the top and bottom
// wells, narrow waist between, slightly rounded top, small tongue at the
// bottom that the play button extrudes through. Filled with a brushed-metal
// gradient + a few highlight/shadow strokes to evoke milled aluminum.

import QtQuick
import QtQuick.Shapes

Item {
    id: pod
    implicitWidth: 280
    implicitHeight: 460

    Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            strokeColor: "#0a0b0d"
            strokeWidth: 1.5
            fillGradient: LinearGradient {
                x1: 0; y1: 0; x2: 0; y2: pod.height
                GradientStop { position: 0.00; color: "#3a3f48" }
                GradientStop { position: 0.20; color: "#252830" }
                GradientStop { position: 0.50; color: "#191b21" }
                GradientStop { position: 0.80; color: "#252830" }
                GradientStop { position: 1.00; color: "#13151a" }
            }
            // Counterclockwise from top-left rounded shoulder.
            startX: 38; startY: 16

            // Top edge.
            PathLine { x: pod.width - 38; y: 16 }
            // Upper-right shoulder curving down around the top well.
            PathCubic {
                x: pod.width - 8; y: 140
                control1X: pod.width - 6; control1Y: 24
                control2X: pod.width - 6; control2Y: 80
            }
            PathCubic {
                x: pod.width - 8; y: 240
                control1X: pod.width - 4; control1Y: 180
                control2X: pod.width - 4; control2Y: 220
            }
            // Right side curving out around the bottom well.
            PathCubic {
                x: pod.width - 14; y: 400
                control1X: pod.width - 2; control1Y: 280
                control2X: pod.width - 4; control2Y: 360
            }
            // Bottom-right corner.
            PathCubic {
                x: pod.width / 2 + 28; y: pod.height - 12
                control1X: pod.width - 30; control1Y: pod.height - 16
                control2X: pod.width / 2 + 60; control2Y: pod.height - 10
            }
            // Bottom tongue (small protrusion the play button sits on).
            PathLine { x: pod.width / 2 + 22; y: pod.height - 4 }
            PathLine { x: pod.width / 2 - 22; y: pod.height - 4 }
            PathLine { x: pod.width / 2 - 28; y: pod.height - 12 }
            // Bottom-left corner.
            PathCubic {
                x: 14; y: 400
                control1X: pod.width / 2 - 60; control1Y: pod.height - 10
                control2X: 30; control2Y: pod.height - 16
            }
            // Left side back up, mirror of right.
            PathCubic {
                x: 8; y: 240
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

    // Six rivet/screw heads at structural points — purely decorative.
    Repeater {
        model: [
            { x: 18, y: 18 },
            { x: pod.width - 30, y: 18 },
            { x: 6, y: pod.height / 2 - 6 },
            { x: pod.width - 18, y: pod.height / 2 - 6 },
            { x: 22, y: pod.height - 30 },
            { x: pod.width - 34, y: pod.height - 30 }
        ]
        delegate: Rectangle {
            required property var modelData
            x: modelData.x; y: modelData.y
            width: 8; height: 8; radius: 4
            color: "#3a4048"
            border.color: "#0a0b0d"
            border.width: 1
            // Crosshead slot.
            Rectangle {
                anchors.centerIn: parent
                width: 5; height: 1
                color: "#0a0b0d"
                opacity: 0.7
            }
        }
    }
}
