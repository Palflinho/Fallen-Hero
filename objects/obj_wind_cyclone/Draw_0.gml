// Lâminas Cortantes de Vento Rotativas (Bouncing Blades)
draw_set_alpha(0.3 + 0.1 * sin(current_time / 80));
draw_set_color(make_colour_rgb(180, 240, 255));
draw_circle(x, y, radius, false);

// Quatro Lâminas Afiadas de Aço Prateado / Ciano Galvânico
for (var _a = 0; _a < 4; _a++) {
    var _ang = rot_angle + _a * 90;
    var _tip_x = x + lengthdir_x(radius + 4, _ang);
    var _tip_y = y + lengthdir_y(radius + 4, _ang);
    var _b1_x = x + lengthdir_x(radius * 0.4, _ang - 25);
    var _b1_y = y + lengthdir_y(radius * 0.4, _ang - 25);
    var _b2_x = x + lengthdir_x(radius * 0.4, _ang + 25);
    var _b2_y = y + lengthdir_y(radius * 0.4, _ang + 25);

    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(220, 245, 255));
    draw_triangle(_tip_x, _tip_y, _b1_x, _b1_y, _b2_x, _b2_y, false);

    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_line(_tip_x, _tip_y, x, y);
}

// Núcleo do Ciclone
draw_set_alpha(0.9);
draw_set_color(c_white);
draw_circle(x, y, 6, false);
draw_set_color(make_colour_rgb(100, 220, 255));
draw_circle(x, y, 7, true);

draw_set_alpha(1);
draw_set_color(c_white);
