event_inherited();
elem_strip_elite();

// DRONE DO ESCUDO (O Salvador): enquanto houver drones vivos o escudo do Salvador
// fica ativo. Destrua todos para sobrecarregar o traje.
stats_scaled = true; // vida fixa, sem escalonamento de bioma
body_colour = make_colour_rgb(40, 220, 255);
body_radius = 12;
hp_max = 70;
hp = hp_max;
hp_lag = hp;
move_speed = 0;
contact_damage = 0;
knockback_resistance = 1.0;
has_poise = false;
can_enrage = false;
exp_reward = 6;
gold_reward = 0;
owner = noone;
orbit_angle = 0;
orbit_radius = 95;
shot_timer = random_range(1.2, 2.2);
state = "orbit";
