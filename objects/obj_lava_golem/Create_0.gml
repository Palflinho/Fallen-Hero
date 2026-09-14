event_inherited();

// Mini-Chefe Guardião de Magma (Quadrado Grande Exclusivo da Sala Pré-Boss)
body_colour = c_maroon;
body_radius = 32;
hp_max = 240;
hp = hp_max;
move_speed = 36;
contact_damage = 20;

damage_reduction = 0.35;
knockback_resistance = 0.90;

vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
state = "chase";

attack_cooldown_timer = 1.0;
attack_cooldown = 2.2;
combo_count = 0;

// Golpe 1: Erupção Magmática (2 erupções sob o jogador)
erupcao_timer = 0;
erupcao_telegraph = 0.8;
erupcao_targets_x = [0, 0];
erupcao_targets_y = [0, 0];
erupcao_radius = 50;
erupcao_damage = 18;

// Golpe 2: Carga Ígnea (Investida do General Magma)
charge_windup = 0.45;
charge_windup_timer = 0;
charge_timer = 0;
charge_vx = 0;
charge_vy = 0;
charge_damage = 24;

// Janela de Vulnerabilidade: Superaquecimento
vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 3.0;

exp_reward = 150;
gold_reward = 10;
