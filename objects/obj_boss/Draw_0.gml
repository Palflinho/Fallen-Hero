event_inherited();

if (!vulnerable && state == "barrage") {
    draw_set_alpha(0.15);
    draw_set_color(c_red);
    draw_circle(x, y, melee_trigger_dist, true);
    draw_set_alpha(1);
}

if (state == "slam_windup") {
    draw_set_alpha(0.25 + 0.25 * sin(current_time / 40));
    draw_set_color(c_red);
    draw_circle(x, y, slam_hit_radius, true);
    draw_set_alpha(1);
}

var _label = "Guardiao das Aguas";
if (vulnerable) {
    _label = "VULNERAVEL!";
} else if (state == "recover") {
    _label = "Recuperando...";
}

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(vulnerable ? c_lime : c_white);
draw_text(x, y - body_radius - 24, _label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
