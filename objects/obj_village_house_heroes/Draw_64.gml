var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// -------------------------------------------------------------------------
// 1. Dica Flutuante no Mundo quando próximo à porta
// -------------------------------------------------------------------------
if (!modal_open) {
    if (is_world_paused()) exit;

    var _door_x = x;
    var _door_y = y + 42;
    var _dist = point_distance(_door_x, _door_y, _player.x, _player.y);

    if (_dist <= interact_radius) {
        var _cam = view_camera[0];
        var _cx = camera_get_view_x(_cam);
        var _cy = camera_get_view_y(_cam);
        var _sx = (_door_x - _cx);
        var _sy = (_door_y - _cy - 48);

        draw_set_font(-1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        var _txt = "[Espaco / A] Alojamento dos Herois";
        var _lang = loc_get_language();
        if (_lang == "en") _txt = "[Space / A] Hero Quarters";
        else if (_lang == "es") _txt = "[Espacio / A] Cuartel de Heroes";
        else if (_lang == "ja") _txt = "[Space / A] 英雄の宿舎";

        var _bw = string_width(_txt) + 24;
        var _bh = 26;
        var _bx = _sx - _bw * 0.5;
        var _by = _sy - _bh * 0.5;

        draw_set_alpha(0.88);
        draw_set_colour(make_colour_rgb(15, 20, 32));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
        draw_set_colour(make_colour_rgb(255, 215, 80));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

        draw_set_alpha(1.0);
        draw_set_colour(make_colour_rgb(255, 220, 100));
        draw_text(_sx, _sy, _txt);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    exit;
}

// -------------------------------------------------------------------------
// 2. Modal Completo de Seleção de Classe & Talentos na Vila
// -------------------------------------------------------------------------
// Fundo escurecido
draw_set_alpha(0.82);
draw_set_colour(make_colour_rgb(6, 8, 14));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1.0);

var _mw = 1000;
var _mh = 620;
var _mx = (_gw - _mw) * 0.5;
var _my = (_gh - _mh) * 0.5;

// Moldura do Modal
draw_set_colour(make_colour_rgb(18, 24, 38));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
draw_set_colour(make_colour_rgb(80, 110, 160));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
draw_set_colour(make_colour_rgb(40, 60, 90));
draw_rectangle(_mx + 4, _my + 4, _mx + _mw - 4, _my + _mh - 4, true);

// Cabeçalho do Modal
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_yellow);
draw_text_transformed(_gw * 0.5, _my + 16, "ALOJAMENTO DOS CAMPEOES", 1.8, 1.8, 0);

draw_set_colour(make_colour_rgb(160, 180, 210));
draw_text(_gw * 0.5, _my + 46, "Escolha sua Classe, Afinidade Elemental e Talentos Iniciais");

// -------------------------------------------------------------------------
// Grid das 4 Classes
// -------------------------------------------------------------------------
var _card_w = 216;
var _card_h = 240;
var _card_gap = 18;
var _cards_total_w = 4 * _card_w + 3 * _card_gap;
var _card_start_x = _mx + (_mw - _cards_total_w) * 0.5;
var _card_y = _my + 74;

