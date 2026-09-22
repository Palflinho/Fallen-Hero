// =========================================================================
// DRAW_64: PORTAL DA FENDA & MODAL DE PREPARAÇÃO DA EXPEDIÇÃO
// =========================================================================

var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// -------------------------------------------------------------------------
// 1. Prompt Flutuante no Mundo (Quando o Modal está fechado)
// -------------------------------------------------------------------------
if (!modal_open) {
    if (point_distance(x, y, _player.x, _player.y) <= 75) {
        var _cam = view_camera[0];
        var _cx = camera_get_view_x(_cam);
        var _cy = camera_get_view_y(_cam);
        var _sx = (x - _cx);
        var _sy = (y - _cy - 72);

        draw_set_font(-1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);

        var _final_unlocked = all_elements_reclaimed();
        var _prompt = _final_unlocked ? loc("portal_temple5_prompt") : "[Espaco / A] Iniciar Expedicao (Portal)";
        var _col = _final_unlocked ? make_colour_rgb(255, 220, 80) : make_colour_rgb(120, 220, 255);

        var _box_w = string_width(_prompt) + 24;
        var _box_h = 28;
        var _bx = _sx - _box_w * 0.5;
        var _by = _sy - _box_h;

        draw_set_alpha(0.88);
        draw_set_colour(make_colour_rgb(12, 16, 26));
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);
        draw_set_colour(_col);
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);

        draw_set_alpha(1.0);
        draw_set_colour(_col);
        draw_text(_sx, _by + 20, _prompt);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_colour(c_white);
    }
    exit;
}

// -------------------------------------------------------------------------
// 2. MODAL DEDICADO DE SELEÇÃO AO INICIAR A RUN
// -------------------------------------------------------------------------

// Fundo Escurecido Translúcido (Backdrop)
draw_set_colour(c_black);
draw_set_alpha(0.82);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1.0);

// Painel Central Arcano
var _mw = min(1040, _gw - 60);
var _mh = 530;
var _mx = round((_gw - _mw) * 0.5);
var _my = round((_gh - _mh) * 0.5);

// Fundo do Painel
draw_set_colour(make_colour_rgb(10, 14, 24));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);

// Borda Mística / Dimensional
draw_set_colour(make_colour_rgb(35, 75, 120));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
draw_set_colour(make_colour_rgb(80, 190, 255));
draw_rectangle(_mx + 4, _my + 4, _mx + _mw - 4, _my + _mh - 4, true);

// Cabeçalho
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_colour(make_colour_rgb(255, 220, 80));
draw_text_transformed(_gw * 0.5, _my + 14, "PORTAL DA FENDA - PREPARACAO DA EXPEDICAO", 1.35, 1.35, 0);

draw_set_colour(make_colour_rgb(180, 220, 245));
draw_text(_gw * 0.5, _my + 38, "Selecione o Campeao e a Afinidade Elemental para descer as catacumbas:");

// Divisor Superior
draw_set_colour(make_colour_rgb(40, 80, 120));
draw_line(_mx + 20, _my + 58, _mx + _mw - 20, _my + 58);

// -------------------------------------------------------------------------
// Cards das 4 Classes
// -------------------------------------------------------------------------
var _card_y = _my + 70;
var _card_h = 280;
var _gap = 16;
var _card_w = floor((_mw - 60 - 3 * _gap) / 4);

for (var _i = 0; _i < 4; _i++) {
    var _cx = _mx + 30 + _i * (_card_w + _gap);
    var _is_sel = (_i == selected_class_idx);
    var _c_name = classes[_i];

    // Clique direto no card
    if (touch_gui_clicked(_cx, _card_y, _cx + _card_w, _card_y + _card_h)) {
        selected_class_idx = _i;
        sfx_play("menu_move");
    }

    // Fundo do Card
    draw_set_colour(_is_sel ? make_colour_rgb(20, 42, 70) : make_colour_rgb(13, 18, 30));
    draw_rectangle(_cx, _card_y, _cx + _card_w, _card_y + _card_h, false);

    // Borda do Card
    draw_set_colour(_is_sel ? make_colour_rgb(255, 215, 80) : make_colour_rgb(45, 65, 95));
    draw_rectangle(_cx, _card_y, _cx + _card_w, _card_y + _card_h, true);
    if (_is_sel) {
        draw_rectangle(_cx + 2, _card_y + 2, _cx + _card_w - 2, _card_y + _card_h - 2, true);
    }

    // Nome da Classe
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(_is_sel ? c_yellow : c_white);
    draw_text_transformed(_cx + _card_w * 0.5, _card_y + 10, class_labels[_i], 1.25, 1.25, 0);

    // Retrato Chibi
    var _chibi_cx = _cx + _card_w * 0.5;
    var _chibi_cy = _card_y + 98;
    var _spr = asset_get_index("spr_portrait_" + _c_name);
    if (_spr != -1 && sprite_exists(_spr)) {
        var _sw = sprite_get_width(_spr);
        var _sh = sprite_get_height(_spr);
        var _max_w = _card_w - 32;
        var _max_h = 100;
        var _scale = min(_max_w / max(1, _sw), _max_h / max(1, _sh));
        draw_sprite_ext(_spr, 0, _chibi_cx, _chibi_cy, _scale, _scale, 0, c_white, 1.0);
    } else {
        draw_set_colour(class_colors[_i]);
        draw_circle(_chibi_cx, _chibi_cy, 36, false);
        draw_set_colour(c_black);
        draw_text(_chibi_cx, _chibi_cy - 8, string_copy(_c_name, 1, 3));
    }

    // Divisor interno
    draw_set_colour(make_colour_rgb(35, 60, 90));
    draw_line(_cx + 10, _card_y + 155, _cx + _card_w - 10, _card_y + 155);

    // Arma e Função
    draw_set_colour(make_colour_rgb(255, 205, 90));
    draw_text(_cx + _card_w * 0.5, _card_y + 162, class_weapons[_i]);

    draw_set_colour(make_colour_rgb(130, 210, 255));
    draw_text(_cx + _card_w * 0.5, _card_y + 180, class_roles[_i]);

    // Descrição
    draw_set_colour(make_colour_rgb(170, 190, 215));
    draw_text_ext(_cx + _card_w * 0.5, _card_y + 204, class_subtitles[_i], 14, _card_w - 16);

    // Distintivo de Seleção
    draw_set_colour(_is_sel ? c_lime : make_colour_rgb(90, 110, 135));
    draw_text(_cx + _card_w * 0.5, _card_y + 258, _is_sel ? "[ SELECIONADO ]" : "[ Clique p/ Escolher ]");
}

