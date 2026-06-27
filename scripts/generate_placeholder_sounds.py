#!/usr/bin/env python3
"""Synthesizes placeholder sound effects for the Tactile Premium audio layer.

Outputs six short .wav clips under `assets/sounds/`:
  tap.wav    — short bandpassed click (~80 ms)
  reveal.wav — soft anticipatory chime (~180 ms)
  win.wav    — C major triad bell (~600 ms)
  loss.wav   — F minor cluster bell (~600 ms)
  tie.wav    — A4 + C#5 perfect-fifth tone (~400 ms)
  unlock.wav — C major + octave celebratory bell (~800 ms)

These are not premium production samples. They are deliberately neutral
synthesized placeholders so the audio integration can be soaked. Swap any
of them with a curated CC0 sample by overwriting the .wav file in place —
no code changes required.

Run from the project root:
  python3 scripts/generate_placeholder_sounds.py
"""
from __future__ import annotations

import math
import os
import random
import struct
import wave

SAMPLE_RATE = 44100
OUT_DIR = "assets/sounds"


def envelope(t: float, attack: float, decay: float) -> float:
    """Soft attack-decay envelope. Returns 0..1."""
    if t < attack:
        return t / attack if attack > 0 else 1.0
    return math.exp(-(t - attack) / decay)


def write_wav(path: str, samples: list[float]) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with wave.open(path, "wb") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(SAMPLE_RATE)
        for s in samples:
            clipped = max(-1.0, min(1.0, s))
            f.writeframes(struct.pack("<h", int(clipped * 32767)))


def make_click(path: str, duration: float = 0.08, vol: float = 0.4) -> None:
    """A short bandpass-ish click around 2 kHz with a tiny noise burst."""
    random.seed(42)
    samples: list[float] = []
    n_samples = int(duration * SAMPLE_RATE)
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        env = envelope(t, 0.001, 0.015)
        sample = 0.0
        for freq, weight in ((1800, 0.5), (2200, 0.5), (2600, 0.3)):
            sample += math.sin(2 * math.pi * freq * t) * weight
        sample /= 1.3
        if t < 0.005:
            sample += (random.random() - 0.5) * 0.3
        samples.append(sample * env * vol)
    write_wav(path, samples)


def make_tone(
    path: str,
    freqs: list[float],
    duration: float,
    *,
    attack: float = 0.005,
    decay: float = 0.3,
    vol: float = 0.35,
) -> None:
    """Sum of sines with an attack-decay envelope."""
    samples: list[float] = []
    n_samples = int(duration * SAMPLE_RATE)
    n_freqs = max(1, len(freqs))
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        env = envelope(t, attack, decay)
        partial = 0.0
        for freq in freqs:
            partial += math.sin(2 * math.pi * freq * t)
        samples.append((partial / n_freqs) * env * vol)
    write_wav(path, samples)


def main() -> None:
    make_click(f"{OUT_DIR}/tap.wav", duration=0.08, vol=0.4)
    make_tone(
        f"{OUT_DIR}/reveal.wav",
        [523.25, 1046.50],
        0.18,
        attack=0.005,
        decay=0.08,
        vol=0.3,
    )
    make_tone(
        f"{OUT_DIR}/win.wav",
        [523.25, 659.25, 783.99],  # C5 E5 G5
        0.6,
        decay=0.35,
        vol=0.35,
    )
    make_tone(
        f"{OUT_DIR}/loss.wav",
        [349.23, 415.30, 466.16],  # F4 G#4 A#4 — subdued
        0.6,
        decay=0.35,
        vol=0.30,
    )
    make_tone(
        f"{OUT_DIR}/tie.wav",
        [440.00, 554.37],  # A4 + C#5 — neutral
        0.4,
        decay=0.25,
        vol=0.32,
    )
    make_tone(
        f"{OUT_DIR}/unlock.wav",
        [523.25, 659.25, 783.99, 1046.50],  # C major + octave shimmer
        0.8,
        decay=0.4,
        vol=0.32,
    )
    print(f"Wrote 6 placeholder sounds to {OUT_DIR}/")


if __name__ == "__main__":
    main()
