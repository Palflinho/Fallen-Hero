var _dt = delta_time / 1000000;
life -= _dt;

x += dir_x * speed_px * _dt;
y += dir_y * speed_px * _dt;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
    player_take_damage(damage);
    instance_destroy();
    exit;
}

if (!fh_place_free_of_walls(x, y, body_radius)) {
    instance_destroy();
    exit;
}

if (life <= 0) instance_destroy();
