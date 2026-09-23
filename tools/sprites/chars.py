import math, random
from pixel import *

# ---------------------------------------------------------------- poses
# Every frame gets: bob (vertical offset of the upper body), far/near foot x
# and lift, and a class-specific "act" key driving the weapon/arms.
IDLE = [
    dict(bob=0, far=(21, 0), near=(27, 0), act="idle", sway=0),
    dict(bob=0, far=(21, 0), near=(27, 0), act="idle", sway=1),
    dict(bob=-1, far=(21, 0), near=(27, 0), act="idle", sway=1),
    dict(bob=-1, far=(21, 0), near=(27, 0), act="idle", sway=0),
]
WALK = [
    dict(bob=0, far=(28, 0), near=(19, 0), act="walk0", sway=0),
    dict(bob=-1, far=(25, 0), near=(22, -2), act="walk1", sway=1),
    dict(bob=0, far=(19, 0), near=(28, 0), act="walk2", sway=0),
    dict(bob=-1, far=(22, -2), near=(25, 0), act="walk3", sway=-1),
]
ATTACK = [
    dict(bob=0, far=(20, 0), near=(26, 0), act="windup", sway=0),
    dict(bob=0, far=(22, 0), near=(30, 0), act="strike", sway=1),
    dict(bob=0, far=(22, 0), near=(30, 0), act="follow", sway=1),
    dict(bob=0, far=(21, 0), near=(27, 0), act="recover", sway=0),
]

FOOT_Y = 40.3


def feet(c, pose, far_col, near_col, which, rx=3.2, ry=2.0):
    fx, fl = pose["far"] if which == "far" else pose["near"]
    col = far_col if which == "far" else near_col
    cy = FOOT_Y + fl
    c.paint(ellipse_px(fx, cy, rx, ry), ramp(col[0], col[1], col[2], fx, cy, rx, ry))


def shade3(base, sh, li, cx, cy, rx, ry):
    return ramp(base, sh, li, cx, cy, rx, ry)


def slash_arc(c, cx, cy, r0, r1, a0, a1, col, col2):
    for x in range(W):
        for y in range(H):
            dx, dy = x + 0.5 - cx, y + 0.5 - cy
            d = math.hypot(dx, dy)
            a = math.atan2(dy, dx)
            if r0 <= d <= r1 and a0 <= a <= a1:
                t = (a - a0) / (a1 - a0)
                c.set(x, y, col if d > (r0 + r1) / 2 - 0.2 else col2)
                if t < 0.25 and (x + y) % 2 == 0:
                    c.set(x, y, None)


def sword(c, hx, hy, tx, ty, steel, steel_d, steel_l, guard, grip):
    ang = math.atan2(ty - hy, tx - hx)
    ux, uy = math.cos(ang), math.sin(ang)
    # grip behind the hand
    c.paint(line_px(hx - ux * 3, hy - uy * 3, hx, hy, 1.6), flat(grip))
    # blade
    bx, by = hx + ux * 2, hy + uy * 2
    c.paint(line_px(bx, by, tx, ty, 2.3), flat(steel))
    for (x, y) in line_px(bx + uy * 0.5, by - ux * 0.5, tx, ty, 0.9):
        c.set(x, y, steel_l)
    # crossguard perpendicular
    gx, gy = hx + ux * 1.5, hy + uy * 1.5
    c.paint(line_px(gx - uy * 2.6, gy + ux * 2.6, gx + uy * 2.6, gy - ux * 2.6, 1.4), flat(guard))


# =====================================================================
# TATU CAVALEIRO
# =====================================================================
K = dict(
    skin=(rgb(236, 188, 92), rgb(201, 146, 58), rgb(252, 220, 140)),
    shell=(rgb(152, 102, 60), rgb(112, 72, 42), rgb(186, 134, 82)),
    band=rgb(96, 60, 36),
    steel=(rgb(178, 188, 200), rgb(118, 128, 146), rgb(228, 236, 244)),
    belt=rgb(112, 70, 40), gold=rgb(236, 192, 64),
    kilt=(rgb(176, 134, 92), rgb(140, 102, 66), rgb(200, 162, 120)),
    boot=(rgb(124, 82, 50), rgb(92, 58, 34), rgb(156, 108, 70)),
    wood=(rgb(160, 106, 58), rgb(120, 76, 40), rgb(190, 136, 84)),
    pink=rgb(236, 150, 140), eye=rgb(34, 24, 30), white=rgb(255, 255, 255),
    spot=rgb(170, 110, 50),
)

