if (is_world_paused()) exit;

if (!pressed) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
        pressed = true;
        global.boss_buttons_pressed += 1;
        if (global.boss_buttons_pressed >= 4) {
            with (obj_boss_door) instance_destroy();
        }

        // Feedback visual: um rastro de luz voa ate o portal e acende uma das 4 luzes
        sfx_play("magic", 0.05, 1.2);
        fx_spawn_sparks(x, y, c_aqua, 18);
        trigger_camera_shake(2);
        global.seal_ping_timer = 2.5;
        var _gate = noone;
        with (obj_stage_gate) if (trigger_mode == "buttons") _gate = id;
        if (_gate != noone) {
            var _t = instance_create_layer(x, y, layer, obj_seal_trail);
            _t.target_x = _gate.x;
            _t.target_y = _gate.y;
        }
    }
}
