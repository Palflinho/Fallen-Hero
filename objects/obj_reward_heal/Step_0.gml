if (is_world_paused()) exit;

bob_t += delta_time / 1000000;
if (random(1) < 0.15) fx_spawn_sparks(x + random_range(-14, 14), y + random_range(-14, 14), c_lime, 1);

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
    _player.hp = _player.hp_max;
    sfx_play("chest", 0.04, 1.2);
    trigger_camera_shake(3);
    fx_spawn_sparks(_player.x, _player.y, c_lime, 24);
    fx_spawn_damage_popup(_player.x, _player.y - 20, "VIDA RESTAURADA!", true, c_lime);
    instance_destroy();
}
