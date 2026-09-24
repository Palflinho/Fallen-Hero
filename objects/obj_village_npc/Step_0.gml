if (talk_cooldown > 0) talk_cooldown -= delta_time / 1000000;
if (is_world_paused()) exit;

var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

var _dist = point_distance(x, y, _player.x, _player.y);

if (_dist <= interact_radius && talk_cooldown <= 0) {
    var _interact = input_check_ui_confirm() || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space);
    var _touch = touch_room_clicked(x - 24, y - 32, x + 24, y + 24);

    if (_interact || _touch) {
        talk_cooldown = 0.6;

        // Efeito sonoro vocal personalizado por personagem
        var _pitch = 1.0;
        switch (npc_id) {
            case "blacksmith": _pitch = 0.75; break;
            case "alchemist":  _pitch = 1.15; break;
            case "scout":      _pitch = 1.35; break;
            case "oracle":     _pitch = 0.85; break;
        }
        sfx_play("voice_elder", 0.08, _pitch);

        // Resolve dinamicamente a fala reativa (Classe do herói + Essências resgatadas)
        var _scene_id = village_get_npc_dialogue_id(npc_id);
        dialogue_play_id(_scene_id, function() {
            with (obj_village_npc) { talk_cooldown = 0.6; }
        });
    }
}