KNIGHT_ARM = {
    "idle": ((31, 33), (41, 24)),
    "walk0": ((31, 33), (41, 24)),
    "walk1": ((31, 32), (41, 23)),
    "walk2": ((31, 33), (41, 25)),
    "walk3": ((31, 32), (41, 24)),
    "windup": ((27, 26), (12, 4)),
    "strike": ((34, 30), (46, 29)),
    "follow": ((32, 35), (41, 43)),
    "recover": ((31, 33), (39, 26)),
}


def draw_knight(pose):
    c = Canvas()
    b = pose["bob"]
    act = pose["act"]
    lean = -1 if act == "windup" else (1 if act in ("strike", "follow") else 0)
    ox = lean  # upper body horizontal lean

    # tail
    c.paint(ellipse_px(12 + ox, 37 + b, 5.2, 2.2, -0.45), shade3(*K["skin"], 12, 37 + b, 5, 2.2))
    for (x, y) in ((10 + ox, 37 + b), (13 + ox, 36 + b)):
        c.set(x, y, K["spot"])
    feet(c, pose, K["boot"], K["boot"], "far")

    # shell (behind)
    scx, scy = 17 + ox, 27 + b
    c.paint(ellipse_px(scx, scy, 9.2, 11.2), shade3(*K["shell"], scx, scy, 9.2, 11.2))
    for bx in (11, 14, 17, 20):
        for (x, y) in ellipse_px(scx, scy, 9.2, 11.2):
            if x == bx + ox and (x + y) % 5 != 0:
                c.set(x, y, K["band"])

    # kilt + body
    c.paint(poly_px([(18 + ox, 34 + b), (31 + ox, 34 + b), (32 + ox, 38.5 + b), (17 + ox, 38.5 + b)]),
            band_shade(*K["kilt"], 34 + b, 38 + b))
    c.paint(ellipse_px(25 + ox, 30 + b, 6.4, 5.2), shade3(*K["steel"], 25 + ox, 30 + b, 6.4, 5.2))
    c.paint(rect_px(19 + ox, 34 + b, 31 + ox, 35 + b), flat(K["belt"]))
    for (x, y) in rect_px(26 + ox, 34 + b, 27 + ox, 35 + b):
        c.set(x, y, K["gold"])
    feet(c, pose, K["boot"], K["boot"], "near")

    (hx, hy), (tx, ty) = KNIGHT_ARM[act]
    if act not in ("windup", "strike", "follow"):
        hy += b
        ty += b
    if act == "windup":
        sword(c, hx, hy, tx, ty, K["steel"][0], K["steel"][1], K["steel"][2], K["gold"], K["belt"])

    # ears (behind head)
    for (ex, ey, a) in ((21.5, 9, -0.3), (27, 8.5, 0.25)):
        c.paint(ellipse_px(ex + ox, ey + b, 2.3, 4.6, a), shade3(*K["skin"], ex + ox, ey + b, 2.3, 4.6))
        c.paint(ellipse_px(ex + ox, ey + 0.8 + b, 0.9, 2.6, a), flat(K["pink"]), outline=None)

    # front pauldron
    c.paint(ellipse_px(29 + ox, 27 + b, 3.4, 2.4), shade3(*K["steel"], 29 + ox, 27 + b, 3.4, 2.4))

    # head + snout
    hcx, hcy = 26 + ox, 17 + b
    c.paint(ellipse_px(hcx, hcy, 8.6, 8.0), shade3(*K["skin"], hcx, hcy, 8.6, 8.0))
    c.paint(ellipse_px(33 + ox, 20.5 + b, 4.6, 3.2), shade3(*K["skin"], 33 + ox, 20.5 + b, 4.6, 3.2), outline=None)
    # snout outline only on the outer edge
    for (x, y) in ellipse_px(33 + ox, 20.5 + b, 5.6, 4.2):
        if c.get(x, y) is None:
            c.set(x, y, OUT)
    c.paint(ellipse_px(37.2 + ox, 19.8 + b, 1.4, 1.4), flat(K["pink"]), outline=None)
    # eye
    for (x, y) in rect_px(29 + ox, 14 + b, 30 + ox, 17 + b):
        c.set(x, y, K["eye"])
    c.set(30 + ox, 14 + b, K["white"])
    c.set(29 + ox, 17 + b, rgb(90, 70, 80))
    # blush
    c.set(31 + ox, 20 + b, K["pink"])
    c.set(32 + ox, 20 + b, K["pink"])

    # shield (held in front, near-left)
    shx, shy = 18.5 + ox, 32 + b
    c.paint(ellipse_px(shx, shy, 5.2, 6.0), shade3(*K["steel"], shx, shy, 5.2, 6.0))
    c.paint(ellipse_px(shx, shy, 3.9, 4.7), shade3(*K["wood"], shx, shy, 3.9, 4.7), outline=None)
    for (x, y) in ellipse_px(shx, shy, 3.9, 4.7):
        if x == int(shx) - 1:
            c.set(x, y, K["wood"][1])
    c.paint(ellipse_px(shx, shy, 1.4, 1.4), flat(K["steel"][0]), outline=None)
    c.set(int(shx) - 1, int(shy) - 1, K["steel"][2])

    # sword arm
    if act == "strike":
        slash_arc(c, 30, 30, 13, 16, -1.5, 1.3, rgb(255, 255, 236, 230), rgb(255, 236, 160, 170))
    if act != "windup":
        sword(c, hx, hy, tx, ty, K["steel"][0], K["steel"][1], K["steel"][2], K["gold"], K["belt"])
    c.paint(ellipse_px(hx, hy, 1.9, 1.9), flat(K["skin"][0]))
    return c


