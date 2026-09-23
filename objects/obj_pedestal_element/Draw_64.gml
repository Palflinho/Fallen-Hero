var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

if (point_distance(x, y, _player.x, _player.y) <= 55) {
    var _cam = view_camera[0];
    var _cx = camera_get_view_x(_cam);
    var _cy = camera_get_view_y(_cam);
    var _sx = (x - _cx);
    var _sy = (y - _cy - 48);

    draw_set_font(ui_font());
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    var _ped_name = loc("pedestal_" + element_id);
    var _is_rec = element_is_reclaimed(element_id);
    var _stat = _is_rec ? loc("essence_reclaimed") : loc("essence_missing");
    var _stat_col = _is_rec ? make_colour_rgb(100, 235, 120) : make_colour_rgb(220, 90, 90);

    var _box_w = max(string_width(_ped_name), string_width(_stat)) + 24;
    var _box_h = 36;
    var _bx = _sx - _box_w * 0.5;
    var _by = _sy - _box_h;

    draw_set_alpha(0.85);
    draw_set_colour(make_colour_rgb(15, 20, 30));
    draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);
    draw_set_colour(c_gray);
    draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);

    draw_set_alpha(1.0);
    draw_set_colour(c_white);
    draw_text(_sx, _by + 16, _ped_name);
    draw_set_colour(_stat_col);
    draw_text(_sx, _by + 32, _stat);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
