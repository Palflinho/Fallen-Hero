if (state != "main_menu") {
    draw_set_font(-1);
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
        var _title_y = 140;

        // Titulo com sombra
        draw_set_color(make_colour_rgb(15, 22, 35));
        draw_text_transformed(_title_x + 3, _title_y + 3, "FALLEN HERO", 3, 3, 0);

        draw_set_color(c_yellow);
        draw_text_transformed(_title_x, _title_y, "FALLEN HERO", 3, 3, 0);

        draw_set_color(make_colour_rgb(130, 180, 230));
        draw_text_transformed(_title_x, _title_y + 48, "As Cronicas dos Elementos", 1.2, 1.2, 0);

        // Botoes do menu principal
        var _menu_start_x = (room_width - main_menu_btn_w) / 2;
        var _menu_start_y = 250;

        for (var _i = 0; _i < array_length(main_menu_options); _i++) {
            var _bx = _menu_start_x;
            var _by = _menu_start_y + _i * (main_menu_btn_h + main_menu_btn_gap);
            var _is_cur = (main_menu_cursor == _i);
            var _is_continue = (_i == 1);
            var _has_save = global.has_save;

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
            if (_is_continue && !_has_save) {
                _label = "Continuar  (Sem Save)";
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

        // Painel de resumo do save
        if (global.has_save) {
            var _box_w = 660;
            var _box_h = 76;
            var _box_x = (room_width - _box_w) / 2;
            var _box_y = 485;

            draw_set_alpha(0.88);
            draw_set_color(make_colour_rgb(12, 16, 26));
            draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
            draw_set_alpha(1);

            draw_set_color((main_menu_cursor == 1) ? c_yellow : make_colour_rgb(60, 85, 120));
            draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_aqua);
            draw_text(_box_x + _box_w / 2, _box_y + 14, "PROGRESSO SALVO DISPONIVEL");

            draw_set_color(c_white);
            draw_text(_box_x + _box_w / 2, _box_y + 42, get_save_summary());
        }

        // Rodape de instrucoes
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_colour_rgb(160, 170, 185));
        draw_text(room_width / 2, room_height - 45, "W / S ou Setas: Navegar   |   Z / Enter / Espaco: Confirmar");
        break;

    case "select":
        var _n = array_length(classes);
        var _total_w = _n * box_w + (_n - 1) * box_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _y = room_height / 2 - box_h / 2;

        draw_set_color(c_white);
        draw_text(room_width / 2, 80, "Escolha seu Heroi");
        draw_text(room_width / 2, room_height - 60, "Setas: Mover  -  Z: Confirmar  -  S: Loja  -  X / Esc: Voltar ao Menu");

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
            draw_text(_bx + box_w / 2, _y + box_h + 24, labels[_i]);
        }
        break;

    case "select_talents":
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(room_width / 2, 36, "Talentos - " + labels[selected_index]);

        var _elem_id = elements[selected_element_index];
        var _arch = class_get_archetype_name(classes[selected_index], _elem_id);
        var _desc = class_get_archetype_desc(classes[selected_index], _elem_id);

        draw_set_color(c_yellow);
        draw_text(room_width / 2, 66, "< Q / E : Sintonia Elemental - " + element_get_name(_elem_id) + " (" + _arch + ") >");
        draw_set_color(c_aqua);
        draw_text(room_width / 2, 88, _desc);
        var _grid_start_y = 126;

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

            // ---- Bottom Info Box (Caixa de Texto Embaixo) ----
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
            var _box_h = 145;
            var _box_x = (room_width - _box_w) / 2;
            var _box_y = room_height - 188;

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
                draw_text(_box_x + _box_w - 24, _box_y + 18, "[Espaco] para Selecionar  (" + string(array_length(talent_selected_ids)) + "/3)");
            } else {
                draw_set_color(c_gray);
                draw_text(_box_x + _box_w - 24, _box_y + 18, "[Limite de 3 Atingido]");
            }

            // Divider line
            draw_set_color(make_colour_rgb(45, 60, 85));
            draw_line(_box_x + 130, _box_y + 44, _box_x + _box_w - 24, _box_y + 44);

            // Description with numeric values (calculo dinâmico de altura para evitar sobreposicao)
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

        // Footer instructions
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(room_width / 2, room_height - 30, "Setas: Navegar na grade  -  Espaco: Marcar/Desmarcar (max 3)  -  Z: Iniciar Run  -  X: Voltar");
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

        draw_set_color(c_yellow);
        draw_set_halign(fa_right);
        draw_text(_start_tab_x - 14, _tab_y + 16, "< Q");
        draw_set_halign(fa_left);
        draw_text(_start_tab_x + _total_tabs_w + 14, _tab_y + 16, "E >");
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
            var _cols = min(talent_grid_cols, _tn);
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
                } else {
                    draw_set_color(make_colour_rgb(55, 68, 90));
                    draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
                }

                // Icon
                var _icon = talent_get_icon_type(_t);
                var _icon_col = _is_cursor ? c_yellow : (_unlocked ? c_lime : c_ltgray);
                draw_talent_icon(_icon, _cx + talent_card_w / 2, _cy + 34, 26, _icon_col);

                // Name
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(_is_cursor ? c_yellow : (_unlocked ? c_white : c_ltgray));
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

            var _box_w = 980;
            var _box_h = 145;
            var _box_x = (room_width - _box_w) / 2;
            var _box_y = room_height - 188;

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
            draw_talent_icon(talent_get_icon_type(_cur_t), _box_x + 66, _box_y + _box_h / 2, 44, _unlocked ? c_lime : c_yellow);

            // Header line: Title & Price/Status
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(c_yellow);
            draw_text(_box_x + 130, _box_y + 18, _cur_t.label);

            draw_set_halign(fa_right);
            if (_unlocked) {
                draw_set_color(c_lime);
                draw_text(_box_x + _box_w - 24, _box_y + 18, "JA DESBLOQUEADO");
            } else {
                if (global.gold >= _cur_t.cost) {
                    draw_set_color(c_yellow);
                    draw_text(_box_x + _box_w - 24, _box_y + 18, "PRECO: " + string(_cur_t.cost) + " OURO   [Z para Comprar]");
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

        // Footer instructions
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(room_width / 2, room_height - 30, "Setas: Navegar na grade  -  Q / E: Trocar Classe  -  Z: Comprar  -  X: Voltar");
        break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
