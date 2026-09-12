// Nuvem química densa com pulsação
var _pulse = 0.28 + 0.10 * sin(current_time / 80);
draw_set_alpha(_pulse);
draw_set_color(make_colour_rgb(60, 180, 50));
draw_circle(x, y, radius, false);

// Espirais internas de gás tóxico
draw_set_alpha(0.35);
draw_set_color(make_colour_rgb(140, 220, 40));
var _rot = current_time / 60;
for (var _a = 0; _a < 4; _a++) {
    var _ang = _rot + _a * 90;
    var _gx = x + lengthdir_x(radius * 0.45, _ang);
    var _gy = y + lengthdir_y(radius * 0.45, _ang);
    draw_circle(_gx, _gy, radius * 0.35, false);
}

// Borda difusa
draw_set_alpha(0.65);
draw_set_color(make_colour_rgb(170, 240, 60));
draw_circle(x, y, radius, true);

draw_set_alpha(1);
draw_set_color(c_white);
