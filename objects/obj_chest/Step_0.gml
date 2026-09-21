if (is_world_paused()) exit;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
    sfx_play("chest", 0.04);
    trigger_camera_shake(4);
    if (variable_instance_exists(id, "is_points") && is_points) {
        _player.talent_pending_points += points_amount;
        fx_spawn_sparks(_player.x, _player.y, c_yellow, 20);
        var _txt = (points_amount > 1) ? ("+" + string(points_amount) + " PONTOS DE TALENTO!") : "+1 PONTO DE TALENTO!";
        fx_spawn_damage_popup(_player.x, _player.y - 20, _txt, true, c_yellow);
        instance_destroy();
    } else {
        open_chest_reward(talent_id);
        instance_destroy();
    }
}
