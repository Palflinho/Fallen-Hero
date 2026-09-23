event_inherited();

body_colour = make_colour_rgb(130, 220, 240);
hp_max = 48;
hp = hp_max;
move_speed = 52;
contact_damage = 7;
preferred_range = 160;
attack_cooldown = 2.4;
attack_cooldown_timer = 1.0;
telegraph_time = 0.75;
aoe_radius = 65;
aoe_damage = 18;
cast_target_x = 0;
cast_target_y = 0;
cast_timer = 0;
state = "patrol";
vision_range = 240;
vision_angle = 100;
spider_sense_range = 75;
patrol_radius = 120;
exp_reward = 35;
gold_reward = 2;
knockback_resistance = 0.15;
is_rare_mob = true;
rare_chest_drop_chance = 0.20;

// --- Conjurador de Vento: barreira que reflete projeteis + vortice que puxa ---
attack_windup = 0.4;
attack_windup_timer = 0;
barrier_cooldown = 0;
barrier_cooldown_max = 6.0;
barrier_time = 3.0;
barrier_timer = 0;
barrier_radius = 70;
vortex_radius = 180;
vortex_pull = 55;
vortex_tick = 0;
exhausted_timer = 0;
