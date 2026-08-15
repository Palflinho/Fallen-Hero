if (global.paused || global.attr_window_open) exit;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
    player_apply_poison(tick_damage, tick_interval, poison_duration);
}
