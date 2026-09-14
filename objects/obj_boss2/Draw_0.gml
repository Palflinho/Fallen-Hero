event_inherited();

// 1. Telegrafia de Erupção de Magma nos 3 alvos
if (state == "erupcao_windup") {
    var _t = clamp(1.0 - (erupcao_timer / erupcao_telegraph), 0, 1);
    for (var _i = 0; _i < 3; _i++) {
        var _tx = erupcao_targets_x[_i];
        var _ty = erupcao_targets_y[_i];
        draw_set_alpha(0.20 + 0.15 * sin(current_time * 0.03));
        draw_set_color(c_red);
        draw_circle(_tx, _ty, erupcao_radius * _t, false);
        draw_set_alpha(0.85);
        draw_circle(_tx, _ty, erupcao_radius, true);
        draw_set_color(c_yellow);
        draw_circle(_tx, _ty, erupcao_radius * 0.4, true);
    }
    draw_set_alpha(1);
}

// 2. Telegrafia de Carga Vulcânica
if (state == "charge_windup") {
    draw_set_alpha(0.25 + 0.20 * sin(current_time * 0.04));
    draw_set_color(c_orange);
    draw_circle(x, y, body_radius + 20, true);
    draw_set_alpha(1);
}

var _label = "General Magma";
if (vulnerable) {
    _label = "SUPERAQUECIDO! VULNERAVEL!";
    // Miyamoto Polish: Golden opportunity aura
    draw_set_alpha(0.35 + 0.20 * sin(current_time * 0.015));
    draw_set_color(c_yellow);
    draw_circle(x, y, (body_radius + 18 + 4 * sin(current_time * 0.01)) * scale_x, true);
    draw_set_color(c_orange);
    draw_circle(x, y, (body_radius + 22) * scale_x, true);
    draw_set_alpha(1);
} else if (state == "recover") {
    _label = "Recuperando...";
}

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(vulnerable ? c_yellow : c_white);
draw_text(x, y - body_radius - 24, _label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
