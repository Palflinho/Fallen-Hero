if (locked_warning_timer > 0) locked_warning_timer--;
if (reset_notice_timer > 0) reset_notice_timer--;
if (save_notice_timer > 0) save_notice_timer--;

// Alternar Modo Dev com F1, F2 ou toque no indicador superior esquerdo
var _is_mobile_dev = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));
var _touch_dev = _is_mobile_dev && touch_room_clicked(12, 12, 280, 42);

if (keyboard_check_pressed(vk_f1) || keyboard_check_pressed(vk_f2) || _touch_dev) {
    global.dev_mode = !global.dev_mode;
    save_meta();
    if (state == "select_talents") {
        var _character = classes[selected_index];
        var _elem_current = elements[selected_element_index];
        if (element_is_unlocked(_elem_current, _character)) {
            var _all = get_talents_for_character_and_affinity(_character, _elem_current);
            var _unlocked = [];
            for (var i = 0; i < array_length(_all); i++) {
                if (talent_is_unlocked(_all[i].id)) array_push(_unlocked, _all[i]);
            }
            talent_select_list = _unlocked;
        } else {
            talent_select_list = [];
        }
        talent_select_cursor = 0;
        talent_grid_scroll_row = 0;
    }
}

// Resetar elementos da campanha para testes com F3
if (keyboard_check_pressed(vk_f3)) {
    global.meta_elements = {
        knight: {water: false, fire: false, wind: false, earth: false},
        mage: {water: false, fire: false, wind: false, earth: false},
        archer: {water: false, fire: false, wind: false, earth: false},
        assassin: {water: false, fire: false, wind: false, earth: false},
        water: false, fire: false, wind: false, earth: false
    };
    global.dev_mode = false;
    save_meta();
    reset_notice_timer = 120;
    if (state == "select_talents") {
        var _character = classes[selected_index];
        var _elem_current = elements[selected_element_index];
        if (element_is_unlocked(_elem_current, _character)) {
            var _all = get_talents_for_character_and_affinity(_character, _elem_current);
            var _unlocked = [];
            for (var i = 0; i < array_length(_all); i++) {
                if (talent_is_unlocked(_all[i].id)) array_push(_unlocked, _all[i]);
            }
            talent_select_list = _unlocked;
        } else {
            talent_select_list = [];
        }
        talent_select_cursor = 0;
        talent_grid_scroll_row = 0;
        talent_selected_ids = [];
    }
}

// Alternar Modo Touch Simulado com F4
if (keyboard_check_pressed(vk_f4)) {
    global.dev_touch_mode = !global.dev_touch_mode;
}

