var _is_pts = (variable_instance_exists(id, "is_points") && is_points);

draw_set_alpha(0.6 + 0.15 * sin(current_time / 150));
draw_set_color(_is_pts ? make_colour_rgb(255, 220, 50) : c_yellow);
draw_rectangle(x - radius, y - radius, x + radius, y + radius, false);
draw_set_alpha(1);

draw_set_color(_is_pts ? c_yellow : c_orange);
draw_rectangle(x - radius, y - radius, x + radius, y + radius, true);
draw_rectangle(x - radius, y - 4, x + radius, y + 4, true);

if (_is_pts) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(x, y - 1, "*");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_color(c_white);
