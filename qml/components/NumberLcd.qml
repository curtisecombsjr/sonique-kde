// NumberLcd — the bottom well's LCD readout: track number, time, title.
//
// Visual style: deep blue/teal phosphor backplate, faux-LED green and cyan
// digits, scanline overlay. Layout mirrors the reference's bottom-well:
// big "008" track number top-left, "00:00:00" time below it, multi-line
// track title on the right.

import QtQuick

Item {
    id: lcd
    anchors.fill: parent

    property int trackNumber: 0
    property int positionMs: 0
    property int durationMs: 0
    property string title: ""

    function fmt(ms) {
        if (ms < 0 || isNaN(ms)) return "--:--:--";
        let s = Math.floor(ms / 1000);
        const h = Math.floor(s / 3600); s -= h * 3600;
        const m = Math.floor(s / 60);   s -= m * 60;
        const pad = n => (n < 10 ? "0" : "") + n;
        return pad(h) + ":" + pad(m) + ":" + pad(s);
    }
    function pad3(n) {
        n = Math.max(0, n | 0);
        return n < 10 ? "00" + n : n < 100 ? "0" + n : "" + n;
    }

    // Phosphor backplate (linear-only gradient on Rectangle in Qt 6;
    // overlaid soft-edge to fake the radial falloff).
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0a3848" }
            GradientStop { position: 0.5; color: "#06212a" }
            GradientStop { position: 1.0; color: "#020a10" }
        }
    }

    // Track number — big numeric on the left.
    Text {
        id: trackNumText
        anchors {
            left: parent.left; leftMargin: parent.width * 0.18
            top: parent.top; topMargin: parent.height * 0.30
        }
        text: lcd.pad3(lcd.trackNumber)
        color: "#9cf0ff"
        font.pixelSize: parent.width * 0.18
        font.family: "monospace"
        font.bold: true
    }
    Text {
        anchors {
            left: trackNumText.left
            top: trackNumText.bottom; topMargin: 4
        }
        text: lcd.fmt(lcd.positionMs)
        color: "#5cd4e8"
        font.pixelSize: parent.width * 0.085
        font.family: "monospace"
    }

    // Title — right side, wrappable.
    Text {
        anchors {
            left: parent.horizontalCenter; leftMargin: 4
            right: parent.right; rightMargin: parent.width * 0.18
            verticalCenter: parent.verticalCenter
        }
        text: lcd.title
        color: "#9cf0ff"
        font.pixelSize: parent.width * 0.075
        font.family: "monospace"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
    }

    // Faint scanline overlay.
    Repeater {
        model: Math.floor(lcd.height / 3)
        delegate: Rectangle {
            required property int index
            x: 0
            y: index * 3
            width: lcd.width
            height: 1
            color: Qt.rgba(0, 0, 0, 0.18)
        }
    }
}
