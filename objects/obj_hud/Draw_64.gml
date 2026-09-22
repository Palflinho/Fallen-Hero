if (target == noone || !instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (target == noone) exit;
}

draw_set_font(-1);
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

// 7. Onboarding Diegético de Controles (na Vila e na Sala 1 da Masmorra)
if (!game_over && !level_complete && !global.paused && !global.attr_window_open && !is_world_paused()) {
    if (room == room_village || room == Room1) {
        var _hint_txt = "[WASD / Setas] Mover   *   [Z / Clique] Atacar   *   [X] Especial   *   [Espaco] Esquiva / Interagir   *   [G] Ficha & Talentos";
        var _lang = loc_get_language();
        if (_lang == "en") _hint_txt = "[WASD / Arrows] Move   *   [Z / Click] Attack   *   [X] Skill   *   [Space] Dash / Interact   *   [G] Hero Sheet";
        else if (_lang == "es") _hint_txt = "[WASD / Flechas] Mover   *   [Z / Clic] Atacar   *   [X] Especial   *   [Espacio] Esquiva / Interactuar   *   [G] Hoja de Heroe";
        else if (_lang == "ja") _hint_txt = "[WASD / 矢印] 移動   *   [Z] 攻撃   *   [X] スキル   *   [Space] 回避/調べる   *   [G] ステータス";

        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_font(-1);

        var _hw = string_width(_hint_txt) + 24;
        var _hh = 24;
        var _hx = _gw * 0.5;
        var _hy = _gh - 14;

        draw_set_alpha(0.7);
        draw_set_colour(make_colour_rgb(10, 14, 22));
        draw_rectangle(_hx - _hw * 0.5, _hy - _hh, _hx + _hw * 0.5, _hy, false);
        draw_set_colour(make_colour_rgb(60, 80, 110));
        draw_rectangle(_hx - _hw * 0.5, _hy - _hh, _hx + _hw * 0.5, _hy, true);

        draw_set_alpha(0.9);
        draw_set_colour(make_colour_rgb(200, 220, 240));
        draw_text(_hx, _hy - 4, _hint_txt);

        draw_set_alpha(1.0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}