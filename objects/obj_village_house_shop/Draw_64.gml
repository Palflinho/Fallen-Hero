var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// -------------------------------------------------------------------------
// 1. Dica Flutuante no Mundo quando próximo ao Empório
// -------------------------------------------------------------------------
if (!modal_open) {
    if (is_world_paused()) exit;

    var _door_x = x + 15;
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

        var _txt = "[Espaco / A] Emporio da Fenda (Loja)";
        var _lang = loc_get_language();
        if (_lang == "en") _txt = "[Space / A] Rift Emporium (Shop)";
        else if (_lang == "es") _txt = "[Espacio / A] Bazar de la Falla (Tienda)";
        else if (_lang == "ja") _txt = "[Space / A] 裂け目の商店 (ショップ)";

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
// 2. Modal Completo da Loja de Meta-Progressão
// -------------------------------------------------------------------------
draw_set_alpha(0.84);
draw_set_colour(make_colour_rgb(6, 8, 14));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1.0);

var _mw = 1040;
var _mh = 630;
var _mx = (_gw - _mw) * 0.5;
var _my = (_gh - _mh) * 0.5;

// Moldura do Modal
draw_set_colour(make_colour_rgb(20, 22, 32));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
draw_set_colour(make_colour_rgb(210, 160, 50));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
draw_set_colour(make_colour_rgb(70, 50, 20));
draw_rectangle(_mx + 4, _my + 4, _mx + _mw - 4, _my + _mh - 4, true);

// Cabeçalho da Loja
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_yellow);
draw_text_transformed(_gw * 0.5, _my + 14, "EMPORIO DA FENDA", 1.8, 1.8, 0);

draw_set_colour(make_colour_rgb(180, 190, 210));
draw_text(_gw * 0.5, _my + 42, "Adquira aprimoramentos permanentes com o ouro resgatado das masmorras");

// Saldo de Ouro no Topo Direito
draw_set_halign(fa_right);
draw_set_colour(make_colour_rgb(255, 220, 80));
draw_text_transformed(_mx + _mw - 24, _my + 16, "Ouro Salvo: " + string(global.gold) + " G", 1.25, 1.25, 0);

// -------------------------------------------------------------------------
// Abas das 4 Classes
// -------------------------------------------------------------------------
var _tab_w = 170;
var _tab_h = 32;
var _tab_gap = 14;
var _total_tabs_w = 4 * _tab_w + 3 * _tab_gap;
var _tab_start_x = _mx + (_mw - _total_tabs_w) * 0.5;
var _tab_y = _my + 68;

for (var _i = 0; _i < 4; _i++) {
    var _tx = _tab_start_x + _i * (_tab_w + _tab_gap);
    var _is_active = (_i == shop_tab_index);

    if (touch_gui_clicked(_tx, _tab_y, _tx + _tab_w, _tab_y + _tab_h)) {
        shop_tab_index = _i;
        shop_talent_index = 0;
        shop_grid_scroll_row = 0;
        sfx_play("menu_move");
    }

    draw_set_colour(_is_active ? make_colour_rgb(45, 55, 80) : make_colour_rgb(14, 16, 24));
    draw_rectangle(_tx, _tab_y, _tx + _tab_w, _tab_y + _tab_h, false);
    draw_set_colour(_is_active ? c_yellow : make_colour_rgb(60, 70, 95));
    draw_rectangle(_tx, _tab_y, _tx + _tab_w, _tab_y + _tab_h, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(_is_active ? c_yellow : c_white);
    draw_text(_tx + _tab_w * 0.5, _tab_y + _tab_h * 0.5, class_labels[_i]);
}

// -------------------------------------------------------------------------
// Grade de Talentos da Classe Ativa
// -------------------------------------------------------------------------
var _tab_talents = get_talents_for_character(classes[shop_tab_index]);
var _tn = array_length(_tab_talents);
var _grid_y = _tab_y + _tab_h + 12;

if (_tn > 0) {
    var _cols = min(shop_grid_cols, _tn);
    if (_cols <= 0) _cols = 1;
    var _total_grid_w = _cols * talent_card_w + (_cols - 1) * talent_card_gap_x;
    var _start_x = _mx + (_mw - _total_grid_w) * 0.5;
    var _total_rows = ceil(_tn / _cols);
    var _start_row = shop_grid_scroll_row;
    var _end_row = min(_total_rows, _start_row + shop_grid_visible_rows);

    for (var _r = _start_row; _r < _end_row; _r++) {
        for (var _c = 0; _c < _cols; _c++) {
            var _idx = _r * _cols + _c;
            if (_idx >= _tn) break;

            var _cx = _start_x + _c * (talent_card_w + talent_card_gap_x);
            var _cy = _grid_y + (_r - _start_row) * (talent_card_h + talent_card_gap_y);
            var _t_item = _tab_talents[_idx];
            var _is_sel = (_idx == shop_talent_index);

            var _unlocked = talent_is_unlocked(_t_item.id);
            var _affinity_ok = (_t_item.affinity == "none" || element_is_unlocked(_t_item.affinity, classes[shop_tab_index]));

            // Clique no card
            if (touch_gui_clicked(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h)) {
                shop_talent_index = _idx;
                sfx_play("menu_move");
            }

            // Fundo do Card
            var _bg_col = make_colour_rgb(14, 18, 28);
            if (_is_sel) _bg_col = make_colour_rgb(30, 42, 65);
            else if (_unlocked) _bg_col = make_colour_rgb(16, 28, 22);

            draw_set_colour(_bg_col);
            draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, false);

            // Borda
            var _border_col = _is_sel ? c_yellow : make_colour_rgb(45, 60, 85);
            if (_unlocked) _border_col = _is_sel ? c_yellow : make_colour_rgb(40, 130, 70);
            draw_set_colour(_border_col);
            draw_rectangle(_cx, _cy, _cx + talent_card_w, _cy + talent_card_h, true);
            if (_is_sel) draw_rectangle(_cx - 1, _cy - 1, _cx + talent_card_w + 1, _cy + talent_card_h + 1, true);

            // Icone Vetorial Procedural do Talento
            var _icon = talent_get_icon_type(_t_item);
            var _icon_col = _is_sel ? c_yellow : (_unlocked ? c_lime : (!_affinity_ok ? make_colour_rgb(140, 70, 75) : make_colour_rgb(180, 205, 230)));
            draw_talent_icon(_icon, _cx + talent_card_w * 0.5, _cy + 24, 24, _icon_col);

            // Nome do Talento
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_colour(_unlocked ? c_lime : (_is_sel ? c_yellow : c_white));
            draw_text_ext(_cx + talent_card_w * 0.5, _cy + 42, _t_item.label, 13, talent_card_w - 12);

            // Custo ou Status
            var _cost_str = "";
            var _cost_col = c_white;
            if (_unlocked) {
                _cost_str = "[ADQUIRIDO]";
                _cost_col = c_lime;
            } else if (!_affinity_ok) {
                _cost_str = "[BLOQUEADO]";
                _cost_col = make_colour_rgb(220, 80, 80);
            } else {
                _cost_str = string(_t_item.cost) + " Ouro";
                _cost_col = (global.gold >= _t_item.cost) ? make_colour_rgb(255, 215, 60) : make_colour_rgb(180, 140, 140);
            }

            draw_set_valign(fa_bottom);
            draw_set_colour(_cost_col);
            draw_text(_cx + talent_card_w * 0.5, _cy + talent_card_h - 6, _cost_str);
        }
    }
}

