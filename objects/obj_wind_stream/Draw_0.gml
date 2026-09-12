var _w = base_w * image_xscale;
var _h = base_h * image_yscale;

// Faixa translúcida da corrente
draw_set_alpha(0.18 + 0.08 * sin(anim_timer * 4));
draw_set_color(make_colour_rgb(160, 230, 255));
draw_rectangle(x, y, x + _w, y + _h, false);

// Linhas de fluxo de vento em movimento
draw_set_alpha(0.5);
draw_set_color(c_white);

var _flow_offset = (anim_timer * 90) % 32;
var _cols = max(1, floor(_w / 32));
var _rows = max(1, floor(_h / 32));

for (var _r = 0; _r < _rows; _r++) {
    for (var _c = 0; _c < _cols; _c++) {
        var _lx = x + _c * 32 + lengthdir_x(_flow_offset, dir);
        var _ly = y + _r * 32 + lengthdir_y(_flow_offset, dir);
        if (_lx >= x && _lx <= x + _w - 8 && _ly >= y && _ly <= y + _h - 8) {
            draw_line(_lx, _ly, _lx + lengthdir_x(14, dir), _ly + lengthdir_y(14, dir));
        }
    }
}

// Borda suave
draw_set_alpha(0.4);
draw_set_color(make_colour_rgb(200, 245, 255));
draw_rectangle(x, y, x + _w, y + _h, true);

draw_set_alpha(1);
draw_set_color(c_white);
