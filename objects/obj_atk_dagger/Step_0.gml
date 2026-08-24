var _dt = delta_time / 1000000;
life -= _dt;

with (obj_enemy_parent) {
    var _already_hit = false;
    for (var _i = 0; _i < array_length(other.hit_list); _i++) {
        if (other.hit_list[_i] == id) {
            _already_hit = true;
            break;
        }
    }
    if (!_already_hit && point_distance(x, y, other.x, other.y) <= body_radius + other.body_radius) {
        array_push(other.hit_list, id);
        player_on_hit_enemy(other.owner, id, other.damage);
        enemy_apply_poison(id, 3, 0.5, 2);
        enemy_apply_slow(id, 0.5, 1.5);
    }
}

if (life <= 0) instance_destroy();