# =====================================================================
# LOBO-GUARÁ MAGA
# =====================================================================
M = dict(
    fur=(rgb(232, 140, 52), rgb(196, 100, 36), rgb(250, 182, 96)),
    black=rgb(44, 32, 36), white=(rgb(252, 246, 236), rgb(222, 212, 200), rgb(255, 255, 255)),
    robe=(rgb(46, 112, 118), rgb(30, 80, 86), rgb(74, 148, 148)),
    gold=rgb(238, 194, 72), belt=rgb(180, 150, 100),
    boot=(rgb(134, 90, 54), rgb(98, 64, 38), rgb(166, 118, 74)),
    wood=(rgb(146, 98, 56), rgb(104, 68, 38), rgb(182, 132, 82)),
    crystal=(rgb(196, 240, 255), rgb(132, 196, 228), rgb(255, 255, 255)),
    eye=rgb(214, 128, 40), pink=rgb(236, 170, 160),
)

MAGE_STAFF = {
    "idle": ((32, 33), 0.20),
    "walk0": ((32, 33), 0.24), "walk1": ((32, 32), 0.20),
    "walk2": ((32, 33), 0.16), "walk3": ((32, 32), 0.20),
    "windup": ((28, 30), -0.45),
    "strike": ((34, 30), 0.95),
    "follow": ((34, 31), 0.80),
    "recover": ((32, 33), 0.30),
}


