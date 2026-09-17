if (modal_anim <= 0) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Fundo escuro com fade
draw_set_alpha(0.75 * modal_anim);
draw_set_colour(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Caixa do Modal
var _mw = 860;
var _mh = 520;
var _mx = (_gui_w - _mw) / 2;
var _my = (_gui_h - _mh) / 2;

draw_set_alpha(0.95 * modal_anim);
draw_set_colour(make_colour_rgb(22, 24, 30));
draw_roundrect(_mx, _my, _mx + _mw, _my + _mh, false);

draw_set_alpha(1.0 * modal_anim);
draw_set_colour(make_colour_rgb(255, 205, 90));
draw_roundrect(_mx, _my, _mx + _mw, _my + _mh, true);

// Título do Santuário
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fnt_title);
draw_set_colour(c_white);
draw_text(_gui_w / 2, _my + 24, "SANTUARIO DAS ESSENCIAS ELEMENTAIS");

var _stats = village_get_essence_stats();

// Barra de Restauração Global do Planeta
var _bar_w = 600;
var _bar_h = 16;
var _bar_x = (_gui_w - _bar_w) / 2;
var _bar_y = _my + 70;

draw_set_colour(make_colour_rgb(40, 44, 52));
draw_roundrect(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

var _fill_w = _bar_w * (_stats.percent / 100);
if (_fill_w > 0) {
    draw_set_colour(make_colour_rgb(100, 220, 140));
    draw_roundrect(_bar_x, _bar_y, _bar_x + _fill_w, _bar_y + _bar_h, false);
}
draw_set_colour(make_colour_rgb(120, 130, 150));
draw_roundrect(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

draw_set_font(fnt_regular);
draw_set_colour(c_white);
draw_text(_gui_w / 2, _bar_y + 24, "Revitalizacao do Planeta Natal: " + string(_stats.percent) + "% (" + string(_stats.total) + "/4 Essencias Resgatadas)");

// Lore da Fase Atual de Restauração
var _lore = village_get_restoration_lore(_stats.total);
draw_set_colour(make_colour_rgb(210, 215, 230));
draw_text_ext(_gui_w / 2, _bar_y + 54, _lore, 22, 760);

// 4 Cards das Essências
var _card_w = 175;
var _card_h = 170;
var _card_gap = 20;
var _start_cx = _mx + (_mw - (4 * _card_w + 3 * _card_gap)) / 2;
var _card_y = _my + 235;

var _card_titles = ["Agua / Gelo", "Fogo / Magma", "Vento / Ar", "Terra / Basalto"];
var _card_bosses = ["General da Agua", "General Magma", "General do Vendaval", "General de Basalto"];
var _card_colors = [
    make_colour_rgb(70, 170, 255),
    make_colour_rgb(255, 95, 45),
    make_colour_rgb(140, 250, 140),
    make_colour_rgb(210, 160, 80)
];
var _card_active = [_stats.water, _stats.fire, _stats.wind, _stats.earth];

for (var i = 0; i < 4; i++) {
    var _cx = _start_cx + i * (_card_w + _card_gap);
    
    draw_set_alpha(0.9 * modal_anim);
    if (_card_active[i]) {
        draw_set_colour(make_colour_rgb(30, 36, 46));
        draw_roundrect(_cx, _card_y, _cx + _card_w, _card_y + _card_h, false);
        draw_set_colour(_card_colors[i]);
        draw_roundrect(_cx, _card_y, _cx + _card_w, _card_y + _card_h, true);
    } else {
        draw_set_colour(make_colour_rgb(24, 26, 32));
        draw_roundrect(_cx, _card_y, _cx + _card_w, _card_y + _card_h, false);
        draw_set_colour(make_colour_rgb(60, 65, 75));
        draw_roundrect(_cx, _card_y, _cx + _card_w, _card_y + _card_h, true);
    }
    
    // Ícone do elemento
    var _ic_y = _card_y + 38;
    if (_card_active[i]) {
        draw_set_colour(_card_colors[i]);
        draw_circle(_cx + _card_w / 2, _ic_y, 20, false);
        draw_set_colour(c_white);
        draw_circle(_cx + _card_w / 2, _ic_y, 8, false);
    } else {
        draw_set_colour(c_dkgray);
        draw_circle(_cx + _card_w / 2, _ic_y, 14, false);
        draw_set_colour(c_gray);
        draw_circle(_cx + _card_w / 2, _ic_y, 14, true);
    }
    
    // Texto do Card
    draw_set_halign(fa_center);
    draw_set_colour(_card_active[i] ? c_white : c_gray);
    draw_text(_cx + _card_w / 2, _card_y + 75, _card_titles[i]);
    
    draw_set_font(fnt_regular);
    if (_card_active[i]) {
        draw_set_colour(make_colour_rgb(100, 255, 150));
        draw_text(_cx + _card_w / 2, _card_y + 105, "[RESGATADA]");
        draw_set_colour(c_ltgray);
        draw_text(_cx + _card_w / 2, _card_y + 130, "Alimentando a Vila");
    } else {
        draw_set_colour(make_colour_rgb(255, 100, 100));
        draw_text(_cx + _card_w / 2, _card_y + 105, "[CORROMPIDA]");
        draw_set_colour(c_dkgray);
        draw_text(_cx + _card_w / 2, _card_y + 130, _card_bosses[i]);
    }
}

// Botão Fechar
var _btn_w = 180;
var _btn_h = 44;
var _btn_x = _gui_w / 2 - _btn_w / 2;
var _btn_y = _my + _mh - 62;

draw_set_colour(make_colour_rgb(45, 50, 62));
draw_roundrect(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, false);
draw_set_colour(make_colour_rgb(255, 215, 100));
draw_roundrect(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);
draw_text(_gui_w / 2, _btn_y + _btn_h / 2, "Fechar [ESC / B]");
