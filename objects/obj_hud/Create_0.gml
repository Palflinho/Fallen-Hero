target = noone;
bar_w = 220;
bar_h = 18;
bar_gap = 8;
pad = 20;

level_complete = false;
game_over = false;
boss_room = (instance_number(obj_boss) > 0) || (instance_number(obj_boss2) > 0) || (object_exists(asset_get_index("obj_boss3")) && instance_number(asset_get_index("obj_boss3")) > 0) || (object_exists(asset_get_index("obj_boss4")) && instance_number(asset_get_index("obj_boss4")) > 0) || (object_exists(asset_get_index("obj_boss_human")) && instance_number(asset_get_index("obj_boss_human")) > 0);
// O fim da partida agora e conduzido pelo obj_ending_controller (derrota do Salvador);
// nenhuma sala de chefe encerra a expedicao sozinha.
is_final_room = false;
mob_clear_chest_spawned = false;

global.paused = false;
global.attr_window_open = false;
global.chest_reward_open = false;
global.run_victory = false;

// Talento ganho ao cruzar um portal: abre a escolha de slot ja na sala nova
if (variable_global_exists("pending_chest_talent") && global.pending_chest_talent != "") {
    open_chest_reward(global.pending_chest_talent);
    global.pending_chest_talent = "";
}

hud_chest_slot_cursor = 0;
hud_talent_slot_cursor = 0;

global.boss_buttons_pressed = 0;
death_gold_earned = 0;
death_gold_kept = 0;
death_gold_lost = 0;

touch_controls_init();
