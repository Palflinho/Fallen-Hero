if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;

with (obj_enemy_parent) {
    // A Agua derruba o que voa (mesma regra do Arqueiro); o resto que estiver intangivel e ignorado
    if (fh_untargetable && !fh_air) continue;
    var _already_hit = false;
    var _ids = other.hit_group.ids;
    for (var _i = 0; _i < array_length(_ids); _i++) {
        if (_ids[_i] == id) {
            _already_hit = true;
            break;
        }
    }
    if (!_already_hit && point_distance(x, y, other.x, other.y) <= body_radius + other.body_radius && !fh_line_intersects_wall(other.x, other.y, x, y)) {
        array_push(other.hit_group.ids, id);
        player_on_hit_enemy(other.owner, id, other.damage);
        if (other.slow) enemy_apply_slow(id, 0.6, 1.5);
    }
}

if (life <= 0) instance_destroy();