def draw_mage(pose):
    c = Canvas()
    b = pose["bob"]
    act = pose["act"]
    ox = -1 if act == "windup" else (1 if act in ("strike", "follow") else 0)
    sw = pose["sway"]

    # bushy tail
    c.paint(ellipse_px(12 + ox, 34 + b + sw * 0.5, 6.0, 3.0, -0.6 + sw * 0.08),
            shade3(*M["fur"], 12 + ox, 34 + b, 6, 3))
    c.paint(ellipse_px(8 + ox, 37 + b + sw * 0.5, 2.2, 1.8, -0.6), flat(M["white"][0]), outline=None)

    # far leg (black sock) + boot
    fx, fl = pose["far"]
    c.paint(rect_px(fx - 1, 35 + b, fx + 1, 38), flat(M["black"]))
    feet(c, pose, M["boot"], M["boot"], "far", rx=2.8)

    # robe (dress)
    c.paint(poly_px([(19 + ox, 25 + b), (30 + ox, 25 + b), (32.5 + ox, 37.5 + b), (16.5 + ox, 37.5 + b)]),
            band_shade(*M["robe"], 25 + b, 37 + b))
    for (x, y) in ((21, 33), (27, 35), (24, 30), (29, 31)):
        c.set(x + ox, y + b, M["gold"])
    c.paint(rect_px(19 + ox, 31 + b, 30 + ox, 31 + b), flat(M["belt"]), outline=None)

    nx_, nl = pose["near"]
    c.paint(rect_px(nx_ - 1, 36 + b, nx_ + 1, 38), flat(M["black"]))
    feet(c, pose, M["boot"], M["boot"], "near", rx=2.8)

    # white chest ruff
    c.paint(ellipse_px(27 + ox, 25 + b, 4.0, 2.6), flat(M["white"][0]))

    # ears
    for pts, inner in (
        ([(18, 13), (23, 11), (19, 0.5)], [(19.5, 11.5), (21.5, 11), (19.5, 4)]),
        ([(24, 11), (29, 12), (28.5, 1)], [(25.5, 11), (27.5, 11.5), (27.5, 4.5)]),
    ):
        c.paint(poly_px([(x + ox, y + b) for x, y in pts]), flat(M["fur"][1]))
        c.paint(poly_px([(x + ox, y + b) for x, y in inner]), flat(M["white"][0]), outline=None)
    # gold earring on the back ear
    for (x, y) in ((19, 11), (18, 12), (19, 13)):
        c.set(x + ox, y + b, M["gold"])

    # head
    hcx, hcy = 25 + ox, 16.5 + b
    c.paint(ellipse_px(hcx, hcy, 8.2, 7.2), shade3(*M["fur"], hcx, hcy, 8.2, 7.2))
    # black mane tuft
    c.paint(ellipse_px(21 + ox, 10.5 + b, 3.2, 2.0, -0.3), flat(M["black"]), outline=None)
    c.paint(ellipse_px(17.5 + ox, 16 + b, 1.6, 4.0, 0.2), flat(M["black"]), outline=None)
    # muzzle
    c.paint(ellipse_px(31.5 + ox, 19.5 + b, 4.5, 2.8), shade3(*M["fur"], 31.5 + ox, 19.5 + b, 4.5, 2.8), outline=None)
    c.paint(ellipse_px(30.5 + ox, 21 + b, 3.5, 1.6), flat(M["white"][0]), outline=None)
    for (x, y) in ellipse_px(31.5 + ox, 19.5 + b, 5.5, 3.8):
        if c.get(x, y) is None:
            c.set(x, y, OUT)
    c.paint(ellipse_px(35.6 + ox, 18.6 + b, 1.3, 1.1), flat(M["black"]), outline=None)
    # eye (amber, lashed)
    for (x, y) in rect_px(26 + ox, 14 + b, 28 + ox, 17 + b):
        c.set(x, y, M["eye"])
    for (x, y) in rect_px(27 + ox, 15 + b, 28 + ox, 17 + b):
        c.set(x, y, M["black"])
    c.set(27 + ox, 15 + b, rgb(255, 255, 255))
    for x in range(25, 30):
        c.set(x + ox, 13 + b, M["black"])
    c.set(29 + ox, 12 + b, M["black"])
    c.set(30 + ox, 18 + b, M["pink"])

    # staff
    (hx, hy), ang = MAGE_STAFF[act]
    if act not in ("windup", "strike", "follow"):
        hy += b
    L_up, L_dn = 17, 8
    ux, uy = math.sin(ang), -math.cos(ang)
    tx, ty = hx + ux * L_up, hy + uy * L_up
    bx, by = hx - ux * L_dn, hy - uy * L_dn
    c.paint(line_px(bx, by, tx, ty, 2.0), flat(M["wood"][0]))
    for (x, y) in line_px(bx - 0.5, by, tx - 0.5, ty, 0.8):
        c.set(x, y, M["wood"][1])
    # crook + crystal
    glow = act in ("strike", "follow")
    if glow:
        for (x, y) in ellipse_px(tx, ty - 1, 5.5, 5.5):
            if c.get(x, y) is None:
                c.set(x, y, rgb(190, 240, 255, 110))
    c.paint(ellipse_px(tx, ty - 1, 2.4, 3.0), shade3(*M["crystal"], tx, ty - 1, 2.4, 3.0))
    c.set(int(tx) - 1, int(ty) - 2, rgb(255, 255, 255))
    if act == "strike":
        for dx, dy in ((0, -7), (6, -3), (7, 3), (-5, -5)):
            c.set(int(tx) + dx, int(ty) + dy, rgb(255, 255, 255))
            c.set(int(tx) + dx + 1, int(ty) + dy, rgb(190, 240, 255))
    # paw
    c.paint(ellipse_px(hx, hy, 1.8, 1.8), flat(M["fur"][0]))
    return c


