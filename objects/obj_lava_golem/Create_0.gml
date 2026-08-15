event_inherited();

// Unlike the Ice Golem (melee, slime-style per the GDD), the Fire Golem fights at medium
// range like the elemental -- it's the elemental's kiting pattern with golem-tier stats.
body_colour = c_maroon;
body_radius = 24;
hp_max = 110;
hp = hp_max;
move_speed = 34;
contact_damage = 20;
preferred_range = 200;
attack_range = 260;
attack_cooldown = 1.6;
attack_cooldown_timer = 0;
attack_windup = 0.4;
attack_windup_timer = 0;
projectile_damage = 12;
projectile_speed = 200;
state = "patrol";
vision_range = 220;
patrol_radius = 90;

shield_interval = 4.5;
shield_timer = shield_interval;
shield_duration = 1.3;
shield_active_timer = 0;

// Magia -- once the fight has gone on long enough, a self-centered fire burst.
magia_interval = 15;
magia_timer = magia_interval;
magia_telegraph = 0.7;
magia_windup_timer = 0;
magia_radius = 110;
magia_damage = 18;

exp_reward = 45;
gold_reward = 14;