switch (state) {
    case "main_menu":
        var _opt_count = array_length(main_menu_options);
        var _menu_start_x = (room_width - main_menu_btn_w) / 2;
        var _menu_start_y = 250;

        // Suporte a clique / toque nos botões do Menu Principal
        for (var _i = 0; _i < _opt_count; _i++) {
            var _bx = _menu_start_x;
            var _by = _menu_start_y + _i * (main_menu_btn_h + main_menu_btn_gap);
            if (touch_room_clicked(_bx, _by, _bx + main_menu_btn_w, _by + main_menu_btn_h)) {
                main_menu_cursor = _i;
                switch (_i) {
                    case 0: // Novo Jogo -> abre tela de 3 slots
                        save_slot_action = "new_game";
                        save_slot_cursor = global.current_save_slot - 1;
                        state = "save_slots";
                        break;
                    case 1: // Continuar -> abre tela de 3 slots
                        if (any_save_slot_exists()) {
                            save_slot_action = "continue";
                            save_slot_cursor = global.current_save_slot - 1;
                            state = "save_slots";
                        }
                        break;
                    case 2: // Sair
                        game_end();
                        break;
                }
            }
        }

        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            main_menu_cursor = (main_menu_cursor - 1 + _opt_count) mod _opt_count;
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            main_menu_cursor = (main_menu_cursor + 1) mod _opt_count;
        }

        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            switch (main_menu_cursor) {
                case 0: // Novo Jogo -> abre tela de 3 slots
                    save_slot_action = "new_game";
                    save_slot_cursor = global.current_save_slot - 1;
                    state = "save_slots";
                    break;
                case 1: // Continuar -> abre tela de 3 slots
                    if (any_save_slot_exists()) {
                        save_slot_action = "continue";
                        save_slot_cursor = global.current_save_slot - 1;
                        state = "save_slots";
                    }
                    break;
                case 2: // Sair
                    game_end();
                    break;
            }
        }
        break;

    case "save_slots":
        var _total_w = 3 * save_card_w + 2 * save_card_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _card_y = 160;

        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
            save_slot_cursor = (save_slot_cursor - 1 + 3) mod 3;
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
            save_slot_cursor = (save_slot_cursor + 1) mod 3;
        }
        if (keyboard_check_pressed(ord("1"))) save_slot_cursor = 0;
        if (keyboard_check_pressed(ord("2"))) save_slot_cursor = 1;
        if (keyboard_check_pressed(ord("3"))) save_slot_cursor = 2;

        var _slot_to_confirm = -1;

        // Clique / toque nos 3 cards e nos botões de exclusão
        for (var _s = 0; _s < 3; _s++) {
            var _cx = _start_x + _s * (save_card_w + save_card_gap);

            // Botão excluir no canto do card
            var _del_x = _cx + save_card_w - 42;
            var _del_y = _card_y + 12;
            if (save_slot_exists(_s + 1) && touch_room_clicked(_del_x, _del_y, _del_x + 32, _del_y + 32)) {
                save_slot_delete(_s + 1);
                save_notice_text = "Slot " + string(_s + 1) + " apagado com sucesso!";
                save_notice_timer = 90;
                continue;
            }

            // Clique no corpo do card
            if (touch_room_clicked(_cx, _card_y, _cx + save_card_w, _card_y + save_card_h)) {
                save_slot_cursor = _s;
                _slot_to_confirm = _s + 1;
            }
        }

        // Excluir slot selecionado com a tecla Delete
        if (keyboard_check_pressed(vk_delete)) {
            var _target_slot = save_slot_cursor + 1;
            if (save_slot_exists(_target_slot)) {
                save_slot_delete(_target_slot);
                save_notice_text = "Slot " + string(_target_slot) + " apagado com sucesso!";
                save_notice_timer = 90;
            }
        }

        // Tecla de confirmação
        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            _slot_to_confirm = save_slot_cursor + 1;
        }

        if (_slot_to_confirm > 0) {
            var _chosen_slot = _slot_to_confirm;
            if (save_slot_action == "new_game") {
                // RESET TOTAL E GENUÍNO DO NOVO JOGO
                save_slot_init_new_game(_chosen_slot);
                global.current_save_slot = _chosen_slot;
                selected_index = 0;
                selected_element_index = 0;
                talent_selected_ids = [];
                save_notice_text = "Novo jogo iniciado no Slot " + string(_chosen_slot) + "!";
                save_notice_timer = 90;
                state = "select";
            } else if (save_slot_action == "continue") {
                if (save_slot_exists(_chosen_slot)) {
                    save_slot_load(_chosen_slot);
                    // Atualiza herói e elemento selecionados com base no save
                    for (var _k = 0; _k < array_length(classes); _k++) {
                        if (classes[_k] == global.save_character) {
                            selected_index = _k;
                            break;
                        }
                    }
                    for (var _e = 0; _e < array_length(elements); _e++) {
                        if (elements[_e] == global.save_element) {
                            selected_element_index = _e;
                            break;
                        }
                    }
                    talent_selected_ids = [];
                    for (var _t = 0; _t < array_length(global.chosen_talent_ids); _t++) {
                        if (global.chosen_talent_ids[_t] != "") {
                            array_push(talent_selected_ids, global.chosen_talent_ids[_t]);
                        }
                    }
                    save_notice_text = "Slot " + string(_chosen_slot) + " carregado com sucesso!";
                    save_notice_timer = 90;
                    state = "select";
                } else {
                    save_notice_text = "Slot " + string(_chosen_slot) + " esta vazio!";
                    save_notice_timer = 60;
                }
            }
        }

        // Botão voltar no rodapé
        var _btn_back_y = room_height - 60;
        var _btn_back_h = 42;
        if (touch_room_clicked(40, _btn_back_y, 200, _btn_back_y + _btn_back_h) || keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape)) {
            state = "main_menu";
        }
        break;

    case "select":
        var _n = array_length(classes);
        var _total_w = _n * box_w + (_n - 1) * box_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _y = room_height / 2 - box_h / 2 + 10;

        // Seletor de Slot ativo na tela de seleção (1, 2, 3)
        var _slot_bar_w = 360;
        var _slot_bar_x = (room_width - _slot_bar_w) / 2;
        var _slot_bar_y = 38;
        for (var _s = 1; _s <= 3; _s++) {
            var _sbx = _slot_bar_x + (_s - 1) * 125;
            if (touch_room_clicked(_sbx, _slot_bar_y, _sbx + 110, _slot_bar_y + 32)) {
                global.current_save_slot = _s;
                load_meta_from_disk();
                save_notice_text = "Slot ativo alterado para Slot " + string(_s);
                save_notice_timer = 60;
            }
        }
        if (keyboard_check_pressed(ord("1"))) { global.current_save_slot = 1; load_meta_from_disk(); save_notice_text = "Slot ativo: Slot 1"; save_notice_timer = 60; }
        if (keyboard_check_pressed(ord("2"))) { global.current_save_slot = 2; load_meta_from_disk(); save_notice_text = "Slot ativo: Slot 2"; save_notice_timer = 60; }
        if (keyboard_check_pressed(ord("3"))) { global.current_save_slot = 3; load_meta_from_disk(); save_notice_text = "Slot ativo: Slot 3"; save_notice_timer = 60; }

        // Salvamento explícito do perfil no slot escolhido com G
        var _btn_sel_y = room_height - 62;
        var _btn_sel_h = 42;
        var _save_btn_x = room_width / 2 + 30;
        var _save_btn_w = 200;
        if (keyboard_check_pressed(ord("G")) || touch_room_clicked(_save_btn_x, _btn_sel_y, _save_btn_x + _save_btn_w, _btn_sel_y + _btn_sel_h)) {
            save_slot_save_character_select(global.current_save_slot, classes[selected_index], elements[selected_element_index], talent_selected_ids);
            save_notice_text = "Perfil salvo com sucesso no Slot " + string(global.current_save_slot) + "!";
            save_notice_timer = 120;
        }

        // Toque / clique direto nos cards de heróis
        for (var _i = 0; _i < _n; _i++) {
            var _bx = _start_x + _i * (box_w + box_gap);
            if (touch_room_clicked(_bx, _y, _bx + box_w, _y + box_h + 50)) {
                if (selected_index == _i) {
                    var _character = classes[selected_index];
                    var _elem_current = elements[selected_element_index];
                    if (element_is_unlocked(_elem_current, _character)) {
                        var _all = get_talents_for_character_and_affinity(_character, _elem_current);
                        var _unlocked = [];
                        for (var i = 0; i < array_length(_all); i++) {
                            if (talent_is_unlocked(_all[i].id)) array_push(_unlocked, _all[i]);
                        }
                        talent_select_list = _unlocked;
                    } else {
                        talent_select_list = [];
                    }
                    talent_select_cursor = 0;
                    talent_grid_scroll_row = 0;
                    talent_selected_ids = [];
                    state = "select_talents";
                } else {
                    selected_index = _i;
                }
            }
        }

        // Setas laterais para mobile
        var _is_mobile = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));
        if (_is_mobile) {
            if (touch_room_clicked(_start_x - 70, _y + box_h / 2 - 35, _start_x - 10, _y + box_h / 2 + 35)) {
                selected_index = (selected_index - 1 + _n) mod _n;
            }
            if (touch_room_clicked(_start_x + _total_w + 10, _y + box_h / 2 - 35, _start_x + _total_w + 70, _y + box_h / 2 + 35)) {
                selected_index = (selected_index + 1) mod _n;
            }
        }

        // Botões de ação na base da tela
        if (touch_room_clicked(40, _btn_sel_y, 190, _btn_sel_y + _btn_sel_h)) {
            state = "main_menu";
        }
        if (touch_room_clicked(room_width / 2 - 210, _btn_sel_y, room_width / 2 + 10, _btn_sel_y + _btn_sel_h)) {
            var _character = classes[selected_index];
            var _elem_current = elements[selected_element_index];
            if (element_is_unlocked(_elem_current, _character)) {
                var _all = get_talents_for_character_and_affinity(_character, _elem_current);
                var _unlocked = [];
                for (var i = 0; i < array_length(_all); i++) {
                    if (talent_is_unlocked(_all[i].id)) array_push(_unlocked, _all[i]);
                }
                talent_select_list = _unlocked;
            } else {
                talent_select_list = [];
            }
            talent_select_cursor = 0;
            talent_grid_scroll_row = 0;
            talent_selected_ids = [];
            state = "select_talents";
        }
        if (touch_room_clicked(room_width - 240, _btn_sel_y, room_width - 40, _btn_sel_y + _btn_sel_h)) {
            shop_tab_index = selected_index;
            shop_talent_index = 0;
            shop_grid_scroll_row = 0;
            state = "shop";
        }

        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) selected_index = (selected_index + 1) mod _n;
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) selected_index = (selected_index - 1 + _n) mod _n;

        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
            var _character = classes[selected_index];
            var _elem_current = elements[selected_element_index];
            if (element_is_unlocked(_elem_current, _character)) {
                var _all = get_talents_for_character_and_affinity(_character, _elem_current);
                var _unlocked = [];
                for (var i = 0; i < array_length(_all); i++) {
                    if (talent_is_unlocked(_all[i].id)) array_push(_unlocked, _all[i]);
                }
                talent_select_list = _unlocked;
            } else {
                talent_select_list = [];
            }
            talent_select_cursor = 0;
            talent_grid_scroll_row = 0;
            talent_selected_ids = [];
            state = "select_talents";
        }

        if (keyboard_check_pressed(ord("S"))) {
            shop_tab_index = selected_index;
            shop_talent_index = 0;
            shop_grid_scroll_row = 0;
            state = "shop";
        }

        if (keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape)) {
            state = "main_menu";
        }
        break;

    case "select_talents":
        var _m = array_length(talent_select_list);
        var _el_n = array_length(elements);
        var _elem_changed = false;

        // Troca de elemento por toque / clique no cabeçalho
        if (touch_room_clicked(room_width / 2 - 320, 50, room_width / 2 - 240, 84)) {
            selected_element_index = (selected_element_index - 1 + _el_n) mod _el_n;
            _elem_changed = true;
        }
        if (touch_room_clicked(room_width / 2 + 240, 50, room_width / 2 + 320, 84)) {
            selected_element_index = (selected_element_index + 1) mod _el_n;
            _elem_changed = true;
        }

        if (keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("A"))) {
            selected_element_index = (selected_element_index - 1 + _el_n) mod _el_n;
            _elem_changed = true;
        }
        if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("D"))) {
            selected_element_index = (selected_element_index + 1) mod _el_n;
            _elem_changed = true;
        }

        if (_elem_changed) {
            var _elem_current = elements[selected_element_index];
            if (element_is_unlocked(_elem_current, classes[selected_index])) {
                var _new_all = get_talents_for_character_and_affinity(classes[selected_index], _elem_current);
                var _new_unlocked = [];
                for (var i = 0; i < array_length(_new_all); i++) {
                    if (talent_is_unlocked(_new_all[i].id)) array_push(_new_unlocked, _new_all[i]);
                }
                talent_select_list = _new_unlocked;
            } else {
                talent_select_list = [];
            }
            talent_select_cursor = 0;
            talent_grid_scroll_row = 0;
            _m = array_length(talent_select_list);

            var _valid_ids = [];
            for (var j = 0; j < array_length(talent_selected_ids); j++) {
                for (var k = 0; k < _m; k++) {
                    if (talent_select_list[k].id == talent_selected_ids[j]) {
                        array_push(_valid_ids, talent_selected_ids[j]);
                        break;
                    }
                }
            }
            talent_selected_ids = _valid_ids;
        }

        var _grid_start_y = 126;

        if (_m > 0) {
            var _cols = min(talent_grid_cols, _m);
            if (_cols <= 0) _cols = 1;
            var _total_grid_w = _cols * talent_card_w + (_cols - 1) * talent_card_gap_x;
            var _start_x = (room_width - _total_grid_w) / 2;
            var _total_rows = ceil(_m / _cols);
            var _start_vis_row = talent_grid_scroll_row;
            var _end_vis_row = min(_total_rows, _start_vis_row + talent_grid_visible_rows);

            // Setas de rolagem táteis
            if (_start_vis_row > 0 && touch_room_clicked(room_width / 2 - 120, _grid_start_y - 26, room_width / 2 + 120, _grid_start_y)) {
                talent_grid_scroll_row -= 1;
            }
            if (_end_vis_row < _total_rows && touch_room_clicked(room_width / 2 - 120, _grid_start_y + talent_grid_visible_rows * (talent_card_h + talent_card_gap_y), room_width / 2 + 120, _grid_start_y + talent_grid_visible_rows * (talent_card_h + talent_card_gap_y) + 26)) {
                talent_grid_scroll_row += 1;
            }

            // Clique nos cards da grade de talentos
            for (var _row = _start_vis_row; _row < _end_vis_row; _row++) {
                for (var _col = 0; _col < _cols; _col++) {
                    var _i = _row * _cols + _col;
                    if (_i >= _m) break;
                    var _cx = _start_x + _col * (talent_card_w + talent_card_gap_x);
                    var _cy = _grid_start_y + (_row - _start_vis_row) * (talent_card_h + talent_card_gap_y);

                    if (touch_room_clicked(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h)) {
                        talent_select_cursor = _i;
                        var _id = talent_select_list[_i].id;
                        var _idx = -1;
                        for (var j = 0; j < array_length(talent_selected_ids); j++) {
                            if (talent_selected_ids[j] == _id) {
                                _idx = j;
                                break;
                            }
                        }
                        if (_idx >= 0) {
                            array_delete(talent_selected_ids, _idx, 1);
                        } else if (array_length(talent_selected_ids) < 3) {
                            array_push(talent_selected_ids, _id);
                        }
                    }
                }
            }

            if (keyboard_check_pressed(vk_right)) {
                talent_select_cursor = (talent_select_cursor + 1) mod _m;
            }
            if (keyboard_check_pressed(vk_left)) {
                talent_select_cursor = (talent_select_cursor - 1 + _m) mod _m;
            }
            if (keyboard_check_pressed(vk_down)) {
                if (talent_select_cursor + _cols < _m) {
                    talent_select_cursor += _cols;
                } else {
                    talent_select_cursor = talent_select_cursor mod _cols;
                }
            }
            if (keyboard_check_pressed(vk_up)) {
                if (talent_select_cursor - _cols >= 0) {
                    talent_select_cursor -= _cols;
                } else {
                    var _target = (_total_rows - 1) * _cols + (talent_select_cursor mod _cols);
                    if (_target >= _m) _target = _m - 1;
                    talent_select_cursor = _target;
                }
            }

            // Atualiza rolagem da grade para manter cursor visivel
            var _cur_row = talent_select_cursor div _cols;
            if (_cur_row < talent_grid_scroll_row) {
                talent_grid_scroll_row = _cur_row;
            } else if (_cur_row >= talent_grid_scroll_row + talent_grid_visible_rows) {
                talent_grid_scroll_row = _cur_row - talent_grid_visible_rows + 1;
            }

            if (mouse_wheel_up() && talent_grid_scroll_row > 0) {
                talent_grid_scroll_row -= 1;
            }
            if (mouse_wheel_down()) {
                if (talent_grid_scroll_row + talent_grid_visible_rows < _total_rows) {
                    talent_grid_scroll_row += 1;
                }
            }

            if (keyboard_check_pressed(vk_space)) {
                var _id = talent_select_list[talent_select_cursor].id;
                var _idx = -1;
                for (var i = 0; i < array_length(talent_selected_ids); i++) {
                    if (talent_selected_ids[i] == _id) {
                        _idx = i;
                        break;
                    }
                }
                if (_idx >= 0) {
                    array_delete(talent_selected_ids, _idx, 1);
                } else if (array_length(talent_selected_ids) < 3) {
                    array_push(talent_selected_ids, _id);
                }
            }
        }

        // Botões inferiores em "select_talents"
        var _btn_tal_y = 650;
        var _btn_tal_h = 46;
        if (touch_room_clicked(60, _btn_tal_y, 240, _btn_tal_y + _btn_tal_h)) {
            state = "select";
        }
        if (touch_room_clicked(room_width - 380, _btn_tal_y, room_width - 60, _btn_tal_y + _btn_tal_h)) {
            var _elem_current = elements[selected_element_index];
            if (!element_is_unlocked(_elem_current, classes[selected_index])) {
                locked_warning_timer = 90;
            } else {
                global.selected_character = classes[selected_index];
                global.selected_element = _elem_current;
                global.use_saved_stats = false;

                global.chosen_talent_ids = ["", "", ""];
                for (var i = 0; i < array_length(talent_selected_ids); i++) {
                    global.chosen_talent_ids[i] = talent_selected_ids[i];
                }

                save_checkpoint_fresh(global.selected_character, "Room1", global.selected_element);
                global.run_biome = "water";
                global.run_room_step = 1;
                global.inrun_saved_stats = false;
                room_goto(Room1);
            }
        }

        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter)) {
            var _elem_current = elements[selected_element_index];
            if (!element_is_unlocked(_elem_current, classes[selected_index])) {
                locked_warning_timer = 90;
            } else {
                global.selected_character = classes[selected_index];
                global.selected_element = _elem_current;
                global.use_saved_stats = false;

                global.chosen_talent_ids = ["", "", ""];
                for (var i = 0; i < array_length(talent_selected_ids); i++) {
                    global.chosen_talent_ids[i] = talent_selected_ids[i];
                }

                save_checkpoint_fresh(global.selected_character, "Room1", global.selected_element);
                global.run_biome = "water";
                global.run_room_step = 1;
                global.inrun_saved_stats = false;
                room_goto(Room1);
            }
        }

        if (keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape)) {
            state = "select";
        }
        break;

    case "shop":
        var _cn = array_length(classes);
        var _tab_w = 170;
        var _tab_gap = 16;
        var _total_tabs_w = _cn * _tab_w + (_cn - 1) * _tab_gap;
        var _start_tab_x = (room_width - _total_tabs_w) / 2;
        var _tab_y = 60;

        // Setas para navegação rápida de abas
        if (touch_room_clicked(_start_tab_x - 50, _tab_y - 4, _start_tab_x, _tab_y + 36)) {
            shop_tab_index = (shop_tab_index - 1 + _cn) mod _cn;
            shop_talent_index = 0;
            shop_grid_scroll_row = 0;
        }
        if (touch_room_clicked(_start_tab_x + _total_tabs_w, _tab_y - 4, _start_tab_x + _total_tabs_w + 50, _tab_y + 36)) {
            shop_tab_index = (shop_tab_index + 1) mod _cn;
            shop_talent_index = 0;
            shop_grid_scroll_row = 0;
        }

        // Clique / toque nas abas de classes da loja
        for (var _i = 0; _i < _cn; _i++) {
            var _tx = _start_tab_x + _i * (_tab_w + _tab_gap);
            if (touch_room_clicked(_tx, _tab_y, _tx + _tab_w, _tab_y + 34)) {
                shop_tab_index = _i;
                shop_talent_index = 0;
                shop_grid_scroll_row = 0;
            }
        }

        if (keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("A"))) {
            shop_tab_index = (shop_tab_index - 1 + _cn) mod _cn;
            shop_talent_index = 0;
            shop_grid_scroll_row = 0;
        }
        if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("D"))) {
            shop_tab_index = (shop_tab_index + 1) mod _cn;
            shop_talent_index = 0;
            shop_grid_scroll_row = 0;
        }

        var _tab_talents = get_talents_for_character(classes[shop_tab_index]);
        var _tn = array_length(_tab_talents);
        var _grid_shop_y = 110;

        if (_tn > 0) {
            var _cols = min(talent_grid_cols, _tn);
            if (_cols <= 0) _cols = 1;
            var _total_grid_w = _cols * talent_card_w + (_cols - 1) * talent_card_gap_x;
            var _start_x = (room_width - _total_grid_w) / 2;
            var _total_s_rows = ceil(_tn / _cols);
            var _start_vis_s_row = shop_grid_scroll_row;
            var _end_vis_s_row = min(_total_s_rows, _start_vis_s_row + shop_grid_visible_rows);

            // Setas de rolagem da loja
            if (_start_vis_s_row > 0 && touch_room_clicked(room_width / 2 - 120, _grid_shop_y - 26, room_width / 2 + 120, _grid_shop_y)) {
                shop_grid_scroll_row -= 1;
            }
            if (_end_vis_s_row < _total_s_rows && touch_room_clicked(room_width / 2 - 120, _grid_shop_y + shop_grid_visible_rows * (talent_card_h + talent_card_gap_y), room_width / 2 + 120, _grid_shop_y + shop_grid_visible_rows * (talent_card_h + talent_card_gap_y) + 26)) {
                shop_grid_scroll_row += 1;
            }

            // Clique nos cards da loja
            for (var _row = _start_vis_s_row; _row < _end_vis_s_row; _row++) {
                for (var _col = 0; _col < _cols; _col++) {
                    var _i = _row * _cols + _col;
                    if (_i >= _tn) break;
                    var _cx = _start_x + _col * (talent_card_w + talent_card_gap_x);
                    var _cy = _grid_shop_y + (_row - _start_vis_s_row) * (talent_card_h + talent_card_gap_y);

                    if (touch_room_clicked(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h)) {
                        if (shop_talent_index == _i) {
                            var _cur_shop_t = _tab_talents[shop_talent_index];
                            if (_cur_shop_t.affinity != "none" && !element_is_unlocked(_cur_shop_t.affinity, classes[shop_tab_index])) {
                                locked_warning_timer = 60;
                            } else {
                                talent_purchase(_cur_shop_t.id);
                            }
                        } else {
                            shop_talent_index = _i;
                        }
                    }
                }
            }

            if (keyboard_check_pressed(vk_right)) {
                shop_talent_index = (shop_talent_index + 1) mod _tn;
            }
            if (keyboard_check_pressed(vk_left)) {
                shop_talent_index = (shop_talent_index - 1 + _tn) mod _tn;
            }
            if (keyboard_check_pressed(vk_down)) {
                if (shop_talent_index + _cols < _tn) {
                    shop_talent_index += _cols;
                } else {
                    shop_talent_index = shop_talent_index mod _cols;
                }
            }
            if (keyboard_check_pressed(vk_up)) {
                if (shop_talent_index - _cols >= 0) {
                    shop_talent_index -= _cols;
                } else {
                    var _target = (_total_s_rows - 1) * _cols + (shop_talent_index mod _cols);
                    if (_target >= _tn) _target = _tn - 1;
                    shop_talent_index = _target;
                }
            }

            // Atualiza rolagem da loja
            var _cur_s_row = shop_talent_index div _cols;
            if (_cur_s_row < shop_grid_scroll_row) {
                shop_grid_scroll_row = _cur_s_row;
            } else if (_cur_s_row >= shop_grid_scroll_row + shop_grid_visible_rows) {
                shop_grid_scroll_row = _cur_s_row - shop_grid_visible_rows + 1;
            }

            if (mouse_wheel_up() && shop_grid_scroll_row > 0) {
                shop_grid_scroll_row -= 1;
            }
            if (mouse_wheel_down()) {
                if (shop_grid_scroll_row + shop_grid_visible_rows < _total_s_rows) {
                    shop_grid_scroll_row += 1;
                }
            }

            if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
                var _cur_shop_t = _tab_talents[shop_talent_index];
                if (_cur_shop_t.affinity != "none" && !element_is_unlocked(_cur_shop_t.affinity, classes[shop_tab_index])) {
                    locked_warning_timer = 60;
                } else {
                    talent_purchase(_cur_shop_t.id);
                }
            }
        }

        // Botões inferiores na Loja
        var _btn_shop_y = 650;
        var _btn_shop_h = 46;
        if (touch_room_clicked(60, _btn_shop_y, 240, _btn_shop_y + _btn_shop_h)) {
            state = "select";
        }
        if (touch_room_clicked(room_width - 380, _btn_shop_y, room_width - 60, _btn_shop_y + _btn_shop_h)) {
            if (_tn > 0) {
                var _cur_shop_t = _tab_talents[shop_talent_index];
                if (_cur_shop_t.affinity != "none" && !element_is_unlocked(_cur_shop_t.affinity, classes[shop_tab_index])) {
                    locked_warning_timer = 60;
                } else {
                    talent_purchase(_cur_shop_t.id);
                }
            }
        }

        if (keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape)) {
            state = "select";
        }
        break;
}
