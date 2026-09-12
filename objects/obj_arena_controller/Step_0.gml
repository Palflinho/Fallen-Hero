if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
if (banner_timer > 0) banner_timer -= _dt;

var _player = instance_find(obj_player, 0);

switch (arena_state) {
    case "waiting":
        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= trigger_radius) {
            arena_state = "starting";
            banner_text = biome_title + " ATIVADA! PREPARE-SE";
            banner_timer = 2.5;
            wave_delay_timer = 2.0;
            arena_barrier_active = true;
            fx_spawn_sparks(x, y, theme_colour, 20);
        }
        break;

    case "starting":
        wave_delay_timer -= _dt;
        if (wave_delay_timer <= 0) {
            arena_state = "active";
            current_wave = 1;
            queue_wave_spawns(biome, current_wave);
            banner_text = "ONDA 1 DE " + string(total_waves);
            banner_timer = 2.2;
        }
        break;

    case "active":
        // Invocação sequencial rápida dos monstros da onda
        if (array_length(spawn_queue) > 0) {
            spawn_timer -= _dt;
            if (spawn_timer <= 0) {
                spawn_timer = 0.35;
                var _item = spawn_queue[0];
                array_delete(spawn_queue, 0, 1);
                var _e = instance_create_layer(_item.x, _item.y, layer, _item.obj);
                if (_e != noone) {
                    _e.has_spotted_player = true;
                    _e.state = "chase";
                }
                fx_spawn_sparks(_item.x, _item.y, theme_colour, 12);
            }
        } else {
            // Verifica se a onda foi totalmente derrotada
            var _living_enemies = instance_number(obj_enemy_parent);
            if (_living_enemies == 0) {
                if (current_wave < total_waves) {
                    arena_state = "wave_cleared";
                    wave_delay_timer = 2.2;
                    banner_text = "ONDA " + string(current_wave) + " SUPERADA!";
                    banner_timer = 2.0;
                    fx_spawn_sparks(x, y, c_yellow, 16);
                } else {
                    arena_state = "victory";
                    arena_barrier_active = false;
                    banner_text = "✦ ARENA CONQUISTADA! BAU DO CAMPEAO LIBERADO! ✦";
                    banner_timer = 3.5;
                }
            }
        }
        break;

    case "wave_cleared":
        wave_delay_timer -= _dt;
        if (wave_delay_timer <= 0) {
            current_wave += 1;
            arena_state = "active";
            queue_wave_spawns(biome, current_wave);
            banner_text = "ONDA " + string(current_wave) + " DE " + string(total_waves);
            banner_timer = 2.2;
            fx_spawn_sparks(x, y, theme_colour, 20);
        }
        break;

    case "victory":
        if (!reward_spawned) {
            reward_spawned = true;
            var _chest = instance_create_layer(x, y + 20, layer, obj_chest);
            var _gate = instance_create_layer(x, y - 220, layer, obj_stage_gate);
            _gate.trigger_mode = "always_open";
            _gate.target_room = asset_get_index("room_shop");
            _gate.reward_type = "heal";
            _gate.gate_label = "Avanco: O Mercador Arcano (Loja)";
            _gate.gate_colour = c_yellow;
            fx_spawn_sparks(x, y, c_yellow, 35);
        }
        break;
}
