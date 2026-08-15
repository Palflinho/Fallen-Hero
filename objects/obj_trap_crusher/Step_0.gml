if (global.paused || global.attr_window_open) exit;

var _dt = delta_time / 1000000;

switch (state) {
    case "hidden":
        cycle_timer -= _dt;
        if (cycle_timer <= 0) {
            state = "telegraph";
            telegraph_timer = telegraph_time;
        }
        break;

    case "telegraph":
        telegraph_timer -= _dt;
        if (telegraph_timer <= 0) {
            state = "erupt";
            erupt_timer = erupt_time;
            has_hit = false;
        }
        break;

    case "erupt":
        erupt_timer -= _dt;
        if (!has_hit) {
            var _player = instance_find(obj_player, 0);
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
                player_take_damage(damage, "physical");
                has_hit = true;
            }
        }
        if (erupt_timer <= 0) {
            state = "hidden";
            cycle_timer = cycle_time;
        }
        break;
}
