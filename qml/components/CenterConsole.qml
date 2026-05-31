// CenterConsole — the spine between Vis View's two wells.
//
// Now uses Sphere for the chrome ball and yellow knob so they actually
// look spherical.

import QtQuick

Item {
    id: spine
    implicitHeight: 60

    signal navClicked()
    property real volume: 0.8

    // --- Left: nav text-button + LED column ------------------------------
    Column {
        anchors {
            left: parent.left; leftMargin: 14
            verticalCenter: parent.verticalCenter
        }
        spacing: 3
        Text {
            text: "nav"
            color: navMouse.containsMouse ? "#dff4ff" : "#9cf0ff"
            font.pixelSize: 12
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
                    width: 11; height: 11; radius: 5.5
                    color: "#0a1a18"
                    border.color: "#3aa874"; border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: parent.modelData
                        color: "#5cd4a8"
                        font.pixelSize: 7
                        font.bold: true
                    }
                }
            }
        }
    }

    // --- Middle: chrome ball ---------------------------------------------
    Sphere {
        id: ball
        anchors.centerIn: parent
        diameter: 32
        color0: "#f8fafd"
        color1: "#8a92a0"
        color2: "#0a0c10"
        highlightOpacity: 0.9
    }

    // --- Right: volume knob ----------------------------------------------
    Item {
        id: volBlock
        width: 56; height: 40
        anchors {
            right: parent.right; rightMargin: 12
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
            font.pixelSize: 11
            font.family: "monospace"
            font.bold: true
        }

        Sphere {
            id: knob
            anchors {
                left: volLabel.right; leftMargin: 4
                verticalCenter: parent.verticalCenter
            }
            diameter: 26
            color0: "#fff89a"
            color1: "#d09418"
            color2: "#3a2604"
            highlightOpacity: 0.7

            // Indicator dot rotated by current volume.
            Rectangle {
                x: parent.width / 2 - 1.5
                y: 3
                width: 3; height: 7; radius: 1.5
                color: "#1a0e02"
                transformOrigin: Item.Bottom
                rotation: (spine.volume - 0.5) * 270
                transform: Translate { y: parent.height / 2 - 5 }
            }

            WheelHandler {
                onWheel: (event) => {
                    let step = event.angleDelta.y > 0 ? 0.05 : -0.05;
                    spine.volume = Math.max(0, Math.min(1, spine.volume + step));
                }
            }
        }
    }
}
