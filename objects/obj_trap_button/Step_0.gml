if (!triggered) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= trigger_radius) {
        triggered = true;
        with (obj_ice_patch) {
            active = true;
        }
    }
}