# =====================================================================
# LAGARTO ARQUEIRO
# =====================================================================
A = dict(
    skin=(rgb(252, 216, 84), rgb(226, 170, 50), rgb(255, 240, 156)),
    belly=rgb(255, 248, 214),
    spot=rgb(84, 84, 96), wspot=rgb(255, 255, 244),
    hood=(rgb(98, 168, 82), rgb(58, 118, 56), rgb(146, 204, 112)),
    feather=rgb(232, 92, 70), feather2=rgb(246, 166, 176),
    quiver=(rgb(152, 110, 64), rgb(112, 76, 44), rgb(184, 142, 90)),
    band=rgb(62, 132, 76),
    bow=rgb(104, 56, 40), string=rgb(236, 230, 214),
    tip=rgb(222, 226, 236), tailtip=rgb(170, 174, 182),
    boot=(rgb(172, 124, 72), rgb(130, 90, 50), rgb(200, 156, 104)),
    eye=rgb(222, 52, 62),
)

ARCHER_BOW = {
    # (bow x, bow cy, string pull x) ; string pull x None = relaxed
    "idle": (35, 30, None), "walk0": (35, 30, None), "walk1": (35, 29, None),
    "walk2": (35, 30, None), "walk3": (35, 29, None),
    "windup": (36, 29, 27), "strike": (37, 29, None), "follow": (36, 29, None),
    "recover": (35, 30, None),
}


