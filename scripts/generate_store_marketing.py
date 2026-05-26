#!/usr/bin/env python3
"""Generates the Play Store marketing pack for RPS Duel.

Six 1080x1920 marketing screenshots (raw app captures wrapped in a Tactile
Premium cream frame with an ink headline + sage accent rule) plus the
1024x500 feature graphic. The feature graphic uses three cropped in-app move
icons (rock / paper / scissors) on the right so the listing reads as a game,
not as a SaaS landing page.

Run from the project root:
  python3 scripts/generate_store_marketing.py

Inputs:  store-assets/screenshots/screenshot_{2,3,4,5,6,1,lang_picker_en}.png
Outputs: assets/store-final/{01..06}_*.png + assets/store-final/feature_graphic.png
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

# Tactile Premium palette (mirrors lib/ui/theme/tactile_theme.dart:9-27).
CREAM = (240, 233, 216, 255)  # #F0E9D8
SAGE = (92, 125, 68, 255)     # #5C7D44
CLAY = (168, 90, 59, 255)     # #A85A3B
INK = (31, 28, 20, 255)       # #1F1C14

# Marketing screenshot canvas.
SHOT_W, SHOT_H = 1080, 1920
EMBED_W, EMBED_H = 720, 1600      # raw 1080x2400 scaled 0.667x, aspect preserved
EMBED_X = (SHOT_W - EMBED_W) // 2  # 180
EMBED_Y = 290
CORNER_RADIUS = 28
SHADOW_BLUR = 18
SHADOW_OFFSET_Y = 8
SHADOW_ALPHA = 32                  # ~12.5% of 255

HEADLINE_FONT_SIZE = 52
HEADLINE_LINE_GAP = 12
RULE_GAP_ABOVE = 28
SAGE_RULE_WIDTH = 96
SAGE_RULE_HEIGHT = 4

# Feature graphic canvas.
FG_W, FG_H = 1024, 500
FG_TITLE_FONT_SIZE = 96
FG_SUB_FONT_SIZE = 30
FG_TEXT_X = 64

# Feature graphic — cropped in-app move icons on the right.
# Source: store-assets/screenshots/screenshot_1.png (English idle, 1080x2400).
# In-app move-button row sits at y≈1305-1551 with three colorful icon tiles
# (gray 3D rock, blue document paper, red+blue cartoon scissors).
FG_ICON_SOURCE = Path("store-assets/screenshots/screenshot_1.png")
FG_ICON_SOURCE_CENTERS = [(196, 1518), (540, 1518), (876, 1518)]   # source pixel centers
FG_ICON_SOURCE_SIZE = 220                                          # source crop box (px)
FG_ICON_RENDER_SIZE = 138                                          # final icon size on canvas
FG_ICON_CENTERS_X = [655, 801, 947]                                # x centers on canvas
FG_ICON_CENTER_Y = 250                                             # y center on canvas
FG_ICON_CORNER_RADIUS = 20                                         # rounded-square mask
FG_ICON_SHADOW_BLUR = 10
FG_ICON_SHADOW_OFFSET_Y = 5
FG_ICON_SHADOW_ALPHA = 32

OUT_DIR = Path("assets/store-final")
RAW_DIR = Path("store-assets/screenshots")

# (output_filename, source_filename, headline_lines).
# Phase 25 mapping — English only, frame order swapped (04 difficulty before
# 05 settings), 03+04 headlines shortened.
JOBS = [
    ("01_win_hook.png", "screenshot_3.png", ["Beat the CPU in fast", "tactical duels"]),
    ("02_cpu_thinking.png", "screenshot_2.png", ["Quick rounds.", "Instant decisions."]),
    ("03_achievements.png", "screenshot_6.png", ["Track wins.", "Unlock achievements."]),
    ("04_difficulty.png", "screenshot_5.png", ["Pick your difficulty"]),
    ("05_settings.png", "screenshot_4.png", ["Simple settings.", "Clean experience."]),
    ("06_localization.png", "screenshot_lang_picker_en.png", ["Play in your language"]),
]


def load_font(size: int, *, bold: bool = False):
    """Try DejaVu Sans (ships with Ubuntu); fall back to PIL's default font."""
    candidates = []
    if bold:
        candidates += [
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
            "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf",
        ]
    else:
        candidates += [
            "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
            "/usr/share/fonts/dejavu/DejaVuSans.ttf",
        ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size=size)
        except OSError:
            continue
    return ImageFont.load_default()


def rounded_screenshot(src_path: Path, w: int, h: int, radius: int) -> Image.Image:
    """Load the raw screenshot, scale to (w, h), apply a rounded-corner alpha mask."""
    raw = Image.open(src_path).convert("RGBA")
    scaled = raw.resize((w, h), Image.LANCZOS)
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, w, h), radius=radius, fill=255)
    scaled.putalpha(mask)
    return scaled


def drop_shadow(w: int, h: int, radius: int, blur: int, alpha: int) -> Image.Image:
    """A soft shadow image matching the rounded screenshot's silhouette."""
    pad = blur * 2
    shadow = Image.new("RGBA", (w + pad * 2, h + pad * 2), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (pad, pad, pad + w, pad + h),
        radius=radius,
        fill=(INK[0], INK[1], INK[2], alpha),
    )
    return shadow.filter(ImageFilter.GaussianBlur(blur))


