draw_set_font(ui_font());
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Barra de ajuda inferior
var _tool_txt = is_undefined(tool) ? tr("Nenhum item escolhido") : tool.label;
var _help = tr("SANDBOX") + "  |  " + tr("Item: ") + _tool_txt + "  |  " + tr("Mouse esq.: colocar   dir.: apagar   [F6] painel   [F7] colisoes");
draw_set_alpha(0.8);
draw_set_color(make_colour_rgb(10, 12, 20));
draw_rectangle(0, _gh - 24, _gw - (panel_visible ? panel_w : 0), _gh, false);
draw_set_alpha(1);
draw_set_color(c_yellow);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(10, _gh - 12, _help);

if (toast_timer > 0) {
    draw_set_halign(fa_center);
    draw_set_color(c_aqua);
    draw_text((_gw - panel_w) / 2, _gh - 44, toast_text);
}

if (!panel_visible) {
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// Painel lateral
var _px = _gw - panel_w;
draw_set_alpha(0.93);
draw_set_color(make_colour_rgb(14, 17, 27));
draw_rectangle(_px, 0, _gw, _gh, false);
draw_set_alpha(1);
draw_set_color(make_colour_rgb(70, 90, 130));
draw_line(_px, 0, _px, _gh);

for (var _i = 0; _i < array_length(panel_rows); _i++) {
    var _r = panel_rows[_i];
    if (!_r.visible) continue;
    if (_r.action == "") {
        // Titulo de secao
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(_r.header_col);
        draw_text(_r.x1 + 2, (_r.y1 + _r.y2) / 2, _r.label);
        continue;
    }
    draw_set_color(_r.active ? make_colour_rgb(50, 70, 110) : make_colour_rgb(24, 30, 46));
    draw_rectangle(_r.x1, _r.y1, _r.x2, _r.y2, false);
    draw_set_color(_r.active ? c_yellow : make_colour_rgb(55, 70, 100));
    draw_rectangle(_r.x1, _r.y1, _r.x2, _r.y2, true);
    draw_set_halign(_r.centered ? fa_center : fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_r.active ? c_yellow : c_white);
    var _tx = _r.centered ? (_r.x1 + _r.x2) / 2 : _r.x1 + 8;
    var _tw = string_width(_r.label);
    var _max = (_r.x2 - _r.x1) - 12;
    var _sc = (_tw > _max) ? (_max / _tw) : 1;
    draw_text_transformed(_tx, (_r.y1 + _r.y2) / 2, _r.label, _sc, _sc, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
