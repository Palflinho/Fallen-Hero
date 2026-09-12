if (is_world_paused()) exit;

var _dt = delta_time / 1000000;

var _ready = false;
if (trigger_mode == "boss_dead") {
    _ready = (instance_number(obj_boss) == 0 && instance_number(obj_boss2) == 0);
} else if (trigger_mode == "clear_mobs") {
    _ready = (instance_number(obj_enemy_parent) == 0);
} else {
    _ready = (global.boss_buttons_pressed >= 4);
}

if (_ready) {
    sparkle_timer -= _dt;
    if (sparkle_timer <= 0) {
        sparkle_timer = 0.22;
        var _ang = random(360);
        var _r = random_range(radius * 0.3, radius * 0.9);
        fx_spawn_sparks(x + lengthdir_x(_r, _ang), y + lengthdir_y(_r, _ang), gate_colour, 1);
    }

    var _player = instance_find(obj_player, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
        // Concede a recompensa do portal estilo Hades ao cruzar
        if (reward_type == "gold") {
            player_gain_gold(reward_value);
            fx_spawn_reward_popup(_player.x, _player.y, 0, reward_value);
        } else if (reward_type == "heal") {
            _player.hp = min(_player.hp_max, _player.hp + _player.hp_max * 0.40);
            fx_spawn_sparks(_player.x, _player.y, c_lime, 12);
        } else if (reward_type == "talent") {
            var _tid = roll_chest_talent();
            if (_tid != "") open_chest_reward(_tid);
        } else if (reward_type == "boss") {
            _player.hp = min(_player.hp_max, _player.hp + _player.hp_max * 0.25);
            player_gain_gold(reward_value);
            fx_spawn_sparks(_player.x, _player.y, c_aqua, 14);
            fx_spawn_reward_popup(_player.x, _player.y, 0, reward_value);
        } else if (reward_type == "victory") {
            global.run_victory = true;
            global.paused = true;
            exit;
        }

        save_checkpoint(room_get_name(target_room));
        room_goto(target_room);
    }
}
