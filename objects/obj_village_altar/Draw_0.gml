var _stats = village_get_essence_stats();

// Base de pedra do Altar
draw_set_alpha(0.3);
draw_set_colour(c_black);
draw_ellipse(x - 56, y - 24, x + 56, y + 24, false);

draw_set_alpha(1.0);
draw_set_colour(make_colour_rgb(45, 48, 55));
draw_circle(x, y, 48, false);

draw_set_colour(make_colour_rgb(68, 72, 85));
draw_circle(x, y, 44, false);

draw_set_colour(make_colour_rgb(25, 28, 35));
draw_circle(x, y, 28, false);

// 4 Cristais / Orbes Orbitais das Essências
var _elem_angles = [0, 90, 180, 270];
var _elem_colors = [
    make_colour_rgb(80, 180, 255),  // Agua / Gelo
    make_colour_rgb(255, 90, 40),   // Fogo / Magma
    make_colour_rgb(160, 255, 120), // Vento / Tempestade
    make_colour_rgb(180, 140, 70)   // Terra / Basalto
];
var _elem_active = [_stats.water, _stats.fire, _stats.wind, _stats.earth];

var _orbit_r = 38 + sin(pulse_timer) * 3;

for (var i = 0; i < 4; i++) {
    var _ang = _elem_angles[i] + pulse_timer * 15;
    var _ox = x + lengthdir_x(_orbit_r, _ang);
    var _oy = y + lengthdir_y(_orbit_r * 0.7, _ang);
    
    if (_elem_active[i]) {
        // Essência Resgatada: Brilho pulsante
        var _glow_r = 10 + sin(pulse_timer * 2 + i) * 2;
        draw_set_alpha(0.4);
        draw_set_colour(_elem_colors[i]);
        draw_circle(_ox, _oy, _glow_r + 4, false);
        
        draw_set_alpha(1.0);
        draw_circle(_ox, _oy, _glow_r, false);
        draw_set_colour(c_white);
        draw_circle(_ox, _oy, 4, false);
    } else {
        // Essência Corrompida: Pedra opaca
        draw_set_alpha(0.6);
        draw_set_colour(c_dkgray);
        draw_circle(_ox, _oy, 6, false);
        draw_set_colour(c_gray);
        draw_circle(_ox, _oy, 6, true);
    }
}

// Núcleo central
draw_set_alpha(1.0);
if (_stats.total > 0) {
    draw_set_colour(c_white);
    draw_circle(x, y, 10 + sin(pulse_timer * 3) * 2, false);
} else {
    draw_set_colour(c_red);
    draw_circle(x, y, 6, false);
}

// Balão de interação flutuante
if (is_near && !show_modal) {
    var _by = y - 64 + sin(pulse_timer * 2) * 4;
    var _text = "[E] / [A] Altar dos Elementos";
    draw_set_font(fnt_regular);
    var _tw = string_width(_text) + 24;
    var _th = 28;
    
    draw_set_alpha(0.85);
    draw_set_colour(make_colour_rgb(18, 20, 26));
    draw_roundrect(x - _tw / 2, _by - _th / 2, x + _tw / 2, _by + _th / 2, false);
    
    draw_set_alpha(1.0);
    draw_set_colour(make_colour_rgb(255, 215, 100));
    draw_roundrect(x - _tw / 2, _by - _th / 2, x + _tw / 2, _by + _th / 2, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(x, _by, _text);
}
