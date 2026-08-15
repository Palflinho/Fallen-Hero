if (global.paused || global.attr_window_open) exit;

var _dt = delta_time / 1000000;

cycle_timer -= _dt;
if (cycle_timer <= 0) {
    is_up = !is_up;
    cycle_timer = is_up ? cycle_up_time : cycle_down_time;
}

if (!is_up) exit;

var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

var _player = instance_find(obj_player, 0);
if (_player != noone) {
    var _cx = clamp(_player.x, x, x + _w);
    var _cy = clamp(_player.y, y, y + _h);
    if (point_distance(_player.x, _player.y, _cx, _cy) < _player.body_radius) {
        tick_timer -= _dt;
        if (tick_timer <= 0) {
            player_take_damage(tick_damage, "physical");
            tick_timer = tick_interval;
        }
    }
}
