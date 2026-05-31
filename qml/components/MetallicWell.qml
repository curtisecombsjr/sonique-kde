// MetallicWell — a recessed circular well with proper inner-shadow falloff
// using Shape + RadialGradient. Content (visualizer, LCD, etc.) renders
// inside, clipped to the circular cup.

import QtQuick
import QtQuick.Shapes

Item {
    id: well
    property real diameter: 200
    property color rimColor: "#9ec9f0"
    property color cupColor: "#000508"
    property int beadCount: 56
    default property alias children: cupContent.children

    implicitWidth: diameter + 30
    implicitHeight: diameter + 30

    // Outer bezel — black ring framing the well.
    Shape {
        anchors.centerIn: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 4
        width: well.diameter + 24
        height: width

        ShapePath {
            strokeColor: "#06080a"
            strokeWidth: 2
            fillGradient: RadialGradient {
                centerX: width / 2
                centerY: height / 2
                centerRadius: width / 2
                GradientStop { position: 0.80; color: "#23272d" }
                GradientStop { position: 0.95; color: "#0e1014" }
                GradientStop { position: 1.00; color: "#06080a" }
            }
            startX: width; startY: height / 2
            PathArc { x: 0; y: height / 2; radiusX: width / 2; radiusY: height / 2; direction: PathArc.Clockwise }
            PathArc { x: width; y: height / 2; radiusX: width / 2; radiusY: height / 2; direction: PathArc.Clockwise }
        }
    }

    // Inner cup — recessed dark area where content lives. Render the cup
    // background as a Shape with a radial gradient so the falloff is
    // visible (looks recessed).
    Shape {
        anchors.centerIn: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 4
        width: well.diameter
        height: width

        ShapePath {
            strokeWidth: 0
            fillGradient: RadialGradient {
                centerX: width / 2
                centerY: height / 2
                centerRadius: width / 2
                GradientStop { position: 0.0; color: well.cupColor }
                GradientStop { position: 0.85; color: well.cupColor }
                GradientStop { position: 1.0; color: "#000000" }
            }
            startX: width; startY: height / 2
            PathArc { x: 0; y: height / 2; radiusX: width / 2; radiusY: height / 2; direction: PathArc.Clockwise }
            PathArc { x: width; y: height / 2; radiusX: width / 2; radiusY: height / 2; direction: PathArc.Clockwise }
        }
    }

    // Inner content area — children render here, clipped to the cup circle.
    Item {
        id: cupClip
        anchors.centerIn: parent
        width: well.diameter
        height: width
        clip: true

        // A round mask via OpacityMask would be ideal; for now we let
        // children be drawn within a square and rely on the well bezel
        // covering the corners. Children should draw circular content.
        Item {
            id: cupContent
            anchors.fill: parent
        }
    }

    // Bead-chain rim — small light dots ringing the cup edge.
    Repeater {
        model: well.beadCount
        delegate: Rectangle {
            required property int index
            readonly property real angle: index * 2 * Math.PI / well.beadCount
            readonly property real ringR: well.diameter / 2 + 4
            width: 3; height: 3; radius: 1.5
            x: well.width / 2 + ringR * Math.cos(angle) - 1.5
            y: well.height / 2 + ringR * Math.sin(angle) - 1.5
            color: well.rimColor
            opacity: 0.9
        }
    }
}
