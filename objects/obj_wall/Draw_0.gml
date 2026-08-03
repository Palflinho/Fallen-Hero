var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

draw_set_color(c_gray);
draw_rectangle(x, y, x + _w, y + _h, false);
draw_set_color(c_black);
draw_rectangle(x, y, x + _w, y + _h, true);
draw_set_color(c_white);
