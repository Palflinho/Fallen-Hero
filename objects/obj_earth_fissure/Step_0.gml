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
        fx_spawn_sparks(x + _w * 0.5, y + _h * 0.5, make_colour_rgb(140, 105, 65), 5);
    } else if (state == "warning") {
        state = "active";
        timer = time_active;
        is_up = true;
        fx_spawn_sparks(x + _w * 0.5, y + _h * 0.5, make_colour_rgb(180, 150, 110), 10);
    } else {
        state = "dormant";
        timer = time_dormant;
        is_up = false;
    }
}

if (state == "warning") {
    dust_timer -= _dt;
    if (dust_timer <= 0) {
        dust_timer = 0.22;
        fx_spawn_sparks(x + random(_w), y + random(_h), make_colour_rgb(150, 120, 80), 1);
    }
} else if (state == "active") {
    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        var _cx = clamp(_player.x, x, x + _w);
        var _cy = clamp(_player.y, y, y + _h);
        if (point_distance(_player.x, _player.y, _cx, _cy) < _player.body_radius) {
            tick_timer -= _dt;
            if (tick_timer <= 0) {
                tick_timer = 0.5;
                player_take_damage(damage, "physical");
                fx_spawn_sparks(_player.x, _player.y, make_colour_rgb(160, 130, 90), 8);
            }
        }
    }
}
