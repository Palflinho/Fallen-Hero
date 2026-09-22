event_inherited();

body_colour = c_red;
hp_max = 44;
hp = hp_max;
move_speed = 58;
contact_damage = 8;
preferred_range = 180;
attack_range = 220;
attack_cooldown = 1.2;
attack_cooldown_timer = random_range(0.4, 0.8); // Pausa de reação inicial para não atirar no frame 1
attack_windup = 0.40; // 0.40s de windup telegrafado
attack_windup_timer = 0;
consecutive_shots = 0; // Calibração progressiva da telemetria
locked_aim_dir = -1;   // Trava de mira na fase final do windup
projectile_damage = 10;
projectile_speed = 240;
state = "patrol";
vision_range = 240;
vision_angle = 110;
spider_sense_range = 80;
patrol_radius = 130;
exp_reward = 26;
gold_reward = 1;
knockback_resistance = 0.25;
