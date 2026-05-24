#!/usr/bin/env python3
"""Generates MVP placeholder brand icons for RPS Duel.

Three minimal white tokens (rock / paper / scissors) arranged in an
equilateral triangle on an indigo background. Pure PIL primitives so
the output is crisp at every size down to the 48px Android mdpi and
the 16px favicon.

Outputs:
  assets/app_icon/app_icon.png            -- 1024x1024, full triangle
  assets/app_icon/app_icon_foreground.png -- 1024x1024, 75% triangle,
                                             transparent bg (used as the
                                             Android adaptive-icon
                                             foreground layer so the
                                             safe-zone crop does not
                                             chop the tokens)

Run from the project root:
  python3 scripts/generate_app_icon.py
Then regenerate the per-platform launcher assets:
  dart run flutter_launcher_icons
"""
from math import cos, pi, sin
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 1024
INDIGO = (63, 81, 181, 255)  # #3F51B5
WHITE = (255, 255, 255, 255)
OUT_DIR = Path("assets/app_icon")


def draw_tokens(img: Image.Image, vertex_radius: float, shape_size: float) -> None:
    """Paint three white tokens at the vertices of a centered equilateral triangle.

    Args:
      img:           target RGBA image (any size; uses module-level SIZE for centering)
      vertex_radius: distance from canvas center to each triangle vertex (pixels)
      shape_size:    visual width/diameter of each token (pixels)
    """
    draw = ImageDraw.Draw(img)
    cx, cy = SIZE / 2, SIZE / 2
    half = shape_size / 2

    # Apex up, 120 degrees apart. In PIL coordinates (y grows down)
    # angle -pi/2 lands at the top; +2pi/3 from there lands bottom-right;
    # +4pi/3 lands bottom-left.
    angles = [
        -pi / 2,
        -pi / 2 + 2 * pi / 3,
        -pi / 2 + 4 * pi / 3,
    ]
    (rock_x, rock_y), (br_x, br_y), (bl_x, bl_y) = [
        (cx + vertex_radius * cos(a), cy + vertex_radius * sin(a)) for a in angles
    ]

    # Rock -- filled circle at apex.
    draw.ellipse(
        (rock_x - half, rock_y - half, rock_x + half, rock_y + half),
        fill=WHITE,
    )

    # Paper -- rounded square at bottom-left.
    paper_radius = shape_size * 0.18
    draw.rounded_rectangle(
        (bl_x - half, bl_y - half, bl_x + half, bl_y + half),
        radius=paper_radius,
        fill=WHITE,
    )

    # Scissors -- two crossed lines (X) at bottom-right.
    stroke = max(20, int(shape_size * 0.22))
    draw.line(
        (br_x - half, br_y - half, br_x + half, br_y + half),
        fill=WHITE,
        width=stroke,
    )
    draw.line(
        (br_x - half, br_y + half, br_x + half, br_y - half),
        fill=WHITE,
        width=stroke,
    )


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    # Main icon: indigo bg + full-size triangle.
    main_img = Image.new("RGBA", (SIZE, SIZE), INDIGO)
    draw_tokens(main_img, vertex_radius=240, shape_size=180)
    main_img.save(OUT_DIR / "app_icon.png")

    # Adaptive foreground: transparent bg + 75% triangle (Android safe-zone padding).
    fg_img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw_tokens(fg_img, vertex_radius=180, shape_size=140)
    fg_img.save(OUT_DIR / "app_icon_foreground.png")

    print(f"Wrote {OUT_DIR / 'app_icon.png'} and {OUT_DIR / 'app_icon_foreground.png'}")


if __name__ == "__main__":
    main()
