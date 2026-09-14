// Indicador do Modo Dev e Atalhos de Teste no canto superior esquerdo
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _is_mobile = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));

var _dev_str = _is_mobile ? (global.dev_mode ? "Modo Dev: ATIVO (Liberado)" : "Modo Dev: Normal") : (global.dev_mode ? "[F1] MODO DEV: ATIVADO (Tudo Desbloqueado)" : "[F1] Modo Dev: Desativado (Normal)");
var _dev_col = global.dev_mode ? c_aqua : make_colour_rgb(130, 140, 160);

draw_set_alpha(0.75);
draw_set_color(make_colour_rgb(14, 18, 28));
draw_rectangle(12, 12, 16 + string_width(_dev_str) + 12, 36, false);
draw_set_alpha(1);
draw_set_color(global.dev_mode ? c_aqua : make_colour_rgb(50, 65, 85));
draw_rectangle(12, 12, 16 + string_width(_dev_str) + 12, 36, true);

draw_set_color(_dev_col);
draw_text(18, 16, _dev_str);

if (global.dev_mode && !_is_mobile) {
    draw_set_color(make_colour_rgb(110, 120, 140));
    draw_text(18, 42, "[F3] Zerar Elementos da Campanha");
}

if (reset_notice_timer > 0) {
    draw_set_color(c_yellow);
    draw_text(260, 40, ">> Elementos reiniciados para bloqueados!");
}

