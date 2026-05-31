# sonique-kde

A from-scratch Qt 6 / KDE Frameworks 6 reimagining of the
[Sonique](https://en.wikipedia.org/wiki/Sonique_(media_player)) 1.x audio
player (~1999). Pixel-perfect homage to the original's amorphous frameless
UI with three morphing view modes, ring of glowing transport buttons, and
LCD-style readout — but running on Qt Multimedia's FFmpeg backend, so it
plays anything PipeWire will accept (including 24- and 32-bit PCM at
96 kHz, which the original Sonique couldn't decode).

## Why

Sonique 1.x under Wine refuses to play modern high-resolution WAVs because
both its decoder (`ACMWave.sqp`) and its mixer (`MikITdll.dll`) are hard-
coded around 16-bit / 44.1 kHz CD quality. Transcoding a 99 GB high-res
library wasn't appealing. So: keep the look, rebuild the pipeline.

## Build

Arch Linux + KDE Plasma 6:

```bash
sudo pacman -S --needed qt6-base qt6-multimedia qt6-declarative \
    qt6-quickcontrols2 extra-cmake-modules kcoreaddons kconfig \
    cmake ninja
cmake -B build -G Ninja
cmake --build build
./build/sonique-kde [optional/path/to/audio.wav]
```

## Status

**MVP / Phase 1.** Frameless window, audio playback via Qt Multimedia,
rough Amp View. Pixel-perfect skin work, view morphing, and visualizations
are Phase 2+.

See `~/Projects/vault/projects/audio/sonique-kde/index.md` for the design.

## License

(TBD — leaning GPL-3.0-or-later for the code; original artwork in `assets/`
is original work and not copied from Sonique.)
