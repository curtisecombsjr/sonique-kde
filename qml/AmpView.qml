// AmpView — the horizontal pill from sonique-AMP-VIEW.png.
//
// Structure:
//   * Persistent pill body: long capsule with metallic end-caps. Bottom
//     half always shows "sonique" wordmark + "008 00:00:00" time digits.
//   * Hover overlay: a green LCD-style strip that fades in above the pill
//     when the mouse enters, containing transport buttons + track title +
//     small utility icons. Fades out when the mouse leaves.

import QtQuick
import app.sonique

Item {
    id: amp
    implicitWidth: 360
    implicitHeight: 90

    signal modeToggled()

    HoverHandler { id: hover }

    // --- Persistent pill (always visible) --------------------------------
    Item {
        id: pill
        anchors {
            left: parent.left; right: parent.right
            bottom: parent.bottom
        }
        height: 30

        // Body — long capsule.
        Rectangle {
            anchors {
                left: parent.left; leftMargin: 22
                right: parent.right; rightMargin: 22
                top: parent.top; bottom: parent.bottom
            }
            radius: 6
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2a2e35" }
                GradientStop { position: 0.5; color: "#191b21" }
                GradientStop { position: 1.0; color: "#0a0c10" }
            }
            border.color: "#0a0b0d"; border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 6
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "sonique"
                    color: "#9cf0ff"
                    font.pixelSize: 12
                    font.family: "monospace"
                    font.italic: true
                    font.bold: true
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "008"
                    color: "#9cf0ff"
                    font.pixelSize: 13
                    font.family: "monospace"
                    font.bold: true
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        let p = AudioEngine.position;
                        let s = Math.floor(p / 1000);
                        const h = Math.floor(s / 3600); s -= h * 3600;
                        const m = Math.floor(s / 60); s -= m * 60;
                        const pad = n => (n < 10 ? "0" : "") + n;
                        return pad(h) + ":" + pad(m) + ":" + pad(s);
                    }
                    color: "#5cd4e8"
                    font.pixelSize: 13
                    font.family: "monospace"
                }
            }
        }

        // Left chrome end-cap.
        Rectangle {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            width: 38; height: 28; radius: 14
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#d8dde6" }
                GradientStop { position: 0.5; color: "#6a7280" }
                GradientStop { position: 1.0; color: "#0a0c10" }
            }
            border.color: "#0a0b0d"; border.width: 1

            // Three LED-style buttons.
            Row {
                anchors.centerIn: parent
                spacing: 3
                Repeater {
                    model: ["#d04040", "#40d088", "#d0a040"]
                    delegate: Rectangle {
                        required property color modelData
                        width: 5; height: 5; radius: 2.5
                        color: modelData
                        opacity: 0.85
                    }
                }
            }
        }

        // Right chrome end-cap.
        Rectangle {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            width: 38; height: 28; radius: 14
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#d8dde6" }
                GradientStop { position: 0.5; color: "#6a7280" }
                GradientStop { position: 1.0; color: "#0a0c10" }
            }
            border.color: "#0a0b0d"; border.width: 1

            // Click here to toggle to Vis View.
            TapHandler { onTapped: amp.modeToggled() }
        }
    }

    // --- Hover overlay control strip -------------------------------------
    Rectangle {
        id: hoverStrip
        anchors {
            left: pill.left; leftMargin: 30
            right: pill.right; rightMargin: 30
            bottom: pill.top; bottomMargin: 2
        }
        height: 44
        radius: 18
        opacity: hover.hovered ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 160 } }

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a3a1c" }
            GradientStop { position: 0.5; color: "#0f2410" }
            GradientStop { position: 1.0; color: "#061306" }
        }
        border.color: "#0a0b0d"; border.width: 1

        // Transport icons row at the top.
        Row {
            anchors {
                left: parent.left; leftMargin: 12
                top: parent.top; topMargin: 4
            }
            spacing: 4
            Repeater {
                model: [
                    { glyph: "⏮", action: "prev" },
                    { glyph: "▶",  action: "play" },
                    { glyph: "⏸", action: "pause" },
                    { glyph: "⏹", action: "stop" },
                    { glyph: "⏭", action: "next" }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 16; height: 16; radius: 8
                    color: glyphMouse.containsMouse ? "#1a3022" : "#0a1a14"
                    border.color: "#5cd4a8"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: modelData.glyph
                        color: "#9cf0c8"
                        font.pixelSize: 9
                    }
                    MouseArea {
                        id: glyphMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.action === "play")  AudioEngine.play();
                            if (modelData.action === "pause") AudioEngine.pause();
                            if (modelData.action === "stop")  AudioEngine.stop();
                            if (modelData.action === "prev")  AudioEngine.seek(0);
                        }
                    }
                }
            }
        }

        // Utility icons on the right.
        Row {
            anchors {
                right: parent.right; rightMargin: 12
                top: parent.top; topMargin: 4
            }
            spacing: 3
            Repeater {
                model: ["i", "?", "×"]
                delegate: Rectangle {
                    required property string modelData
                    width: 16; height: 16; radius: 8
                    color: "#0a1a14"
                    border.color: "#5cd4a8"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: parent.modelData
                        color: "#9cf0c8"
                        font.pixelSize: 9
                    }
                }
            }
        }

        // Track title underneath the icon rows.
        Rectangle {
            anchors {
                left: parent.left; leftMargin: 10
                right: parent.right; rightMargin: 10
                bottom: parent.bottom; bottomMargin: 4
            }
            height: 16
            color: "#0c2810"
            radius: 3
            border.color: "#5cd4a8"; border.width: 1
            Text {
                anchors {
                    fill: parent
                    margins: 4
                }
                text: AudioEngine.title.length > 0
                    ? AudioEngine.title
                    : "— drop a file —"
                color: "#9cf0c8"
                font.pixelSize: 10
                font.family: "monospace"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
