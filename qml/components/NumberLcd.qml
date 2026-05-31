// NumberLcd — the bottom well's LCD readout: track number, time, title.
// Rendered as a Shape with a radial gradient backplate so it actually
// looks like a recessed phosphor screen instead of a flat rectangle.

import QtQuick
import QtQuick.Shapes

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

    // Phosphor backplate — proper radial via Shape.
    Shape {
        anchors.fill: parent
        antialiasing: true

        ShapePath {
            strokeWidth: 0
            fillGradient: RadialGradient {
                centerX: lcd.width / 2
                centerY: lcd.height / 2
                centerRadius: Math.max(lcd.width, lcd.height) / 2
                GradientStop { position: 0.0; color: "#0a4858" }
                GradientStop { position: 0.6; color: "#06212a" }
                GradientStop { position: 1.0; color: "#010608" }
            }
            startX: lcd.width; startY: lcd.height / 2
            PathArc {
                x: 0; y: lcd.height / 2
                radiusX: lcd.width / 2; radiusY: lcd.height / 2
                direction: PathArc.Clockwise
            }
            PathArc {
                x: lcd.width; y: lcd.height / 2
                radiusX: lcd.width / 2; radiusY: lcd.height / 2
                direction: PathArc.Clockwise
            }
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
        font.pixelSize: parent.width * 0.20
        font.family: "monospace"
        font.bold: true
        style: Text.Raised
        styleColor: "#063848"
    }
    Text {
        anchors {
            left: trackNumText.left
            top: trackNumText.bottom; topMargin: 6
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
            x: 0; y: index * 3
            width: lcd.width
            height: 1
            color: Qt.rgba(0, 0, 0, 0.18)
        }
    }
}
