var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

if (active) {
    draw_set_alpha(0.55 + 0.15 * sin(current_time / 100));
    draw_set_color(c_orange);
    draw_rectangle(x, y, x + _w, y + _h, false);
    draw_set_alpha(0.8);
    draw_set_color(c_red);
    draw_rectangle(x, y, x + _w, y + _h, true);
} else {
    draw_set_alpha(0.2);
    draw_set_color(c_gray);
    draw_rectangle(x, y, x + _w, y + _h, false);
}
draw_set_alpha(1);
draw_set_color(c_white);
