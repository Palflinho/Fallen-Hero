if (global.paused || global.attr_window_open) exit;

var _ready = (trigger_mode == "boss_dead")
    ? (instance_number(obj_enemy_parent) == 0)
    : (global.boss_buttons_pressed >= 4);

if (_ready) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
        save_checkpoint(room_get_name(target_room));
        room_goto(target_room);
    }
}
