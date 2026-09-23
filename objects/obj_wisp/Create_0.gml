event_inherited();
elem_strip_elite();

// FOGO-FATUO: pequeno, fragil e voador. Nao ataca: procura um aliado e o INFUNDE,
// transformando-o em elite. Mate-o antes que alcance alguem!
element = variable_global_exists("run_biome") ? global.run_biome : "water";
body_colour = elem_colour(element);
body_radius = 8;
hp_max = 18;
hp = hp_max;
move_speed = 95;
contact_damage = 0;
knockback_resistance = 0;
vision_range = 9999;
vision_angle = 360;
has_poise = false;
can_enrage = false;
exp_reward = 10;
gold_reward = 1;

state = "seek";
target = noone;
infuse_time = 1.0;
infuse_timer = 0;
wander_dir = random(360);
wander_timer = 0;
bob = random(100);
