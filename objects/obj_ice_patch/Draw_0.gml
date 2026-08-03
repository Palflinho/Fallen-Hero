if (!active) exit;

var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

draw_set_alpha(0.35);
draw_set_color(c_aqua);
draw_rectangle(x, y, x + _w, y + _h, false);
draw_set_alpha(0.7);
draw_set_color(c_white);
draw_rectangle(x, y, x + _w, y + _h, true);
draw_set_alpha(1);
