// =========================================================================
// PORTAL DA FENDA (obj_village_portal) - Fallen Hero
// =========================================================================
// Ponto de partida para a expedição roguelite pelas catacumbas.
// Ao interagir com o portal, abre a tela de PREPARAÇÃO DE TALENTOS DA RUN.
// (A seleção de personagens fica dedicada na Casa dos Heróis).
// =========================================================================

vortex_timer = 0;
hum_sound_timer = 1.0;
portal_radius = 48;

// Bonecos de treino ao lado do caminho de saida da vila (ensinam ataque e defesa sem tutorial)
if (!instance_exists(obj_training_dummy)) {
    var _d1 = fh_find_free_spawn_pos(x - 230, y + 640, 20);
    var _dummy_a = instance_create_layer(_d1.x, _d1.y, layer, obj_training_dummy);
    _dummy_a.mode = "static";
    var _d2 = fh_find_free_spawn_pos(x + 230, y + 640, 20);
    var _dummy_b = instance_create_layer(_d2.x, _d2.y, layer, obj_training_dummy);
    _dummy_b.mode = "attacker";
}

modal_open = false;
interact_cooldown = 0;
notice_timer = 0;
notice_text = "";

// Lista de talentos e slots de build da run
talent_select_list = [];
talent_selected_ids = [];
talent_cursor = 0;
scroll_row = 0;
max_equipped_slots = 3;

function refresh_talents_list() {
    var _p_char = variable_global_exists("selected_character") ? global.selected_character : "knight";
    var _p_elem = variable_global_exists("selected_element") ? global.selected_element : "none";
    
    ensure_meta_loaded();

    var _all = get_talents_for_character_and_affinity(_p_char, _p_elem);
    var _unlocked = [];
    for (var _i = 0; _i < array_length(_all); _i++) {
        var _t = _all[_i];
        if (talent_is_unlocked(_t.id)) {
            array_push(_unlocked, _t);
        }
    }
    talent_select_list = _unlocked;

    if (array_length(talent_select_list) > 0) {
        talent_cursor = clamp(talent_cursor, 0, array_length(talent_select_list) - 1);
    } else {
        talent_cursor = 0;
    }
    scroll_row = 0;
}

function open_portal_modal() {
    modal_open = true;
    global.village_modal_open = true;
    notice_timer = 0;
    notice_text = "";

    with (obj_player) {
        defend_active = false;
        defend_timer = 0;
        attack_buffer_timer = 0;
        state = "idle";
    }
    keyboard_clear(ord("X"));
    keyboard_clear(vk_space);
    keyboard_clear(vk_enter);
    keyboard_clear(ord("Z"));
    io_clear();

    // Sincroniza talentos já equipados pelo jogador
    talent_selected_ids = [];
    if (variable_global_exists("chosen_talent_ids") && is_array(global.chosen_talent_ids)) {
        for (var _t = 0; _t < array_length(global.chosen_talent_ids); _t++) {
            var _tid = global.chosen_talent_ids[_t];
            if (_tid != "" && is_string(_tid)) {
                array_push(talent_selected_ids, _tid);
            }
        }
    }

    refresh_talents_list();
    sfx_play("portal_hum", 0.05, 0.6);
}

function close_portal_modal() {
    modal_open = false;
    global.village_modal_open = false;
    interact_cooldown = 0.4;
    with (obj_player) {
        defend_active = false;
        defend_timer = 0;
        attack_buffer_timer = 0;
        state = "idle";
    }
    keyboard_clear(ord("X"));
    keyboard_clear(vk_space);
    keyboard_clear(vk_enter);
    keyboard_clear(ord("Z"));
    io_clear();
    sfx_play("menu_select");
}

function toggle_equip_talent(_tid) {
    if (_tid == "" || is_undefined(_tid)) return;

    var _found_idx = -1;
    for (var _i = 0; _i < array_length(talent_selected_ids); _i++) {
        if (talent_selected_ids[_i] == _tid) {
            _found_idx = _i;
            break;
        }
    }

    if (_found_idx != -1) {
        // Desequipa talento
        array_delete(talent_selected_ids, _found_idx, 1);
        sfx_play("menu_select");
    } else {
        // Equipa talento
        if (array_length(talent_selected_ids) < max_equipped_slots) {
            array_push(talent_selected_ids, _tid);
            sfx_play("equip");
        } else {
            notice_text = tr("Limite de 3 talentos atingido! Desequipe um para equipar outro.");
            notice_timer = 75;
            sfx_play("stagger", 0.05, 0.7);
        }
    }
}

function start_expedition() {
    // Grava os talentos selecionados
    global.chosen_talent_ids = ["", "", ""];
    for (var _i = 0; _i < array_length(talent_selected_ids) && _i < max_equipped_slots; _i++) {
        global.chosen_talent_ids[_i] = talent_selected_ids[_i];
    }

    var _p_char = variable_global_exists("selected_character") ? global.selected_character : "knight";
    var _p_elem = variable_global_exists("selected_element") ? global.selected_element : "none";

    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        _player.talent_slot_ids = global.chosen_talent_ids;
        player_change_class(_player, _p_char, _p_elem, global.chosen_talent_ids);
    }

    if (variable_global_exists("current_save_slot")) {
        save_slot_save_character_select(global.current_save_slot, _p_char, _p_elem, global.chosen_talent_ids);
    }

    modal_open = false;
    global.village_modal_open = false;

    sfx_play("magic", 0.05, 0.8);
    trigger_camera_shake(5);

    // Save automatico: entrar no portal da vila salva o progresso antes da expedicao
    global.inrun_saved_stats = false;
    global.use_saved_stats = false;
    global.run_gold_earned = 0;
    run_stats_reset();
    run_start_autosave();

    if (all_elements_reclaimed()) {
        // Todas as essencias recuperadas! Abre passagem ao Templo 5 (O Humano)
        global.run_biome = "human";
        global.run_room_step = 1;
        room_goto(asset_get_index("room_temple5_shop"));
    } else {
        // Inicia Expedicao pelos Templos Elementais (começando pelo Templo da Agua)
        global.run_biome = "water";
        global.run_room_step = 1;
        global.temple_arena_layout = irandom(3);
        global.temple_arena_biome = "water";
        room_goto(Room1);
    }
}