def draw_archer(pose):
    c = Canvas()
    b = pose["bob"]
    act = pose["act"]
    sw = pose["sway"]

    # thick tail curling up, grey tip
    path = [(19, 37.5), (14, 38.5), (9.5, 37.5), (6.5, 34.5), (5.5, 31), (6.5 + sw * 0.5, 28)]
    widths = [5.2, 4.8, 4.2, 3.6, 3.0, 2.6]
    tail = set()
    tip = set()
    for i in range(len(path) - 1):
        (x0, y0), (x1, y1) = path[i], path[i + 1]
        seg = line_px(x0, y0 + b, x1, y1 + b, widths[i])
        tail.update(seg)
        if i >= len(path) - 3:
            tip.update(line_px(x0, y0 + b, x1, y1 + b, widths[i]) if i == len(path) - 2 else [])
    c.paint(tail, lambda x, y: A["tailtip"] if (x, y) in tip else (A["skin"][1] if y >= 38 + b else A["skin"][0]))
    for (x, y) in ((11, 37), (13, 38), (8, 35)):
        c.set(x, y + b, A["spot"] if x != 13 else A["wspot"])

    feet(c, pose, A["boot"], A["boot"], "far", rx=3.0)

    # quiver (behind body)
    for (fx, fy) in ((13.5, 24), (15.5, 23), (17, 24.5)):
        c.paint(ellipse_px(fx, fy + b, 1.2, 2.2, -0.5), flat(A["feather"]))
    c.paint(line_px(15.5, 27 + b, 21, 37 + b, 5.0), band_shade(*A["quiver"], 27 + b, 37 + b))
    c.paint(line_px(17.2, 30 + b, 18.4, 32.3 + b, 5.0), flat(A["band"]), outline=None)

    # body
    c.paint(ellipse_px(23.5, 31 + b, 6.4, 6.4), shade3(*A["skin"], 23.5, 31 + b, 6.4, 6.4))
    c.paint(ellipse_px(27, 32.5 + b, 2.6, 3.8), flat(A["belly"]), outline=None)
    c.set(20, 30 + b, A["spot"])
    c.set(21, 33 + b, A["wspot"])
    feet(c, pose, A["boot"], A["boot"], "near", rx=3.0)

    # head
    hcx, hcy = 25.5, 18 + b
    c.paint(ellipse_px(hcx, hcy, 8.6, 7.6), shade3(*A["skin"], hcx, hcy, 8.6, 7.6))
    c.paint(ellipse_px(32.5, 20 + b, 5.0, 3.6), shade3(*A["skin"], 32.5, 20 + b, 5, 3.6), outline=None)
    for (x, y) in ellipse_px(32.5, 20 + b, 6.0, 4.6):
        if c.get(x, y) is None:
            c.set(x, y, OUT)
    # mouth line + nostril
    for x in range(29, 37):
        c.set(x, 22 + b, rgb(150, 96, 60))
    c.set(36, 19 + b, OUT)
    # cheek spots
    c.set(22, 21 + b, A["spot"])
    c.set(23, 22 + b, A["wspot"])
    c.set(21, 23 + b, A["wspot"])

    # hood (bandana) with point towards the back
    hood = [(17, 16), (20, 11), (26, 9.5), (32, 11.5), (34, 15), (30, 14.5), (24, 14.5), (18, 17.5), (11, 16)]
    c.paint(poly_px([(x, y + b) for x, y in hood]), band_shade(*A["hood"], 9 + b, 17 + b))
    # red feather sticking up from the back
    c.paint(ellipse_px(15.5, 8 + b, 2.0, 5.5, -0.35), flat(A["feather"]))
    for y in range(5, 11):
        c.set(15 + (1 if y > 8 else 0), y + b, A["feather2"])

    # eye (red, determined)
    for (x, y) in rect_px(29, 16 + b, 31, 17 + b):
        c.set(x, y, rgb(255, 255, 255))
    c.set(30, 16 + b, A["eye"])
    c.set(30, 17 + b, A["eye"])
    c.set(31, 17 + b, A["eye"])
    for x in range(28, 33):
        c.set(x, 15 + b, OUT)

    # bow + arrow
    bx, bcy, pull = ARCHER_BOW[act]
    if act not in ("windup", "strike", "follow"):
        bcy += b
    top, bot = (bx - 2, bcy - 10), (bx - 2, bcy + 10)
    bowpx = set()
    for t in range(0, 51):
        a = -1.25 + t * 0.05
        x = bx - 2.5 + math.cos(a) * 4.2
        y = bcy + math.sin(a) * 10.5
        bowpx.update(line_px(x, y, x, y, 2.0))
    c.paint(bowpx, flat(A["bow"]))
    top, bot = (bx - 1, bcy - 10), (bx - 1, bcy + 10)
    sx = pull if pull is not None else bx - 3
    c.paint(line_px(top[0], top[1], sx, bcy, 0.9), flat(A["string"]), outline=None)
    c.paint(line_px(sx, bcy, bot[0], bot[1], 0.9), flat(A["string"]), outline=None)
    if act in ("idle", "walk0", "walk1", "walk2", "walk3", "windup", "recover"):
        ax0 = sx if pull is not None else bx - 3
        c.paint(line_px(ax0, bcy, bx + 6, bcy, 1.0), flat(rgb(150, 100, 60)))
        c.paint(poly_px([(bx + 5, bcy - 2), (bx + 9, bcy + 0.5), (bx + 5, bcy + 3)]), flat(A["tip"]))
        c.paint(ellipse_px(ax0 + 1, bcy - 1, 1.4, 1.0), flat(A["feather"]), outline=None)
    if act == "strike":
        for x in range(bx + 2, W):
            if x % 3 != 0:
                c.set(x, bcy, rgb(255, 250, 220, 200))
        c.set(bx + 4, bcy - 2, rgb(255, 250, 220))
        c.set(bx + 4, bcy + 2, rgb(255, 250, 220))
    # hands: front hand on grip, back hand on string
    c.paint(ellipse_px(bx - 1, bcy, 1.8, 1.8), flat(A["skin"][0]))
    hand_x = pull if pull is not None else 29
    c.paint(ellipse_px(hand_x, bcy + (0 if pull else 2), 1.7, 1.7), flat(A["skin"][0]))
    return c


