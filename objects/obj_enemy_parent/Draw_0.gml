// 1. Miyamoto Telegraphs: Ground Danger Circles (Casters & Golem AoE)
if (state == "cast" && variable_instance_exists(id, "cast_target_x") && variable_instance_exists(id, "aoe_radius")) {
    var _t = clamp(1 - (cast_timer / telegraph_time), 0, 1);
    var _col = (object_index == obj_magma_caster) ? c_orange : c_purple;
    draw_set_alpha(0.3);
    draw_set_color(_col);
    draw_circle(cast_target_x, cast_target_y, aoe_radius * _t, false);
    draw_set_alpha(0.7);
    draw_circle(cast_target_x, cast_target_y, aoe_radius, true);
    draw_set_alpha(1);
}

if (state == "magia_windup" && variable_instance_exists(id, "magia_radius")) {
    var _t = clamp(1 - (magia_windup_timer / magia_telegraph), 0, 1);
    draw_set_alpha(0.25 + 0.15 * sin(current_time * 0.03));
    draw_set_color(c_red);
    draw_circle(x, y, magia_radius * _t, false);
    draw_set_alpha(0.8);
    draw_circle(x, y, magia_radius, true);
    draw_set_alpha(1);
}

// 1.5. Cone de Visao Sutil em Patrulha (Facilita planejamento tatico do jogador)
if (state == "patrol" && variable_instance_exists(id, "vision_range") && variable_instance_exists(id, "vision_angle") && variable_instance_exists(id, "facing_dir")) {
    draw_set_alpha(0.04);
    draw_set_color(c_yellow);
    var _half_ang = vision_angle * 0.5;
    var _steps = 8;
    for (var _s = 0; _s < _steps; _s++) {
        var _a1 = facing_dir - _half_ang + (_s / _steps) * vision_angle;
        var _a2 = facing_dir - _half_ang + ((_s + 1) / _steps) * vision_angle;
        draw_triangle(x, y, x + lengthdir_x(vision_range * 0.75, _a1), y + lengthdir_y(vision_range * 0.75, _a1), x + lengthdir_x(vision_range * 0.75, _a2), y + lengthdir_y(vision_range * 0.75, _a2), false);
    }
    draw_set_alpha(1);
}

