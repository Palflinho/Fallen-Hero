// Aura de vento em volta do chefe
draw_set_alpha(0.25 + 0.1 * sin(current_time / 60));
draw_set_color(make_colour_rgb(180, 240, 255));
draw_circle(x, y, body_radius + 14, false);

// Asas giratorias de vento
draw_set_alpha(0.65);
draw_set_color(c_white);
for (var _a = 0; _a < 4; _a++) {
    var _ang = rot_angle + _a * 90;
    var _wx = x + lengthdir_x(body_radius + 8, _ang);
    var _wy = y + lengthdir_y(body_radius + 8, _ang);
    draw_line_width(x, y, _wx, _wy, 4);
    draw_circle(_wx, _wy, 6, false);
}

// Corpo principal
draw_set_alpha(1);
draw_set_color(hit_flash_timer > 0 ? c_white : body_colour);
draw_circle(x, y, body_radius * scale_x, false);

draw_set_color(make_colour_rgb(60, 140, 200));
draw_circle(x, y, body_radius * scale_x, true);
draw_circle(x, y, body_radius * scale_x - 3, true);

// Olhos incandescentes
draw_set_color(c_yellow);
draw_circle(x - 10, y - 8, 4, false);
draw_circle(x + 10, y - 8, 4, false);

draw_set_color(c_white);
