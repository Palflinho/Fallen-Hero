var _dt = delta_time / 1000000;
life -= _dt;

if (instance_exists(owner)) {
    x = owner.x;
    y = owner.y;
}

if (!has_hit) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && !_player.invisible && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
        player_take_damage(damage, damage_type);
        has_hit = true;
    }
}

if (life <= 0) instance_destroy();
