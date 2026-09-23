event_inherited();

body_colour = c_maroon;
hp_max = 48;
hp = hp_max;
move_speed = 42;
contact_damage = 7;
preferred_range = 150;
attack_cooldown = 2.6;
attack_cooldown_timer = 1.0;
telegraph_time = 0.8;
aoe_radius = 70;
aoe_damage = 24;
cast_target_x = 0;
cast_target_y = 0;
cast_timer = 0;
state = "patrol";
vision_range = 220;
vision_angle = 100;
spider_sense_range = 75;
patrol_radius = 120;
exp_reward = 32;
gold_reward = 2;
knockback_resistance = 0.15;

// Burn -- fire's answer to frost's slow: a lingering damage-over-time instead.
burn_damage = 3;
burn_tick_interval = 0.6;
burn_duration = 2.5;
is_rare_mob = true;
rare_chest_drop_chance = 0.20;

// --- Conjurador de Magma: 3 meteoros encadeados que seguem o jogador ---
attack_cooldown = 4.0;
attack_windup = 0.4;
attack_windup_timer = 0;
meteor_damage = 16;
meteor_count = 3;
meteor_gap = 0.45;
channel_timer = 0;
exhausted_timer = 0;