# =====================================================================
# URUTAU ASSASSINO
# =====================================================================
U = dict(
    feather=(rgb(152, 136, 116), rgb(112, 98, 84), rgb(192, 178, 158)),
    streak=rgb(84, 72, 62), speck=rgb(212, 200, 180),
    vest=(rgb(72, 58, 48), rgb(50, 40, 32), rgb(98, 82, 68)),
    wrap=rgb(116, 94, 72), beak=rgb(124, 116, 110),
    ring=rgb(246, 200, 48), pupil=rgb(20, 18, 26),
    blade=(rgb(216, 222, 232), rgb(150, 156, 172), rgb(250, 252, 255)),
    handle=rgb(74, 52, 40), talon=(rgb(176, 156, 124), rgb(138, 120, 92), rgb(204, 186, 156)),
)

ASSASSIN_DAGGER = {
    # front hand, front dagger tip ; back hand, back dagger tip
    "idle": ((31, 32), (32, 39), (17, 30), (15, 23)),
    "walk0": ((31, 32), (32, 39), (17, 31), (15, 24)),
    "walk1": ((31, 31), (32, 38), (17, 30), (15, 23)),
    "walk2": ((31, 32), (32, 39), (17, 29), (15, 22)),
    "walk3": ((31, 31), (32, 38), (17, 30), (15, 23)),
    "windup": ((27, 30), (20, 30), (17, 29), (15, 22)),
    "strike": ((36, 29), (46, 29), (19, 30), (16, 24)),
    "follow": ((34, 31), (42, 36), (19, 30), (17, 24)),
    "recover": ((31, 32), (32, 39), (17, 30), (15, 23)),
}


def speckle(c, pixels, col, seed, density=0.18):
    rnd = random.Random(seed)
    for (x, y) in pixels:
        if rnd.random() < density:
            c.set(x, y, col)


def dagger(c, hx, hy, tx, ty):
    ang = math.atan2(ty - hy, tx - hx)
    ux, uy = math.cos(ang), math.sin(ang)
    c.paint(line_px(hx - ux * 2, hy - uy * 2, hx + ux, hy + uy, 1.6), flat(U["handle"]))
    c.paint(line_px(hx + ux * 1.5, hy + uy * 1.5, tx, ty, 1.9), flat(U["blade"][0]))
    for (x, y) in line_px(hx + ux * 2, hy + uy * 2, tx - ux, ty - uy, 0.7):
        c.set(x, y, U["blade"][2])


