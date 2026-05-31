// CenterConsole — the spine between Vis View's two wells.
//
// Left: "nav" button (toggles to Nav view), plus a column of small LED-ish
// utility buttons (eject / loop / shuffle).
// Middle: silver chrome ball — purely decorative anchor that matches the
// reference; clicking it cycles visualization presets later.
// Right: "vol" label with the yellow volume knob.

import QtQuick

Item {
    id: spine
    implicitHeight: 60

    signal navClicked()

    // --- Left: nav text-button + LED column ------------------------------
    Column {
        anchors {
            left: parent.left; leftMargin: 18
            verticalCenter: parent.verticalCenter
        }
        spacing: 2
        Text {
            text: "nav"
            color: navMouse.containsMouse ? "#dff4ff" : "#9cf0ff"
            font.pixelSize: 11
            font.family: "monospace"
            font.bold: true
            MouseArea {
                id: navMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: spine.navClicked()
            }
        }
        Row {
            spacing: 4
            Repeater {
                model: ["▲", "↻", "S"]
                delegate: Rectangle {
                    required property string modelData
                    width: 10; height: 10; radius: 5
                    color: "#0a1a18"
                    border.color: "#3aa874"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: parent.modelData
                        color: "#5cd4a8"
                        font.pixelSize: 6
                    }
                }
            }
        }
    }

    // --- Middle: chrome ball ---------------------------------------------
    Rectangle {
        id: ball
        anchors.centerIn: parent
        width: 30; height: 30; radius: 15
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#d8dde6" }
            GradientStop { position: 0.5; color: "#7a8290" }
            GradientStop { position: 1.0; color: "#1a1d22" }
        }
        border.color: "#0a0b0d"; border.width: 1
        // Specular highlight blob.
        Rectangle {
            x: 6; y: 4
            width: 10; height: 5; radius: 5
            color: "#ffffff"
            opacity: 0.7
        }
    }

    // --- Right: volume knob ----------------------------------------------
    Item {
        id: volBlock
        width: 50; height: 40
        anchors {
            right: parent.right; rightMargin: 14
            verticalCenter: parent.verticalCenter
        }

        Text {
            id: volLabel
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            text: "vol"
            color: "#9cf0ff"
            font.pixelSize: 10
            font.family: "monospace"
        }
        Rectangle {
            id: knob
            anchors {
                left: volLabel.right; leftMargin: 4
                verticalCenter: parent.verticalCenter
            }
            width: 24; height: 24; radius: 12
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff89a" }
                GradientStop { position: 0.5; color: "#dba51c" }
                GradientStop { position: 1.0; color: "#3a2604" }
            }
            border.color: "#0a0b0d"; border.width: 1

            // Indicator dot rotated by current volume.
            Rectangle {
                x: parent.width / 2 - 1
                y: 3
                width: 2; height: 5; radius: 1
                color: "#1a1206"
                transformOrigin: Item.Bottom
                rotation: (volume - 0.5) * 270
                transform: Translate { y: parent.height / 2 - 4 }
                property real volume: 0.8
            }

            WheelHandler {
                onWheel: (event) => {
                    // Volume binding lives in VisView; CenterConsole exposes
                    // this knob via property aliases set by the parent.
                    if (typeof spine.volume !== "undefined") {
                        let step = event.angleDelta.y > 0 ? 0.05 : -0.05;
                        spine.volume = Math.max(0, Math.min(1, spine.volume + step));
                    }
                }
            }
        }
    }

    property real volume: 0.8
}