// -------------------------------------------------------------------------
// Painel de Detalhes do Talento Selecionado
// -------------------------------------------------------------------------
var _det_y = _my + _mh - 126;
var _det_h = 60;
draw_set_colour(make_colour_rgb(10, 14, 22));
draw_rectangle(_mx + 30, _det_y, _mx + _mw - 30, _det_y + _det_h, false);
draw_set_colour(make_colour_rgb(50, 70, 100));
draw_rectangle(_mx + 30, _det_y, _mx + _mw - 30, _det_y + _det_h, true);

if (_tn > 0 && shop_talent_index < _tn) {
    var _cur_sel_t = _tab_talents[shop_talent_index];
    
    // Icone de Destaque no Painel Inferior
    var _det_icon = talent_get_icon_type(_cur_sel_t);
    var _det_icon_col = talent_is_unlocked(_cur_sel_t.id) ? c_lime : c_yellow;
    draw_talent_icon(_det_icon, _mx + 62, _det_y + _det_h * 0.5, 34, _det_icon_col);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_colour(c_yellow);
    draw_text(_mx + 96, _det_y + 8, _cur_sel_t.label + " (" + string_upper(_cur_sel_t.affinity) + ")");

    draw_set_colour(make_colour_rgb(180, 200, 220));
    draw_text_ext(_mx + 96, _det_y + 28, _cur_sel_t.desc_value, 14, _mw - 140);
}

// -------------------------------------------------------------------------
// Rodapé com Ações
// -------------------------------------------------------------------------
var _foot_y = _my + _mh - 36;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _btn_buy_x = _gw * 0.5 + 140;
var _btn_buy_w = 240;
var _btn_buy_h = 34;
draw_set_colour(make_colour_rgb(35, 110, 50));
draw_rectangle(_btn_buy_x - _btn_buy_w * 0.5, _foot_y - _btn_buy_h * 0.5, _btn_buy_x + _btn_buy_w * 0.5, _foot_y + _btn_buy_h * 0.5, false);
draw_set_colour(c_lime);
draw_rectangle(_btn_buy_x - _btn_buy_w * 0.5, _foot_y - _btn_buy_h * 0.5, _btn_buy_x + _btn_buy_w * 0.5, _foot_y + _btn_buy_h * 0.5, true);
draw_set_colour(c_white);
draw_text(_btn_buy_x, _foot_y, "[Z / Enter] Comprar Talento");

var _btn_ext_x = _gw * 0.5 - 140;
var _btn_ext_w = 180;
draw_set_colour(make_colour_rgb(60, 30, 35));
draw_rectangle(_btn_ext_x - _btn_ext_w * 0.5, _foot_y - _btn_buy_h * 0.5, _btn_ext_x + _btn_ext_w * 0.5, _foot_y + _btn_buy_h * 0.5, false);
draw_set_colour(make_colour_rgb(220, 80, 80));
draw_rectangle(_btn_ext_x - _btn_ext_w * 0.5, _foot_y - _btn_buy_h * 0.5, _btn_ext_x + _btn_ext_w * 0.5, _foot_y + _btn_buy_h * 0.5, true);
draw_set_colour(c_white);
draw_text(_btn_ext_x, _foot_y, "[X / Esc] Sair da Loja");

// Toast de Notificação
if (notice_timer > 0) {
    var _nw = string_width(notice_text) + 36;
    draw_set_alpha(0.92);
    draw_set_colour(make_colour_rgb(180, 30, 40));
    draw_rectangle(_gw * 0.5 - _nw * 0.5, _my + _mh - 165, _gw * 0.5 + _nw * 0.5, _my + _mh - 135, false);
    draw_set_colour(c_yellow);
    draw_rectangle(_gw * 0.5 - _nw * 0.5, _my + _mh - 165, _gw * 0.5 + _nw * 0.5, _my + _mh - 135, true);
    draw_set_alpha(1.0);
    draw_set_colour(c_white);
    draw_text(_gw * 0.5, _my + _mh - 150, notice_text);
}
