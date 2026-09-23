var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

if (point_distance(x, y, _player.x, _player.y) <= 75) {
    var _cam = view_camera[0];
    var _cx = camera_get_view_x(_cam);
    var _cy = camera_get_view_y(_cam);
    var _sx = (x - _cx);
    var _sy = (y - _cy - 72);

    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    var _final_unlocked = all_elements_reclaimed();
    var _prompt = _final_unlocked ? loc_prompt("portal_temple5_prompt") : loc_prompt("portal_prompt");
    var _col = _final_unlocked ? make_colour_rgb(255, 220, 80) : make_colour_rgb(120, 220, 255);

    var _box_w = string_width(_prompt) + 24;
    var _box_h = 28;
    var _bx = _sx - _box_w * 0.5;
    var _by = _sy - _box_h;

    draw_set_alpha(0.88);
    draw_set_colour(make_colour_rgb(12, 16, 26));
    draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);
    draw_set_colour(_col);
    draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);

    draw_set_alpha(1.0);
    draw_set_colour(_col);
    draw_text(_sx, _by + 20, _prompt);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
}
