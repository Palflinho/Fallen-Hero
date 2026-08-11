if (!pressed) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
        pressed = true;
        global.boss_buttons_pressed += 1;
        if (global.boss_buttons_pressed >= 4) {
            with (obj_boss_door) instance_destroy();
        }
    }
}
