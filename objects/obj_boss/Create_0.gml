event_inherited();

body_colour = c_maroon;
body_radius = 60;
hp_max = 600;
hp = hp_max;
move_speed = 20;
contact_damage = 16;

// Immune by default -- only takes damage while `vulnerable` is true.
damage_reduction = 0;
knockback_resistance = 1.0;

vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
facing_dir = 180;

// Ranged barrage -- same idea as obj_elemental, but a multi-shot fan and bigger scale.
// This is the boss's default, constant behaviour whenever the player keeps their distance.
barrage_shots_total = 5;
barrage_shots_fired = 0;
barrage_shot_timer = 0.6;
barrage_shot_interval = 0.16;
barrage_volley_pause = 0.45;
barrage_spread = 60;
projectile_damage = 9;
projectile_speed = 260;

// Melee AoE slam -- same idea as slime/golem windup hits, but huge. Only triggers when
// the player pushes deep into melee_range (past half of it); otherwise the boss never
// stops shooting. The windup is deliberately generous: even the slowest class can walk
// into that inner ring and walk back out again before it lands, so the slam is always
// avoidable and never a "free hit" -- it's purely a bait for the vulnerability window.
melee_range = 260;
melee_trigger_dist = melee_range * 0.5;
slam_windup = 1.5;
slam_windup_timer = 0;
slam_hit_radius = 190;
slam_damage = 26;

vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 4.0;

// After the vulnerability window closes, the boss idles for a moment before it can act
// again (ranged or melee) -- a guaranteed breather so a slam is never immediately chained
// into another slam check, even if the player stayed in melee_trigger_dist the whole time.
post_slam_recover = 1.3;
recover_timer = 0;

exp_reward = 300;
gold_reward = 100;

state = "barrage";
