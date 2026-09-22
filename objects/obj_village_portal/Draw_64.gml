// =========================================================================
// DRAW_64: PORTAL DA FENDA & MODAL DE PREPARAÇÃO DE TALENTOS DA RUN
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
// 2. MODAL DEDICADO DE SELEÇÃO DE TALENTOS PARA A RUN
// -------------------------------------------------------------------------

// Fundo Escurecido Translúcido (Backdrop)
draw_set_colour(c_black);
draw_set_alpha(0.84);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1.0);

// Painel Central Arcano
var _mw = min(1040, _gw - 60);
var _mh = 540;
var _mx = round((_gw - _mw) * 0.5);
var _my = round((_gh - _mh) * 0.5);

// Fundo do Painel
draw_set_colour(make_colour_rgb(12, 16, 26));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);

// Bordas Dimensionais
draw_set_colour(make_colour_rgb(35, 75, 120));
draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
draw_set_colour(make_colour_rgb(80, 190, 255));
draw_rectangle(_mx + 3, _my + 3, _mx + _mw - 3, _my + _mh - 3, true);

// Cabeçalho Principal
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_colour(make_colour_rgb(255, 220, 100));
draw_text(_mx + _mw * 0.5, _my + 12, "PORTAL DA FENDA - PREPARACAO DA EXPEDICAO");

var _p_char = variable_global_exists("selected_character") ? global.selected_character : "knight";
var _p_elem = variable_global_exists("selected_element") ? global.selected_element : "none";

var _char_label = (_p_char == "knight" ? "Cavaleiro" : (_p_char == "mage" ? "Mago" : (_p_char == "archer" ? "Arqueiro" : "Assassino")));
var _elem_label = (_p_elem == "none" ? "Neutro" : (_p_elem == "water" ? "Agua" : (_p_elem == "fire" ? "Fogo" : (_p_elem == "wind" ? "Vento" : "Terra"))));

draw_set_colour(make_colour_rgb(170, 200, 230));
draw_text(_mx + _mw * 0.5, _my + 32, "Heroi Ativo: " + _char_label + "  |  Afinidade: " + _elem_label + "  (Troque na Casa dos Herois)");

// -------------------------------------------------------------------------
// 3. SEÇÃO SUPERIOR: OS 3 SLOTS DE TALENTOS EQUIPADOS DA RUN
// -------------------------------------------------------------------------
var _slot_w = 260;
var _slot_h = 56;
var _slots_total_w = 3 * _slot_w + 2 * 20;
var _slots_x0 = _mx + (_mw - _slots_total_w) * 0.5;
var _slots_y0 = _my + 56;

for (var _s = 0; _s < max_equipped_slots; _s++) {
    var _sbx = _slots_x0 + _s * (_slot_w + 20);
    var _sby = _slots_y0;

    var _has_talent = (_s < array_length(talent_selected_ids));
    var _t_def = undefined;
    if (_has_talent) {
        _t_def = talent_get_def(talent_selected_ids[_s]);
    }

    if (_has_talent && !is_undefined(_t_def)) {
        // Slot Equipado
        draw_set_colour(make_colour_rgb(18, 38, 54));
        draw_rectangle(_sbx, _sby, _sbx + _slot_w, _sby + _slot_h, false);

        draw_set_colour(make_colour_rgb(90, 210, 255));
        draw_rectangle(_sbx, _sby, _sbx + _slot_w, _sby + _slot_h, true);

        // Ícone do Talento
        draw_talent_icon(talent_get_icon_type(_t_def), _sbx + 24, _sby + _slot_h * 0.5, 24, c_yellow);

        // Textos do Slot
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_colour(c_white);
        var _slot_name = variable_struct_exists(_t_def, "label") ? _t_def.label : (variable_struct_exists(_t_def, "name") ? _t_def.name : "Talento");
        draw_text(_sbx + 48, _sby + 10, _slot_name);

        draw_set_colour(make_colour_rgb(130, 190, 220));
        draw_text(_sbx + 48, _sby + 28, "[Slot " + string(_s + 1) + "] Clique p/ Remover");
    } else {
        // Slot Vazio
        draw_set_colour(make_colour_rgb(16, 22, 32));
        draw_rectangle(_sbx, _sby, _sbx + _slot_w, _sby + _slot_h, false);

        draw_set_colour(make_colour_rgb(45, 65, 90));
        draw_rectangle(_sbx, _sby, _sbx + _slot_w, _sby + _slot_h, true);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(make_colour_rgb(120, 140, 170));
        draw_text(_sbx + _slot_w * 0.5, _sby + _slot_h * 0.5 - 6, "[ Slot " + string(_s + 1) + " Vazio ]");
        draw_set_colour(make_colour_rgb(80, 100, 130));
        draw_text(_sbx + _slot_w * 0.5, _sby + _slot_h * 0.5 + 12, "(Selecione na lista abaixo)");
    }
}

