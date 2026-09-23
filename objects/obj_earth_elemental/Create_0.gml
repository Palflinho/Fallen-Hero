event_inherited();

body_colour = make_colour_rgb(145, 110, 75);
body_radius = 20;
hp_max = 48;
hp = hp_max;
move_speed = 38;
contact_damage = 12;

damage_reduction = 0.35;
knockback_resistance = 0.8;

vision_range = 220;
vision_angle = 100;
spider_sense_range = 75;
patrol_radius = 120;

preferred_range = 80;
attack_range = 150;
attack_cooldown = 2.2;
attack_cooldown_timer = 0;
attack_windup = 0.45;
attack_windup_timer = 0;

exp_reward = 35;
gold_reward = 2;
state = "patrol";
is_rare_mob = true;
rare_chest_drop_chance = 0.20;

// --- Elemental de Terra: estaca atrasada que irrompe sob o jogador 0.8s depois ---
preferred_range = 150;
attack_range = 240;
attack_cooldown = 2.4;
stake_damage = 14;
recover_timer = 0;
