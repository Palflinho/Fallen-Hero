event_inherited();
elem_strip_elite();

// TOTEM ELEMENTAL: estacionario, fortalece aliados dentro da aura.
//   Agua  = cura   |  Fogo = velocidade  |  Vento = reflete projeteis  |  Terra = escudo de pedra
element = variable_global_exists("run_biome") ? global.run_biome : "water";
body_colour = elem_colour(element);
body_radius = 16;
hp_max = 70;
hp = hp_max;
move_speed = 0;
contact_damage = 0;
knockback_resistance = 1.0;
vision_range = 9999;
vision_angle = 360;
has_poise = false;
can_enrage = false;
exp_reward = 20;
gold_reward = 2;

state = "idle";
aura_radius = 140;
pulse_interval = 1.0;
pulse_timer = 0.5;
shield_interval = 4.0;
shield_timer = 1.0;
pulse_fx = 0;
