// Aura de vento em volta do chefe
if (state == "vulnerable") {
    var _pulse = 0.5 + 0.5 * sin(current_time * 0.015);
    draw_set_alpha(0.3 + 0.2 * _pulse);
    draw_set_color(c_lime);
    draw_circle(x, y, (body_radius + 18) * scale_x, false);
    draw_set_alpha(0.8);
    draw_circle(x, y, (body_radius + 18) * scale_x, true);
} else {
    draw_set_alpha(0.25 + 0.1 * sin(current_time / 60));
    draw_set_color(make_colour_rgb(180, 240, 255));
    draw_circle(x, y, body_radius + 14, false);
}

// Asas giratorias de vento
draw_set_alpha(state == "vulnerable" ? 0.35 : 0.65);
draw_set_color(state == "vulnerable" ? c_lime : c_white);
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

draw_set_color(state == "vulnerable" ? c_green : make_colour_rgb(60, 140, 200));
draw_circle(x, y, body_radius * scale_x, true);
draw_circle(x, y, body_radius * scale_x - 3, true);

// Olhos incandescentes
if (state == "vulnerable") {
    // Olhos tontos em espiral / X
    draw_set_color(c_yellow);
    draw_line_width(x - 14, y - 12, x - 6, y - 4, 2);
    draw_line_width(x - 14, y - 4, x - 6, y - 12, 2);
    draw_line_width(x + 6, y - 12, x + 14, y - 4, 2);
    draw_line_width(x + 6, y - 4, x + 14, y - 12, 2);
    
    // Estrelas de tontura orbitando a cabeça
    for (var _s = 0; _s < 3; _s++) {
        var _sang = current_time * 0.005 + _s * (2 * pi / 3);
        var _sx = x + cos(_sang) * 26;
        var _sy = y - body_radius - 12 + sin(_sang) * 8;
        draw_set_color(c_yellow);
        draw_circle(_sx, _sy, 3.5, false);
    }
} else {
    draw_set_color(c_yellow);
    draw_circle(x - 10, y - 8, 4, false);
    draw_circle(x + 10, y - 8, 4, false);
}

draw_set_color(c_white);
