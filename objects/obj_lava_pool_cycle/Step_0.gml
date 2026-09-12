if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

timer -= _dt;
if (timer <= 0) {
    if (state == "dormant") {
        state = "warning";
        timer = time_warning;
        is_up = false;
        fx_spawn_sparks(x + _w * 0.5, y + _h * 0.5, c_dkgray, 4);
    } else if (state == "warning") {
        state = "active";
        timer = time_active;
        is_up = true;
        fx_spawn_sparks(x + _w * 0.5, y + _h * 0.5, c_orange, 8);
    } else {
        state = "dormant";
        timer = time_dormant;
        is_up = false;
    }
}

if (state == "warning") {
    smoke_timer -= _dt;
    if (smoke_timer <= 0) {
        smoke_timer = 0.2;
        fx_spawn_sparks(x + random(_w), y + random(_h), c_yellow, 1);
    }
} else if (state == "active") {
    smoke_timer -= _dt;
    if (smoke_timer <= 0) {
        smoke_timer = 0.12;
        fx_spawn_sparks(x + random(_w), y + random(_h), c_orange, 2);
    }

    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        var _cx = clamp(_player.x, x, x + _w);
        var _cy = clamp(_player.y, y, y + _h);
        if (point_distance(_player.x, _player.y, _cx, _cy) < _player.body_radius) {
            tick_timer -= _dt;
            if (tick_timer <= 0) {
                player_take_damage(tick_damage, "physical");
                player_apply_poison(3, 0.5, 1.5);
                tick_timer = tick_interval;
            }
        }
    }
}
