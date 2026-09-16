if (target == noone || !instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (target == noone) exit;
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// 1. Efeito de Flash de Dano na Tela
hud_draw_damage_flash(_gw, _gh);

// 2. Card de Status do Jogador, Barras e Objetivo
hud_draw_player_card(id, target, pad, _gw, _gh, boss_room);

// 3. Barra Superior do Chefe da Fase
hud_draw_boss_bar(_gw, _gh, boss_room);

// 4. Minimapa Radar e Trilha de NÃ³s do Bioma
hud_draw_minimap_and_tracker(id, target, _gw, _gh, game_over, level_complete);

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

// 6. Controles Touch Mobile (caso ativos)
touch_controls_draw_gui();