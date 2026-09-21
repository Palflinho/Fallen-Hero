var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

if (point_distance(x, y, _player.x, _player.y) <= 52 && !is_world_paused()) {
    var _cam = view_camera[0];
    var _cx = camera_get_view_x(_cam);
    var _cy = camera_get_view_y(_cam);
    var _sx = (x - _cx);
    var _sy = (y - _cy - 36);

    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    var _txt = "[Espaço / A] Conversar";
    var _lang = loc_get_language();
    switch (_lang) {
        case "en": _txt = "[Space / A] Talk"; break;
        case "es": _txt = "[Espacio / A] Hablar"; break;
        case "ja": _txt = "[Space / A] 話す"; break;
    }

    var _box_w = string_width(_txt) + 18;
    var _box_h = 24;
    var _bx = _sx - _box_w * 0.5;
    var _by = _sy - _box_h;

    draw_set_alpha(0.85);
    draw_set_colour(make_colour_rgb(15, 20, 30));
    draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);
    draw_set_colour(make_colour_rgb(255, 215, 80));
    draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);

    draw_set_alpha(1.0);
    draw_set_colour(make_colour_rgb(255, 215, 80));
    draw_text(_sx, _by + 17, _txt);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
}
