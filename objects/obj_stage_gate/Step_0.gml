if (is_world_paused()) exit;

var _dt = delta_time / 1000000;

var _ready = false;
if (trigger_mode == "always_open" || room == asset_get_index("room_shop")) {
    _ready = true;
} else if (trigger_mode == "boss_dead") {
    var _b3_clear = object_exists(asset_get_index("obj_boss3")) ? (instance_number(asset_get_index("obj_boss3")) == 0) : true;
    var _b4_clear = object_exists(asset_get_index("obj_boss4")) ? (instance_number(asset_get_index("obj_boss4")) == 0) : true;
    _ready = (instance_number(obj_boss) == 0 && instance_number(obj_boss2) == 0 && _b3_clear && _b4_clear);
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

        // Roteamento inteligente do ciclo de 7 etapas da fase
        if (!variable_global_exists("run_biome")) global.run_biome = "water";
        var _dest = target_room;

        // Sala 1 (Exploracao 1) -> Sala 2 (room_exp2)
        if (room == Room1) {
            global.run_biome = "water";
            global.run_room_step = 2;
            _dest = asset_get_index("room_exp2");
        } else if (room == Room3) {
            global.run_biome = "fire";
            global.run_room_step = 2;
            _dest = asset_get_index("room_exp2");
        } else if (room == Room5) {
            global.run_biome = "wind";
            global.run_room_step = 2;
            _dest = asset_get_index("room_exp2");
        } else if (room == Room7) {
            global.run_biome = "earth";
            global.run_room_step = 2;
            _dest = asset_get_index("room_exp2");
        }
        // Sala 2 (Exploracao 2) -> Sala 2.5 (room_arena)
        else if (room == asset_get_index("room_exp2")) {
            global.run_room_step = 2.5;
            _dest = asset_get_index("room_arena");
        }
        // Sala 2.5 (Arena) -> Sala 3 (room_shop)
        else if (room == asset_get_index("room_arena")) {
            global.run_room_step = 3;
            _dest = asset_get_index("room_shop");
        }
        // Sala 3 (Mercado) -> Sala 4 (room_exp4)
        else if (room == asset_get_index("room_shop")) {
            global.run_room_step = 4;
            _dest = asset_get_index("room_exp4");
        }
        // Sala 4 (Exploracao 3) -> Sala 5 (room_preboss)
        else if (room == asset_get_index("room_exp4")) {
            global.run_room_step = 5;
            _dest = asset_get_index("room_preboss");
        }
        // Sala 5 (Pre-Chefe) -> Sala 6 (Chefe correspondente)
        else if (room == asset_get_index("room_preboss")) {
            global.run_room_step = 6;
            if (global.run_biome == "water") _dest = asset_get_index("Room2");
            else if (global.run_biome == "fire") _dest = asset_get_index("Room4");
            else if (global.run_biome == "wind") _dest = asset_get_index("Room6");
            else if (global.run_biome == "earth") _dest = asset_get_index("Room8");
        }
        // Sala 6 (Chefe da Fase) -> Proximo Bioma Sala 1 ou Vitoria
        else if (room == Room2) {
            global.run_biome = "fire";
            global.run_room_step = 1;
            _dest = asset_get_index("Room3");
        } else if (room == Room4) {
            global.run_biome = "wind";
            global.run_room_step = 1;
            _dest = asset_get_index("Room5");
        } else if (room == Room6) {
            global.run_biome = "earth";
            global.run_room_step = 1;
            _dest = asset_get_index("Room7");
        } else if (room == Room8) {
            global.run_victory = true;
            global.paused = true;
            exit;
        }

        if (_dest != noone && room_exists(_dest)) {
            global.boss_buttons_pressed = 0;
            save_checkpoint(room_get_name(_dest));
            room_goto(_dest);
        }
    }
}
