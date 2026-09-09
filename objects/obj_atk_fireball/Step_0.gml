if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;

x += dir_x * speed_px * _dt;
y += dir_y * speed_px * _dt;

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
        if (other.pierce_remaining > 0) {
            other.pierce_remaining -= 1;
        } else {
            other.should_destroy = true;
        }
    }
}

if (should_destroy || life <= 0 || !fh_place_free_of_walls(x, y, body_radius)) {
    instance_destroy();
}
