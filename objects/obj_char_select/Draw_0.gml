var _n = array_length(classes);
var _total_w = _n * box_w + (_n - 1) * box_gap;
var _start_x = (room_width - _total_w) / 2;
var _y = room_height / 2 - box_h / 2;

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(room_width / 2, 80, "Escolha seu Heroi");
draw_text(room_width / 2, room_height - 60, "Setas para mover  -  Z para confirmar (novo jogo)");

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

draw_set_halign(fa_left);
draw_set_valign(fa_top);