def render_marketing_screenshot(
    src_path: Path,
    out_path: Path,
    headline_lines: list,
    headline_font: ImageFont.FreeTypeFont,
) -> None:
    canvas = Image.new("RGBA", (SHOT_W, SHOT_H), CREAM)
    draw = ImageDraw.Draw(canvas)

    # Vertically center (headline + rule) block within the top band y=0..EMBED_Y.
    line_h = HEADLINE_FONT_SIZE + HEADLINE_LINE_GAP
    text_block_h = line_h * len(headline_lines)
    block_h = text_block_h + RULE_GAP_ABOVE + SAGE_RULE_HEIGHT
    block_top = (EMBED_Y - block_h) // 2

    # Headline lines, centered.
    for i, line in enumerate(headline_lines):
        bbox = draw.textbbox((0, 0), line, font=headline_font)
        text_w = bbox[2] - bbox[0]
        x = (SHOT_W - text_w) // 2 - bbox[0]
        y = block_top + i * line_h - bbox[1]
        draw.text((x, y), line, font=headline_font, fill=INK)

    # Sage accent rule, centered below the headline.
    rule_y = block_top + text_block_h + RULE_GAP_ABOVE
    rule_x = (SHOT_W - SAGE_RULE_WIDTH) // 2
    draw.rectangle(
        (rule_x, rule_y, rule_x + SAGE_RULE_WIDTH, rule_y + SAGE_RULE_HEIGHT),
        fill=SAGE,
    )

    # Drop shadow under the embedded screenshot.
    shadow_img = drop_shadow(EMBED_W, EMBED_H, CORNER_RADIUS, SHADOW_BLUR, SHADOW_ALPHA)
    sx = EMBED_X - SHADOW_BLUR * 2
    sy = EMBED_Y - SHADOW_BLUR * 2 + SHADOW_OFFSET_Y
    canvas.alpha_composite(shadow_img, (sx, sy))

    # Embedded screenshot (rounded corners).
    embed = rounded_screenshot(src_path, EMBED_W, EMBED_H, CORNER_RADIUS)
    canvas.alpha_composite(embed, (EMBED_X, EMBED_Y))

    canvas.convert("RGB").save(out_path, optimize=True)
    print(f"  wrote {out_path}  ({SHOT_W}x{SHOT_H})")


def cropped_icon(
    src_img: Image.Image,
    source_center: tuple,
    source_size: int,
    target_size: int,
    corner_radius: int,
) -> Image.Image:
    """Crop a square around the in-app move icon, scale, apply rounded-corner mask."""
    sx, sy = source_center
    half = source_size // 2
    raw = src_img.crop((sx - half, sy - half, sx + half, sy + half))
    scaled = raw.resize((target_size, target_size), Image.LANCZOS).convert("RGBA")
    mask = Image.new("L", (target_size, target_size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, target_size, target_size), radius=corner_radius, fill=255
    )
    scaled.putalpha(mask)
    return scaled


def render_feature_graphic(out_path: Path) -> None:
    canvas = Image.new("RGBA", (FG_W, FG_H), CREAM)
    draw = ImageDraw.Draw(canvas)

    title_font = load_font(FG_TITLE_FONT_SIZE, bold=True)
    sub_font = load_font(FG_SUB_FONT_SIZE, bold=False)

    title = "RPS Duel"
    subtitle = "Tactical duel game"

    tb = draw.textbbox((0, 0), title, font=title_font)
    sb = draw.textbbox((0, 0), subtitle, font=sub_font)
    title_h = tb[3] - tb[1]
    sub_h = sb[3] - sb[1]
    gap = 20
    block_h = title_h + gap + sub_h
    block_top = (FG_H - block_h) // 2

    draw.text(
        (FG_TEXT_X - tb[0], block_top - tb[1]),
        title,
        font=title_font,
        fill=SAGE,
    )
    draw.text(
        (FG_TEXT_X - sb[0], block_top + title_h + gap - sb[1]),
        subtitle,
        font=sub_font,
        fill=CLAY,
    )

    # Right side: three cropped in-app move icons (rock / paper / scissors).
    src_img = Image.open(FG_ICON_SOURCE).convert("RGBA")
    shadow_tile = drop_shadow(
        FG_ICON_RENDER_SIZE,
        FG_ICON_RENDER_SIZE,
        FG_ICON_CORNER_RADIUS,
        FG_ICON_SHADOW_BLUR,
        FG_ICON_SHADOW_ALPHA,
    )
    pad = FG_ICON_SHADOW_BLUR * 2
    for cx, source_center in zip(FG_ICON_CENTERS_X, FG_ICON_SOURCE_CENTERS):
        # Shadow first.
        sx = cx - FG_ICON_RENDER_SIZE // 2 - pad
        sy = FG_ICON_CENTER_Y - FG_ICON_RENDER_SIZE // 2 - pad + FG_ICON_SHADOW_OFFSET_Y
        canvas.alpha_composite(shadow_tile, (sx, sy))
        # Then the rounded-cropped icon on top.
        icon = cropped_icon(
            src_img,
            source_center,
            FG_ICON_SOURCE_SIZE,
            FG_ICON_RENDER_SIZE,
            FG_ICON_CORNER_RADIUS,
        )
        ix = cx - FG_ICON_RENDER_SIZE // 2
        iy = FG_ICON_CENTER_Y - FG_ICON_RENDER_SIZE // 2
        canvas.alpha_composite(icon, (ix, iy))

    canvas.convert("RGB").save(out_path, optimize=True)
    print(f"  wrote {out_path}  ({FG_W}x{FG_H})")


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    headline_font = load_font(HEADLINE_FONT_SIZE, bold=True)

    print("Marketing screenshots:")
    for out_name, src_name, headline_lines in JOBS:
        src = RAW_DIR / src_name
        if not src.exists():
            raise FileNotFoundError(f"source missing: {src}")
        render_marketing_screenshot(
            src, OUT_DIR / out_name, headline_lines, headline_font
        )

    print("Feature graphic:")
    render_feature_graphic(OUT_DIR / "feature_graphic.png")


if __name__ == "__main__":
    main()
