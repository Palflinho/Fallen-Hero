if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
if (banner_timer > 0) banner_timer -= _dt;

var _player = instance_find(obj_player, 0);

switch (arena_state) {
    case "waiting":
        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= trigger_radius) {
            arena_state = "starting";
            banner_text = biome_title + tr(" ATIVADA! PREPARE-SE");
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
            banner_text = tr("ONDA 1 DE ") + string(total_waves);
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
                    banner_text = tr("ONDA ") + string(current_wave) + tr(" SUPERADA!");
                    banner_timer = 2.0;
                    fx_spawn_sparks(x, y, c_yellow, 16);
                } else {
                    // Todas as ondas vencidas: o Espirito Elemental do templo desperta
                    arena_state = "spirit_intro";
                    wave_delay_timer = 2.8;
                    banner_text = tr("O ESPIRITO ") + spirit_name + tr(" DESPERTA!");
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
            banner_text = tr("ONDA ") + string(current_wave) + tr(" DE ") + string(total_waves);
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
            banner_text = spirit_name + tr(", ESPIRITO GUARDIAO DO TEMPLO");
            banner_timer = 2.2;
            fx_spawn_sparks(_sp2.x, _sp2.y, theme_colour, 30);
        }
        break;

    case "spirit":
        if (!instance_exists(spirit_inst) && instance_number(obj_enemy_parent) == 0) {
            // O espirito libertado agradece e encoraja o heroi antes do chefe
            arena_state = "spirit_farewell";
            arena_barrier_active = false;
            banner_text = tr("* ESPIRITO ") + spirit_name + tr(" LIBERTADO! *");
            banner_timer = 3.0;
            sfx_play("victory", 0.05, 0.9);
            fx_spawn_sparks(x, y, theme_colour, 35);
            dialogue_play_id("spirit_freed_" + biome, function() {
                with (obj_arena_controller) arena_state = "victory";
            });
        }
        break;

    case "spirit_farewell":
        // Aguardando o fim do dialogo (o mundo fica pausado enquanto ele esta aberto)
        break;

    case "victory":
        if (!reward_spawned) {
            // Escolha unica: CURA TOTAL ou BAU DE TALENTO
            reward_spawned = true;
            reward_heal_inst = instance_create_layer(x - 130, y + 30, layer, obj_reward_heal);
            reward_chest_inst = instance_create_layer(x + 130, y + 30, layer, obj_chest);
            if (reward_chest_inst != noone) {
                with (reward_chest_inst) {
                    is_points = false;
                    points_amount = 0;
                    if (talent_id == "") talent_id = roll_chest_talent();
                    if (talent_id == "") { is_points = true; points_amount = 3; }
                }
            }
            arena_state = "reward_choice";
            banner_text = tr("ESCOLHA UMA RECOMPENSA: CURA OU TALENTO");
            banner_timer = 4.0;
            fx_spawn_sparks(x, y, c_yellow, 35);
        }
        break;

    case "reward_choice":
        if (!instance_exists(reward_heal_inst) || !instance_exists(reward_chest_inst)) {
            // A outra opcao se desfaz
            if (instance_exists(reward_heal_inst)) {
                fx_spawn_sparks(reward_heal_inst.x, reward_heal_inst.y, c_lime, 14);
                instance_destroy(reward_heal_inst);
            }
            if (instance_exists(reward_chest_inst)) {
                fx_spawn_sparks(reward_chest_inst.x, reward_chest_inst.y, c_yellow, 14);
                instance_destroy(reward_chest_inst);
            }
            arena_state = "done";
            var _gate = instance_create_layer(x, y - 220, layer, obj_stage_gate);
            _gate.trigger_mode = "always_open";
            _gate.reward_type = "gold";
            _gate.reward_value = 18;
            _gate.gate_label = tr("Avanco: Camara do General (Chefe)");
            _gate.gate_colour = make_colour_rgb(230, 80, 255);
            fx_spawn_sparks(x, y - 220, c_yellow, 30);
        }
        break;
}
