// Indicador do Modo Dev e Atalhos de Teste no canto superior esquerdo
draw_set_font(ui_font());
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _is_mobile = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));

var _dev_str = _is_mobile ? (global.dev_mode ? tr("Modo Dev: ATIVO (Liberado)") : tr("Modo Dev: Normal")) : (global.dev_mode ? tr("[F1] MODO DEV: ATIVADO (Tudo Desbloqueado)") : tr("[F1] Modo Dev: Desativado (Normal)"));
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
    draw_text(18, 42, tr("[F3] Zerar Elementos da Campanha"));
}

if (reset_notice_timer > 0) {
    draw_set_color(c_yellow);
    draw_text(260, 40, tr(">> Elementos reiniciados para bloqueados!"));
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

// Seletor de Idioma no Canto Superior Direito
var _lang_str = "[L] " + loc("language", "Idioma") + ": " + loc_get_language_label();
var _lw = string_width(_lang_str) + 20;
var _lx = room_width - _lw - 16;
var _ly = 12;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(0.85);
draw_set_color(make_colour_rgb(14, 18, 28));
draw_rectangle(_lx, _ly, _lx + _lw, _ly + 24, false);
draw_set_alpha(1);
draw_set_color(make_colour_rgb(70, 140, 220));
draw_rectangle(_lx, _ly, _lx + _lw, _ly + 24, true);

draw_set_color(make_colour_rgb(220, 240, 255));
draw_text(_lx + 10, _ly + 4, _lang_str);

if (mouse_check_button_pressed(mb_left)) {
    if (mouse_x >= _lx && mouse_x <= _lx + _lw && mouse_y >= _ly && mouse_y <= _ly + 24) {
        loc_next_language();
        char_select_refresh_texts();
        sfx_play("menu_select", 0.05, 1.2);
    }
}


draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (state) {
    case "main_menu":
        var _title_x = room_width / 2;
        var _title_y = 150;

        // Titulo com sombra
        draw_set_color(make_colour_rgb(15, 22, 35));
        draw_text_transformed(_title_x + 3, _title_y + 3, tr("FALLEN HERO"), 3, 3, 0);

        draw_set_color(c_yellow);
        draw_text_transformed(_title_x, _title_y, tr("FALLEN HERO"), 3, 3, 0);

        draw_set_color(make_colour_rgb(130, 180, 230));
        draw_text_transformed(_title_x, _title_y + 48, tr("As Cronicas dos Elementos"), 1.2, 1.2, 0);

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
                _label = tr("Continuar  (Sem Saves)");
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
        var _menu_tip = _is_mobile ? tr("Toque na opcao desejada para navegar") : tr("W / S ou Setas: Navegar   |   Z / Enter / Espaco / Clique: Confirmar");
        draw_text(room_width / 2, room_height - 45, _menu_tip);
        break;

    case "options":
        char_select_options_draw();
        break;

    case "controls":
        char_select_controls_draw();
        break;

    case "save_slots":
        var _is_new = (save_slot_action == "new_game");
        var _title_text = _is_new ? tr("NOVO JOGO - ESCOLHA UM SLOT") : tr("CONTINUAR - ESCOLHA UM SLOT");
        var _sub_text = _is_new ? tr("Selecione um slot para iniciar sua nova jornada do zero absoluto") : tr("Selecione um slot existente para carregar seu heroi salvo");

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
            draw_text_transformed(_cx + save_card_w / 2, _card_y + 30, tr("SLOT ") + string(_slot_num), 1.35, 1.35, 0);

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
                draw_text(_cx + save_card_w / 2, _card_y + 175, tr("SLOT VAZIO"));

                draw_set_color(make_colour_rgb(110, 130, 160));
                draw_text(_cx + save_card_w / 2, _card_y + 205, tr("Disponivel para"));
                draw_text(_cx + save_card_w / 2, _card_y + 225, tr("Nova Jornada"));

                // Rodapé do Card
                if (_is_new) {
                    draw_set_color(c_lime);
                    draw_rectangle(_cx + 25, _card_y + save_card_h - 52, _cx + save_card_w - 25, _card_y + save_card_h - 18, false);
                    draw_set_color(c_black);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, tr("INICIAR AQUI"));
                } else {
                    draw_set_color(c_dkgray);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, tr("(Sem Dados)"));
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
                draw_text(_cx + save_card_w / 2, _card_y + 125, tr("Nivel ") + string(_info.level));

                // 3. Sintonia Elemental
                draw_set_color(c_yellow);
                var _elem_str = tr("Sintonia: ") + element_get_name(_info.element);
                draw_text(_cx + save_card_w / 2, _card_y + 155, _elem_str);

                // 4. Tempo de Jogo
                draw_set_color(make_colour_rgb(180, 205, 235));
                draw_text(_cx + save_card_w / 2, _card_y + 190, tr("Tempo de Jogo:"));
                draw_set_color(c_white);
                draw_text(_cx + save_card_w / 2, _card_y + 212, format_playtime(_info.playtime));

                // Rodapé do Card
                if (_is_new) {
                    draw_set_color(make_colour_rgb(70, 30, 35));
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, false);
                    draw_set_color(c_orange);
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, true);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, tr("SOBRESCREVER"));
                } else {
                    draw_set_color(make_colour_rgb(26, 60, 40));
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, false);
                    draw_set_color(c_lime);
                    draw_rectangle(_cx + 20, _card_y + save_card_h - 52, _cx + save_card_w - 20, _card_y + save_card_h - 18, true);
                    draw_set_color(c_white);
                    draw_text(_cx + save_card_w / 2, _card_y + save_card_h - 35, tr("CARREGAR"));
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
        draw_text(120, _btn_back_y + _btn_back_h / 2, _is_mobile ? tr("VOLTAR") : (input_get_btn_label("cancel") + tr(" Voltar")));

        draw_set_halign(fa_center);
        draw_set_color(make_colour_rgb(160, 175, 195));
        var _slots_tip = _is_mobile ? tr("Toque no card para selecionar   |   Toque no [X] para excluir") : (input_has_gamepad_connected() ? (tr("D-Pad: Navegar   |   ") + input_get_btn_label("confirm") + tr(": Confirmar   |   ") + input_get_btn_label("cancel") + tr(": Voltar")) : tr("Setas / 1, 2, 3: Navegar   |   Enter / Clique: Confirmar   |   ESC: Voltar"));
        draw_text(room_width / 2 + 50, _btn_back_y + _btn_back_h / 2, _slots_tip);
        break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
