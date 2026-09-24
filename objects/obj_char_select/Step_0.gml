input_update_device();
bgm_play("title");


if (reset_notice_timer > 0) reset_notice_timer--;
if (save_notice_timer > 0) save_notice_timer--;

// Alternar Modo Dev com F1, F2 ou toque no indicador superior esquerdo
var _is_mobile_dev = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));
var _touch_dev = _is_mobile_dev && touch_room_clicked(12, 12, 280, 42);

// Alternar Idioma com [L] ou Gamepad Select
var _gp_lang = (gamepad_is_connected(0) && gamepad_button_check_pressed(0, gp_select));
if ((keyboard_check_pressed(ord("L")) || _gp_lang) && state != "options") {
    loc_next_language();
    char_select_refresh_texts();
    sfx_play("menu_select", 0.05, 1.2);
}

if (keyboard_check_pressed(vk_f1) || keyboard_check_pressed(vk_f2) || _touch_dev) {
    global.dev_mode = !global.dev_mode;
    save_meta();
    char_select_refresh_texts();
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
}

// Sandbox do desenvolvedor com F5 (so com o Modo Dev ligado)
if (keyboard_check_pressed(vk_f5) && global.dev_mode && state == "main_menu") {
    sandbox_enter();
    exit;
}

// Alternar Modo Touch Simulado com F4
if (keyboard_check_pressed(vk_f4)) {
    global.dev_touch_mode = !global.dev_touch_mode;
}

