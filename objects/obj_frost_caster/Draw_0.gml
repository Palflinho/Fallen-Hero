event_inherited();

if (state == "cast") {
    var _t = clamp(1 - (cast_timer / telegraph_time), 0, 1);
    draw_set_alpha(0.35);
    draw_set_color(c_purple);
    draw_circle(cast_target_x, cast_target_y, aoe_radius * _t, false);
    draw_set_alpha(0.6);
    draw_circle(cast_target_x, cast_target_y, aoe_radius, true);
    draw_set_alpha(1);
}
