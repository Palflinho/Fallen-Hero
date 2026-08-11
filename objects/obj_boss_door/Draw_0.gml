var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

draw_set_color(c_maroon);
draw_rectangle(x, y, x + _w, y + _h, false);
draw_set_color(c_red);
draw_rectangle(x, y, x + _w, y + _h, true);
draw_set_color(c_white);
