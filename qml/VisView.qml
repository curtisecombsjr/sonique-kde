// VisView — the iconic stacked-pod view. Curtis's favorite.
//
// Composition (top to bottom inside the metallic pod):
//   * MetallicWell containing CircularVisualizer (green phosphor)
//   * CenterConsole spine (nav | chrome ball | volume knob)
//   * MetallicWell containing NumberLcd (track # / time / title)
//   * Small play button extruding from the bottom tongue
//
// Layout is anchored, not absolute — proportions tune by changing the few
// margin/spacing values below, not by repositioning every child.

import QtQuick
import "components"
import app.sonique

Item {
    id: vis
    implicitWidth: 280
    implicitHeight: 460

    signal modeToggled()

    MetallicPod {
        id: pod
        anchors.fill: parent
    }

    // --- Top well: visualizer --------------------------------------------
    MetallicWell {
        id: visWell
        diameter: 190
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top; topMargin: 36
        }

        CircularVisualizer {
            playing: AudioEngine.state === AudioEngine.Playing
        }

        // Vertical "sonique" wordmark on the well's left edge.
        Text {
            anchors {
                left: parent.left; leftMargin: 8
                verticalCenter: parent.verticalCenter
            }
            text: "sonique"
            color: "#9cf0ff"
            font.pixelSize: 11
            font.family: "monospace"
            font.italic: true
            rotation: -90
            transformOrigin: Item.Center
        }

        // Three small utility icons top-right.
        Row {
            anchors {
                right: parent.right; rightMargin: 14
                top: parent.top; topMargin: 14
            }
            spacing: 3
            Repeater {
                model: ["i", "?", "×"]
                delegate: Rectangle {
                    required property string modelData
                    width: 12; height: 12; radius: 6
                    color: "#0a1822"
                    border.color: "#3da1ff"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: parent.modelData
                        color: "#9cf0ff"
                        font.pixelSize: 8
                        font.family: "monospace"
                    }
                }
            }
        }
    }

    // --- Center console ---------------------------------------------------
    CenterConsole {
        id: spine
        anchors {
            left: parent.left; right: parent.right
            top: visWell.bottom; topMargin: -4
        }
        volume: AudioEngine.volume
        onVolumeChanged: AudioEngine.volume = volume
        onNavClicked: vis.modeToggled()
    }

    // --- Bottom well: LCD readout ----------------------------------------
    MetallicWell {
        id: lcdWell
        diameter: 190
        rimColor: "#3da1ff"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: spine.bottom; topMargin: -4
        }

        NumberLcd {
            trackNumber: 8  // placeholder — playlist Phase 2.5
            positionMs: AudioEngine.position
            durationMs: AudioEngine.duration
            title: AudioEngine.title.length > 0
                ? AudioEngine.title
                : "— drop a file —"
        }
    }

    // --- Play button extruding from bottom tongue ------------------------
    Rectangle {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: lcdWell.bottom; topMargin: 0
        }
        width: 28; height: 28; radius: 14
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#c4f0a0" }
            GradientStop { position: 0.5; color: "#5aa838" }
            GradientStop { position: 1.0; color: "#1a3008" }
        }
        border.color: "#0a0b0d"; border.width: 1

        Text {
            anchors.centerIn: parent
            text: AudioEngine.state === AudioEngine.Playing ? "❚❚" : "▶"
            color: "#0a1a04"
            font.pixelSize: 13
            font.bold: true
        }

        TapHandler {
            onTapped: AudioEngine.state === AudioEngine.Playing
                ? AudioEngine.pause()
                : AudioEngine.play()
        }
    }
}
