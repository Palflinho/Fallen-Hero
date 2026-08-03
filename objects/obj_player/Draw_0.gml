var _col = body_colour;
if (hit_flash_timer > 0) {
    _col = merge_colour(c_white, c_red, 0.5);
} else if (state == "defend" && defend_active && defend_mode == "block") {
    _col = c_yellow;
} else if (state == "defend" && defend_active && defend_mode == "manashield") {
    _col = c_blue;
}

var _alpha = invisible ? 0.35 : 1;

draw_set_alpha(_alpha);
draw_set_color(_col);
draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, false);
draw_set_color(c_black);
draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, true);
draw_set_alpha(1);

draw_line_width(x, y, x + facing_x * body_radius * 1.6, y + facing_y * body_radius * 1.6, 3);

if (state == "attack") {
    draw_set_color(c_white);
    draw_circle(x + facing_x * 10, y + facing_y * 10, 5, true);
}

if (state == "dead") {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, y - body_radius - 24, "Game Over - press R");
    draw_set_halign(fa_left);
}

draw_set_color(c_white);
