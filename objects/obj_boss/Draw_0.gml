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
    _label = "VULNERAVEL! ATAQUE AGORA!";
    // Miyamoto Polish: Golden opportunity aura
    draw_set_alpha(0.35 + 0.15 * sin(current_time * 0.01));
    draw_set_color(c_yellow);
    draw_circle(x, y, body_radius + 16 + 4 * sin(current_time * 0.008), true);
    draw_set_alpha(1);
} else if (state == "recover") {
    _label = "Recuperando...";
}

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

if (variable_instance_exists(id, "adaptation") && is_struct(adaptation) && adaptation.active) {
    draw_set_alpha(0.20 + 0.10 * sin(current_time * 0.005));
    draw_set_color(adaptation.aura_colour);
    draw_circle(x, y, body_radius + 8, false);
    draw_circle(x, y, body_radius + 12 + 2 * sin(current_time * 0.008), true);
    draw_set_alpha(1);
    
    draw_text(x, y - body_radius - 42, "✦ " + adaptation.title + " ✦");
}

draw_set_color(vulnerable ? c_yellow : c_white);
draw_text(x, y - body_radius - 24, _label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
