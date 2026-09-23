// Aviso do leque: 3 setas curtas mostrando as direcoes dos tiros
if (state == "windup") {
    draw_set_alpha(0.55);
    draw_set_color(c_orange);
    for (var _f = -1; _f <= 1; _f++) {
        var _a = facing_dir + _f * fan_spread;
        draw_line_width(x, y, x + lengthdir_x(70, _a), y + lengthdir_y(70, _a), 2);
    }
    draw_set_alpha(1);
}
event_inherited();
