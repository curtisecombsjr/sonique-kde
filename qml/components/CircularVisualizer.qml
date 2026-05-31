// CircularVisualizer — the green phosphor visualizer that lives in the
// top well of Vis View.
//
// Until the FFT audio probe lands, animation is driven by a time-based
// `phase` property so we have something visually alive. Swapping to real
// FFT data later is a one-line bind: set `magnitudes` to a property that
// holds the latest spectrum, and feed `phase` from playback position
// instead of a tick.

import QtQuick

Item {
    id: viz
    anchors.fill: parent

    property bool playing: true
    property real phase: 0.0
    // Phase 3: real spectrum data. For now an array filled by the animator.
    property var magnitudes: []

    NumberAnimation on phase {
        running: viz.playing
        from: 0; to: 2 * Math.PI
        duration: 4000
        loops: Animation.Infinite
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d");
            const w = width, h = height;
            const cx = w / 2, cy = h / 2;
            const maxR = Math.min(w, h) / 2 - 4;
            ctx.reset();
            ctx.clearRect(0, 0, w, h);

            // Phosphor background gradient.
            const bg = ctx.createRadialGradient(cx, cy, 0, cx, cy, maxR);
            bg.addColorStop(0, "rgba(40, 80, 30, 1)");
            bg.addColorStop(0.6, "rgba(20, 50, 18, 1)");
            bg.addColorStop(1, "rgba(5, 16, 8, 1)");
            ctx.fillStyle = bg;
            ctx.beginPath();
            ctx.arc(cx, cy, maxR, 0, 2 * Math.PI);
            ctx.fill();

            // Concentric rings (Sonique's signature grid).
            ctx.strokeStyle = "rgba(180, 255, 140, 0.18)";
            ctx.lineWidth = 1;
            for (let i = 1; i <= 6; i++) {
                ctx.beginPath();
                ctx.arc(cx, cy, maxR * i / 6, 0, 2 * Math.PI);
                ctx.stroke();
            }

            // Radial spokes.
            ctx.strokeStyle = "rgba(180, 255, 140, 0.10)";
            for (let i = 0; i < 12; i++) {
                const a = i * Math.PI / 6;
                ctx.beginPath();
                ctx.moveTo(cx, cy);
                ctx.lineTo(cx + maxR * Math.cos(a), cy + maxR * Math.sin(a));
                ctx.stroke();
            }

            // Circular waveform — a wiggly ring whose radius modulates with
            // the phase. This is the placeholder until FFT data is wired up.
            ctx.strokeStyle = "rgba(160, 255, 120, 0.9)";
            ctx.lineWidth = 1.8;
            ctx.beginPath();
            const segs = 96;
            for (let i = 0; i <= segs; i++) {
                const a = i * 2 * Math.PI / segs;
                const wobble = Math.sin(a * 8 + viz.phase) * 0.18
                             + Math.sin(a * 3 - viz.phase * 1.7) * 0.10;
                const r = maxR * (0.62 + wobble);
                const x = cx + r * Math.cos(a);
                const y = cy + r * Math.sin(a);
                if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
            }
            ctx.stroke();

            // Inner pulsing core.
            const core = maxR * (0.10 + 0.05 * Math.sin(viz.phase * 3));
            const coreGrad = ctx.createRadialGradient(cx, cy, 0, cx, cy, core);
            coreGrad.addColorStop(0, "rgba(220, 255, 200, 0.9)");
            coreGrad.addColorStop(1, "rgba(80, 200, 80, 0)");
            ctx.fillStyle = coreGrad;
            ctx.beginPath();
            ctx.arc(cx, cy, core, 0, 2 * Math.PI);
            ctx.fill();
        }

        // Repaint whenever phase changes.
        Connections {
            target: viz
            function onPhaseChanged() { canvas.requestPaint(); }
        }
    }
}
