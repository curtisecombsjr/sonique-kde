// VisView — now using the actual Sonique screenshot as the skin canvas.
//
// The 270x340 PNG at assets/skin/vis-pod.png is the pod with the background
// flood-filled to transparent. We layer dynamic elements on top of it:
//   * Live LCD digits over the bottom-well numerals
//   * Live track title over the bottom-well title region
//   * Invisible click targets over nav / play / volume-knob hotspots
//
// The visualizer in the green well is currently the frozen pixels from the
// screenshot. Phase 2.5 will punch a transparent hole there and put
// CircularVisualizer behind it for real-time animation.

import QtQuick
import app.sonique

Item {
    id: vis
    implicitWidth: 270
    implicitHeight: 340

    signal modeToggled()

    // --- The skin ---------------------------------------------------------
    Image {
        id: skin
        anchors.fill: parent
        source: "qrc:/qt/qml/app/sonique/assets/skin/vis-pod.png"
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }

    // --- Dynamic LCD overlays --------------------------------------------
    // Pixel positions measured from vis-pod.png at native 270x340.
    // Track number "008" sits around x=70..115, y=232..258 (rough).
    Text {
        x: 73; y: 232
        text: {
            const n = 8;  // playlist Phase 2.5
            return n < 10 ? "00" + n : n < 100 ? "0" + n : "" + n;
        }
        color: "#9cf0ff"
        font.pixelSize: 22
        font.family: "monospace"
        font.bold: true
    }
    Text {
        x: 73; y: 256
        text: {
            let p = AudioEngine.position;
            let s = Math.floor(p / 1000);
            const h = Math.floor(s / 3600); s -= h * 3600;
            const m = Math.floor(s / 60); s -= m * 60;
            const pad = n => (n < 10 ? "0" : "") + n;
            return pad(h) + ":" + pad(m) + ":" + pad(s);
        }
        color: "#5cd4e8"
        font.pixelSize: 12
        font.family: "monospace"
    }
    // Track title — covers the screenshot's "test-tone-24bit-44k.wav" text.
    Rectangle {
        x: 118; y: 248
        width: 80; height: 30
        color: "#020a10"  // covers the static text underneath
        Text {
            anchors.fill: parent
            anchors.margins: 2
            text: AudioEngine.title.length > 0
                ? AudioEngine.title
                : "— drop a file —"
            color: "#9cf0ff"
            font.pixelSize: 9
            font.family: "monospace"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // --- Click targets / interactivity (invisible) -----------------------

    // nav button — toggles to Amp View
    MouseArea {
        // "nav" text in the screenshot sits around (76, 178)..(105, 196)
        x: 70; y: 175
        width: 38; height: 22
        cursorShape: Qt.PointingHandCursor
        onClicked: vis.modeToggled()
    }

    // Volume knob (yellow) — mouse wheel adjusts volume
    Item {
        x: 178; y: 178
        width: 28; height: 28
        WheelHandler {
            onWheel: (event) => {
                let step = event.angleDelta.y > 0 ? 0.05 : -0.05;
                AudioEngine.volume = Math.max(0, Math.min(1, AudioEngine.volume + step));
            }
        }
    }

    // Play button (green, at bottom) — toggles play/pause
    MouseArea {
        // Play button sits around (78, 305)..(105, 332) in vis-pod.png
        x: 76; y: 302
        width: 32; height: 32
        cursorShape: Qt.PointingHandCursor
        onClicked: AudioEngine.state === AudioEngine.Playing
            ? AudioEngine.pause()
            : AudioEngine.play()
    }
}
