event_inherited();

// General Magma -- same proven pattern as the Water boss, fire-reskinned and a step
// stronger (GDD: each phase's soldiers hit harder than the last).
body_colour = c_red;
body_radius = 62;
hp_max = 750;
hp = hp_max;
move_speed = 22;
contact_damage = 18;

damage_reduction = 0;

vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
facing_dir = 180;

barrage_shots_total = 6;
barrage_shots_fired = 0;
barrage_shot_timer = 0.6;
barrage_shot_interval = 0.15;
barrage_volley_pause = 0.4;
barrage_spread = 65;
projectile_damage = 11;
projectile_speed = 270;

melee_range = 260;
melee_trigger_dist = melee_range * 0.5;
slam_windup = 1.5;
slam_windup_timer = 0;
slam_hit_radius = 200;
slam_damage = 32;

vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 4.0;

post_slam_recover = 1.3;
recover_timer = 0;

exp_reward = 450;
gold_reward = 150;

state = "barrage";
