base_size = 32;

// The room places this instance with "rotation" set toward an open corridor; image_angle
// picks that up at creation, so the dart always fires down an actual passage.
fire_dir_x = lengthdir_x(1, image_angle);
fire_dir_y = lengthdir_y(1, image_angle);

fire_interval = 1.6;
fire_timer = random_range(0.4, fire_interval);
telegraph_time = 0.35;
telegraph_timer = 0;
state = "idle";
damage = 10;
projectile_speed = 240;
