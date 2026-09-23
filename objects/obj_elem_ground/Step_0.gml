if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;
if (life <= 0) {
    instance_destroy();
    exit;
}

if (kind == "fire") {
    if (tick_timer > 0) tick_timer -= _dt;
    var _p = elem_player();
    if (_p != noone && tick_timer <= 0 && point_distance(x, y, _p.x, _p.y) <= radius + _p.body_radius * 0.5) {
        player_take_damage(damage, "magical");
        tick_timer = tick_interval;
    }
    if (random(1) < 0.15) fx_spawn_sparks(x + random_range(-radius, radius) * 0.6, y + random_range(-radius, radius) * 0.6, c_orange, 1);
}
