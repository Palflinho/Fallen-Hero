// 1. Círculo de Alcance Melee
if (!vulnerable && state == "barrage") {
    draw_set_alpha(0.12);
    draw_set_color(c_navy);
    draw_circle(x, y, melee_trigger_dist, true);
    draw_set_alpha(1);
}

// 2. Telegrafia de Sakurai do Slam (Círculo de impacto vermelho pulsante)
if (state == "slam_windup") {
    draw_set_alpha(0.20 + 0.15 * sin(current_time / 40));
    draw_set_color(c_red);
    draw_circle(x, y, slam_hit_radius, false);
    draw_set_alpha(0.8);
    draw_circle(x, y, slam_hit_radius, true);
    draw_set_alpha(1);
}

// 3. Renderização Visual Imponente do General da Água
chibi_draw_boss_water(id, x, y, state, scale_x, scale_y, vulnerable);

if (hit_flash_timer > 0) {
    draw_set_colour(c_white);
    draw_set_alpha(0.5);
    draw_circle(x, y - 10, body_radius * scale_x * 0.9, false);
    draw_set_alpha(1);
}

// 4. Telegrafia de "!" de Sakurai
if (state == "slam_windup") {
    var _ty = y - body_radius * scale_y - 28 + sin(current_time * 0.02) * 2;
    draw_set_alpha(0.9);
    draw_set_color(c_red);
    draw_circle(x, _ty, 10, false);
    draw_set_color(c_white);
    draw_circle(x, _ty, 10, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x, _ty, "!");
    draw_set_alpha(1);
}

// 5. Títulos e Estado de Vulnerabilidade
var _label = "General da Água";
if (vulnerable) {
    _label = "VULNERÁVEL! ATAQUE AGORA!";
    draw_set_alpha(0.35 + 0.15 * sin(current_time * 0.01));
    draw_set_color(c_yellow);
    draw_circle(x, y, body_radius + 20 + 4 * sin(current_time * 0.008), true);
    draw_set_alpha(1);
} else if (state == "recover") {
    _label = "Recuperando...";
}

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// Aura da Mutação Adaptativa
if (variable_instance_exists(id, "adaptation") && is_struct(adaptation) && adaptation.active) {
    draw_set_alpha(0.20 + 0.10 * sin(current_time * 0.005));
    draw_set_color(adaptation.aura_colour);
    draw_circle(x, y, body_radius + 8, false);
    draw_circle(x, y, body_radius + 12 + 2 * sin(current_time * 0.008), true);
    draw_set_alpha(1);
    
    draw_text(x, y - body_radius - 42, "* " + adaptation.title + " *");
}

draw_set_color(vulnerable ? c_yellow : c_white);
draw_text(x, y - body_radius - 24, _label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
