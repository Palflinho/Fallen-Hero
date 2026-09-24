if (target == noone || !instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (target == noone) exit;
}

draw_set_font(ui_font());
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _is_village_modal = (variable_global_exists("village_modal_open") && global.village_modal_open);
var _is_dialogue = dialogue_is_active();
var _is_sheet_or_pause = (global.paused || global.attr_window_open || global.chest_reward_open || game_over || level_complete);

// 1. Efeito de Flash de Dano na Tela
hud_draw_damage_flash(_gw, _gh);

// 2. Card de Status do Jogador, Barras e Objetivo
if (!_is_village_modal && !_is_dialogue && !_is_sheet_or_pause) {
    hud_draw_player_card(id, target, pad, _gw, _gh, boss_room);
}

// 3. Barra Superior do Chefe da Fase
if (!_is_village_modal && !_is_dialogue) {
    hud_draw_boss_bar(_gw, _gh, boss_room);
}

// 4. Minimapa Radar e Trilha de Nos do Bioma (apenas em masmorras, nunca na Vila nem em modais)
if (room != room_village && !_is_village_modal && !_is_dialogue && !_is_sheet_or_pause) {
    hud_draw_minimap_and_tracker(id, target, _gw, _gh, game_over, level_complete);
}

// 4.5. Flash e Banner Sensorial de Conquista de Sala / Abertura de Portal
if (variable_instance_exists(id, "room_banner_flash") && room_banner_flash > 0) {
    var _f_alpha = min(0.40, room_banner_flash);
    draw_set_alpha(_f_alpha);
    draw_set_colour(c_white);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1.0);
}

if (variable_instance_exists(id, "room_banner_timer") && room_banner_timer > 0 && !_is_village_modal && !_is_dialogue) {
    var _alpha = clamp(room_banner_timer * 1.5, 0, 1.0);
    var _bcx = _gw * 0.5;
    var _bcy = 84;
    var _bw = 480;
    var _bh = 54;

    draw_set_alpha(_alpha * 0.88);
    draw_set_colour(make_colour_rgb(10, 14, 24));
    draw_rectangle(_bcx - _bw * 0.5, _bcy - _bh * 0.5, _bcx + _bw * 0.5, _bcy + _bh * 0.5, false);

    // Borda Tematica com brilho
    draw_set_colour(room_banner_color);
    draw_rectangle(_bcx - _bw * 0.5, _bcy - _bh * 0.5, _bcx + _bw * 0.5, _bcy + _bh * 0.5, true);
    draw_set_colour(c_white);
    draw_rectangle(_bcx - _bw * 0.5 + 2, _bcy - _bh * 0.5 + 2, _bcx + _bw * 0.5 - 2, _bcy + _bh * 0.5 - 2, true);

    // Titulo Triunfante
    draw_set_font(ui_font());
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _pulse = 0.85 + 0.15 * abs(sin(current_time * 0.006));
    draw_set_alpha(_alpha);
    draw_set_colour(merge_colour(room_banner_color, c_white, _pulse * 0.4));
    draw_text_transformed(_bcx, _bcy - 8, room_banner_title, 1.2, 1.2, 0);

    // Subtitulo
    draw_set_colour(make_colour_rgb(210, 230, 245));
    draw_text(_bcx, _bcy + 13, room_banner_sub);

    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
}

// 5. Modais de Estado de Jogo (Exclusivos)
if (game_over) {
    hud_draw_game_over(_gw, _gh, death_gold_earned, death_gold_lost, death_gold_kept);
} else if (level_complete || (variable_global_exists("run_victory") && global.run_victory)) {
    hud_draw_victory(target, _gw, _gh);
} else if (global.chest_reward_open) {
    hud_draw_chest_reward(id, target, _gw, _gh);
} else if (global.paused || global.attr_window_open) {
    hud_draw_hero_sheet(id, target, _gw, _gh);
}

// 6. Controles Touch Mobile (caso ativos e tela livre de modais)
if (!_is_village_modal && !_is_dialogue && !_is_sheet_or_pause) {
    touch_controls_draw_gui();
}