// -------------------------------------------------------------------------
// Seletor de Afinidade Elemental
// -------------------------------------------------------------------------
var _cur_char = classes[selected_class_idx];
var _cur_elem = elements[selected_element_idx];
var _elem_unlocked = element_is_unlocked(_cur_elem, _cur_char);
var _bar_y = _card_y + _card_h + 14;
var _bar_h = 60;

draw_set_colour(make_colour_rgb(12, 18, 30));
draw_rectangle(_mx + 30, _bar_y, _mx + _mw - 30, _bar_y + _bar_h, false);
draw_set_colour(element_colors[selected_element_idx]);
draw_rectangle(_mx + 30, _bar_y, _mx + _mw - 30, _bar_y + _bar_h, true);

// Setas clicáveis
if (touch_gui_clicked(_mx + 35, _bar_y + 6, _mx + 95, _bar_y + _bar_h - 6)) {
    selected_element_idx = (selected_element_idx - 1 + array_length(elements)) mod array_length(elements);
    sfx_play("menu_move");
}
if (touch_gui_clicked(_mx + _mw - 95, _bar_y + 6, _mx + _mw - 35, _bar_y + _bar_h - 6)) {
    selected_element_idx = (selected_element_idx + 1) mod array_length(elements);
    sfx_play("menu_move");
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_yellow);
draw_text(_mx + 65, _bar_y + _bar_h * 0.5, "< [Q]");
draw_text(_mx + _mw - 65, _bar_y + _bar_h * 0.5, "[E] >");

var _status_txt = _elem_unlocked ? "[LIBERADO]" : "[BLOQUEADO - Conquiste na Masmorra]";
var _status_col = _elem_unlocked ? c_lime : make_colour_rgb(245, 85, 85);
var _arch_label = get_hero_archetype_label(_cur_char, _cur_elem);

draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_text(_gw * 0.5, _bar_y + 10, "Afinidade Elemental: " + element_labels[selected_element_idx] + "  -  Arquetipo: " + _arch_label);

draw_set_colour(_status_col);
draw_text(_gw * 0.5, _bar_y + 34, _status_txt);

// -------------------------------------------------------------------------
// Rodapé com Ações de Confirmação & Alertas
// -------------------------------------------------------------------------
if (notice_timer > 0 && notice_text != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(make_colour_rgb(255, 90, 90));
    draw_text(_gw * 0.5, _bar_y + _bar_h + 10, notice_text);
}

var _btn_y = _my + _mh - 56;
var _btn_h = 42;

// Botão Iniciar Expedição
var _btn_c_w = 280;
var _btn_c_x = _gw * 0.5 - _btn_c_w - 15;
var _c_hover = touch_gui_clicked(_btn_c_x, _btn_y, _btn_c_x + _btn_c_w, _btn_y + _btn_h);

draw_set_colour(_elem_unlocked ? make_colour_rgb(20, 75, 45) : make_colour_rgb(50, 50, 50));
draw_rectangle(_btn_c_x, _btn_y, _btn_c_x + _btn_c_w, _btn_y + _btn_h, false);
draw_set_colour(_elem_unlocked ? c_lime : c_gray);
draw_rectangle(_btn_c_x, _btn_y, _btn_c_x + _btn_c_w, _btn_y + _btn_h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(_elem_unlocked ? c_white : c_gray);
draw_text(_btn_c_x + _btn_c_w * 0.5, _btn_y + _btn_h * 0.5, "[Z / Enter] Descer as Catacumbas!");

// Botão Permanecer na Vila
var _btn_x_w = 180;
var _btn_x_x = _gw * 0.5 + 15;
var _x_hover = touch_gui_clicked(_btn_x_x, _btn_y, _btn_x_x + _btn_x_w, _btn_y + _btn_h);

draw_set_colour(make_colour_rgb(45, 20, 24));
draw_rectangle(_btn_x_x, _btn_y, _btn_x_x + _btn_x_w, _btn_y + _btn_h, false);
draw_set_colour(make_colour_rgb(220, 75, 75));
draw_rectangle(_btn_x_x, _btn_y, _btn_x_x + _btn_x_w, _btn_y + _btn_h, true);

draw_set_colour(c_white);
draw_text(_btn_x_x + _btn_x_w * 0.5, _btn_y + _btn_h * 0.5, "[Esc] Ficar na Vila");

// Eventos de clique nos botões
if (_c_hover) {
    start_expedition();
}
if (_x_hover) {
    close_portal_modal();
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
