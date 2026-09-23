// Atualiza sistema de vibracao e deteccao dinamica de dispositivos
input_rumble_update(delta_time / 1000000);
input_update_device();

// Atualiza módulo de controles touch mobile / emulador PC
touch_controls_update();

// Ticks down regardless of any pause/UI state -- if this lived behind is_world_paused()
// itself, hitstop would freeze permanently the moment it started.
if (global.hitstop_timer > 0) global.hitstop_timer -= delta_time / 1000000;
if (!variable_global_exists("screen_damage_flash")) global.screen_damage_flash = 0;
if (global.screen_damage_flash > 0) global.screen_damage_flash -= delta_time / 1000000;
if (!variable_global_exists("camera_shake")) global.camera_shake = 0;
if (global.camera_shake > 0) global.camera_shake = max(0, global.camera_shake - (delta_time / 1000000) * 30);

if (!variable_global_exists("run_playtime")) global.run_playtime = 0;
if (!is_world_paused()) global.run_playtime += delta_time / 1000000;

var _player = instance_find(obj_player, 0);

// Dispara Diálogo Narrativo de Introdução ao entrar na Sala 1 (Templo da Água)
if (room == Room1 && (!variable_global_exists("dialogue_intro_shown") || !global.dialogue_intro_shown)) {
    global.dialogue_intro_shown = true;
    dialogue_play_id("temple1_water_intro");
}

// Dispara Diálogo Narrativo ao entrar na Sala 5 (Templo do Vento - Fase 3)
if (room == Room5 && (!variable_global_exists("dialogue_wind_intro_shown") || !global.dialogue_wind_intro_shown)) {
    global.dialogue_wind_intro_shown = true;
    dialogue_play_id("temple3_wind_intro");
}

// Dispara Diálogo Narrativo ao entrar na Sala 5.1 (Mercado do Templo 5)
if (room == asset_get_index("room_temple5_shop") && (!variable_global_exists("dialogue_temple5_shop_shown") || !global.dialogue_temple5_shop_shown)) {
    global.dialogue_temple5_shop_shown = true;
    dialogue_play_id("temple5_shop_intro");
}

// Câmera Centralizada Suave no Jogador (Feedback Lele: Jogador sempre no centro da câmera) + Shake
if (view_enabled && view_visible[0] && _player != noone) {
    var _cam = view_camera[0];
    camera_set_view_target(_cam, noone);
    var _vw = camera_get_view_width(_cam);
    var _vh = camera_get_view_height(_cam);
    var _target_cx = clamp(_player.x - _vw * 0.5, 0, max(0, room_width - _vw));
    var _target_cy = clamp(_player.y - _vh * 0.5, 0, max(0, room_height - _vh));
    
    var _cur_cx = camera_get_view_x(_cam);
    var _cur_cy = camera_get_view_y(_cam);
    var _new_cx = lerp(_cur_cx, _target_cx, 0.25);
    var _new_cy = lerp(_cur_cy, _target_cy, 0.25);

    var _shake_x = 0;
    var _shake_y = 0;
    if (global.camera_shake > 0) {
        _shake_x = random_range(-global.camera_shake, global.camera_shake);
        _shake_y = random_range(-global.camera_shake, global.camera_shake);
    }
    camera_set_view_pos(_cam, clamp(_new_cx + _shake_x, 0, max(0, room_width - _vw)), clamp(_new_cy + _shake_y, 0, max(0, room_height - _vh)));
}

if (!level_complete && boss_room && is_final_room && instance_number(obj_enemy_parent) == 0) {
    level_complete = true;
}

if (!boss_room && !mob_clear_chest_spawned && instance_number(obj_enemy_parent) == 0) {
    mob_clear_chest_spawned = true;
}

if (!game_over && _player != noone && _player.state == "dead") {
    game_over = true;
    input_rumble_stop();
    global.paused = false;
    global.attr_window_open = false;
    global.chest_reward_open = false;

    // Mantem 60% do ouro ganho na partida
    if (!variable_global_exists("run_gold_earned")) global.run_gold_earned = 0;
    death_gold_earned = global.run_gold_earned;
    death_gold_kept = round(death_gold_earned * 0.60);
    death_gold_lost = death_gold_earned - death_gold_kept;

    ensure_meta_loaded();
    global.gold = max(0, global.gold - death_gold_lost);
    save_meta();

    global.run_gold_earned = 0;
    clear_save();
}

