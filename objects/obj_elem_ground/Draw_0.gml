var _fade = clamp(life / max(0.01, life_max), 0, 1);
var _in = clamp((life_max - life) / 0.15, 0, 1); // surge rapido
var _a = min(_fade * 1.6, 1) * _in;

if (kind == "fire") {
    var _flick = 0.85 + 0.15 * sin((current_time + anim_seed) * 0.02);
    draw_set_alpha(0.35 * _a);
    draw_set_color(make_colour_rgb(200, 60, 20));
    draw_circle(x, y, radius * _flick, false);
    draw_set_alpha(0.55 * _a);
    draw_set_color(colour);
    draw_circle(x, y, radius * 0.6 * _flick, false);
    draw_set_alpha(0.8 * _a);
    draw_circle(x, y, radius, true);
} else if (kind == "slick") {
    draw_set_alpha(0.35 * _a);
    draw_set_color(colour);
    draw_circle(x, y, radius, false);
    draw_set_alpha(0.7 * _a);
    draw_set_color(c_white);
    draw_circle(x, y, radius, true);
    // brilho de gelo
    var _sa = (current_time * 0.1 + anim_seed) mod 360;
    draw_line(x + lengthdir_x(radius * 0.5, _sa), y + lengthdir_y(radius * 0.5, _sa), x + lengthdir_x(radius * 0.5, _sa + 180), y + lengthdir_y(radius * 0.5, _sa + 180));
} else {
    draw_set_alpha(0.25 * _a);
    draw_set_color(colour);
    draw_circle(x, y, radius, false);
}
draw_set_alpha(1);
draw_set_color(c_white);