// Divisor Sutil
draw_set_colour(make_colour_rgb(35, 60, 95));
draw_line(_mx + 30, _my + 126, _mx + _mw - 30, _my + 126);

// -------------------------------------------------------------------------
// 4. SEÇÃO CENTRAL: GRADE DE TALENTOS DESBLOQUEADOS (3x3)
// -------------------------------------------------------------------------
var _cols = 3;
var _card_w = 270;
var _card_h = 50;
var _cgap_x = 16;
var _cgap_y = 10;
var _grid_x0 = _mx + (_mw - (_cols * _card_w + (_cols - 1) * _cgap_x)) * 0.5;
var _grid_y0 = _my + 140;

var _n_talents = array_length(talent_select_list);

if (_n_talents == 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_rgb(220, 180, 100));
    draw_text(_mx + _mw * 0.5, _grid_y0 + 50, "Nenhum talento desbloqueado para esta afinidade!");
    draw_set_colour(make_colour_rgb(160, 175, 195));
    draw_text(_mx + _mw * 0.5, _grid_y0 + 74, "Desbloqueie talentos permanentes no Emporio da Fenda (Loja) na Vila com Ouro.");
    draw_text(_mx + _mw * 0.5, _grid_y0 + 96, "Voce ainda pode descer as catacumbas e encontrar talentos em baus durante a run!");
} else {
    var _visible_start = scroll_row * _cols;
    var _visible_end = min(_n_talents, _visible_start + 9);

    for (var _i = _visible_start; _i < _visible_end; _i++) {
        var _local_idx = _i - _visible_start;
        var _col = _local_idx mod _cols;
        var _r = floor(_local_idx / _cols);
        var _cx = _grid_x0 + _col * (_card_w + _cgap_x);
        var _cy = _grid_y0 + _r * (_card_h + _cgap_y);

        var _t = talent_select_list[_i];
        var _is_selected = (_i == talent_cursor);

        // Verifica se está equipado
        var _is_equipped = false;
        for (var _eq = 0; _eq < array_length(talent_selected_ids); _eq++) {
            if (talent_selected_ids[_eq] == _t.id) {
                _is_equipped = true;
                break;
            }
        }

        // Fundo do Card
        if (_is_equipped) {
            draw_set_colour(make_colour_rgb(16, 42, 50));
        } else if (_is_selected) {
            draw_set_colour(make_colour_rgb(24, 34, 52));
        } else {
            draw_set_colour(make_colour_rgb(16, 22, 34));
        }
        draw_rectangle(_cx, _cy, _cx + _card_w, _cy + _card_h, false);

        // Borda do Card
        if (_is_selected) {
            draw_set_colour(make_colour_rgb(255, 220, 80));
            draw_rectangle(_cx, _cy, _cx + _card_w, _cy + _card_h, true);
            draw_set_colour(make_colour_rgb(80, 200, 255));
            draw_rectangle(_cx + 1, _cy + 1, _cx + _card_w - 1, _cy + _card_h - 1, true);
        } else if (_is_equipped) {
            draw_set_colour(make_colour_rgb(70, 210, 180));
            draw_rectangle(_cx, _cy, _cx + _card_w, _cy + _card_h, true);
        } else {
            draw_set_colour(make_colour_rgb(40, 56, 80));
            draw_rectangle(_cx, _cy, _cx + _card_w, _cy + _card_h, true);
        }

        // Ícone
        draw_talent_icon(talent_get_icon_type(_t), _cx + 22, _cy + _card_h * 0.5, 20, _is_equipped ? c_lime : c_yellow);

        // Nome do Talento
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_colour(_is_selected ? c_white : (_is_equipped ? make_colour_rgb(200, 255, 220) : make_colour_rgb(210, 215, 225)));
        var _t_name = variable_struct_exists(_t, "label") ? _t.label : (variable_struct_exists(_t, "name") ? _t.name : "Talento");
        draw_text(_cx + 44, _cy + 8, _t_name);

        // Afinidade
        draw_set_colour(make_colour_rgb(130, 155, 185));
        var _aff_raw = variable_struct_exists(_t, "affinity") ? _t.affinity : "none";
        var _aff_txt = (_aff_raw == "water" ? "Agua" : (_aff_raw == "fire" ? "Fogo" : (_aff_raw == "wind" ? "Vento" : (_aff_raw == "earth" ? "Terra" : "Neutro"))));
        draw_text(_cx + 44, _cy + 26, "Afinidade: " + _aff_txt);

        // Selo de Equipado
        if (_is_equipped) {
            draw_set_halign(fa_right);
            draw_set_colour(make_colour_rgb(70, 230, 150));
            draw_text(_cx + _card_w - 8, _cy + 26, "✓ EQUIPADO");
        }
    }
}

// -------------------------------------------------------------------------
// 5. SEÇÃO INFERIOR: PAINEL DE DETALHES DO TALENTO EM FOCO
// -------------------------------------------------------------------------
var _det_y = _my + 328;
var _det_h = 138;
var _det_w = _mw - 60;
var _det_x = _mx + 30;

