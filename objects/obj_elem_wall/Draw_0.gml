var _w = base_size * image_xscale;
var _h = base_size * image_yscale;
var _top = y + _h * (1 - rise);
var _crumble = (life < 0.8) ? (0.5 + 0.5 * sin(current_time * 0.05)) : 1;

draw_set_alpha(_crumble);
draw_set_color(make_colour_rgb(120, 88, 55));
draw_rectangle(x, _top, x + _w, y + _h, false);
draw_set_color(make_colour_rgb(160, 120, 75));
draw_rectangle(x + 3, _top + 3, x + _w - 3, _top + 8, false);
draw_set_color(c_black);
draw_rectangle(x, _top, x + _w, y + _h, true);
// rachaduras quando esta prestes a ruir
if (life < 1.5) {
    draw_line(x + _w * 0.3, _top, x + _w * 0.5, y + _h * 0.6);
    draw_line(x + _w * 0.5, y + _h * 0.6, x + _w * 0.75, y + _h);
}
draw_set_alpha(1);
draw_set_color(c_white);
