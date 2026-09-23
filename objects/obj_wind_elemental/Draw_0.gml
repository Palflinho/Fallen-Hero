// Rastro do teleporte: linha tracejada de onde saiu ate onde apareceu
if (blink_fx_timer > 0) {
    draw_set_alpha(blink_fx_timer / 0.3);
    draw_set_color(c_white);
    var _len = point_distance(blink_from_x, blink_from_y, x, y);
    var _d = point_direction(blink_from_x, blink_from_y, x, y);
    for (var _s = 0; _s < _len; _s += 16) {
        draw_line(blink_from_x + lengthdir_x(_s, _d), blink_from_y + lengthdir_y(_s, _d), blink_from_x + lengthdir_x(_s + 8, _d), blink_from_y + lengthdir_y(_s + 8, _d));
    }
    draw_set_alpha(1);
}
// Pas de vento girando ao redor do corpo
draw_set_alpha(0.5);
draw_set_color(c_white);
for (var _k = 0; _k < 3; _k++) {
    var _ra = anim_rot + _k * 120;
    draw_line_width(x + lengthdir_x(body_radius + 2, _ra), y + lengthdir_y(body_radius + 2, _ra), x + lengthdir_x(body_radius + 9, _ra + 30), y + lengthdir_y(body_radius + 9, _ra + 30), 2);
}
draw_set_alpha(1);
event_inherited();
