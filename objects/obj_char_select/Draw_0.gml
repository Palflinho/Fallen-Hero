draw_set_font(-1);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(room_width - 20, 20, "Ouro: " + string(global.gold));
draw_set_color(c_white);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (state) {
    case "select":
        var _n = array_length(classes);
        var _total_w = _n * box_w + (_n - 1) * box_gap;
        var _start_x = (room_width - _total_w) / 2;
        var _y = room_height / 2 - box_h / 2;

        draw_set_color(c_white);
        draw_text(room_width / 2, 80, "Escolha seu Heroi");
        draw_text(room_width / 2, room_height - 60, "Setas para mover  -  Z confirma  -  S abre a loja");

        if (global.has_save) {
            draw_set_color(c_yellow);
            draw_text(room_width / 2, 110, "C - Continuar (" + global.save_character + " - " + global.save_room + ")");
            draw_set_color(c_white);
        }

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
        draw_set_color(c_white);
        draw_text(room_width / 2, 50, "Talentos - " + labels[selected_index]);

        var _ly = 150;
        if (classes[selected_index] == "knight") {
            var _elem_id = elements[selected_element_index];
            var _arch = knight_get_archetype_name(_elem_id);
            var _desc = knight_get_archetype_desc(_elem_id);

            draw_set_color(c_yellow);
            draw_text(room_width / 2, 80, "< Q / E : Sintonia Elemental - " + element_labels[selected_element_index] + " >");
            draw_set_color(c_aqua);
            draw_text(room_width / 2, 105, _desc);
            _ly = 145;
        }

        draw_set_color(c_white);
        draw_text(room_width / 2, room_height - 70, "Cima/baixo navega  -  Espaco marca (max 3)  -  Z confirma e comeca  -  X volta");
        draw_text(room_width / 2, room_height - 40, string(array_length(talent_selected_ids)) + "/3 selecionados");

        var _m = array_length(talent_select_list);
        if (_m == 0) {
            draw_text(room_width / 2, _ly + 30, "Nenhum talento desbloqueado ainda -- volte e aperte S pra abrir a loja.");
        }
        for (var _i = 0; _i < _m; _i++) {
            var _t = talent_select_list[_i];
            var _is_cursor = (_i == talent_select_cursor);
            var _is_picked = false;
            for (var j = 0; j < array_length(talent_selected_ids); j++) {
                if (talent_selected_ids[j] == _t.id) {
                    _is_picked = true;
                    break;
                }
            }

            draw_set_color(_is_cursor ? c_yellow : c_white);
            draw_text(room_width / 2, _ly + _i * 26, (_is_picked ? "[X] " : "[ ] ") + _t.label);
        }
        draw_set_color(c_white);
        break;

    case "shop":
        draw_set_color(c_white);
        draw_text(room_width / 2, 80, "Loja de Talentos");
        draw_text(room_width / 2, room_height - 60, "Esquerda/direita: personagem  -  cima/baixo: talento  -  Z compra  -  X volta");

        var _n2 = array_length(classes);
        var _tab_w = room_width / _n2;
        for (var _i = 0; _i < _n2; _i++) {
            var _tx = _tab_w * _i + _tab_w / 2;
            draw_set_color((_i == shop_tab_index) ? colours[_i] : c_gray);
            draw_text(_tx, 130, labels[_i]);
        }

        var _tab_talents = get_talents_for_character(classes[shop_tab_index]);
        var _ty = 210;
        for (var _i = 0; _i < array_length(_tab_talents); _i++) {
            var _t = _tab_talents[_i];
            var _unlocked = talent_is_unlocked(_t.id);
            var _is_cursor = (_i == shop_talent_index);

            draw_set_color(_is_cursor ? c_yellow : (_unlocked ? c_lime : c_white));
            var _status = _unlocked ? "Desbloqueado" : ("Custa " + string(_t.cost) + " ouro");
            draw_text(room_width / 2, _ty + _i * 40, _t.label + "  -  " + _status);
        }
        draw_set_color(c_white);
        break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
