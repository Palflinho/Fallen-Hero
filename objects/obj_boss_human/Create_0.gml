event_inherited();

body_colour = make_colour_rgb(60, 75, 95); // Traje exoesqueleto cinza chumbo
accent_colour = make_colour_rgb(40, 220, 255); // Luzes cibernéticas ciano/neon
body_radius = 48;
hp_max = 1600;
hp = hp_max;
move_speed = 70;
contact_damage = 30;

damage_reduction = 0;
knockback_resistance = 0.95;

vision_range = 9999;
vision_angle = 360;

// Estados de IA do Boss Humano
state = "dialogue_wait"; // Inicia aguardando o diálogo dramático
state_timer = 0;
combat_timer = 0;

// Sistema de Escudo de Energia
shield_active = false;
shield_timer = 0;
shield_max_duration = 5.0;
shield_cooldown = 14.0;
shield_cooldown_timer = 8.0; // Primeiro escudo após 8s de combate

// Sistema de Feixe Laser
laser_charging = false;
laser_charge_timer = 0;
laser_charge_duration = 1.2;
laser_firing = false;
laser_fire_timer = 0;
laser_fire_duration = 0.9;
laser_target_x = 0;
laser_target_y = 0;
laser_angle = 0;
laser_damage_tick = 0;

// Sistema de Drones Auxiliares
drone_angle = 0;
drones_active = false;
drone_shot_timer = 0;

// Vulnerabilidade / Superaquecimento do Traje
vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 4.0;

// Diálogo inicial
dialogue_triggered = false;

exp_reward = 800;
gold_reward = 100;
