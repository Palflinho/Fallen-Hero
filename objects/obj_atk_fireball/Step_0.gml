var _dt = delta_time / 1000000;
life -= _dt;

x += dir_x * speed_px * _dt;
y += dir_y * speed_px * _dt;

var _hit_something = false;
with (obj_enemy_parent) {
    if (point_distance(x, y, other.x, other.y) <= body_radius + other.body_radius) {
        enemy_take_damage(id, other.damage);
        _hit_something = true;
    }
}

if (_hit_something || life <= 0 || !fh_place_free_of_walls(x, y, body_radius)) {
    instance_destroy();
}
