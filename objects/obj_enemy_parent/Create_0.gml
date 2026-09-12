hp_max = 30;
hp = hp_max;
hit_flash_timer = 0;
hit_flash_duration = 0.12;
move_speed = 60;
contact_damage = 8;
state = "idle";
body_radius = 14;
body_colour = c_lime;

// Sakurai Polish: Knockback Physics
knockback_vx = 0;
knockback_vy = 0;
knockback_friction = 0.85;
knockback_resistance = 0.0;

// Sakurai Polish: Squash & Stretch Animation
scale_x = 1.0;
scale_y = 1.0;
squash_recovery = 0.18;

// Dynamic Combat Health Bar (Clutter reduction + Souls-like lagging damage bar)
hp_bar_timer = 0;
hp_bar_duration = 2.8;
hp_lag = hp_max;
hp_lag_speed = 0.08;

// Miyamoto Polish: Attack Telegraphing
telegraph_alert_timer = 0;

poison_active = false;
poison_damage = 0;
poison_tick_interval = 0;
poison_tick_timer = 0;
poison_duration = 0;

slow_active = false;
slow_multiplier = 1;
slow_duration = 0;

move_speed_effective = move_speed;

damage_reduction = 1;

exp_reward = 10;
gold_reward = 3;

home_x = x;
home_y = y;
patrol_radius = 150;
patrol_target_x = x;
patrol_target_y = y;
patrol_wait_timer = random_range(0, 1.5);
facing_dir = random(360);
vision_range = 180;
vision_angle = 110;
lost_sight_timer = 0;
lost_sight_grace = 1.5;
spider_sense_range = 65;
spider_alert_timer = 0;
has_spotted_player = false;
