event_inherited();

body_colour = make_colour_rgb(190, 245, 255);
hp_max = 46;
hp = hp_max;
move_speed = 72;
contact_damage = 9;
attack_range = 36;
attack_cooldown = 0.8;
attack_cooldown_timer = 0;
attack_windup = 0.18;
attack_windup_timer = 0;
state = "patrol";
vision_range = 180;
vision_angle = 100;
spider_sense_range = 70;
patrol_radius = 120;
exp_reward = 25;
gold_reward = 1;
knockback_resistance = 0.05;

// --- Slime de Vento: salta em arco (intangivel no ar) e empurra tudo ao pousar ---
hop_range = 160;
hop_time = 0.55;
hop_timer = 0;
hop_start_x = x;
hop_start_y = y;
hop_target_x = x;
hop_target_y = y;
land_radius = 34;
push_radius = 72;
recover_timer = 0;
