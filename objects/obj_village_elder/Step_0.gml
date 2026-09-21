if (is_world_paused()) exit;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 52) {
    if (input_check_ui_confirm()) {
        sfx_play("voice_elder", 0.08, 0.6);
        if (!talked) {
            talked = true;
            dialogue_play_id("village_elder_intro");
        } else {
            dialogue_play_id("village_pedestals_hint");
        }
    }
}