for (var _i = 0; _i < 4; _i++) {
    var _cx = _card_start_x + _i * (_card_w + _card_gap);
    var _is_sel = (_i == selected_class_idx);
    var _c_name = classes[_i];
    var _c_col = class_colors[_i];

    // Clique com mouse/toque no card
    if (touch_gui_clicked(_cx, _card_y, _cx + _card_w, _card_y + _card_h)) {
        selected_class_idx = _i;
        refresh_talents_list();
        sfx_play("menu_move");
    }

    // Fundo do Card
    draw_set_alpha(_is_sel ? 0.95 : 0.65);
    draw_set_colour(_is_sel ? make_colour_rgb(26, 38, 60) : make_colour_rgb(14, 18, 28));
    draw_rectangle(_cx, _card_y, _cx + _card_w, _card_y + _card_h, false);

    // Borda destacada
    draw_set_alpha(1.0);
    draw_set_colour(_is_sel ? c_yellow : make_colour_rgb(50, 65, 90));
    draw_rectangle(_cx, _card_y, _cx + _card_w, _card_y + _card_h, true);
    if (_is_sel) {
        draw_rectangle(_cx - 2, _card_y - 2, _cx + _card_w + 2, _card_y + _card_h + 2, true);
    }

    // Nome da Classe
    draw_set_halign(fa_center);
    draw_set_colour(_is_sel ? c_yellow : c_white);
    draw_text_transformed(_cx + _card_w * 0.5, _card_y + 12, class_labels[_i], 1.25, 1.25, 0);

    // Ícone / Representação Chibi do Herói
    var _chibi_cx = _cx + _card_w * 0.5;
    var _chibi_cy = _card_y + 82;
    var _spr = asset_get_index("spr_portrait_" + _c_name);
    if (_spr != -1 && sprite_exists(_spr)) {
        var _sw = sprite_get_width(_spr);
        var _sh = sprite_get_height(_spr);
        var _max_w = _card_w - 36;
        var _max_h = 105;
        var _scale = min(_max_w / max(1, _sw), _max_h / max(1, _sh));
        draw_sprite_ext(_spr, 0, _chibi_cx, _chibi_cy, _scale, _scale, 0, c_white, 1.0);
    } else {
        draw_set_colour(_c_col);
        draw_circle(_chibi_cx, _chibi_cy, 24, false);
        draw_set_colour(c_black);
        draw_circle(_chibi_cx - 6, _chibi_cy - 4, 3, false);
        draw_circle(_chibi_cx + 6, _chibi_cy - 4, 3, false);
    }

    // Descrição do papel da classe
    draw_set_colour(make_colour_rgb(170, 185, 205));
    draw_text_ext(_cx + _card_w * 0.5, _card_y + 155, class_subtitles[_i], 14, _card_w - 18);
}

// -------------------------------------------------------------------------
// Seletor de Afinidade Elemental (Barra Central)
// -------------------------------------------------------------------------
var _cur_char = classes[selected_class_idx];
var _cur_elem = elements[selected_element_idx];
var _elem_unlocked = element_is_unlocked(_cur_elem, _cur_char);
var _bar_y = _card_y + _card_h + 16;

draw_set_colour(make_colour_rgb(12, 16, 26));
draw_rectangle(_mx + 40, _bar_y, _mx + _mw - 40, _bar_y + 42, false);
draw_set_colour(element_colors[selected_element_idx]);
draw_rectangle(_mx + 40, _bar_y, _mx + _mw - 40, _bar_y + 42, true);

// Setas clicáveis para trocar elemento
if (touch_gui_clicked(_mx + 45, _bar_y, _mx + 95, _bar_y + 42)) {
    selected_element_idx = (selected_element_idx - 1 + array_length(elements)) mod array_length(elements);
    refresh_talents_list();
    sfx_play("menu_move");
}
if (touch_gui_clicked(_mx + _mw - 95, _bar_y, _mx + _mw - 45, _bar_y + 42)) {
    selected_element_idx = (selected_element_idx + 1) mod array_length(elements);
    refresh_talents_list();
    sfx_play("menu_move");
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_yellow);
draw_text(_mx + 70, _bar_y + 21, "< [Q]");
draw_text(_mx + _mw - 70, _bar_y + 21, "[E] >");

var _status_txt = _elem_unlocked ? "[LIBERADO]" : "[BLOQUEADO - Vença no Templo]";
var _status_col = _elem_unlocked ? c_lime : make_colour_rgb(240, 80, 80);
var _arch_label = get_hero_archetype_label(_cur_char, _cur_elem);

draw_set_colour(c_white);
draw_text(_gw * 0.5 - 140, _bar_y + 21, "Afinidade: " + element_labels[selected_element_idx] + " (" + _arch_label + ")");
draw_set_colour(_status_col);
draw_text(_gw * 0.5 + 230, _bar_y + 21, _status_txt);

// -------------------------------------------------------------------------
// Lista de Talentos Iniciais Disponíveis
// -------------------------------------------------------------------------
var _tal_sec_y = _bar_y + 54;
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(make_colour_rgb(255, 215, 80));
draw_text(_mx + 45, _tal_sec_y, "Talentos Iniciais Equipados (" + string(array_length(talent_selected_ids)) + "/3) - Pressione [Espaco] para Selecionar:");

var _t_count = array_length(talent_select_list);
var _tal_card_y = _tal_sec_y + 26;
var _t_box_w = 286;
var _t_box_h = 60;
var _t_gap = 16;

