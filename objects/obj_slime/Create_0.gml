event_inherited();

body_colour = c_lime;
hp_max = 48;
hp = hp_max;
move_speed = 50;
contact_damage = 8;
attack_range = 34;
attack_cooldown = 1.0;
attack_cooldown_timer = 0;
attack_windup = 0.25;
attack_windup_timer = 0;
state = "patrol";
vision_range = 150;
vision_angle = 90;
spider_sense_range = 55;
patrol_radius = 100;
exp_reward = 15;
gold_reward = 1;
knockback_resistance = 0.0;

// --- Slime de Agua: divide-se ao morrer; os minis se reunem curados se nao forem mortos em 3s ---
is_mini = false;
split_done = false;
partner = noone;
merge_timer = 0;
orig_hp_max = hp_max;
orig_contact = contact_damage;
orig_speed = move_speed;
orig_exp = exp_reward;
orig_gold = gold_reward;
// Investida escorregadia: deixa um rastro de gelo
lunge_range = 120;
lunge_dir = 0;
lunge_timer = 0;
lunge_hit = false;
trail_timer = 0;
recover_timer = 0;
