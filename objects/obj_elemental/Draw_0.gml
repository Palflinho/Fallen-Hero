// Carga da bolha (bolha crescendo na frente do corpo)
if (state == "windup") {
    var _t = 1 - clamp(attack_windup_timer / max(0.01, attack_windup), 0, 1);
    draw_set_alpha(0.6);
    draw_set_color(c_aqua);
    draw_circle(x + lengthdir_x(body_radius + 6, facing_dir), y + lengthdir_y(body_radius + 6, facing_dir), 3 + 8 * _t, true);
    draw_set_alpha(1);
}
event_inherited();
