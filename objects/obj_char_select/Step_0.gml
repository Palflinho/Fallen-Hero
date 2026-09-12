if (locked_warning_timer > 0) locked_warning_timer--;
if (reset_notice_timer > 0) reset_notice_timer--;

// Alternar Modo Dev com F1 ou F2
if (keyboard_check_pressed(vk_f1) || keyboard_check_pressed(vk_f2)) {
    global.dev_mode = !global.dev_mode;
    save_meta();
    if (state == "select_talents") {
        var _character = classes[selected_index];
        var _elem_current = elements[selected_element_index];
        if (element_is_unlocked(_elem_current)) {
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
    global.meta_elements = {water: false, fire: false, wind: false, earth: false};
    global.dev_mode = false;
    save_meta();
    reset_notice_timer = 120;
    if (state == "select_talents") {
        var _character = classes[selected_index];
        var _elem_current = elements[selected_element_index];
        if (element_is_unlocked(_elem_current)) {
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

switch (state) {
    case "main_menu":
        var _opt_count = array_length(main_menu_options);
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            main_menu_cursor = (main_menu_cursor - 1 + _opt_count) mod _opt_count;
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            main_menu_cursor = (main_menu_cursor + 1) mod _opt_count;
        }

        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            switch (main_menu_cursor) {
                case 0: // Novo Jogo
                    state = "select";
                    break;
                case 1: // Continuar
                    if (global.has_save) {
                        goto_checkpoint();
                    }
                    break;
                case 2: // Sair
                    game_end();
                    break;
            }
        }

        if (global.has_save && keyboard_check_pressed(ord("C"))) {
            goto_checkpoint();
        }
        break;

    case "select":
        var _n = array_length(classes);

        if (keyboard_check_pressed(vk_right)) selected_index = (selected_index + 1) mod _n;
        if (keyboard_check_pressed(vk_left)) selected_index = (selected_index - 1 + _n) mod _n;

        if (keyboard_check_pressed(ord("Z"))) {
            var _character = classes[selected_index];
            var _elem_current = elements[selected_element_index];
            if (element_is_unlocked(_elem_current)) {
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
            if (element_is_unlocked(_elem_current)) {
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

        if (_m > 0) {
            var _cols = min(talent_grid_cols, _m);
            if (_cols <= 0) _cols = 1;

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
                    var _total_rows = ceil(_m / _cols);
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
                var _total_rows = ceil(_m / _cols);
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

        if (keyboard_check_pressed(ord("Z"))) {
            var _elem_current = elements[selected_element_index];
            if (!element_is_unlocked(_elem_current)) {
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
                room_goto(Room1);
            }
        }

        if (keyboard_check_pressed(ord("X"))) {
            state = "select";
        }
        break;

    case "shop":
        var _cn = array_length(classes);
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
        if (_tn > 0) {
            var _cols = min(talent_grid_cols, _tn);
            if (_cols <= 0) _cols = 1;

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
                    var _total_rows = ceil(_tn / _cols);
                    var _target = (_total_rows - 1) * _cols + (shop_talent_index mod _cols);
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
                var _total_s_rows = ceil(_tn / _cols);
                if (shop_grid_scroll_row + shop_grid_visible_rows < _total_s_rows) {
                    shop_grid_scroll_row += 1;
                }
            }

            if (keyboard_check_pressed(ord("Z"))) {
                var _cur_shop_t = _tab_talents[shop_talent_index];
                if (_cur_shop_t.affinity != "none" && !element_is_unlocked(_cur_shop_t.affinity)) {
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
