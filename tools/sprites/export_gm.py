import os, re, shutil, uuid, sys
from chars import RENDER, ANIMS

REPO = sys.argv[1]
ORIGIN_X, ORIGIN_Y = 24, 31
FPS = dict(idle=5.0, walk=10.0, attack=14.0)


def keyframe(i, name, frame_id):
    return ('            {"$Keyframe<SpriteFrameKeyframe>":"","Channels":{\n'
            '                "0":{"$SpriteFrameKeyframe":"","Id":{"name":"%s","path":"sprites/%s/%s.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},\n'
            '              },"Disabled":false,"id":"%s","IsCreationKey":false,"Key":%d.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},\n'
            % (frame_id, name, name, uuid.uuid4(), i))


def yy(name, frame_ids, layer_id, bbox, fps):
    l, t, r, b = bbox
    frames = "".join('    {"$GMSpriteFrame":"v1","%%Name":"%s","name":"%s","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},\n' % (f, f) for f in frame_ids)
    kfs = "".join(keyframe(i, name, f) for i, f in enumerate(frame_ids))
    return f'''{{
  "$GMSprite":"v2",
  "%Name":"{name}",
  "bboxMode":0,
  "bbox_bottom":{b},
  "bbox_left":{l},
  "bbox_right":{r},
  "bbox_top":{t},
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
{frames}  ],
  "gridX":0,
  "gridY":0,
  "height":48,
  "HTile":false,
  "layers":[
    {{"$GMImageLayer":"","%Name":"{layer_id}","blendMode":0,"displayName":"default","isLocked":false,"name":"{layer_id}","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,}},
  ],
  "name":"{name}",
  "nineSlice":null,
  "origin":9,
  "parent":{{
    "name":"Sprites",
    "path":"folders/Sprites.yy",
  }},
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{{
    "$GMSequence":"v1",
    "%Name":"{name}",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{{
      "$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    }},
    "eventStubScript":null,
    "eventToFunction":{{}},
    "length":{len(frame_ids)}.0,
    "lockOrigin":false,
    "moments":{{
      "$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    }},
    "name":"{name}",
    "playback":1,
    "playbackSpeed":{fps},
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {{"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
{kfs}          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",}},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,}},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":{ORIGIN_X},
    "yorigin":{ORIGIN_Y},
  }},
  "swatchColours":null,
  "swfPrecision":2.525,
  "textureGroupId":{{
    "name":"Default",
    "path":"texturegroups/Default",
  }},
  "type":0,
  "VTile":false,
  "width":48,
}}
'''


names = []
for cls, render in RENDER.items():
    for anim, poses in ANIMS.items():
        name = f"spr_hero_{cls}_{anim}"
        names.append(name)
        d = os.path.join(REPO, "sprites", name)
        shutil.rmtree(d, ignore_errors=True)
        os.makedirs(d)
        layer_id = str(uuid.uuid4())
        frame_ids, boxes = [], []
        for p in poses:
            im = render(p).image()
            fid = str(uuid.uuid4())
            frame_ids.append(fid)
            im.save(os.path.join(d, fid + ".png"))
            os.makedirs(os.path.join(d, "layers", fid))
            im.save(os.path.join(d, "layers", fid, layer_id + ".png"))
            boxes.append(im.getbbox())
        l = min(bx[0] for bx in boxes); t = min(bx[1] for bx in boxes)
        r = max(bx[2] for bx in boxes) - 1; b = max(bx[3] for bx in boxes) - 1
        with open(os.path.join(d, name + ".yy"), "w", newline="\n") as f:
            f.write(yy(name, frame_ids, layer_id, (l, t, r, b), FPS[anim]))

# register in the project
yyp_path = os.path.join(REPO, "Fallen Hero.yyp")
yyp = open(yyp_path, encoding="utf-8").read()
anchor = '    {"id":{"name":"spr_portrait_knight","path":"sprites/spr_portrait_knight/spr_portrait_knight.yy",},},\n'
assert anchor in yyp, "anchor not found"
add = "".join('    {"id":{"name":"%s","path":"sprites/%s/%s.yy",},},\n' % (n, n, n) for n in names if '"%s"' % n not in yyp)
yyp = yyp.replace(anchor, anchor + add)
open(yyp_path, "w", encoding="utf-8", newline="\n").write(yyp)
print("exported", len(names), "sprites; newly registered:", add.count("\n"))
