import sys
from PIL import Image, ImageDraw
from chars import RENDER, ANIMS

SCALE = 6
classes = sys.argv[1:] or list(RENDER)
rows = []
for cls in classes:
    for anim, poses in ANIMS.items():
        rows.append((cls, anim, [RENDER[cls](p).image(SCALE) for p in poses]))

cell = 48 * SCALE
sheet = Image.new("RGBA", (cell * 4 + 10, (cell + 4) * len(rows)), (120, 170, 110, 255))
for r, (cls, anim, frames) in enumerate(rows):
    for i, fr in enumerate(frames):
        bg = Image.new("RGBA", (cell, cell), (150, 196, 132, 255) if (r + i) % 2 else (140, 188, 122, 255))
        bg.alpha_composite(fr)
        sheet.paste(bg, (i * (cell + 2), r * (cell + 4)))
sheet.save("sheet_%s.png" % "_".join(classes))
print("ok")
