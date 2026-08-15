if (global.paused || global.attr_window_open) exit;

var _dt = delta_time / 1000000;

switch (state) {
    case "idle":
        fire_timer -= _dt;
        if (fire_timer <= 0) {
            state = "telegraph";
            telegraph_timer = telegraph_time;
        }
        break;

    case "telegraph":
        telegraph_timer -= _dt;
        if (telegraph_timer <= 0) {
            var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
            _p.owner = id;
            _p.damage = damage;
            _p.dir_x = fire_dir_x;
            _p.dir_y = fire_dir_y;
            _p.speed_px = projectile_speed;
            _p.colour = c_red;
            _p.body_radius = 6;

            state = "idle";
            fire_timer = fire_interval;
        }
        break;
}
