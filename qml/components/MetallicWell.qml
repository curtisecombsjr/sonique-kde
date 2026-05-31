// MetallicWell — a recessed circular well in the pod, with the iconic
// dotted bead-chain rim that Sonique's wells have. Content goes inside as
// children of `content` (an Item centered in the well).

import QtQuick

Item {
    id: well
    property real diameter: 200
    property color rimColor: "#9ec9f0"
    property int beadCount: 56
    property alias contentItem: content
    default property alias children: content.children

    implicitWidth: diameter + 30
    implicitHeight: diameter + 30

    // Outer shadow ring (the recessed lip).
    Rectangle {
        anchors.centerIn: parent
        width: well.diameter + 16
        height: width
        radius: width / 2
        color: "transparent"
        border.color: "#06080a"
        border.width: 4
    }
    Rectangle {
        anchors.centerIn: parent
        width: well.diameter + 8
        height: width
        radius: width / 2
        color: "#1a1d22"
        border.color: "#0a0c10"
        border.width: 2
    }

    // Inner cup (where children render).
    Rectangle {
        id: cup
        anchors.centerIn: parent
        width: well.diameter
        height: width
        radius: width / 2
        color: "#000508"
        clip: true

        Item {
            id: content
            anchors.fill: parent
        }
    }

    // Bead-chain rim — small light dots ringing the cup edge.
    Repeater {
        model: well.beadCount
        delegate: Rectangle {
            required property int index
            readonly property real angle: index * 2 * Math.PI / well.beadCount
            readonly property real ringR: well.diameter / 2 + 2
            width: 3; height: 3; radius: 1.5
            x: well.width / 2 + ringR * Math.cos(angle) - 1.5
            y: well.height / 2 + ringR * Math.sin(angle) - 1.5
            color: well.rimColor
            opacity: 0.85
        }
    }
}
