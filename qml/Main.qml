// Main — the top-level frameless window and view state machine.
//
// Sonique's three view modes (Amp / Nav / Vis) morph into one another via
// resize+crossfade. For the MVP we ship only AmpView; the State machine is
// scaffolded so adding Nav/Vis in Phase 2 is additive, not a rewrite.

import QtQuick
import QtQuick.Window
import app.sonique

Window {
    id: root
    width: ampView.implicitWidth
    height: ampView.implicitHeight
    visible: true
    title: qsTr("sonique-kde")

    // Frameless, transparent — the skin paints its own shape and shadow.
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    // Drag the window by its body (compositor takes over on Wayland via
    // startSystemMove(); this is the right way under KWin).
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.ArrowCursor
        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton)
                root.startSystemMove();
        }
    }

    // View-morph state machine lives on an Item (Window can't host states).
    Item {
        id: views
        anchors.fill: parent
        state: "amp"
        states: [
            State { name: "amp" },
            State { name: "nav" }, // Phase 2
            State { name: "vis" }  // Phase 2
        ]

        AmpView {
            id: ampView
            anchors.centerIn: parent
            opacity: views.state === "amp" ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        }
    }

    // Keyboard shortcuts — match Sonique's hotkeys.htm where they don't clash
    // with KDE global ones. Space=play/pause is universal.
    Shortcut {
        sequence: "Space"
        onActivated: AudioEngine.state === AudioEngine.Playing
            ? AudioEngine.pause()
            : AudioEngine.play()
    }
    Shortcut {
        sequence: "Esc"
        onActivated: Qt.quit()
    }
}