for (var _k = 0; _k < min(3, _t_count); _k++) {
    var _tx = _mx + 45 + _k * (_t_box_w + _t_gap);
    var _t_item = talent_select_list[_k];
    var _t_id = _t_item.id;

    var _is_equipped = false;
    for (var _eq = 0; _eq < array_length(talent_selected_ids); _eq++) {
        if (talent_selected_ids[_eq] == _t_id) { _is_equipped = true; break; }
    }

    if (touch_gui_clicked(_tx, _tal_card_y, _tx + _t_box_w, _tal_card_y + _t_box_h)) {
        talent_cursor = _k;
        var _idx = -1;
        for (var _i = 0; _i < array_length(talent_selected_ids); _i++) {
            if (talent_selected_ids[_i] == _t_id) { _idx = _i; break; }
        }
        if (_idx >= 0) {
            array_delete(talent_selected_ids, _idx, 1);
        } else if (array_length(talent_selected_ids) < 3) {
            array_push(talent_selected_ids, _t_id);
        }
        sfx_play("gold", 0.08, 0.8);
    }

    draw_set_colour(_is_equipped ? make_colour_rgb(25, 45, 70) : make_colour_rgb(12, 16, 26));
    draw_rectangle(_tx, _tal_card_y, _tx + _t_box_w, _tal_card_y + _t_box_h, false);
    draw_set_colour(_is_equipped ? c_lime : make_colour_rgb(50, 70, 95));
    draw_rectangle(_tx, _tal_card_y, _tx + _t_box_w, _tal_card_y + _t_box_h, true);

    draw_set_colour(_is_equipped ? c_lime : c_white);
    draw_text(_tx + 10, _tal_card_y + 8, (_is_equipped ? "[X] " : "[ ] ") + _t_item.label);
    draw_set_colour(make_colour_rgb(160, 180, 200));
    draw_text_ext(_tx + 10, _tal_card_y + 28, _t_item.desc_value, 13, _t_box_w - 18);
}

if (_t_count == 0) {
    draw_set_colour(make_colour_rgb(180, 100, 100));
    draw_text(_mx + 45, _tal_card_y + 12, "Nenhum talento desbloqueado para esta afinidade ainda. Visite o Emporio da Fenda!");
}

// -------------------------------------------------------------------------
// Rodapé com Ações de Confirmação
// -------------------------------------------------------------------------
var _foot_y = _my + _mh - 56;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Botão Confirmar
var _btn_cf_x = _gw * 0.5 + 160;
var _btn_cf_w = 260;
var _btn_cf_h = 38;
draw_set_colour(make_colour_rgb(35, 120, 55));
draw_rectangle(_btn_cf_x - _btn_cf_w * 0.5, _foot_y - _btn_cf_h * 0.5, _btn_cf_x + _btn_cf_w * 0.5, _foot_y + _btn_cf_h * 0.5, false);
draw_set_colour(c_lime);
draw_rectangle(_btn_cf_x - _btn_cf_w * 0.5, _foot_y - _btn_cf_h * 0.5, _btn_cf_x + _btn_cf_w * 0.5, _foot_y + _btn_cf_h * 0.5, true);
draw_set_colour(c_white);
draw_text(_btn_cf_x, _foot_y, "[Z / Enter] Assumir Esta Classe");

// Botão Fechar
var _btn_cl_x = _gw * 0.5 - 160;
var _btn_cl_w = 200;
draw_set_colour(make_colour_rgb(60, 30, 35));
draw_rectangle(_btn_cl_x - _btn_cl_w * 0.5, _foot_y - _btn_cf_h * 0.5, _btn_cl_x + _btn_cl_w * 0.5, _foot_y + _btn_cf_h * 0.5, false);
draw_set_colour(make_colour_rgb(220, 80, 80));
draw_rectangle(_btn_cl_x - _btn_cl_w * 0.5, _foot_y - _btn_cf_h * 0.5, _btn_cl_x + _btn_cl_w * 0.5, _foot_y + _btn_cf_h * 0.5, true);
draw_set_colour(c_white);
draw_text(_btn_cl_x, _foot_y, "[X / Esc] Voltar a Vila");

// Toast de Notificação
if (notice_timer > 0) {
    var _nw = string_width(notice_text) + 36;
    draw_set_alpha(0.92);
    draw_set_colour(make_colour_rgb(180, 30, 40));
    draw_rectangle(_gw * 0.5 - _nw * 0.5, _my + _mh - 105, _gw * 0.5 + _nw * 0.5, _my + _mh - 75, false);
    draw_set_colour(c_yellow);
    draw_rectangle(_gw * 0.5 - _nw * 0.5, _my + _mh - 105, _gw * 0.5 + _nw * 0.5, _my + _mh - 75, true);
    draw_set_alpha(1.0);
    draw_set_colour(c_white);
    draw_text(_gw * 0.5, _my + _mh - 90, notice_text);
}
