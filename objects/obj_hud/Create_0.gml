target = noone;
bar_w = 220;
bar_h = 18;
bar_gap = 8;
pad = 20;

level_complete = false;
game_over = false;
boss_room = (instance_number(obj_boss) > 0) || (instance_number(obj_boss2) > 0);
is_final_room = (room == Room4);
mob_clear_chest_spawned = false;

global.paused = false;
global.attr_window_open = false;
global.chest_reward_open = false;

global.boss_buttons_pressed = 0;
death_gold_earned = 0;
death_gold_kept = 0;
death_gold_lost = 0;
