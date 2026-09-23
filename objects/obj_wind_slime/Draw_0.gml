// Marca do pouso (circulo = area)
if (state == "hop_windup" || state == "hop") {
    var _t = (state == "hop") ? clamp(hop_timer / hop_time, 0, 1) : 0;
    elem_draw_warning_circle(hop_target_x, hop_target_y, land_radius, _t, c_white);
    draw_set_alpha(0.25);
    draw_set_color(c_white);
    draw_circle(hop_target_x, hop_target_y, push_radius, true);
    draw_set_alpha(1);
}
event_inherited();