var _touch_pause = (variable_global_exists("touch_pause_pressed") && global.touch_pause_pressed);

if (game_over) {
    var _touch_tap = false;
    for (var _i = 0; _i < 5; _i++) {
        if (device_mouse_check_button_pressed(_i, mb_left)) _touch_tap = true;
    }
    if (input_check_ui_confirm() || keyboard_check_pressed(ord("C")) || _touch_tap) {
        global.inrun_saved_stats = false;
        global.char_select_direct = true;
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("M"))) {
        global.inrun_saved_stats = false;
        global.char_select_direct = false;
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("R"))) {
        goto_checkpoint();
    }
    exit;
}

if (!variable_global_exists("run_victory")) global.run_victory = false;

if (global.run_victory) {
    if (!variable_instance_exists(id, "victory_mastery_recorded")) {
        victory_mastery_recorded = true;
        if (_player != noone) {
            mastery_unlock(_player.character_class, _player.element_affinity);
        }
    }
}

if (global.run_victory || level_complete) {
    var _touch_tap = false;
    for (var _i = 0; _i < 5; _i++) {
        if (device_mouse_check_button_pressed(_i, mb_left)) _touch_tap = true;
    }
    if (input_check_ui_confirm() || keyboard_check_pressed(ord("C")) || _touch_tap) {
        global.inrun_saved_stats = false;
        clear_save();
        global.run_victory = false;
        level_complete = false;
        global.char_select_direct = true;
        room_goto(room_char_select);
    }
    exit;
}

if (global.chest_reward_open) {
    if (_player != noone) {
        if (input_check_ui_left_pressed()) {
            hud_chest_slot_cursor = max(0, hud_chest_slot_cursor - 1);
        }
        if (input_check_ui_right_pressed()) {
            hud_chest_slot_cursor = min(array_length(_player.talent_slot_ids) - 1, hud_chest_slot_cursor + 1);
        }
        if (input_check_ui_confirm()) {
            equip_chest_talent(_player, hud_chest_slot_cursor);
        }
        if (input_check_ui_cancel() || input_check_slot_discard_pressed()) {
            skip_chest_reward();
        }
        for (var _ks = 0; _ks < array_length(_player.talent_slot_ids); _ks++) {
            if (input_check_slot_pressed(_ks)) equip_chest_talent(_player, _ks);
        }
    }
    exit;
}