draw_set_colour(make_colour_rgb(10, 15, 25));
draw_rectangle(_det_x, _det_y, _det_x + _det_w, _det_y + _det_h, false);

draw_set_colour(make_colour_rgb(38, 65, 100));
draw_rectangle(_det_x, _det_y, _det_x + _det_w, _det_y + _det_h, true);

if (_n_talents > 0 && talent_cursor < _n_talents) {
    var _cur_t = talent_select_list[talent_cursor];

    // Caixa do Ícone Grande
    var _ibx = _det_x + 14;
    var _iby = _det_y + 14;
    draw_set_colour(make_colour_rgb(18, 28, 44));
    draw_rectangle(_ibx, _iby, _ibx + 60, _iby + 60, false);
    draw_set_colour(make_colour_rgb(60, 120, 180));
    draw_rectangle(_ibx, _iby, _ibx + 60, _iby + 60, true);

    draw_talent_icon(talent_get_icon_type(_cur_t), _ibx + 30, _iby + 30, 36, c_yellow);

    // Título e Afinidade
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(make_colour_rgb(255, 220, 80));
    var _cur_name = variable_struct_exists(_cur_t, "label") ? _cur_t.label : (variable_struct_exists(_cur_t, "name") ? _cur_t.name : "Talento");
    draw_text(_det_x + 86, _det_y + 12, _cur_name);

    var _cur_aff_raw = variable_struct_exists(_cur_t, "affinity") ? _cur_t.affinity : "none";
    var _cur_aff_txt = (_cur_aff_raw == "water" ? "Agua" : (_cur_aff_raw == "fire" ? "Fogo" : (_cur_aff_raw == "wind" ? "Vento" : (_cur_aff_raw == "earth" ? "Terra" : "Neutro"))));
    draw_set_colour(make_colour_rgb(100, 200, 255));
    draw_text(_det_x + 86, _det_y + 30, "Afinidade: " + _cur_aff_txt);

    // Descrição Completa
    draw_set_colour(make_colour_rgb(220, 230, 240));
    var _desc = variable_struct_exists(_cur_t, "desc_value") ? _cur_t.desc_value : (variable_struct_exists(_cur_t, "description") ? _cur_t.description : "");
    if (variable_struct_exists(_cur_t, "desc_flavor") && _cur_t.desc_flavor != "") {
        _desc = _desc + " (" + _cur_t.desc_flavor + ")";
    }
    draw_text_ext(_det_x + 86, _det_y + 50, _desc, 15, _det_w - 100);


    // Status de Equipamento
    var _cur_is_eq = false;
    for (var _k = 0; _k < array_length(talent_selected_ids); _k++) {
        if (talent_selected_ids[_k] == _cur_t.id) { _cur_is_eq = true; break; }
    }

    draw_set_halign(fa_right);
    if (_cur_is_eq) {
        draw_set_colour(make_colour_rgb(80, 255, 170));
        draw_text(_det_x + _det_w - 16, _det_y + 14, "[✓ TALENTO EQUIPADO]");
    } else {
        draw_set_colour(make_colour_rgb(140, 180, 220));
        draw_text(_det_x + _det_w - 16, _det_y + 14, "[Pressione ESPACO para Equipar]");
    }
}

// -------------------------------------------------------------------------
// 6. RODAPÉ E BOTÕES DE AÇÃO
// -------------------------------------------------------------------------

// Aviso flutuante
if (notice_timer > 0 && notice_text != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(make_colour_rgb(255, 120, 80));
    draw_text(_mx + _mw * 0.5, _my + _mh - 62, notice_text);
}

// Botão Central de Ação: "Descer às Catacumbas!"
var _btn_w = 320;
var _btn_h = 38;
var _btn_x = _mx + (_mw - _btn_w) * 0.5;
var _btn_y = _my + _mh - 46;

draw_set_colour(make_colour_rgb(30, 60, 40));
draw_rectangle(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, false);
draw_set_colour(make_colour_rgb(90, 220, 120));
draw_rectangle(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(make_colour_rgb(230, 255, 230));
draw_text(_btn_x + _btn_w * 0.5, _btn_y + _btn_h * 0.5, "[Z / Enter] Descer as Catacumbas!");

// Botão / Dica Esquerda: Equipar / Desequipar
draw_set_halign(fa_left);
draw_set_colour(make_colour_rgb(160, 190, 220));
draw_text(_mx + 30, _btn_y + _btn_h * 0.5, "[Espaco / A] Equipar / Desequipar");

// Botão / Dica Direita: Ficar na Vila
draw_set_halign(fa_right);
draw_set_colour(make_colour_rgb(200, 140, 140));
draw_text(_mx + _mw - 30, _btn_y + _btn_h * 0.5, "[Esc / B] Ficar na Vila");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
