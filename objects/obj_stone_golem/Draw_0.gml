// Onda de choque (circulo que se expande)
if (ring_active) {
    draw_set_alpha(0.7 * (1 - ring_r / ring_max) + 0.2);
    draw_set_color(make_colour_rgb(200, 150, 90));
    draw_circle(x, y, ring_r, true);
    draw_circle(x, y, ring_r - 3, true);
    draw_circle(x, y, ring_r + 3, true);
    draw_set_alpha(1);
}
if (state == "slam_windup") {
    elem_draw_warning_circle(x, y, body_radius + 26, 1 - windup_timer / 0.9, make_colour_rgb(200, 150, 90));
}
event_inherited();
// Placas de armadura restantes ao redor do corpo
if (armor_hp > 0) {
    draw_set_color(make_colour_rgb(90, 75, 60));
    for (var _a = 0; _a < armor_hp; _a++) {
        var _aa = 90 + (_a - (armor_max - 1) * 0.5) * 22;
        var _ax = x + lengthdir_x(body_radius + 6, _aa);
        var _ay = y + lengthdir_y(body_radius + 6, _aa);
        draw_rectangle(_ax - 4, _ay - 4, _ax + 4, _ay + 4, false);
    }
    draw_set_color(c_white);
}
if (state == "broken") {
    var _sy = y - body_radius - 24;
    draw_set_color(c_yellow);
    for (var _s = 0; _s < 3; _s++) {
        var _sa = current_time * 0.01 + _s * 2.09;
        draw_circle(x + cos(_sa) * 18, _sy + sin(_sa) * 5, 3, false);
    }
}