switch (state) {
    case "main_menu":
        var _opt_count = array_length(main_menu_options);
        var _menu_start_x = (room_width - main_menu_btn_w) / 2;
        var _menu_start_y = 270;

        // Suporte a clique / toque nos botões do Menu Principal
        for (var _i = 0; _i < _opt_count; _i++) {
            var _bx = _menu_start_x;
            var _by = _menu_start_y + _i * (main_menu_btn_h + main_menu_btn_gap);
            if (touch_room_clicked(_bx, _by, _bx + main_menu_btn_w, _by + main_menu_btn_h)) {
                main_menu_cursor = _i;
                switch (_i) {
                    case 0: // Novo Jogo
                        save_slot_action = "new_game";
                        save_slot_cursor = global.current_save_slot - 1;
                        state = "save_slots";
                        sfx_play("menu_select");
                        break;
                    case 1: // Continuar
                        if (any_save_slot_exists()) {
                            save_slot_action = "continue";
                            save_slot_cursor = global.current_save_slot - 1;
                            state = "save_slots";
                            sfx_play("menu_select");
                        }
                        break;
                    case 2: // Opcoes
                        options_cursor = 0;
                        state = "options";
                        sfx_play("menu_select");
                        break;
                    case 3: // Sair
                        game_end();
                        break;
                    case 4: // Sandbox (Dev)
                        sandbox_enter();
                        break;
                }
            }
        }

        if (input_check_ui_up_pressed()) {
            main_menu_cursor = (main_menu_cursor - 1 + _opt_count) mod _opt_count;
            sfx_play("menu_move");
        }
        if (input_check_ui_down_pressed()) {
            main_menu_cursor = (main_menu_cursor + 1) mod _opt_count;
            sfx_play("menu_move");
        }

        if (input_check_ui_confirm()) {
            switch (main_menu_cursor) {
                case 0: // Novo Jogo
                    save_slot_action = "new_game";
                    save_slot_cursor = global.current_save_slot - 1;
                    state = "save_slots";
                    sfx_play("menu_select");
                    break;
                case 1: // Continuar
                    if (any_save_slot_exists()) {
                        save_slot_action = "continue";
                        save_slot_cursor = global.current_save_slot - 1;
                        state = "save_slots";
                        sfx_play("menu_select");
                    }
                    break;
                case 2: // Opcoes
                    options_cursor = 0;
                    state = "options";
                    sfx_play("menu_select");
                    break;
                case 3: // Sair
                    game_end();
                    break;
                case 4: // Sandbox (Dev)
                    sandbox_enter();
                    break;
            }
        }
        break;

    case "options":
        char_select_options_step();
        break;

    case "controls":
        if (input_check_ui_cancel() || input_check_ui_confirm() || touch_room_clicked(0, 0, room_width, room_height)) {
            sfx_play("menu_select", 0.05, 0.9);
            state = "options";
        }
        break;

    case "save_slots":
        var _total_w = 3 * save_card_w + 2 * save_card_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _card_y = 160;

        if (input_check_ui_left_pressed()) {
            save_slot_cursor = (save_slot_cursor - 1 + 3) mod 3;
            sfx_play("menu_move");
        }
        if (input_check_ui_right_pressed()) {
            save_slot_cursor = (save_slot_cursor + 1) mod 3;
            sfx_play("menu_move");
        }
        if (input_check_slot_pressed(0)) { save_slot_cursor = 0; sfx_play("menu_move"); }
        if (input_check_slot_pressed(1)) { save_slot_cursor = 1; sfx_play("menu_move"); }
        if (input_check_slot_pressed(2)) { save_slot_cursor = 2; sfx_play("menu_move"); }

        var _slot_to_confirm = -1;

        // Clique / toque nos 3 cards e nos botões de exclusão
        for (var _s = 0; _s < 3; _s++) {
            var _cx = _start_x + _s * (save_card_w + save_card_gap);

            // Botão excluir no canto do card
            var _del_x = _cx + save_card_w - 42;
            var _del_y = _card_y + 12;
            if (save_slot_exists(_s + 1) && touch_room_clicked(_del_x, _del_y, _del_x + 32, _del_y + 32)) {
                save_slot_delete(_s + 1);
                save_notice_text = tr("Slot ") + string(_s + 1) + tr(" apagado com sucesso!");
                save_notice_timer = 90;
                continue;
            }

            // Clique no corpo do card
            if (touch_room_clicked(_cx, _card_y, _cx + save_card_w, _card_y + save_card_h)) {
                save_slot_cursor = _s;
                _slot_to_confirm = _s + 1;
            }
        }

        // Excluir slot selecionado com a tecla Delete ou Botão Y do Controle
        var _pad_del = false;
        var _pad_cs = input_get_active_pad();
        if (_pad_cs != -1 && gamepad_button_check_pressed(_pad_cs, gp_face4)) _pad_del = true;

        if (keyboard_check_pressed(vk_delete) || _pad_del) {
            var _target_slot = save_slot_cursor + 1;
            if (save_slot_exists(_target_slot)) {
                save_slot_delete(_target_slot);
                save_notice_text = tr("Slot ") + string(_target_slot) + tr(" apagado com sucesso!");
                save_notice_timer = 90;
                sfx_play("stagger");
            }
        }

        // Confirmação
        if (input_check_ui_confirm()) {
            _slot_to_confirm = save_slot_cursor + 1;
        }

        if (_slot_to_confirm > 0) {
            var _chosen_slot = _slot_to_confirm;
            if (save_slot_action == "new_game") {
                // Inicia novo jogo diretamente na Vila Subterrânea!
                save_slot_init_new_game(_chosen_slot);
                global.current_save_slot = _chosen_slot;
                global.selected_character = "knight";
                global.selected_element = "none";
                global.chosen_talent_ids = ["", "", ""];
                save_checkpoint_fresh("knight", "room_village", "none");
                global.dialogue_intro_shown = false;
                global.dialogue_shop_shown = false;
                global.dialogue_boss_shown = false;
                global.run_biome = "water";
                global.run_room_step = 1;
                global.inrun_saved_stats = false;
                sfx_play("door_open");
                room_goto(room_village);
            } else if (save_slot_action == "continue") {
                if (save_slot_exists(_chosen_slot)) {
                    save_slot_load(_chosen_slot);
                    global.current_save_slot = _chosen_slot;
                    global.selected_character = global.save_character;
                    global.selected_element = variable_global_exists("save_element") ? global.save_element : "none";
                    global.chosen_talent_ids = global.save_talent_ids;
                    global.dialogue_intro_shown = false;
                    global.dialogue_shop_shown = false;
                    global.dialogue_boss_shown = false;
                    global.run_biome = "water";
                    global.run_room_step = 1;
                    global.inrun_saved_stats = false;
                    sfx_play("door_open");
                    room_goto(room_village);
                } else {
                    save_notice_text = tr("Slot ") + string(_chosen_slot) + tr(" esta vazio!");
                    save_notice_timer = 60;
                    sfx_play("stagger");
                }
            }
        }

        // Botão voltar no rodapé
        var _btn_back_y = room_height - 60;
        var _btn_back_h = 42;
        if (touch_room_clicked(40, _btn_back_y, 200, _btn_back_y + _btn_back_h) || input_check_ui_cancel()) {
            state = "main_menu";
            sfx_play("menu_select");
        }
        break;
}
