// Jato curto em forma de gota apontando para fora
var _k = clamp(life / life_max, 0, 1);
var _len = body_radius * 2.2;
var _bx = x - lengthdir_x(_len * 0.5, dir);
var _by = y - lengthdir_y(_len * 0.5, dir);
draw_set_alpha(0.35 + 0.4 * _k);
draw_set_color(c_aqua);
draw_line_width(_bx, _by, x + lengthdir_x(_len * 0.5, dir), y + lengthdir_y(_len * 0.5, dir), max(2, body_radius * 0.8));
draw_circle(x, y, body_radius, false);
draw_set_color(c_white);
draw_circle(x, y, body_radius, true);
draw_set_alpha(1);
