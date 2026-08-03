var _col = body_colour;
if (poison_active) _col = merge_colour(body_colour, c_lime, 0.4);
if (hit_flash_timer > 0) _col = c_white;

draw_set_color(_col);
draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, false);
draw_set_color(c_black);
draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, true);

var _w = body_radius * 2;
var _hx = x - body_radius;
var _hy = y - body_radius - 10;
draw_set_color(c_black);
draw_rectangle(_hx - 1, _hy - 1, _hx + _w + 1, _hy + 5, false);
draw_set_color(c_red);
draw_rectangle(_hx, _hy, _hx + _w * (hp / hp_max), _hy + 4, false);
draw_set_color(c_white);
