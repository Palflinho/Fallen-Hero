event_inherited();
elem_strip_elite();

// Mini-chefe da Sala Pre-Boss do Templo do Vento: GOLEM DE TEMPESTADE
// Ritmo: SOLIDO (dispara rajada) -> TORNADO (persegue girando e empurra)
//        -> TONTO (vulneravel) -> NEVOA (intangivel, se reposiciona) -> ...
body_colour = make_colour_rgb(170, 225, 245);
body_radius = 30;
hp_max = 240;
hp = hp_max;
move_speed = 45;
contact_damage = 16;
knockback_resistance = 0.85;
vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
has_poise = false;
can_enrage = false;
exp_reward = 130;
gold_reward = 9;

state = "solid";
phase_timer = 1.6;
fan_fired = false;
tornado_speed = 150;
tornado_radius = 52;
tornado_hit_cd = 0;
spin = 0;
