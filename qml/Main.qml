// Main — top-level frameless window with view morph state machine.
//
// Default view is Vis (Curtis's favorite). Clicking the "nav" text or the
// right end-cap of the AmpView pill toggles between Vis and Amp. The
// window animates its size to match the active view's implicit dimensions.
//
// Nav View (playlist editor) is scaffolded but not implemented yet —
// Phase 2.5.

import QtQuick
import QtQuick.Window
import app.sonique

Window {
    id: root
    width: 270
    height: 340
    visible: true
    title: qsTr("sonique-kde")
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    // Smooth size morphs when switching views.
    Behavior on width  { NumberAnimation { duration: 320; easing.type: Easing.InOutCubic } }
    Behavior on height { NumberAnimation { duration: 320; easing.type: Easing.InOutCubic } }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.ArrowCursor
        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton)
                root.startSystemMove();
        }
    }

    property string mode: "vis"

    StackLayout2 {  // see comment below — using an Item, not QtQuick.Layouts
        id: layer
        anchors.fill: parent
        visibleView: root.mode
    }

    // Inline component: stacks Vis + Amp, fades between them.
    component StackLayout2 : Item {
        property string visibleView: "vis"

        VisView {
            id: visView
            anchors.fill: parent
            opacity: parent.visibleView === "vis" ? 1.0 : 0.0
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 260 } }
            onModeToggled: root.toggleMode()
        }
        AmpView {
            id: ampView
            anchors.centerIn: parent
            opacity: parent.visibleView === "amp" ? 1.0 : 0.0
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 260 } }
            onModeToggled: root.toggleMode()
        }
    }

    function toggleMode() {
        if (mode === "vis") {
            mode = "amp";
            root.width = 360;
            root.height = 90;
        } else {
            mode = "vis";
            root.width = 270;
            root.height = 340;
        }
    }

    // Hotkeys.
    Shortcut {
        sequence: "Space"
        onActivated: AudioEngine.state === AudioEngine.Playing
            ? AudioEngine.pause()
            : AudioEngine.play()
    }
    Shortcut {
        sequence: "M"
        onActivated: root.toggleMode()
    }
    Shortcut {
        sequence: "Esc"
        onActivated: Qt.quit()
    }
}
