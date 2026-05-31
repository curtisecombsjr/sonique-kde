// LcdReadout — the inset translucent panel showing track title + time.
//
// Sonique used a faux-LCD with a scanline tint. We approximate with a dark
// blue-green rectangle, a subtle inner shadow, and a thin scanline overlay.

import QtQuick

Rectangle {
    id: lcd
    color: "#091214"
    radius: 4
    border.color: "#1d3a44"
    border.width: 1

    property string title: ""
    property int positionMs: 0
    property int durationMs: 0

    function formatTime(ms) {
        if (ms < 0 || isNaN(ms)) return "--:--";
        let s = Math.floor(ms / 1000);
        let m = Math.floor(s / 60);
        s = s % 60;
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
    }

    // Inner glow.
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 3
        color: "transparent"
        border.color: Qt.rgba(0.24, 0.94, 1.0, 0.08)
        border.width: 1
    }

    // Title row.
    Text {
        id: titleText
        anchors {
            left: parent.left; leftMargin: 10
            right: parent.right; rightMargin: 10
            top: parent.top; topMargin: 6
        }
        text: lcd.title
        color: "#9cf0ff"
        font.pixelSize: 14
        font.family: "monospace"
        elide: Text.ElideRight
    }

    // Time row.
    Text {
        id: timeText
        anchors {
            left: parent.left; leftMargin: 10
            bottom: parent.bottom; bottomMargin: 6
        }
        text: lcd.formatTime(lcd.positionMs) + " / " + lcd.formatTime(lcd.durationMs)
        color: "#5cd4e8"
        font.pixelSize: 12
        font.family: "monospace"
    }

    // Faint scanline overlay.
    Repeater {
        model: Math.floor(lcd.height / 2)
        delegate: Rectangle {
            x: 0
            y: index * 2
            width: lcd.width
            height: 1
            color: Qt.rgba(0, 0, 0, 0.10)
        }
    }
}
