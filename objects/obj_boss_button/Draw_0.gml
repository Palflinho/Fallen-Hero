// Selo antigo: circulo runico que pulsa enquanto espera ser ativado
var _t = current_time * 0.004;
if (!pressed) {
    var _pulse = 0.5 + 0.5 * sin(_t * 2);
    draw_set_alpha(0.18 + 0.2 * _pulse);
    draw_set_color(c_aqua);
    draw_circle(x, y, radius + 8 + 4 * _pulse, false);
    draw_set_alpha(1);
}

draw_set_color(make_colour_rgb(20, 26, 38));
draw_circle(x, y, radius, false);
draw_set_color(pressed ? make_colour_rgb(120, 255, 150) : make_colour_rgb(110, 220, 255));
draw_circle(x, y, radius, true);
draw_circle(x, y, radius - 5, true);

// Runas girando
for (var _i = 0; _i < 4; _i++) {
    var _a = _t * 40 + _i * 90;
    draw_circle(x + lengthdir_x(radius - 10, _a), y + lengthdir_y(radius - 10, _a), 2, false);
}

if (pressed) {
    // Coluna de luz do selo ativado
    draw_set_alpha(0.35);
    draw_set_color(make_colour_rgb(120, 255, 150));
    draw_rectangle(x - 4, y - 46, x + 4, y, false);
    draw_set_alpha(1);
    draw_circle(x, y, 6, false);
} else {
    draw_set_color(c_white);
    draw_circle(x, y, 4 + sin(_t * 3), false);
}
draw_set_color(c_white);
