#!/usr/bin/env python3
"""Generates temporary placeholder launcher icons for RPS Duel.

Output:
  assets/app_icon/app_icon.png            -- 1024x1024, indigo bg, white "RPS"
  assets/app_icon/app_icon_foreground.png -- 1024x1024, transparent bg, smaller "RPS"
                                             (used as the Android adaptive-icon
                                             foreground layer so the Android safe-zone
                                             crop does not chop the letters)

Run from project root:
  python3 scripts/generate_app_icon.py
Then regenerate the per-platform launcher assets:
  dart run flutter_launcher_icons
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SIZE = 1024
INDIGO = (63, 81, 181, 255)  # #3F51B5
WHITE = (255, 255, 255, 255)
TEXT = "RPS"
FONT_CANDIDATES = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf",
    "/Library/Fonts/Arial Bold.ttf",
    "C:/Windows/Fonts/arialbd.ttf",
]
OUT_DIR = Path("assets/app_icon")


def find_font(size_pt: int) -> ImageFont.FreeTypeFont:
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            return ImageFont.truetype(path, size_pt)
    return ImageFont.load_default()


def draw_centered_text(img: Image.Image, text: str, font: ImageFont.FreeTypeFont) -> None:
    draw = ImageDraw.Draw(img)
    bbox = draw.textbbox((0, 0), text, font=font)
    w = bbox[2] - bbox[0]
    h = bbox[3] - bbox[1]
    x = (img.width - w) / 2 - bbox[0]
    y = (img.height - h) / 2 - bbox[1]
    draw.text((x, y), text, fill=WHITE, font=font)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    main_img = Image.new("RGBA", (SIZE, SIZE), INDIGO)
    draw_centered_text(main_img, TEXT, find_font(380))
    main_img.save(OUT_DIR / "app_icon.png")

    fg_img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw_centered_text(fg_img, TEXT, find_font(280))
    fg_img.save(OUT_DIR / "app_icon_foreground.png")

    print(f"Wrote {OUT_DIR / 'app_icon.png'} and {OUT_DIR / 'app_icon_foreground.png'}")


if __name__ == "__main__":
    main()