if (global.paused || global.attr_window_open) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _win_w = min(960, _gw - 40);
    var _win_h = min(560, _gh - 30);
    var _win_x = (_gw - _win_w) / 2;
    var _win_y = (_gh - _win_h) / 2;
    var _footer_y = _win_y + _win_h - 42;

    var _men_box_w = 310;
    var _men_box_x = _win_x + _win_w / 2 - _men_box_w / 2;

    // Retomar botão ou toque no botão superior direito
    var _touch_resume = _touch_pause 
        || touch_gui_clicked(_win_x + _win_w - 135, _win_y + 8, _win_x + _win_w - 10, _win_y + 38)
        || touch_gui_clicked(_win_x + 30, _footer_y + 5, _win_x + 200, _footer_y + 37);

    // Botão Menu Principal no rodapé (Abandonar Run)
    var _touch_menu = touch_gui_clicked(_men_box_x, _footer_y + 5, _men_box_x + _men_box_w, _footer_y + 37);
    var _pad_abandon = false;
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_select)) {
            _pad_abandon = true;
        }
    }

    if (input_check_ui_cancel() || input_check_pause_pressed() || _touch_resume) {
        global.paused = false;
        global.attr_window_open = false;
    } else if (keyboard_check_pressed(ord("M")) || _touch_menu || _pad_abandon) {
        global.inrun_saved_stats = false;
        global.paused = false;
        global.attr_window_open = false;
        global.midrun_shop_open = false;
        global.chest_reward_open = false;
        room_goto(room_char_select);
    } else if (_player != noone) {
        // Navegacao com D-Pad nos cards de talentos (3 iniciais + 2 extras)
        var _slot_n = array_length(_player.talent_slot_ids);
        if (input_check_ui_up_pressed()) {
            hud_talent_slot_cursor = max(0, hud_talent_slot_cursor - 1);
        }
        if (input_check_ui_down_pressed()) {
            hud_talent_slot_cursor = min(_slot_n - 1, hud_talent_slot_cursor + 1);
        }

        // Y / Triangulo (auxiliar fixo) ou A / Cruz confirma ponto no talento focado
        if (input_check_ui_aux_pressed() || input_check_ui_confirm()) {
            player_apply_talent_point(_player, hud_talent_slot_cursor);
        }

        // Upgrade de talentos por clique tátil nos cards da ficha
        var _panel_gap = 16;
        var _left_w = 380;
        var _right_w = _win_w - _left_w - _panel_gap - 40;
        var _col1_x = _win_x + 20;
        var _col2_x = _col1_x + _left_w + _panel_gap;
        var _content_y = _win_y + 48;
        var _rx = _col2_x + 16;
        var _ry = _content_y + 12 + 22 + 12;
        var _card_w = _right_w - 32;
        var _card_gap = hud_talent_card_gap(_slot_n);
        var _card_h = hud_talent_card_height(_slot_n, _ry, _footer_y - 8);

        for (var _t_idx = 0; _t_idx < _slot_n; _t_idx++) {
            var _cy = _ry + _t_idx * (_card_h + _card_gap);
            if (touch_gui_clicked(_rx, _cy, _rx + _card_w, _cy + _card_h)) {
                hud_talent_slot_cursor = _t_idx;
                player_apply_talent_point(_player, _t_idx);
            }
        }

        for (var _kt = 0; _kt < _slot_n; _kt++) {
            if (input_check_slot_pressed(_kt)) { hud_talent_slot_cursor = _kt; player_apply_talent_point(_player, _kt); }
        }
    }

    if (keyboard_check_pressed(ord("C"))) {
        global.inrun_saved_stats = false;
        global.paused = false;
        global.attr_window_open = false;
        global.char_select_direct = true;
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("Q"))) {
        game_end();
    }
    exit;
}

if (input_check_pause_pressed() || _touch_pause) {
    global.paused = true;
    global.attr_window_open = true;
} else if (keyboard_check_pressed(vk_f1)) {
    global.char_select_direct = true;
    room_goto(room_char_select);
} else if (keyboard_check_pressed(vk_f2)) {
    global.dev_mode = !global.dev_mode;
    save_meta();
    var _px = (_player != noone ? _player.x : 200);
    var _py = (_player != noone ? _player.y - 30 : 200);
    if (global.dev_mode) {
        array_push(global.combat_popups, {
            x: _px,
            y: _py,
            text: tr("MODO DEV: ATIVADO"),
            colour: c_aqua,
            is_crit: true,
            life: 1.5,
            life_max: 1.5,
            vy: -30,
            vx: 0,
            scale: 1.2
        });
    } else {
        array_push(global.combat_popups, {
            x: _px,
            y: _py,
            text: tr("MODO DEV: DESATIVADO"),
            colour: c_yellow,
            is_crit: false,
            life: 1.5,
            life_max: 1.5,
            vy: -30,
            vx: 0,
            scale: 1.1
        });
    }
} else if (keyboard_check_pressed(vk_f4)) {
    global.dev_touch_mode = !global.dev_touch_mode;
    var _px = (_player != noone ? _player.x : 200);
    var _py = (_player != noone ? _player.y - 30 : 200);
    array_push(global.combat_popups, {
        x: _px,
        y: _py,
        text: global.dev_touch_mode ? tr("TOUCH SIM: ATIVADO") : tr("TOUCH SIM: DESATIVADO"),
        colour: global.dev_touch_mode ? c_lime : c_yellow,
        is_crit: true,
        life: 1.5,
        life_max: 1.5,
        vy: -30,
        vx: 0,
        scale: 1.2
    });
}