// 1.8. Aura Pulsante de Monstro Raro / Campeão
if (variable_instance_exists(id, "is_rare_mob") && is_rare_mob) {
    var _pulse = 0.5 + 0.5 * sin(current_time * 0.008);
    draw_set_alpha(0.18 + 0.12 * _pulse);
    draw_set_color(c_yellow);
    draw_circle(x, y, (body_radius + 6) * scale_x, false);
    draw_set_alpha(0.6 + 0.4 * _pulse);
    draw_circle(x, y, (body_radius + 7) * scale_x, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// 1.85. Aura de Variante Maior / Alfa
if (variable_instance_exists(id, "is_greater_variant") && is_greater_variant) {
    var _gpulse = 0.5 + 0.5 * sin(current_time * 0.006);
    draw_set_alpha(0.14 + 0.10 * _gpulse);
    draw_set_color(c_orange);
    draw_circle(x, y, (body_radius + 4) * scale_x, false);
    draw_set_alpha(0.5 + 0.3 * _gpulse);
    draw_circle(x, y, (body_radius + 5) * scale_x, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// 1.9. Anel Tático de Ameaça Sob os Pés (Feedback Lele / Sakurai: Identificação Imediata de Inimigo)
var _seed = variable_instance_exists(id, "anim_seed") ? anim_seed : (x * 13 + y * 17);
var _threat_pulse = 0.65 + 0.35 * abs(sin((current_time + _seed * 70) * 0.006));
draw_set_alpha(0.18 * _threat_pulse);
draw_set_color(c_red);
draw_ellipse(x - body_radius * 1.15, y + body_radius * 0.45, x + body_radius * 1.15, y + body_radius * 0.90, false);
draw_set_alpha(0.50 * _threat_pulse);
draw_set_color(make_colour_rgb(255, 60, 60));
draw_ellipse(x - body_radius * 1.15, y + body_radius * 0.45, x + body_radius * 1.15, y + body_radius * 0.90, true);
draw_set_alpha(1.0);

// 2. Body Rendering with Sakurai Squash & Stretch Deformation
if (sprite_index != -1) {
    var _blend = body_colour;
    if (poison_active) _blend = merge_colour(body_colour, c_lime, 0.4);
    if (hit_flash_timer > 0) _blend = c_white;
    var _facing_sign = variable_instance_exists(id, "facing_h") ? facing_h : ((facing_dir > 90 && facing_dir < 270) ? -1 : 1);
    draw_sprite_ext(sprite_index, image_index, x, y, scale_x * _facing_sign, scale_y, 0, _blend, 1);
} else {
    var _col = body_colour;
    if (poison_active) _col = merge_colour(body_colour, c_lime, 0.4);
    if (hit_flash_timer > 0) _col = c_white;

    var _hw = body_radius * scale_x;
    var _hh = body_radius * scale_y;
    draw_set_color(_col);
    draw_rectangle(x - _hw, y - _hh, x + _hw, y + _hh, false);
    draw_set_color(c_black);
    draw_rectangle(x - _hw, y - _hh, x + _hw, y + _hh, true);

    // Olhos Ameaçadores de Monstro (Claridade visual para nunca parecer objeto passivo)
    var _facing_sign = variable_instance_exists(id, "facing_h") ? facing_h : ((facing_dir > 90 && facing_dir < 270) ? -1 : 1);
    var _eye_x = x + _facing_sign * 3;
    var _eye_y = y - 2;
    draw_set_color(c_red);
    draw_circle(_eye_x - 4, _eye_y, 2.5, false);
    draw_circle(_eye_x + 4, _eye_y, 2.5, false);
    draw_set_color(c_yellow);
    draw_circle(_eye_x - 4, _eye_y, 1.2, false);
    draw_circle(_eye_x + 4, _eye_y, 1.2, false);
}

// 3. Miyamoto Attack Telegraph: Overhead "!" Warning Bubble
var _is_telegraphing = (state == "windup" || state == "cast" || state == "slam_windup" || state == "magia_windup");
if (_is_telegraphing) {
    var _ty = y - body_radius * scale_y - 18 + sin(current_time * 0.02) * 2;
    draw_set_alpha(0.9);
    draw_set_color(c_red);
    draw_circle(x, _ty, 8, false);
    draw_set_color(c_white);
    draw_circle(x, _ty, 8, true);

    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_transformed(x, _ty, "!", 1.2, 1.2, 0);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// 3.5. Alerta de Sentido Aranha (Detecção por Flanco Lateral)
if (variable_instance_exists(id, "spider_alert_timer") && spider_alert_timer > 0) {
    var _sy = y - body_radius * scale_y - 18;
    var _sp_ratio = spider_alert_timer / 0.6;
    draw_set_alpha(_sp_ratio * 0.9);
    draw_set_color(c_yellow);
    var _rad_pulse = 9 + (1 - _sp_ratio) * 12;
    draw_circle(x, _sy, _rad_pulse, true);
    draw_circle(x, _sy, 7, false);
    draw_set_color(c_black);
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x, _sy, "!");
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// 3.8. Marcacao Espectral (Assassino de Agua / Lamina Espectral)
if (variable_instance_exists(id, "spectral_mark") && spectral_mark > 0) {
    var _mp = 0.6 + 0.4 * sin(current_time * 0.012);
    draw_set_alpha(0.75 * _mp);
    draw_set_color(c_teal);
    draw_circle(x, y - body_radius * scale_y - 12, 4, false);
    draw_set_color(c_white);
    draw_circle(x, y - body_radius * scale_y - 12, 4, true);
    draw_set_alpha(1.0);
}

// 4. Dynamic Combat Health Bar (Lagging yellow damage chunk)
var _is_boss = (object_index == obj_boss || object_index == obj_boss2);
var _should_draw_hp = _is_boss || (hp_bar_timer > 0 && hp < hp_max);

if (_should_draw_hp) {
    var _w = body_radius * 2 + 6;
    var _hx = x - _w * 0.5;
    var _hy = y - body_radius * scale_y - 8;

    // Background border
    draw_set_color(c_black);
    draw_rectangle(_hx - 1, _hy - 1, _hx + _w + 1, _hy + 5, false);

    // Lagging yellow damage chunk
    var _lag_ratio = clamp(hp_lag / hp_max, 0, 1);
    draw_set_color(c_yellow);
    draw_rectangle(_hx, _hy, _hx + _w * _lag_ratio, _hy + 4, false);

    // Active HP bar (red)
    var _hp_ratio = clamp(hp / hp_max, 0, 1);
    draw_set_color(c_red);
    draw_rectangle(_hx, _hy, _hx + _w * _hp_ratio, _hy + 4, false);

    // Indicador textual para monstros raros
    if (variable_instance_exists(id, "is_rare_mob") && is_rare_mob) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_yellow);
        draw_text_transformed(x, _hy - 2, "★ RARO ★", 0.75, 0.75, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    draw_set_color(c_white);
}

