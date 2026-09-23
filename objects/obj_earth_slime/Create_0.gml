event_inherited();

body_colour = make_colour_rgb(135, 100, 60);
hp_max = 46;
hp = hp_max;
move_speed = 40;
contact_damage = 11;
defense = 2;
attack_range = 38;
attack_cooldown = 1.1;
attack_cooldown_timer = 0;
attack_windup = 0.32;
attack_windup_timer = 0;
state = "patrol";
vision_range = 160;
vision_angle = 90;
spider_sense_range = 65;
patrol_radius = 100;
exp_reward = 28;
gold_reward = 1;
knockback_resistance = 0.40;

// --- Slime de Terra: carapaca frontal (3 golpes) + rolamento em linha ---
fh_shell_hits = 3;
fh_shell_arc = 70;
roll_min = 70;
roll_range = 190;
roll_dir = 0;
roll_timer = 0;
roll_hit = false;
dizzy_timer = 0;
