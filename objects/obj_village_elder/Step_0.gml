if (talk_cooldown > 0) talk_cooldown -= delta_time / 1000000;
if (is_world_paused()) exit;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 52) {
    var _touch_elder = touch_room_clicked(x - 50, y - 50, x + 50, y + 50);
    if (talk_cooldown <= 0 && (input_check_ui_confirm() || _touch_elder)) {
        talk_cooldown = 0.6;
        sfx_play("voice_elder", 0.08, 0.6);
        if (!talked) {
            talked = true;
            dialogue_play_id("village_elder_intro", function() {
                with (obj_village_elder) { talk_cooldown = 0.6; }
            });
        } else {
            dialogue_play_id("village_pedestals_hint", function() {
                with (obj_village_elder) { talk_cooldown = 0.6; }
            });
        }
    }
}
