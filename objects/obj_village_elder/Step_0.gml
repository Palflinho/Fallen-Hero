if (is_world_paused()) exit;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 52) {
    var _touch_elder = touch_room_clicked(x - 50, y - 50, x + 50, y + 50);
    if (input_check_ui_confirm() || _touch_elder) {
        sfx_play("voice_elder", 0.08, 0.6);
        if (!talked) {
            talked = true;
            dialogue_play_id("village_elder_intro");
        } else {
            dialogue_play_id("village_pedestals_hint");
        }
    }
}
