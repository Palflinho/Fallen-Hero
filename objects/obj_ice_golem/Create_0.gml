event_inherited();

// Mini-Chefe Guardião Glacial (Quadrado Grande Exclusivo da Sala Pré-Boss)
body_colour = make_colour_rgb(200, 235, 255);
body_radius = 32;
hp_max = 260;
hp = hp_max;
move_speed = 35;
contact_damage = 18;

// Mitigação natural de dano fora da vulnerabilidade
damage_reduction = 0.35;
knockback_resistance = 0.85;

vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
state = "chase";

element_type = "water";

attack_cooldown_timer = 1.0;
attack_cooldown = 2.2;
combo_count = 0;

// Golpe 1: Barragem
fan_shots = 3;

// Golpe 2: Esmagamento / Investida de Chefe
slam_windup = 0.70;
slam_windup_timer = 0;
slam_radius = 130;
slam_damage = 25;
dash_timer = 0;
dash_vx = 0;
dash_vy = 0;

// Janela de Vulnerabilidade
vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 3.0;

exp_reward = 120;
gold_reward = 8;
