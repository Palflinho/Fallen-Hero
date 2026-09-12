// Sombra sísmica
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(x - body_radius * 1.2, y + body_radius * 0.7, x + body_radius * 1.2, y + body_radius * 1.1, false);

// Corpo de granito bruto
draw_set_alpha(1);
draw_set_color(hit_flash_timer > 0 ? c_white : body_colour);
draw_circle(x, y, body_radius * scale_x, false);

// Fissuras incandescentes na rocha
var _pulse = 0.5 + 0.5 * sin(current_time / 80);
draw_set_color(merge_colour(make_colour_rgb(180, 100, 30), c_yellow, _pulse));
draw_line_width(x - 20, y - 10, x, y + 15, 3);
draw_line_width(x, y + 15, x + 25, y - 5, 3);

// Borda de pedra pesada
draw_set_color(make_colour_rgb(70, 50, 30));
draw_circle(x, y, body_radius * scale_x, true);
draw_circle(x, y, body_radius * scale_x - 3, true);

// Olhos rúnicos de terra
draw_set_color(make_colour_rgb(255, 200, 50));
draw_circle(x - 14, y - 14, 5, false);
draw_circle(x + 14, y - 14, 5, false);

draw_set_color(c_white);
