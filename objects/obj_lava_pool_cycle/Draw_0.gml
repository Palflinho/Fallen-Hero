var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

if (is_up) {
    draw_set_alpha(0.6 + 0.15 * sin(current_time / 80));
    draw_set_color(c_orange);
    draw_rectangle(x, y, x + _w, y + _h, false);
    draw_set_alpha(0.85);
    draw_set_color(c_red);
    draw_rectangle(x, y, x + _w, y + _h, true);
} else {
    draw_set_alpha(0.25 + 0.1 * sin(current_time / 60));
    draw_set_color(c_maroon);
    draw_rectangle(x, y, x + _w, y + _h, false);
}
draw_set_alpha(1);
draw_set_color(c_white);