def draw_assassin(pose):
    c = Canvas()
    b = pose["bob"]
    act = pose["act"]
    ox = -1 if act == "windup" else (2 if act in ("strike", "follow") else 0)
    sw = pose["sway"]

    # long tail feathers
    for i, (ang, ln) in enumerate(((-2.75, 11), (-2.55, 10), (-2.95, 9))):
        x0, y0 = 18 + ox, 34 + b
        x1 = x0 + math.cos(ang) * ln
        y1 = y0 - math.sin(ang) * ln * -1 + sw * 0.4
        c.paint(line_px(x0, y0, x1, y1, 3.0), flat(U["feather"][1 if i == 0 else 0]))
        c.set(int(x1) + 1, int(y1), U["streak"])

    # far talon leg
    fx, fl = pose["far"]
    c.paint(line_px(fx, 35 + b, fx, 39 + fl, 1.4), flat(U["talon"][1]))
    c.paint(ellipse_px(fx + 0.5, FOOT_Y + fl, 2.6, 1.3), flat(U["talon"][1]))

    # back arm + dagger (raised behind)
    bh, btip = ASSASSIN_DAGGER[act][2], ASSASSIN_DAGGER[act][3]
    dagger(c, bh[0] + ox, bh[1] + b, btip[0] + ox, btip[1] + b)
    c.paint(ellipse_px(bh[0] + ox, bh[1] + b, 1.8, 1.8), flat(U["wrap"]))

    # body
    bcx, bcy = 24 + ox, 30.5 + b
    body = ellipse_px(bcx, bcy, 7.2, 6.4)
    c.paint(body, shade3(*U["feather"], bcx, bcy, 7.2, 6.4))
    speckle(c, body, U["streak"], 11)
    # vest
    c.paint(poly_px([(22 + ox, 25 + b), (31 + ox, 26 + b), (30.5 + ox, 35.5 + b), (22 + ox, 36 + b)]),
            band_shade(*U["vest"], 25 + b, 36 + b))
    for y in (28, 31, 34):
        c.set(26 + ox, y + b, U["wrap"])
        c.set(27 + ox, y + b + 1, U["wrap"])

    # near talon leg
    nx_, nl = pose["near"]
    c.paint(line_px(nx_, 36 + b, nx_, 39 + nl, 1.4), flat(U["talon"][0]))
    c.paint(ellipse_px(nx_ + 0.5, FOOT_Y + nl, 2.6, 1.3), flat(U["talon"][0]))
    c.set(nx_ + 3, int(FOOT_Y + nl), OUT)

    # big round head
    hcx, hcy = 25 + ox, 17 + b
    head = ellipse_px(hcx, hcy, 9.6, 8.8)
    c.paint(head, shade3(*U["feather"], hcx, hcy, 9.6, 8.8))
    speckle(c, head, U["streak"], 7, 0.14)
    speckle(c, head, U["speck"], 3, 0.06)
    # two huge yellow eyes
    for (ex, ey, r) in ((29.5, 16.5, 3.6), (21.0, 16.5, 3.0)):
        c.paint(ellipse_px(ex + ox, ey + b, r, r), flat(U["ring"]))
        c.paint(ellipse_px(ex + ox + 0.3, ey + b, r - 1.0, r - 1.0), flat(U["pupil"]), outline=None)
        c.set(int(ex + ox + 0.3) + 1, int(ey + b) - 1, rgb(255, 255, 255))
    # angry brows
    c.paint(line_px(26.5 + ox, 11.8 + b, 32.5 + ox, 13.2 + b, 1.2), flat(U["streak"]), outline=None)
    c.paint(line_px(18.5 + ox, 13 + b, 23.5 + ox, 12 + b, 1.2), flat(U["streak"]), outline=None)
    # tiny hooked beak
    c.paint(poly_px([(24.5 + ox, 20 + b), (27 + ox, 20 + b), (25.8 + ox, 23.2 + b)]), flat(U["beak"]))

    # front arm + dagger
    fh, ftip = ASSASSIN_DAGGER[act][0], ASSASSIN_DAGGER[act][1]
    fhx, fhy = fh[0] + (0 if act in ("strike", "follow") else ox), fh[1] + (0 if act in ("strike", "follow") else b)
    ftx, fty = ftip[0] + (0 if act in ("strike", "follow") else ox), ftip[1] + (0 if act in ("strike", "follow") else b)
    if act == "strike":
        for x in range(22, 44):
            if (x % 4) != 0:
                c.set(x, 27, rgb(236, 220, 255, 160))
                c.set(x - 2, 31, rgb(236, 220, 255, 110))
    dagger(c, fhx, fhy, ftx, fty)
    c.paint(ellipse_px(fhx, fhy, 1.9, 1.9), flat(U["wrap"]))
    return c


RENDER = dict(knight=draw_knight, mage=draw_mage, archer=draw_archer, assassin=draw_assassin)
ANIMS = dict(idle=IDLE, walk=WALK, attack=ATTACK)
