#!/usr/bin/env python3
"""Generates the Play Store feature graphic for RPS Duel.

A 1024x500 PNG drawn from the Tactile Premium palette + the launcher-icon
token motif so the listing visually rhymes with the installed app.

Run from anywhere:
  python3 store-assets/feature_graphic/generate_feature_graphic.py

Output:
  store-assets/feature_graphic/feature_graphic.png  (1024x500 RGBA)

Palette is pinned to lib/ui/theme/tactile_theme.dart:9 (TactileColors).
Token primitives mirror scripts/generate_app_icon.py:34 (draw_tokens).
"""
from math import cos, pi, sin
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

# Tactile Premium palette (mirrors lib/ui/theme/tactile_theme.dart:9).
CREAM = (240, 233, 216, 255)  # #F0E9D8
SAGE = (92, 125, 68, 255)     # #5C7D44
CLAY = (168, 90, 59, 255)     # #A85A3B

# Canvas — Play Console requires 1024x500 for the feature graphic.
WIDTH, HEIGHT = 1024, 500

# Token cluster on the right side of the canvas.
TOKEN_CX, TOKEN_CY = 820, HEIGHT // 2
TOKEN_VERTEX_RADIUS = 110   # distance from cluster center to each vertex
TOKEN_SIZE = 90             # per-token diameter

OUT_PATH = Path(__file__).resolve().parent / "feature_graphic.png"


def load_font(size: int, *, bold: bool = False):
    """Try DejaVu Sans (ships with Ubuntu); fall back to PIL's default font."""
    candidates = []
    if bold:
        candidates += [
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
            "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf",
            "DejaVuSans-Bold.ttf",
        ]
    else:
        candidates += [
            "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
            "/usr/share/fonts/dejavu/DejaVuSans.ttf",
            "DejaVuSans.ttf",
        ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size=size), path
        except (OSError, IOError):
            continue
    return ImageFont.load_default(), "<PIL default>"


def draw_tokens(draw: ImageDraw.ImageDraw, cx: float, cy: float,
                vertex_radius: float, shape_size: float, color) -> None:
    """Three tokens at the vertices of an equilateral triangle centered on (cx, cy).

    Mirrors scripts/generate_app_icon.py:34 — apex up, +120 degrees apart,
    rock at the apex (circle), paper bottom-left (rounded square),
    scissors bottom-right (crossed lines).
    """
    half = shape_size / 2
    angles = [
        -pi / 2,
        -pi / 2 + 2 * pi / 3,
        -pi / 2 + 4 * pi / 3,
    ]
    (rock_x, rock_y), (br_x, br_y), (bl_x, bl_y) = [
        (cx + vertex_radius * cos(a), cy + vertex_radius * sin(a)) for a in angles
    ]

    # Rock — filled circle at apex.
    draw.ellipse(
        (rock_x - half, rock_y - half, rock_x + half, rock_y + half),
        fill=color,
    )

    # Paper — rounded square at bottom-left.
    paper_radius = shape_size * 0.18
    draw.rounded_rectangle(
        (bl_x - half, bl_y - half, bl_x + half, bl_y + half),
        radius=paper_radius,
        fill=color,
    )

    # Scissors — two crossed lines (X) at bottom-right.
    stroke = max(8, int(shape_size * 0.22))
    draw.line(
        (br_x - half, br_y - half, br_x + half, br_y + half),
        fill=color,
        width=stroke,
    )
    draw.line(
        (br_x - half, br_y + half, br_x + half, br_y - half),
        fill=color,
        width=stroke,
    )


def main() -> None:
    img = Image.new("RGBA", (WIDTH, HEIGHT), CREAM)
    draw = ImageDraw.Draw(img)

    title_font, title_font_path = load_font(120, bold=True)
    subtitle_font, subtitle_font_path = load_font(36, bold=False)

    title = "RPS Duel"
    subtitle = "Rock Paper Scissors, reimagined"

    # Vertically center the (title, subtitle) block on the left.
    title_bbox = draw.textbbox((0, 0), title, font=title_font)
    subtitle_bbox = draw.textbbox((0, 0), subtitle, font=subtitle_font)
    title_h = title_bbox[3] - title_bbox[1]
    subtitle_h = subtitle_bbox[3] - subtitle_bbox[1]
    gap = 20
    block_h = title_h + gap + subtitle_h

    x = 64
    block_top = (HEIGHT - block_h) // 2

    # textbbox offsets compensate for font ascent padding so the visual top
    # of each glyph block aligns with block_top.
    draw.text((x - title_bbox[0], block_top - title_bbox[1]),
              title, font=title_font, fill=SAGE)
    draw.text((x - subtitle_bbox[0],
               block_top + title_h + gap - subtitle_bbox[1]),
              subtitle, font=subtitle_font, fill=CLAY)

    draw_tokens(draw, TOKEN_CX, TOKEN_CY,
                vertex_radius=TOKEN_VERTEX_RADIUS,
                shape_size=TOKEN_SIZE,
                color=SAGE)

    img.save(OUT_PATH)
    print(f"Wrote {OUT_PATH} ({WIDTH}x{HEIGHT})")
    print(f"  title font:    {title_font_path}")
    print(f"  subtitle font: {subtitle_font_path}")


if __name__ == "__main__":
    main()
