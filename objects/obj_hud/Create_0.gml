target = noone;
bar_w = 220;
bar_h = 18;
bar_gap = 8;
pad = 20;

level_complete = false;
game_over = false;
boss_room = (instance_number(obj_boss) > 0) || (instance_number(obj_boss2) > 0) || (object_exists(asset_get_index("obj_boss3")) && instance_number(asset_get_index("obj_boss3")) > 0) || (object_exists(asset_get_index("obj_boss4")) && instance_number(asset_get_index("obj_boss4")) > 0);
is_final_room = (room_exists(asset_get_index("Room8")) && room == asset_get_index("Room8"));
mob_clear_chest_spawned = false;

global.paused = false;
global.attr_window_open = false;
global.chest_reward_open = false;
global.run_victory = false;

hud_chest_slot_cursor = 0;
hud_talent_slot_cursor = 0;

global.boss_buttons_pressed = 0;
death_gold_earned = 0;
death_gold_kept = 0;
death_gold_lost = 0;

touch_controls_init();
