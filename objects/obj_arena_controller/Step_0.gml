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
                var _sp = fh_find_free_spawn_pos(_item.x, _item.y, 28);
                var _e = instance_create_layer(_sp.x, _sp.y, layer, _item.obj);
                if (_e != noone) {
                    var _p_check = instance_find(obj_player, 0);
                    if (_p_check != noone && _p_check.invisible) {
                        _e.has_spotted_player = false;
                        _e.state = "patrol";
                    } else {
                        _e.has_spotted_player = true;
                        _e.state = "chase";
                    }
                    if (variable_struct_exists(_item, "greater") && _item.greater) {
                        _e.is_greater_variant = true;
                    }
                }
                fx_spawn_sparks(_sp.x, _sp.y, theme_colour, 12);
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
                    // Todas as ondas vencidas: o Espirito Elemental do templo desperta
                    arena_state = "spirit_intro";
                    wave_delay_timer = 2.8;
                    banner_text = "O ESPIRITO " + spirit_name + " DESPERTA!";
                    banner_timer = 2.8;
                    sfx_play("thunder", 0.05, 0.8);
                    trigger_camera_shake(5);
                    fx_spawn_sparks(x, y, theme_colour, 30);
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

    case "spirit_intro":
        wave_delay_timer -= _dt;
        if (random(1) < 0.3) fx_spawn_sparks(x + random_range(-40, 40), y + random_range(-40, 40), theme_colour, 1);
        if (wave_delay_timer <= 0) {
            var _sp2 = fh_find_free_spawn_pos(x, y, 28);
            spirit_inst = instance_create_layer(_sp2.x, _sp2.y, layer, spirit_obj);
            arena_state = "spirit";
            banner_text = spirit_name + ", ESPIRITO GUARDIAO DO TEMPLO";
            banner_timer = 2.2;
            fx_spawn_sparks(_sp2.x, _sp2.y, theme_colour, 30);
        }
        break;

    case "spirit":
        if (!instance_exists(spirit_inst) && instance_number(obj_enemy_parent) == 0) {
            arena_state = "victory";
            arena_barrier_active = false;
            banner_text = "* " + spirit_name + " VENCIDO! BAU DO CAMPEAO LIBERADO! *";
            banner_timer = 3.5;
            sfx_play("victory", 0.05, 0.9);
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
