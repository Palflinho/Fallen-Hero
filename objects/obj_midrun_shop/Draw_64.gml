if (!global.midrun_shop_open) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Fundo escurecido
draw_set_alpha(0.82);
draw_set_color(make_colour_rgb(10, 14, 22));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _box_w = 740;
var _box_h = 460;
var _bx = (_gw - _box_w) / 2;
var _by = (_gh - _box_h) / 2;

// Painel principal da Loja
draw_set_color(make_colour_rgb(18, 24, 38));
draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);

// Borda Dourada
draw_set_color(c_yellow);
draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);
draw_rectangle(_bx - 2, _by - 2, _bx + _box_w + 2, _by + _box_h + 2, true);

// Cabecalho
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text_transformed(_bx + _box_w / 2, _by + 16, "MERCADOR ARCANO - BAZAR DA EXPEDICAO", 1.25, 1.25, 0);

draw_set_halign(fa_right);
draw_set_color(c_yellow);
draw_text(_bx + _box_w - 30, _by + 20, "Ouro: " + string(global.gold) + " Ouro");

draw_set_halign(fa_left);
draw_set_color(make_colour_rgb(60, 85, 125));
draw_line(_bx + 25, _by + 48, _bx + _box_w - 25, _by + 48);

// Grid de Itens: 2 colunas de 4 itens
var _col_w = (_box_w - 70) / 2;
var _item_h = 48;
var _start_y = _by + 60;

for (var _i = 0; _i < array_length(items); _i++) {
    var _it = items[_i];
    var _col = (_i >= 4) ? 1 : 0;
    var _row = (_i >= 4) ? (_i - 4) : _i;

    var _ix = _bx + 30 + _col * (_col_w + 10);
    var _iy = _start_y + _row * (_item_h + 8);

    var _is_selected = (_i == selected_index);

    // Fundo do card do item
    if (_is_selected) {
        var _pulse = 0.35 + 0.15 * sin(current_time * 0.008);
        draw_set_alpha(0.9);
        draw_set_color(make_colour_rgb(35, 50, 75));
        draw_rectangle(_ix, _iy, _ix + _col_w, _iy + _item_h, false);

        draw_set_alpha(_pulse + 0.5);
        draw_set_color(c_yellow);
        draw_rectangle(_ix, _iy, _ix + _col_w, _iy + _item_h, true);
        draw_rectangle(_ix - 1, _iy - 1, _ix + _col_w + 1, _iy + _item_h + 1, true);
        draw_set_alpha(1);
    } else {
        draw_set_color(make_colour_rgb(22, 30, 46));
        draw_rectangle(_ix, _iy, _ix + _col_w, _iy + _item_h, false);
        draw_set_color(make_colour_rgb(45, 60, 85));
        draw_rectangle(_ix, _iy, _ix + _col_w, _iy + _item_h, true);
    }

    // Indicador visual de tipo
    draw_set_color(_it.icon_col);
    draw_rectangle(_ix + 4, _iy + 4, _ix + 10, _iy + _item_h - 4, false);

    // Nome e Categoria
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_is_selected ? c_white : make_colour_rgb(200, 215, 235));
    draw_text(_ix + 16, _iy + 8, _it.name);

    draw_set_color(make_colour_rgb(130, 160, 195));
    draw_text(_ix + 16, _iy + 26, "[" + _it.category + "]");

    // Preço / Comprado
    draw_set_halign(fa_right);
    if (_it.purchased) {
        draw_set_color(c_dkgray);
        draw_text(_ix + _col_w - 10, _iy + 16, "ADQUIRIDO");
    } else {
        var _can_afford = (global.gold >= _it.cost);
        draw_set_color(_can_afford ? c_yellow : c_red);
        draw_text(_ix + _col_w - 10, _iy + 16, string(_it.cost) + " Ouro");
    }
}

// Painel de Detalhes Inferior
var _det_y = _by + 300;
draw_set_color(make_colour_rgb(14, 20, 32));
draw_rectangle(_bx + 25, _det_y, _bx + _box_w - 25, _det_y + 90, false);
draw_set_color(make_colour_rgb(50, 70, 105));
draw_rectangle(_bx + 25, _det_y, _bx + _box_w - 25, _det_y + 90, true);

var _cur_item = items[selected_index];
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_yellow);
draw_text(_bx + 40, _det_y + 12, _cur_item.name + " (" + _cur_item.category + ")");

draw_set_color(c_white);
draw_text_ext(_bx + 40, _det_y + 36, _cur_item.desc, 18, _box_w - 80);

// Mensagem de Feedback (Compra / Falta de Ouro)
if (message_timer > 0) {
    draw_set_halign(fa_center);
    draw_set_color(message_colour);
    draw_text(_bx + _box_w / 2, _det_y + 64, message_text);
}

// Rodapé de Controles
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_colour_rgb(180, 200, 225));
draw_text(_bx + _box_w / 2, _by + _box_h - 25, "[W / S / A / D] Navegar    [ESPACO / Z / ENTER] Comprar    [ESC / C] Sair da Loja");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
