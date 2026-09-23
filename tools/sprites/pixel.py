import math
from PIL import Image

W = H = 48
OUT = (40, 26, 30, 255)


def rgb(r, g, b, a=255):
    return (r, g, b, a)


class Canvas:
    def __init__(self, w=W, h=H):
        self.w, self.h = w, h
        self.px = [[None] * w for _ in range(h)]

    def set(self, x, y, c):
        if 0 <= x < self.w and 0 <= y < self.h and c is not None:
            self.px[y][x] = c

    def get(self, x, y):
        if 0 <= x < self.w and 0 <= y < self.h:
            return self.px[y][x]
        return None

    # -- core: fill a mask with optional per-part outline (4-neighbour dilation)
    def paint(self, pixels, color_fn, outline=OUT):
        pix = set(pixels)
        if outline is not None:
            ring = set()
            for (x, y) in pix:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    q = (x + dx, y + dy)
                    if q not in pix:
                        ring.add(q)
            for (x, y) in ring:
                self.set(x, y, outline)
        for (x, y) in pix:
            self.set(x, y, color_fn(x, y))

    def image(self, scale=1):
        im = Image.new("RGBA", (self.w, self.h), (0, 0, 0, 0))
        for y in range(self.h):
            for x in range(self.w):
                c = self.px[y][x]
                if c is not None:
                    im.putpixel((x, y), c)
        if scale != 1:
            im = im.resize((self.w * scale, self.h * scale), Image.NEAREST)
        return im


def _grid(x0, y0, x1, y1):
    for y in range(max(0, int(math.floor(y0))), min(H, int(math.ceil(y1)) + 1)):
        for x in range(max(0, int(math.floor(x0))), min(W, int(math.ceil(x1)) + 1)):
            yield x, y


def ellipse_px(cx, cy, rx, ry, ang=0.0):
    ca, sa = math.cos(ang), math.sin(ang)
    r = max(rx, ry) + 1
    out = []
    for x, y in _grid(cx - r, cy - r, cx + r, cy + r):
        dx, dy = x + 0.5 - cx, y + 0.5 - cy
        u = (dx * ca + dy * sa) / rx
        v = (-dx * sa + dy * ca) / ry
        if u * u + v * v <= 1.0:
            out.append((x, y))
    return out


def poly_px(pts):
    xs = [p[0] for p in pts]
    ys = [p[1] for p in pts]
    out = []
    for x, y in _grid(min(xs), min(ys), max(xs), max(ys)):
        px, py = x + 0.5, y + 0.5
        inside = False
        j = len(pts) - 1
        for i in range(len(pts)):
            xi, yi = pts[i]
            xj, yj = pts[j]
            if (yi > py) != (yj > py):
                xint = xi + (py - yi) * (xj - xi) / (yj - yi)
                if px < xint:
                    inside = not inside
            j = i
        if inside:
            out.append((x, y))
    return out


def line_px(x0, y0, x1, y1, w=1.0):
    out = []
    r = w / 2.0
    L2 = (x1 - x0) ** 2 + (y1 - y0) ** 2
    for x, y in _grid(min(x0, x1) - r - 1, min(y0, y1) - r - 1, max(x0, x1) + r + 1, max(y0, y1) + r + 1):
        px, py = x + 0.5, y + 0.5
        if L2 == 0:
            t = 0
        else:
            t = max(0, min(1, ((px - x0) * (x1 - x0) + (py - y0) * (y1 - y0)) / L2))
        qx, qy = x0 + t * (x1 - x0), y0 + t * (y1 - y0)
        if (px - qx) ** 2 + (py - qy) ** 2 <= r * r + 0.15:
            out.append((x, y))
    return out


def rect_px(x0, y0, x1, y1):
    return [(x, y) for y in range(y0, y1 + 1) for x in range(x0, x1 + 1)]


def ramp(base, shadow, light, cx, cy, rx, ry, lx=-0.55, ly=-0.75):
    """3-tone spherical shading lit from the top-left."""
    def fn(x, y):
        nx = (x + 0.5 - cx) / max(rx, 0.5)
        ny = (y + 0.5 - cy) / max(ry, 0.5)
        d = nx * lx + ny * ly
        if d > 0.55 and light is not None:
            return light
        if d < -0.35 and shadow is not None:
            return shadow
        return base
    return fn


def flat(c):
    return lambda x, y: c


def band_shade(base, shadow, light, y_top, y_bot):
    """Vertical-gradient 3-tone shading (for cloth/metal that isn't round)."""
    def fn(x, y):
        t = (y - y_top) / max(1, (y_bot - y_top))
        if t < 0.25 and light is not None:
            return light
        if t > 0.7 and shadow is not None:
            return shadow
        return base
    return fn