// Banner Toast de Notificações de Salvamento e Ações
if (save_notice_timer > 0) {
    var _tw = string_width(save_notice_text) + 40;
    var _tx = (room_width - _tw) / 2;
    var _ty = 16;
    draw_set_alpha(0.95);
    draw_set_color(make_colour_rgb(14, 28, 44));
    draw_rectangle(_tx, _ty, _tx + _tw, _ty + 34, false);
    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_rectangle(_tx, _ty, _tx + _tw, _ty + 34, true);
    draw_rectangle(_tx - 1, _ty - 1, _tx + _tw + 1, _ty + 35, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(room_width / 2, _ty + 17, save_notice_text);
}

if (state != "main_menu" && state != "save_slots") {
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(room_width - 20, 20, "Ouro: " + string(global.gold));
    draw_set_color(c_white);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (state) {
    case "main_menu":
        var _title_x = room_width / 2;
        var _title_y = 150;

        // Titulo com sombra
        draw_set_color(make_colour_rgb(15, 22, 35));
        draw_text_transformed(_title_x + 3, _title_y + 3, "FALLEN HERO", 3, 3, 0);

        draw_set_color(c_yellow);
        draw_text_transformed(_title_x, _title_y, "FALLEN HERO", 3, 3, 0);

        draw_set_color(make_colour_rgb(130, 180, 230));
        draw_text_transformed(_title_x, _title_y + 48, "As Cronicas dos Elementos", 1.2, 1.2, 0);

        // Botoes do menu principal
        var _menu_start_x = (room_width - main_menu_btn_w) / 2;
        var _menu_start_y = 270;
        var _has_any_save = any_save_slot_exists();

        for (var _i = 0; _i < array_length(main_menu_options); _i++) {
            var _bx = _menu_start_x;
            var _by = _menu_start_y + _i * (main_menu_btn_h + main_menu_btn_gap);
            var _is_cur = (main_menu_cursor == _i);
            var _is_continue = (_i == 1);

            // Fundo do botao
            draw_set_alpha(0.9);
            if (_is_cur) {
                draw_set_color(make_colour_rgb(34, 48, 76));
            } else {
                draw_set_color(make_colour_rgb(16, 20, 30));
            }
            draw_rectangle(_bx, _by, _bx + main_menu_btn_w, _by + main_menu_btn_h, false);
            draw_set_alpha(1);

            // Borda do botao
            if (_is_cur) {
                draw_set_color(c_yellow);
                draw_rectangle(_bx - 2, _by - 2, _bx + main_menu_btn_w + 2, _by + main_menu_btn_h + 2, true);
                draw_rectangle(_bx, _by, _bx + main_menu_btn_w, _by + main_menu_btn_h, true);
            } else {
                draw_set_color(make_colour_rgb(55, 70, 95));
                draw_rectangle(_bx, _by, _bx + main_menu_btn_w, _by + main_menu_btn_h, true);
            }

            // Texto do botao
            var _label = main_menu_options[_i];
            if (_is_continue && !_has_any_save) {
                _label = "Continuar  (Sem Saves)";
                draw_set_color(c_dkgray);
            } else if (_is_cur) {
                draw_set_color(c_yellow);
            } else {
                draw_set_color(c_white);
            }

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(_bx + main_menu_btn_w / 2, _by + main_menu_btn_h / 2, _label, 1.2, 1.2, 0);

            // Indicador de cursor
            if (_is_cur) {
                draw_text_transformed(_bx + 28, _by + main_menu_btn_h / 2, ">", 1.3, 1.3, 0);
            }
        }

        // Rodape de instrucoes (sem poluicao visual, sem cards empurrando o texto)
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_colour_rgb(160, 170, 185));
        var _menu_tip = _is_mobile ? "Toque na opcao desejada para navegar" : "W / S ou Setas: Navegar   |   Z / Enter / Espaco / Clique: Confirmar";
        draw_text(room_width / 2, room_height - 45, _menu_tip);
        break;

    case "save_slots":
        var _is_new = (save_slot_action == "new_game");
        var _title_text = _is_new ? "NOVO JOGO - ESCOLHA UM SLOT" : "CONTINUAR - ESCOLHA UM SLOT";
        var _sub_text = _is_new ? "Selecione um slot para iniciar sua nova jornada do zero absoluto" : "Selecione um slot existente para carregar seu heroi salvo";

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text_transformed(room_width / 2, 70, _title_text, 1.6, 1.6, 0);
        draw_set_color(make_colour_rgb(150, 190, 230));
        draw_text(room_width / 2, 105, _sub_text);

        var _total_w = 3 * save_card_w + 2 * save_card_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _card_y = 150;

        for (var _s = 0; _s < 3; _s++) {
            var _slot_num = _s + 1;
            var _info = save_slot_get_info(_slot_num);
            var _is_cur = (save_slot_cursor == _s);
            var _cx = _start_x + _s * (save_card_w + save_card_gap);

            // Fundo do Card de Slot
            draw_set_alpha(_is_cur ? 0.95 : 0.85);
            draw_set_color(_is_cur ? make_colour_rgb(26, 38, 62) : make_colour_rgb(15, 20, 32));
            draw_rectangle(_cx, _card_y, _cx + save_card_w, _card_y + save_card_h, false);
            draw_set_alpha(1.0);

            // Borda do Card
            if (_is_cur) {
                draw_set_color(c_yellow);
                draw_rectangle(_cx - 2, _card_y - 2, _cx + save_card_w + 2, _card_y + save_card_h + 2, true);
                draw_rectangle(_cx, _card_y, _cx + save_card_w, _card_y + save_card_h, true);
            } else {
                draw_set_color(_info.occupied ? make_colour_rgb(60, 85, 125) : make_colour_rgb(45, 55, 75));
                draw_rectangle(_cx, _card_y, _cx + save_card_w, _card_y + save_card_h, true);
            }

            // Topo do Card: Número do Slot
            draw_set_color(_is_cur ? c_yellow : c_white);
            draw_text_transformed(_cx + save_card_w / 2, _card_y + 30, "SLOT " + string(_slot_num), 1.35, 1.35, 0);

            // Linha divisória horizontal
            draw_set_color(make_colour_rgb(50, 68, 95));
            draw_line(_cx + 20, _card_y + 54, _cx + save_card_w - 20, _card_y + 54);

            // Botão Excluir Slot (X no canto superior direito)
            if (_info.occupied) {
                var _del_x = _cx + save_card_w - 38;
                var _del_y = _card_y + 14;
                draw_set_color(make_colour_rgb(50, 20, 24));
                draw_rectangle(_del_x, _del_y, _del_x + 24, _del_y + 24, false);
                draw_set_color(c_red);
                draw_rectangle(_del_x, _del_y, _del_x + 24, _del_y + 24, true);
                draw_text(_del_x + 12, _del_y + 12, "X");
            }

            // Conteúdo do Card
            if (!_info.occupied) {
                // SLOT VAZIO
                draw_set_color(make_colour_rgb(75, 90, 115));
                draw_text_transformed(_cx + save_card_w / 2, _card_y + 125, "[ + ]", 2.2, 2.2, 0);

                draw_set_color(c_ltgray);
                draw_text(_cx + save_card_w / 2, _card_y + 175, "SLOT VAZIO");

                draw_set_color(make_colour_rgb(110, 130, 160));
                draw_text(_cx + save_card_w / 2, _card_y + 205, "Disponivel para");
                draw_text(_cx + save_card_w / 2, _card_y + 225, "Nova Jornada");

                // Rodapé do Card
                if (_is_new) {
                    draw_set_color(c_lime);
                    draw_rectangle(_cx + 25, _card_y + save_card_h - 52, _cx + save_card_w - 25, _card_y + save_card_h - 18, false);
                    draw_set_color(c_black);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, "INICIAR AQUI");
                } else {
                    draw_set_color(c_dkgray);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, "(Sem Dados)");
                }
            } else {
                // SLOT OCUPADO
                var _hero_label = _info.hero_label;
                var _max_w = save_card_w - 30;

                // 1. Nome do Herói & Arquétipo (com Iwata Scale Guard para nunca vazar)
                draw_set_color(c_white);
                var _hw = string_width(_hero_label);
                var _sc_h = (_hw > _max_w && _hw > 0) ? (_max_w / _hw) : 1.0;
                draw_text_transformed(_cx + save_card_w / 2, _card_y + 85, _hero_label, _sc_h * 1.1, _sc_h * 1.1, 0);

                // 2. Nível
                draw_set_color(c_aqua);
                draw_text(_cx + save_card_w / 2, _card_y + 125, "Nivel " + string(_info.level));

                // 3. Sintonia Elemental
                draw_set_color(c_yellow);
                var _elem_str = "Sintonia: " + element_get_name(_info.element);
                draw_text(_cx + save_card_w / 2, _card_y + 155, _elem_str);

                // 4. Tempo de Jogo
                draw_set_color(make_colour_rgb(180, 205, 235));
                draw_text(_cx + save_card_w / 2, _card_y + 190, "Tempo de Jogo:");
                draw_set_color(c_white);
                draw_text(_cx + save_card_w / 2, _card_y + 212, format_playtime(_info.playtime));

                // Rodapé do Card
                if (_is_new) {
                    draw_set_color(make_colour_rgb(70, 30, 35));
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, false);
                    draw_set_color(c_orange);
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, true);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, "SOBRESCREVER");
                } else {
                    draw_set_color(make_colour_rgb(26, 60, 40));
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, false);
                    draw_set_color(c_lime);
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, true);
                    draw_set_color(c_white);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, "CARREGAR");
                }
            }
        }

        // Rodapé de Ações
        var _btn_back_y = room_height - 60;
        var _btn_back_h = 42;
        draw_set_color(make_colour_rgb(26, 36, 56));
        draw_rectangle(40, _btn_back_y, 200, _btn_back_y + _btn_back_h, false);
        draw_set_color(make_colour_rgb(70, 95, 135));
        draw_rectangle(40, _btn_back_y, 200, _btn_back_y + _btn_back_h, true);
        draw_set_color(c_ltgray);
        draw_text(120, _btn_back_y + _btn_back_h / 2, _is_mobile ? "VOLTAR" : (input_has_gamepad_connected() ? (input_get_btn_label("cancel") + " Voltar") : "[ESC / X] Voltar"));

        draw_set_halign(fa_center);
        draw_set_color(make_colour_rgb(160, 175, 195));
        var _slots_tip = _is_mobile ? "Toque no card para selecionar   |   Toque no [X] para excluir" : (input_has_gamepad_connected() ? ("D-Pad: Navegar   |   " + input_get_btn_label("confirm") + ": Confirmar   |   " + input_get_btn_label("cancel") + ": Voltar") : "Setas / 1, 2, 3: Navegar   |   Enter / Clique: Confirmar   |   ESC: Voltar");
        draw_text(room_width / 2 + 50, _btn_back_y + _btn_back_h / 2, _slots_tip);
        break;

    case "select":
        var _n = array_length(classes);
        var _total_w = _n * box_w + (_n - 1) * box_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _y = room_height / 2 - box_h / 2 + 10;

        draw_set_color(c_white);
        draw_text_transformed(room_width / 2, 60, "Escolha seu Heroi", 1.4, 1.4, 0);

        // Barra do Slot Ativo no Topo
        var _slot_bar_w = 370;
        var _slot_bar_x = (room_width - _slot_bar_w) / 2;
        var _slot_bar_y = 86;

        for (var _s = 1; _s <= 3; _s++) {
            var _sbx = _slot_bar_x + (_s - 1) * 125;
            var _is_active_slot = (global.current_save_slot == _s);

            draw_set_alpha(0.85);
            draw_set_color(_is_active_slot ? make_colour_rgb(40, 56, 85) : make_colour_rgb(18, 24, 36));
            draw_rectangle(_sbx, _slot_bar_y, _sbx + 115, _slot_bar_y + 28, false);
            draw_set_alpha(1.0);

            draw_set_color(_is_active_slot ? c_yellow : make_colour_rgb(65, 80, 105));
            draw_rectangle(_sbx, _slot_bar_y, _sbx + 115, _slot_bar_y + 28, true);
            if (_is_active_slot) {
                draw_rectangle(_sbx - 1, _slot_bar_y - 1, _sbx + 116, _slot_bar_y + 29, true);
            }

            draw_set_color(_is_active_slot ? c_yellow : c_ltgray);
            draw_text(_sbx + 57, _slot_bar_y + 14, "Slot " + string(_s) + (_is_active_slot ? " *" : ""));
        }

        // Setas táteis para mobile apenas
        if (_is_mobile) {
            draw_set_color(make_colour_rgb(30, 42, 64));
            draw_rectangle(_start_x - 70, _y + box_h / 2 - 35, _start_x - 10, _y + box_h / 2 + 35, false);
            draw_set_color(c_yellow);
            draw_rectangle(_start_x - 70, _y + box_h / 2 - 35, _start_x - 10, _y + box_h / 2 + 35, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(_start_x - 40, _y + box_h / 2, "<", 1.8, 1.8, 0);

            draw_set_color(make_colour_rgb(30, 42, 64));
            draw_rectangle(_start_x + _total_w + 10, _y + box_h / 2 - 35, _start_x + _total_w + 70, _y + box_h / 2 + 35, false);
            draw_set_color(c_yellow);
            draw_rectangle(_start_x + _total_w + 10, _y + box_h / 2 - 35, _start_x + _total_w + 70, _y + box_h / 2 + 35, true);
            draw_set_color(c_yellow);
            draw_text_transformed(_start_x + _total_w + 40, _y + box_h / 2, ">", 1.8, 1.8, 0);
        }

        // Cards dos Heróis
        for (var _i = 0; _i < _n; _i++) {
            var _bx = _start_x + _i * (box_w + box_gap);

            draw_set_color(colours[_i]);
            draw_rectangle(_bx, _y, _bx + box_w, _y + box_h, false);

            draw_set_color((_i == selected_index) ? c_white : c_black);
            draw_rectangle(_bx, _y, _bx + box_w, _y + box_h, true);
            if (_i == selected_index) {
                draw_rectangle(_bx - 4, _y - 4, _bx + box_w + 4, _y + box_h + 4, true);
            }

            draw_set_color(c_white);
            draw_text(_bx + box_w / 2, _y + box_h + 20, labels[_i]);

            // Insignias de Maestria Elemental da classe
            var _c_id = classes[_i];
            var _badge_elems = ["water", "fire", "wind", "earth"];
            var _badge_cols = [c_aqua, c_orange, make_colour_rgb(180, 240, 255), make_colour_rgb(170, 130, 80)];
            var _badge_names = ["A", "F", "V", "T"]; // Água, Fogo, Vento, Terra

            var _bg_start_x = _bx + (box_w - 4 * 28) / 2 + 14;
            for (var _b = 0; _b < 4; _b++) {
                var _be = _badge_elems[_b];
                var _has_m = element_is_unlocked(_be, _c_id) || (variable_global_exists("meta_mastery") && is_struct(global.meta_mastery) && variable_struct_exists(global.meta_mastery, _c_id) && is_struct(global.meta_mastery[$ _c_id]) && variable_struct_exists(global.meta_mastery[$ _c_id], _be) && global.meta_mastery[$ _c_id][$ _be]);

                var _bg_x = _bg_start_x + _b * 28;
                var _bg_y = _y + box_h + 46;
                var _r = 10;

                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);

                if (_has_m) {
                    draw_set_color(_badge_cols[_b]);
                    draw_circle(_bg_x, _bg_y, _r, false);
                    draw_set_color(c_white);
                    draw_circle(_bg_x, _bg_y, _r, true);
                    draw_set_color(c_black);
                    draw_text_transformed(_bg_x, _bg_y, _badge_names[_b], 1.05, 1.05, 0);
                } else {
                    draw_set_alpha(0.6);
                    draw_set_color(make_colour_rgb(16, 20, 28));
                    draw_circle(_bg_x, _bg_y, _r, false);
                    draw_set_alpha(1.0);
                    draw_set_color(make_colour_rgb(60, 70, 90));
                    draw_circle(_bg_x, _bg_y, _r, true);
                    draw_set_color(make_colour_rgb(90, 100, 120));
                    draw_text(_bg_x, _bg_y, _badge_names[_b]);
                }
            }
        }

        // Exibição do Bônus Geral de Maestria
        var _mult = get_mastery_gold_multiplier();
        var _bonus_pct = round((_mult - 1.0) * 100);
        draw_set_halign(fa_center);
        draw_set_color(_bonus_pct > 0 ? c_yellow : c_ltgray);
        draw_text(room_width / 2, room_height - 95, "Insignias: [A]gua [F]ogo [V]ento [T]erra   |   Bonus de Maestria: +" + string(_bonus_pct) + "% Ouro Permanente");

        // Botões e Ações na base da tela
        var _btn_sel_y = room_height - 62;
        var _btn_sel_h = 42;

        // Botão [ Voltar ]
        draw_set_color(make_colour_rgb(26, 36, 56));
        draw_rectangle(40, _btn_sel_y, 190, _btn_sel_y + _btn_sel_h, false);
        draw_set_color(make_colour_rgb(70, 95, 135));
        draw_rectangle(40, _btn_sel_y, 190, _btn_sel_y + _btn_sel_h, true);
        draw_set_color(c_ltgray);
        draw_text(115, _btn_sel_y + _btn_sel_h / 2, _is_mobile ? "VOLTAR" : (input_get_btn_label("cancel") + " Voltar"));

        // Botão [ Confirmar Heroi ]
        draw_set_color(make_colour_rgb(32, 54, 86));
        draw_rectangle(room_width / 2 - 210, _btn_sel_y, room_width / 2 + 10, _btn_sel_y + _btn_sel_h, false);
        draw_set_color(c_yellow);
        draw_rectangle(room_width / 2 - 210, _btn_sel_y, room_width / 2 + 10, _btn_sel_y + _btn_sel_h, true);
        draw_set_color(c_white);
        draw_text(room_width / 2 - 100, _btn_sel_y + _btn_sel_h / 2, _is_mobile ? "CONFIRMAR" : (input_get_btn_label("confirm") + " Confirmar Heroi"));

        // Botão [ Salvar Perfil ] (Exclusivo na Seleção de Personagem)
        var _save_btn_x = room_width / 2 + 30;
        var _save_btn_w = 200;
        draw_set_color(make_colour_rgb(20, 45, 30));
        draw_rectangle(_save_btn_x, _btn_sel_y, _save_btn_x + _save_btn_w, _btn_sel_y + _btn_sel_h, false);
        draw_set_color(c_lime);
        draw_rectangle(_save_btn_x, _btn_sel_y, _save_btn_x + _save_btn_w, _btn_sel_y + _btn_sel_h, true);
        draw_set_color(c_white);
        draw_text(_save_btn_x + _save_btn_w / 2, _btn_sel_y + _btn_sel_h / 2, _is_mobile ? "SALVAR PERFIL" : (input_get_btn_label("save") + " Salvar Perfil"));

        // Botão [ Loja de Talentos ]
        draw_set_color(make_colour_rgb(26, 36, 56));
        draw_rectangle(room_width - 240, _btn_sel_y, room_width - 40, _btn_sel_y + _btn_sel_h, false);
        draw_set_color(make_colour_rgb(215, 175, 60));
        draw_rectangle(room_width - 240, _btn_sel_y, room_width - 40, _btn_sel_y + _btn_sel_h, true);
        draw_set_color(c_yellow);
        draw_text(room_width - 140, _btn_sel_y + _btn_sel_h / 2, _is_mobile ? "LOJA TALENTOS" : (input_get_btn_label("shop") + " Loja Talentos"));
        break;

    case "select_talents":
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(room_width / 2, 34, "Talentos - " + labels[selected_index]);

        var _elem_id = elements[selected_element_index];
        var _elem_unlocked = element_is_unlocked(_elem_id, classes[selected_index]);
        var _arch = class_get_archetype_name(classes[selected_index], _elem_id);
        var _desc = class_get_archetype_desc(classes[selected_index], _elem_id);

        // Setas para troca de elemento com suporte dinamico a gamepad (L1/LB e R1/RB)
        var _lbl_shoulder_l = "< Q";
        var _lbl_shoulder_r = "E >";
        if (_is_mobile) {
            _lbl_shoulder_l = "◀";
            _lbl_shoulder_r = "▶";
        } else {
            var _dev_sh = input_get_device_type();
            if (_dev_sh == "ps") {
                _lbl_shoulder_l = "< L1";
                _lbl_shoulder_r = "R1 >";
            } else if (_dev_sh == "xbox") {
                _lbl_shoulder_l = "< LB";
                _lbl_shoulder_r = "RB >";
            } else {
                _lbl_shoulder_l = "< Q";
                _lbl_shoulder_r = "E >";
            }
        }

        draw_set_color(make_colour_rgb(30, 42, 64));
        draw_rectangle(room_width / 2 - 320, 50, room_width / 2 - 240, 78, false);
        draw_set_color(c_yellow);
        draw_rectangle(room_width / 2 - 320, 50, room_width / 2 - 240, 78, true);
        draw_set_color(c_yellow);
        draw_text(room_width / 2 - 280, 64, _lbl_shoulder_l);

        draw_set_color(make_colour_rgb(30, 42, 64));
        draw_rectangle(room_width / 2 + 240, 50, room_width / 2 + 320, 78, false);
        draw_set_color(c_yellow);
        draw_rectangle(room_width / 2 + 240, 50, room_width / 2 + 320, 78, true);
        draw_set_color(c_yellow);
        draw_text(room_width / 2 + 280, 64, _lbl_shoulder_r);

        if (_elem_unlocked) {
            draw_set_color(c_yellow);
            draw_text(room_width / 2, 64, "Sintonia: " + element_get_name(_elem_id) + " (" + _arch + ")");
            draw_set_color(c_aqua);
            draw_text(room_width / 2, 95, _desc);
        } else {
            draw_set_color(make_colour_rgb(255, 90, 90));
            draw_text(room_width / 2, 64, "Sintonia: " + element_get_name(_elem_id) + " (" + _arch + ") [BLOQUEADO]");
            draw_set_color(c_yellow);
            draw_text(room_width / 2, 95, "Requisito: " + element_get_unlock_requirement(_elem_id));
        }
        var _grid_start_y = 126;

        if (!_elem_unlocked) {
            var _bw = 720;
            var _bh = 220;
            var _bx = (room_width - _bw) / 2;
            var _by = 180;

            draw_set_alpha(0.92);
            draw_set_color(make_colour_rgb(18, 14, 24));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_alpha(1);

            draw_set_color(make_colour_rgb(180, 50, 60));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
            draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + _bh + 2, true);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_red);
            draw_text_transformed(_bx + _bw / 2, _by + 40, "ELEMENTO BLOQUEADO NA CAMPANHA", 1.35, 1.35, 0);

            draw_set_color(c_white);
            draw_text(_bx + _bw / 2, _by + 85, "Para sintonizar seu heroi com os poderes de " + element_get_name(_elem_id) + " (" + _arch + "):");

            draw_set_color(c_yellow);
            draw_text_transformed(_bx + _bw / 2, _by + 118, element_get_unlock_requirement(_elem_id), 1.15, 1.15, 0);

            draw_set_color(c_aqua);
            draw_text(_bx + _bw / 2, _by + 168, "[F1] MODO DEV: Desbloqueia todos os elementos e 200 talentos para testes!");
        } else {
            var _m = array_length(talent_select_list);
            if (_m == 0) {
                draw_set_color(c_white);
                draw_text(room_width / 2, 260, "Nenhum talento desbloqueado ainda para esta classe.");
                draw_set_color(c_yellow);
                draw_text(room_width / 2, 290, "Volte com [X] e aperte [S] para abrir a Loja de Talentos.");
            } else {
                var _cols = min(talent_grid_cols, _m);
                if (_cols <= 0) _cols = 1;
                var _total_grid_w = _cols * talent_card_w + (_cols - 1) * talent_card_gap_x;
                var _start_x = (room_width - _total_grid_w) / 2;
                var _total_rows = ceil(_m / _cols);
                var _start_vis_row = talent_grid_scroll_row;
                var _end_vis_row = min(_total_rows, _start_vis_row + talent_grid_visible_rows);

                if (_start_vis_row > 0) {
                    draw_set_color(c_yellow);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_bottom);
                    draw_text(room_width / 2, _grid_start_y - 2, "▲  (Mais talentos acima)  ▲");
                }
                if (_end_vis_row < _total_rows) {
                    draw_set_color(c_yellow);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_top);
                    draw_text(room_width / 2, _grid_start_y + talent_grid_visible_rows * (talent_card_h + talent_card_gap_y) + 2, "▼  (Mais talentos abaixo - Role para ver)  ▼");
                }

                for (var _row = _start_vis_row; _row < _end_vis_row; _row++) {
                    for (var _col = 0; _col < _cols; _col++) {
                        var _i = _row * _cols + _col;
                        if (_i >= _m) break;
                        var _t = talent_select_list[_i];
                        var _cx = _start_x + _col * (talent_card_w + talent_card_gap_x);
                        var _cy = _grid_start_y + (_row - _start_vis_row) * (talent_card_h + talent_card_gap_y);

                        var _is_cursor = (_i == talent_select_cursor);
                        var _is_picked = false;
                        var _slot_idx = -1;
                        for (var j = 0; j < array_length(talent_selected_ids); j++) {
                            if (talent_selected_ids[j] == _t.id) {
                                _is_picked = true;
                                _slot_idx = j;
                                break;
                            }
                        }

                        // Card background
                        draw_set_alpha(0.85);
                        draw_set_color(_is_cursor ? make_colour_rgb(32, 40, 60) : make_colour_rgb(18, 22, 32));
                        draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, false);
                        draw_set_alpha(1);

                        // Card border
                        if (_is_cursor) {
                            draw_set_color(c_yellow);
                            draw_rectangle(_cx - 2, _cy - 2, _cx + talent_card_w + 2, _cy + talent_card_h + 2, true);
                            draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                        } else if (_is_picked) {
                            draw_set_color(c_aqua);
                            draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                        } else {
                            draw_set_color(make_colour_rgb(55, 68, 90));
                            draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                        }

                        // Icon
                        var _icon = talent_get_icon_type(_t);
                        var _icon_col = _is_cursor ? c_yellow : (_is_picked ? c_aqua : colours[selected_index]);
                        draw_talent_icon(_icon, _cx + talent_card_w / 2, _cy + 34, 26, _icon_col);

                        // Name
                        draw_set_halign(fa_center);
                        draw_set_valign(fa_middle);
                        draw_set_color(_is_cursor ? c_yellow : (_is_picked ? c_white : c_ltgray));
                        var _max_text_w = talent_card_w - 16;
                        var _line_w = string_width_ext(_t.label, 14, _max_text_w);
                        if (_line_w > _max_text_w) {
                            var _sc = _max_text_w / _line_w;
                            draw_text_transformed(_cx + talent_card_w / 2, _cy + 74, _t.label, _sc, _sc, 0);
                        } else {
                            draw_text_ext(_cx + talent_card_w / 2, _cy + 74, _t.label, 14, _max_text_w);
                        }

                        // Selection badge
                        if (_is_picked) {
                            draw_set_color(c_aqua);
                            draw_rectangle(_cx + talent_card_w - 22, _cy + 4, _cx + talent_card_w - 4, _cy + 22, false);
                            draw_set_color(c_black);
                            draw_text(_cx + talent_card_w - 13, _cy + 13, string(_slot_idx + 1));
                        }
                    }
                }

                // ---- Bottom Info Box ----
                var _cur_t = talent_select_list[talent_select_cursor];
                var _cur_picked = false;
                var _cur_slot = -1;
                for (var j = 0; j < array_length(talent_selected_ids); j++) {
                    if (talent_selected_ids[j] == _cur_t.id) {
                        _cur_picked = true;
                        _cur_slot = j;
                        break;
                    }
                }

                var _box_w = 980;
                var _box_h = 135;
                var _box_x = (room_width - _box_w) / 2;
                var _box_y = 475;

                // Background & border
                draw_set_alpha(0.92);
                draw_set_color(make_colour_rgb(12, 16, 26));
                draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
                draw_set_alpha(1);
                draw_set_color(make_colour_rgb(70, 95, 135));
                draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);
                draw_rectangle(_box_x - 1, _box_y - 1, _box_x + _box_w + 1, _box_y + _box_h + 1, true);

                // Left icon container
                draw_set_color(make_colour_rgb(22, 28, 42));
                draw_rectangle(_box_x + 18, _box_y + 18, _box_x + 114, _box_y + _box_h - 18, false);
                draw_set_color(make_colour_rgb(55, 75, 110));
                draw_rectangle(_box_x + 18, _box_y + 18, _box_x + 114, _box_y + _box_h - 18, true);
                draw_talent_icon(talent_get_icon_type(_cur_t), _box_x + 66, _box_y + _box_h / 2, 44, c_yellow);

                // Title and Status
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_color(c_yellow);
                draw_text(_box_x + 130, _box_y + 18, _cur_t.label);

                draw_set_halign(fa_right);
                if (_cur_picked) {
                    draw_set_color(c_aqua);
                    draw_text(_box_x + _box_w - 24, _box_y + 18, "SELECIONADO (Slot " + string(_cur_slot + 1) + "/3)");
                } else if (array_length(talent_selected_ids) < 3) {
                    draw_set_color(c_white);
                    var _sel_prompt = _is_mobile ? "Toque para Selecionar" : (input_get_btn_label("confirm") + " para Selecionar");
                    draw_text(_box_x + _box_w - 24, _box_y + 18, _sel_prompt + "  (" + string(array_length(talent_selected_ids)) + "/3)");
                } else {
                    draw_set_color(c_gray);
                    draw_text(_box_x + _box_w - 24, _box_y + 18, "[Limite de 3 Atingido]");
                }

                // Divider line
                draw_set_color(make_colour_rgb(45, 60, 85));
                draw_line(_box_x + 130, _box_y + 44, _box_x + _box_w - 24, _box_y + 44);

                // Description with numeric values
                var _eff_str = "Efeito: " + talent_get_desc_value(_cur_t);
                var _eff_sep = 18;
                var _text_max_w = _box_w - 160;

                draw_set_halign(fa_left);
                draw_set_color(c_white);
                draw_text_ext(_box_x + 130, _box_y + 52, _eff_str, _eff_sep, _text_max_w);

                var _eff_h = string_height_ext(_eff_str, _eff_sep, _text_max_w);
                var _flavor_str = talent_get_desc_flavor(_cur_t);
                if (_flavor_str != "") {
                    draw_set_color(c_ltgray);
                    draw_text_ext(_box_x + 130, _box_y + 52 + _eff_h + 6, _flavor_str, 16, _text_max_w);
                }
            }
        }

        // Botões inferiores
        var _btn_tal_y = 650;
        var _btn_tal_h = 46;

        // Botão [ Voltar ]
        draw_set_color(make_colour_rgb(26, 36, 56));
        draw_rectangle(60, _btn_tal_y, 240, _btn_tal_y + _btn_tal_h, false);
        draw_set_color(make_colour_rgb(70, 95, 135));
        draw_rectangle(60, _btn_tal_y, 240, _btn_tal_y + _btn_tal_h, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_ltgray);
        draw_text(150, _btn_tal_y + _btn_tal_h / 2, _is_mobile ? "VOLTAR" : (input_get_btn_label("cancel") + " Voltar"));

        // Botão [ Iniciar Expedição ]
        var _btn_ini_w = 320;
        var _btn_ini_x = room_width - 60 - _btn_ini_w;
        draw_set_color(_elem_unlocked ? make_colour_rgb(32, 64, 40) : make_colour_rgb(45, 25, 30));
        draw_rectangle(_btn_ini_x, _btn_tal_y, _btn_ini_x + _btn_ini_w, _btn_tal_y + _btn_tal_h, false);
        draw_set_color(_elem_unlocked ? c_lime : c_red);
        draw_rectangle(_btn_ini_x, _btn_tal_y, _btn_ini_x + _btn_ini_w, _btn_tal_y + _btn_tal_h, true);
        draw_set_color(c_white);
        draw_text(_btn_ini_x + _btn_ini_w / 2, _btn_tal_y + _btn_tal_h / 2, _is_mobile ? "INICIAR EXPEDICAO" : (input_is_gamepad_active() ? (input_get_btn_label("pause") + " INICIAR EXPEDICAO") : "[Z / Enter] INICIAR EXPEDICAO"));

        // Footer instructions adaptadas ao dispositivo
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (!_elem_unlocked) {
            draw_set_color(c_ltgray);
            draw_text(room_width / 2, 626, _is_mobile ? "Troque o Elemento pelas setas ou ative o Modo Dev" : "Troque o Elemento pelas setas ou modo dev [F1]");
        } else {
            draw_set_color(c_white);
            var _tal_tip = _is_mobile ? "Toque nos cards para marcar/desmarcar (max 3 talentos)" : "Clique ou use Espaco para marcar/desmarcar (max 3 talentos)";
            draw_text(room_width / 2, 626, _tal_tip);
        }

        if (locked_warning_timer > 0) {
            var _flash = (locked_warning_timer mod 10 < 5);
            draw_set_color(_flash ? c_yellow : c_red);
            draw_text(room_width / 2, 626, _is_mobile ? "IMPOSSIVEL INICIAR: Elemento bloqueado! Escolha Neutro ou ative Modo Dev." : "IMPOSSIVEL INICIAR: Elemento bloqueado! Escolha Neutro ou elemento ja conquistado, ou aperte F1.");
        }
        break;

    case "shop":
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(room_width / 2, 34, "Loja de Talentos");

        // Tabs for classes
        var _n2 = array_length(classes);
        var _tab_w = 170;
        var _tab_gap = 16;
        var _total_tabs_w = _n2 * _tab_w + (_n2 - 1) * _tab_gap;
        var _start_tab_x = (room_width - _total_tabs_w) / 2;
        var _tab_y = 60;

        var _tab_lbl_l = "< Q";
        var _tab_lbl_r = "E >";
        if (_is_mobile) {
            _tab_lbl_l = "◀";
            _tab_lbl_r = "▶";
        } else {
            var _dev_tab = input_get_device_type();
            if (_dev_tab == "ps") {
                _tab_lbl_l = "< L1";
                _tab_lbl_r = "R1 >";
            } else if (_dev_tab == "xbox") {
                _tab_lbl_l = "< LB";
                _tab_lbl_r = "RB >";
            } else {
                _tab_lbl_l = "< Q";
                _tab_lbl_r = "E >";
            }
        }

        draw_set_color(c_yellow);
        draw_set_halign(fa_right);
        draw_text(_start_tab_x - 14, _tab_y + 16, _tab_lbl_l);
        draw_set_halign(fa_left);
        draw_text(_start_tab_x + _total_tabs_w + 14, _tab_y + 16, _tab_lbl_r);
        draw_set_halign(fa_center);
        draw_set_halign(fa_center);

        for (var _i = 0; _i < _n2; _i++) {
            var _tx = _start_tab_x + _i * (_tab_w + _tab_gap);
            var _is_cur_tab = (_i == shop_tab_index);

            draw_set_alpha(0.8);
            draw_set_color(_is_cur_tab ? make_colour_rgb(35, 45, 70) : make_colour_rgb(18, 22, 32));
            draw_rectangle(_tx, _tab_y, _tx + _tab_w, _tab_y + 32, false);
            draw_set_alpha(1);

            draw_set_color(_is_cur_tab ? colours[_i] : make_colour_rgb(60, 70, 90));
            draw_rectangle(_tx, _tab_y, _tx + _tab_w, _tab_y + 32, true);
            if (_is_cur_tab) {
                draw_rectangle(_tx - 1, _tab_y - 1, _tx + _tab_w + 1, _tab_y + 33, true);
            }

            draw_set_color(_is_cur_tab ? c_white : c_gray);
            draw_text(_tx + _tab_w / 2, _tab_y + 16, labels[_i]);
        }

        // Talent Cards Grid
        var _tab_talents = get_talents_for_character(classes[shop_tab_index]);
        var _tn = array_length(_tab_talents);
        var _grid_shop_y = 110;

        if (_tn > 0) {
            if (!variable_instance_exists(id, "shop_grid_cols")) shop_grid_cols = 6;
            var _cols = min(shop_grid_cols, _tn);
            if (_cols <= 0) _cols = 1;
            var _total_grid_w = _cols * talent_card_w + (_cols - 1) * talent_card_gap_x;
            var _start_x = (room_width - _total_grid_w) / 2;
            var _total_s_rows = ceil(_tn / _cols);
            var _start_vis_s_row = shop_grid_scroll_row;
            var _end_vis_s_row = min(_total_s_rows, _start_vis_s_row + shop_grid_visible_rows);

            if (_start_vis_s_row > 0) {
                draw_set_color(c_yellow);
                draw_set_halign(fa_center);
                draw_set_valign(fa_bottom);
                draw_text(room_width / 2, _grid_shop_y - 2, "▲  (Mais talentos acima)  ▲");
            }
            if (_end_vis_s_row < _total_s_rows) {
                draw_set_color(c_yellow);
                draw_set_halign(fa_center);
                draw_set_valign(fa_top);
                draw_text(room_width / 2, _grid_shop_y + shop_grid_visible_rows * (talent_card_h + talent_card_gap_y) + 2, "▼  (Mais talentos abaixo - Role para ver)  ▼");
            }

            for (var _row = _start_vis_s_row; _row < _end_vis_s_row; _row++) {
                for (var _col = 0; _col < _cols; _col++) {
                    var _i = _row * _cols + _col;
                    if (_i >= _tn) break;
                    var _t = _tab_talents[_i];
                    var _unlocked = talent_is_unlocked(_t.id);
                    var _elem_locked = (_t.affinity != "none" && !element_is_unlocked(_t.affinity, classes[shop_tab_index]));
                    var _is_cursor = (_i == shop_talent_index);
                    var _cx = _start_x + _col * (talent_card_w + talent_card_gap_x);
                    var _cy = _grid_shop_y + (_row - _start_vis_s_row) * (talent_card_h + talent_card_gap_y);

                    // Card background
                    draw_set_alpha(0.85);
                    draw_set_color(_is_cursor ? make_colour_rgb(35, 45, 65) : make_colour_rgb(18, 22, 32));
                    draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, false);
                    draw_set_alpha(1);

                    // Card border
                    if (_is_cursor) {
                        draw_set_color(c_yellow);
                        draw_rectangle(_cx - 2, _cy - 2, _cx + talent_card_w + 2, _cy + talent_card_h + 2, true);
                        draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                    } else if (_unlocked) {
                        draw_set_color(make_colour_rgb(60, 140, 80));
                        draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                    } else if (_elem_locked) {
                        draw_set_color(make_colour_rgb(90, 45, 55));
                        draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                    } else {
                        draw_set_color(make_colour_rgb(55, 68, 90));
                        draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                    }

                    // Icon
                    var _icon = talent_get_icon_type(_t);
                    var _icon_col = _is_cursor ? c_yellow : (_unlocked ? c_lime : (_elem_locked ? make_colour_rgb(150, 90, 95) : c_ltgray));
                    draw_talent_icon(_icon, _cx + talent_card_w / 2, _cy + 34, 26, _icon_col);

                    // Name
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(_is_cursor ? c_yellow : (_unlocked ? c_white : (_elem_locked ? c_gray : c_ltgray)));
                    var _max_text_w = talent_card_w - 16;
                    var _line_w = string_width_ext(_t.label, 14, _max_text_w);
                    if (_line_w > _max_text_w) {
                        var _sc = _max_text_w / _line_w;
                        draw_text_transformed(_cx + talent_card_w / 2, _cy + 74, _t.label, _sc, _sc, 0);
                    } else {
                        draw_text_ext(_cx + talent_card_w / 2, _cy + 74, _t.label, 14, _max_text_w);
                    }

                    // Status Badge in card
                    if (_unlocked) {
                        draw_set_color(c_lime);
                        draw_rectangle(_cx + talent_card_w - 22, _cy + 4, _cx + talent_card_w - 4, _cy + 22, false);
                        draw_set_color(c_black);
                        draw_text(_cx + talent_card_w - 13, _cy + 13, "V");
                    } else if (_elem_locked) {
                        draw_set_color(make_colour_rgb(55, 20, 25));
                        draw_rectangle(_cx + talent_card_w - 48, _cy + 4, _cx + talent_card_w - 4, _cy + 20, false);
                        draw_set_color(c_red);
                        draw_rectangle(_cx + talent_card_w - 48, _cy + 4, _cx + talent_card_w - 4, _cy + 20, true);
                        draw_text(_cx + talent_card_w - 26, _cy + 12, "BLOQ");
                    } else {
                        draw_set_color(make_colour_rgb(45, 38, 20));
                        draw_rectangle(_cx + talent_card_w - 42, _cy + 4, _cx + talent_card_w - 4, _cy + 20, false);
                        draw_set_color(c_yellow);
                        draw_rectangle(_cx + talent_card_w - 42, _cy + 4, _cx + talent_card_w - 4, _cy + 20, true);
                        draw_text(_cx + talent_card_w - 23, _cy + 12, string(_t.cost) + "G");
                    }
                }
            }

            // ---- Bottom Info Box for Shop ----
            var _cur_t = _tab_talents[shop_talent_index];
            var _unlocked = talent_is_unlocked(_cur_t.id);
            var _cur_elem_locked = (_cur_t.affinity != "none" && !element_is_unlocked(_cur_t.affinity, classes[shop_tab_index]));

            var _box_w = 980;
            var _box_h = 135;
            var _box_x = (room_width - _box_w) / 2;
            var _box_y = 475;

            // Background & border
            draw_set_alpha(0.92);
            draw_set_color(make_colour_rgb(12, 16, 26));
            draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
            draw_set_alpha(1);
            draw_set_color(make_colour_rgb(70, 95, 135));
            draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);
            draw_rectangle(_box_x - 1, _box_y - 1, _box_x + _box_w + 1, _box_y + _box_h + 1, true);

            // Left icon container
            draw_set_color(make_colour_rgb(22, 28, 42));
            draw_rectangle(_box_x + 18, _box_y + 18, _box_x + 114, _box_y + _box_h - 18, false);
            draw_set_color(make_colour_rgb(55, 75, 110));
            draw_rectangle(_box_x + 18, _box_y + 18, _box_x + 114, _box_y + _box_h - 18, true);
            draw_talent_icon(talent_get_icon_type(_cur_t), _box_x + 66, _box_y + _box_h / 2, 44, _unlocked ? c_lime : (_cur_elem_locked ? make_colour_rgb(150, 90, 95) : c_yellow));

            // Header line: Title & Price/Status
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(c_yellow);
            draw_text(_box_x + 130, _box_y + 18, _cur_t.label);

            draw_set_halign(fa_right);
            if (_unlocked) {
                draw_set_color(c_lime);
                draw_text(_box_x + _box_w - 24, _box_y + 18, "JA DESBLOQUEADO");
            } else if (_cur_elem_locked) {
                draw_set_color(c_orange);
                draw_text(_box_x + _box_w - 24, _box_y + 18, "BLOQUEADO: " + element_get_unlock_requirement(_cur_t.affinity));
            } else {
                var _buy_tip = _is_mobile ? "(Toque para Comprar)" : "[Z para Comprar]";
                if (global.gold >= _cur_t.cost) {
                    draw_set_color(c_yellow);
                    draw_text(_box_x + _box_w - 24, _box_y + 18, "PRECO: " + string(_cur_t.cost) + " OURO   " + _buy_tip);
                } else {
                    draw_set_color(c_red);
                    draw_text(_box_x + _box_w - 24, _box_y + 18, "PRECO: " + string(_cur_t.cost) + " OURO   (Ouro Insuficiente)");
                }
            }

            // Divider line
            draw_set_color(make_colour_rgb(45, 60, 85));
            draw_line(_box_x + 130, _box_y + 44, _box_x + _box_w - 24, _box_y + 44);

            // Descriptive effect only
            var _shop_flavor = talent_get_desc_flavor(_cur_t);
            var _sh_sep = 18;
            var _sh_max_w = _box_w - 160;

            draw_set_halign(fa_left);
            draw_set_color(c_white);
            draw_text_ext(_box_x + 130, _box_y + 52, _shop_flavor, _sh_sep, _sh_max_w);

            var _sh_h = string_height_ext(_shop_flavor, _sh_sep, _sh_max_w);
            var _meta_y = max(_box_y + 104, _box_y + 52 + _sh_h + 10);

            draw_set_color(c_ltgray);
            draw_text(_box_x + 130, _meta_y, "Classe: " + labels[shop_tab_index] + "   |   Seu saldo: " + string(global.gold) + " ouro");
        }

        // Botões inferiores na Loja
        var _btn_shop_y = 650;
        var _btn_shop_h = 46;

        // Botão [ Voltar ]
        draw_set_color(make_colour_rgb(26, 36, 56));
        draw_rectangle(60, _btn_shop_y, 240, _btn_shop_y + _btn_shop_h, false);
        draw_set_color(make_colour_rgb(70, 95, 135));
        draw_rectangle(60, _btn_shop_y, 240, _btn_shop_y + _btn_shop_h, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_ltgray);
        draw_text(150, _btn_shop_y + _btn_shop_h / 2, _is_mobile ? "VOLTAR" : (input_get_btn_label("cancel") + " Voltar"));

        // Botão [ Comprar ]
        var _btn_buy_w = 320;
        var _btn_buy_x = room_width - 60 - _btn_buy_w;
        draw_set_color(make_colour_rgb(32, 54, 86));
        draw_rectangle(_btn_buy_x, _btn_shop_y, _btn_buy_x + _btn_buy_w, _btn_shop_y + _btn_shop_h, false);
        draw_set_color(c_yellow);
        draw_rectangle(_btn_buy_x, _btn_shop_y, _btn_buy_x + _btn_buy_w, _btn_shop_y + _btn_shop_h, true);
        draw_set_color(c_white);
        draw_text(_btn_buy_x + _btn_buy_w / 2, _btn_shop_y + _btn_shop_h / 2, _is_mobile ? "COMPRAR TALENTO" : (input_get_btn_label("confirm") + " Comprar Talento"));

        // Footer instructions adaptadas ao dispositivo
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        var _shop_tip = _is_mobile ? "Toque nas abas de classe ou nos cards para comprar" : (input_is_gamepad_active() ? ("D-Pad: Navegar   |   " + input_get_btn_label("shoulder_l") + "/" + input_get_btn_label("shoulder_r") + ": Abas   |   " + input_get_btn_label("confirm") + ": Comprar") : "Clique ou use as Setas/Enter para selecionar e comprar");
        draw_text(room_width / 2, 626, _shop_tip);

        if (locked_warning_timer > 0) {
            var _flash = (locked_warning_timer mod 10 < 5);
            draw_set_color(_flash ? c_yellow : c_red);
            draw_text(room_width / 2, 626, _is_mobile ? "COMPRA BLOQUEADA: Derrote o chefe elemental ou ative o Modo Dev no topo!" : "COMPRA BLOQUEADA: Requer derrotar o chefe elemental na campanha ou ativar o Modo Dev [F1]!");
        }
        break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
