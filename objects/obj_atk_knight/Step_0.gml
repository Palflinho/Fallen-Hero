if (is_world_paused()) exit;

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
    if (!_already_hit && !fh_untargetable && point_distance(x, y, other.x, other.y) <= body_radius + other.body_radius && !fh_line_intersects_wall(other.x, other.y, x, y)) {
        array_push(other.hit_list, id);
        player_on_hit_enemy(other.owner, id, other.damage);
    }
}

if (life <= 0) instance_destroy();
