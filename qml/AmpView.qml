// AmpView — Sonique's signature small-mode player.
//
// MVP geometry — refined to pixel-perfect in Phase 2 against
// `reference/sonique-amp.png`. The structural layout is set up so that
// pixel tuning is a matter of changing widths/positions, not refactoring.
//
// Layers (back to front):
//   * Dark teardrop body with subtle gradient
//   * Translucent inner LCD panel (track + time)
//   * Scrubber slider hugging the LCD's bottom edge
//   * Ring of round transport buttons along the curve
//   * Volume knob, top-right

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Shapes
import app.sonique

Item {
    id: amp
    implicitWidth: 420
    implicitHeight: 180

    // --- Body (asymmetric teardrop) ---------------------------------------
    Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            strokeColor: "#1a1c20"
            strokeWidth: 1.5
            fillGradient: LinearGradient {
                x1: 0; y1: 0; x2: 0; y2: amp.height
                GradientStop { position: 0.0; color: "#2a2e35" }
                GradientStop { position: 0.5; color: "#1b1e23" }
                GradientStop { position: 1.0; color: "#0e1014" }
            }
            startX: 80; startY: 6
            // Top edge
            PathLine { x: amp.width - 24; y: 6 }
            // Right teardrop curl
            PathCubic {
                x: amp.width - 8;       y: amp.height - 36
                control1X: amp.width - 4; control1Y: 36
                control2X: amp.width - 4; control2Y: amp.height - 60
            }
            PathCubic {
                x: amp.width - 60;        y: amp.height - 6
                control1X: amp.width - 8;  control1Y: amp.height - 16
                control2X: amp.width - 30; control2Y: amp.height - 6
            }
            // Bottom edge
            PathLine { x: 60; y: amp.height - 6 }
            // Left rounded cap
            PathCubic {
                x: 6;  y: 60
                control1X: 16; control1Y: amp.height - 6
                control2X: 6;  control2Y: amp.height - 30
            }
            PathCubic {
                x: 80; y: 6
                control1X: 6;  control1Y: 30
                control2X: 28; control2Y: 6
            }
        }
    }

    // --- Inner LCD panel --------------------------------------------------
    LcdReadout {
        id: lcd
        anchors {
            left: parent.left; leftMargin: 64
            right: parent.right; rightMargin: 64
            top: parent.top; topMargin: 28
        }
        height: 64
        title: AudioEngine.title.length > 0
            ? AudioEngine.title
            : qsTr("— drop a file —")
        positionMs: AudioEngine.position
        durationMs: AudioEngine.duration
    }

    // --- Scrubber ---------------------------------------------------------
    Slider {
        id: scrubber
        anchors {
            left: lcd.left; right: lcd.right
            top: lcd.bottom; topMargin: 4
        }
        from: 0
        to: Math.max(1, AudioEngine.duration)
        value: AudioEngine.position
        onMoved: AudioEngine.seek(value)

        background: Rectangle {
            x: scrubber.leftPadding
            y: scrubber.topPadding + scrubber.availableHeight / 2 - 2
            width: scrubber.availableWidth
            height: 4
            radius: 2
            color: "#101317"
            Rectangle {
                width: scrubber.visualPosition * parent.width
                height: parent.height
                radius: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#3da1ff" }
                    GradientStop { position: 1.0; color: "#9cf0ff" }
                }
            }
        }
        handle: Rectangle {
            x: scrubber.leftPadding + scrubber.visualPosition * (scrubber.availableWidth - width)
            y: scrubber.topPadding + scrubber.availableHeight / 2 - height / 2
            width: 10; height: 10
            radius: 5
            color: "#dff4ff"
            border.color: "#3da1ff"
            border.width: 1
        }
    }

    // --- Ring of transport buttons ----------------------------------------
    Row {
        anchors {
            left: parent.left; leftMargin: 36
            bottom: parent.bottom; bottomMargin: 18
        }
        spacing: 6

        RingButton {
            glyph: "⏮"
            onClicked: AudioEngine.seek(0)
        }
        RingButton {
            glyph: AudioEngine.state === AudioEngine.Playing ? "⏸" : "▶"
            primary: true
            onClicked: AudioEngine.state === AudioEngine.Playing
                ? AudioEngine.pause()
                : AudioEngine.play()
        }
        RingButton {
            glyph: "⏹"
            onClicked: AudioEngine.stop()
        }
        RingButton {
            glyph: "⏭"
            onClicked: { /* playlist next — Phase 2 */ }
        }
    }

    // --- Volume knob ------------------------------------------------------
    Rectangle {
        id: volKnob
        width: 36; height: 36; radius: 18
        anchors {
            right: parent.right; rightMargin: 30
            bottom: parent.bottom; bottomMargin: 18
        }
        gradient: Gradient {
            GradientStop { position: 0; color: "#2a2e35" }
            GradientStop { position: 1; color: "#0e1014" }
        }
        border.color: "#3da1ff"; border.width: 1

        // Indicator dot rotated by current volume (0..1 -> -135..135 deg).
        Rectangle {
            x: parent.width / 2 - width / 2
            y: 4
            width: 3; height: 8; radius: 1.5
            color: "#9cf0ff"
            transformOrigin: Item.Bottom
            rotation: (AudioEngine.volume - 0.5) * 270
            transform: Translate { y: parent.height / 2 - 6 }
        }

        WheelHandler {
            onWheel: (event) => {
                let step = event.angleDelta.y > 0 ? 0.05 : -0.05;
                AudioEngine.volume = Math.max(0, Math.min(1, AudioEngine.volume + step));
            }
        }
    }
}
