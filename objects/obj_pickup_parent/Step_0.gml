bob_timer += 1;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
    with (_player) {
        apply_pickup(other.kind, other.amount);
    }
    instance_destroy();
}
