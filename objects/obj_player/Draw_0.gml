var _blend = c_white;
if (hit_flash_timer > 0) {
    _blend = merge_colour(c_white, c_red, 0.5);
} else if (parry_flash_timer > 0) {
    _blend = c_yellow;
} else if (poison_active) {
    _blend = c_lime;
} else if (state == "defend" && defend_active) {
    if (defend_mode == "block") _blend = c_yellow;
    else if (defend_mode == "manashield") _blend = c_blue;
    else if (defend_mode == "paladin_aura") _blend = c_aqua;
    else if (defend_mode == "berserk_fury") _blend = c_orange;
    else if (defend_mode == "parry") _blend = c_yellow;
    else if (defend_mode == "guardian_aegis") _blend = make_colour_rgb(205, 133, 63);
}

// Visual Aura effects (drawn behind or around player)
if (state == "defend" && defend_active) {
    if (defend_mode == "paladin_aura") {
        draw_set_alpha(0.20 + 0.08 * sin(current_time * 0.008));
        draw_set_color(c_aqua);
        draw_circle(x, y, paladin_aura_radius, false);
        draw_set_alpha(0.6);
        draw_circle(x, y, paladin_aura_radius, true);
        if (paladin_barrier_active > 0) {
            draw_set_color(c_white);
            draw_circle(x, y, body_radius + 6, true);
        }
        draw_set_alpha(1);
    } else if (defend_mode == "berserk_fury") {
        draw_set_alpha(0.25 + 0.12 * sin(current_time * 0.015));
        draw_set_color(c_red);
        draw_circle(x, y, body_radius + 10, false);
        draw_set_color(c_orange);
        draw_circle(x, y, body_radius + 6, true);
        draw_set_alpha(1);
    } else if (defend_mode == "guardian_aegis") {
        draw_set_alpha(0.35);
        draw_set_color(make_colour_rgb(139, 69, 19));
        draw_circle(x, y, body_radius + 8, false);
        draw_set_color(c_yellow);
        draw_circle(x, y, body_radius + 8, true);
        draw_set_alpha(1);
    } else if (defend_mode == "parry") {
        draw_set_alpha(0.4);
        draw_set_color(c_white);
        draw_circle(x, y, body_radius + 4, true);
        draw_set_alpha(1);
    }
}

var _alpha = invisible ? 0.35 : 1;

if (sprite_walk != -1) {
    var _xscale = (facing_x < 0) ? -1 : 1;
    draw_sprite_ext(sprite_index, image_index, x, y, _xscale, 1, 0, _blend, _alpha);
} else {
    var _col = (_blend == c_white) ? body_colour : _blend;
    draw_set_alpha(_alpha);
    draw_set_color(_col);
    draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, false);
    draw_set_color(c_black);
    draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, true);
    draw_set_alpha(1);

    draw_line_width(x, y, x + facing_x * body_radius * 1.6, y + facing_y * body_radius * 1.6, 3);

    if (state == "attack") {
        draw_set_color(c_white);
        draw_circle(x + facing_x * 10, y + facing_y * 10, 5, true);
    }
}

// Draw shield in front if blocking
if (state == "defend" && defend_active && (defend_mode == "block" || defend_mode == "guardian_aegis")) {
    var _is_titan = (variable_instance_exists(id, "synth_lendario_escudo_titanico") && synth_lendario_escudo_titanico > 0);
    var _shield_r = _is_titan ? 16 : 8;
    draw_set_color((defend_mode == "guardian_aegis") ? c_orange : (_is_titan ? c_aqua : c_yellow));
    draw_set_alpha(0.75);
    var _sx = x + facing_x * (body_radius + (_is_titan ? 10 : 6));
    var _sy = y + facing_y * (body_radius + (_is_titan ? 10 : 6));
    draw_circle(_sx, _sy, _shield_r, false);
    draw_set_color(c_white);
    draw_circle(_sx, _sy, _shield_r, true);
    draw_set_alpha(1);
}

// 02 Lamina Afiada: Brilho prateado avisando que o golpe carregado esta pronto
if (variable_instance_exists(id, "synth_lamina_afiada") && synth_lamina_afiada > 0 && attack_idle_timer >= 2.0) {
    draw_set_color(c_white);
    draw_set_alpha(0.6 + 0.3 * sin(current_time * 0.01));
    var _tip_x = x + facing_x * (body_radius + 12);
    var _tip_y = y + facing_y * (body_radius + 12);
    draw_circle(_tip_x, _tip_y, 4, false);
    draw_circle(_tip_x, _tip_y, 7, true);
    draw_set_alpha(1);
}

// Paladino: Bolha aquosa protetora visivel ao redor do corpo
if (paladin_barrier_active > 0) {
    draw_set_alpha(0.35 + 0.15 * sin(current_time * 0.008));
    draw_set_color(c_aqua);
    draw_circle(x, y, body_radius + 5, true);
    draw_set_alpha(1);
}

draw_set_color(c_white);

// Render Sakurai world-space combat popups, damage numbers & particle bursts
fx_system_draw();
