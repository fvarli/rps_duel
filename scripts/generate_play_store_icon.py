#!/usr/bin/env python3
"""Generates the 512x512 Google Play Store listing icon for RPS Duel.

Downsamples the 1024x1024 brand master to 512x512 with LANCZOS, flattens
onto the indigo brand background so the listing tile has no alpha, and
applies a mild unsharp mask for thumbnail visibility. No redesign —
proportions, colors, and token layout match the existing launcher icon.

Run from the project root:
  python3 scripts/generate_play_store_icon.py
"""
from pathlib import Path

from PIL import Image, ImageFilter

SRC = Path("assets/app_icon/app_icon.png")                # 1024x1024 RGBA master
OUT = Path("assets/store-final/play_store_icon_512.png")  # 512x512 output
SIZE = 512
INDIGO = (63, 81, 181)                                    # #3F51B5 — matches the master


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    src = Image.open(SRC).convert("RGBA")
    if src.size != (1024, 1024):
        raise ValueError(f"unexpected master size: {src.size}")

    scaled = src.resize((SIZE, SIZE), Image.LANCZOS)

    bg = Image.new("RGB", (SIZE, SIZE), INDIGO)
    bg.paste(scaled, mask=scaled.split()[-1])

    sharpened = bg.filter(
        ImageFilter.UnsharpMask(radius=1.0, percent=60, threshold=2)
    )

    sharpened.save(OUT, format="PNG", optimize=True)
    print(f"wrote {OUT}  ({SIZE}x{SIZE})  {OUT.stat().st_size / 1024:.1f} KB")


if __name__ == "__main__":
    main()
