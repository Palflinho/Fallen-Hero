var _t = current_time * 0.001;
var _final_unlocked = all_elements_reclaimed();

// 1. Sombra do Portal no Chão
draw_set_colour(c_black);
draw_set_alpha(0.4);
draw_ellipse(x - 36, y + 18, x + 36, y + 28, false);

// 2. Colunas de Pedra do Arco Sagrado
var _arch_col = make_colour_rgb(60, 65, 80);
var _arch_rim = make_colour_rgb(95, 105, 125);
var _rune_col = _final_unlocked ? make_colour_rgb(255, 220, 80) : make_colour_rgb(80, 200, 255);

// Pilares laterais
draw_set_colour(_arch_col);
draw_set_alpha(1.0);
draw_rectangle(x - 32, y - 48, x - 20, y + 20, false);
draw_rectangle(x + 20, y - 48, x + 32, y + 20, false);
draw_set_colour(_arch_rim);
draw_rectangle(x - 32, y - 48, x - 20, y + 20, true);
draw_rectangle(x + 20, y - 48, x + 32, y + 20, true);

// Arco superior
draw_set_colour(_arch_col);
draw_ellipse(x - 32, y - 64, x + 32, y - 32, false);
draw_set_colour(_arch_rim);
draw_ellipse(x - 32, y - 64, x + 32, y - 32, true);

// 3. Vórtice Dimensional no Interior do Arco
var _pulse = 0.85 + 0.15 * sin(_t * 5);
var _vort_col = _final_unlocked ? c_yellow : make_colour_rgb(40, 140, 240);

draw_set_colour(_vort_col);
draw_set_alpha(0.35 * _pulse);
draw_ellipse(x - 18 * _pulse, y - 40, x + 18 * _pulse, y + 16, false);

draw_set_colour(c_white);
draw_set_alpha(0.65 * _pulse);
draw_ellipse(x - 10 * _pulse, y - 32, x + 10 * _pulse, y + 8, false);

// Fitas orbitais de energia
var _orbit_col = _final_unlocked ? c_white : c_aqua;
draw_set_colour(_orbit_col);
draw_set_alpha(0.7);
for (var _i = 0; _i < 4; _i++) {
    var _ang = _t * 4 + _i * (pi * 0.5);
    var _ox = x + cos(_ang) * 14;
    var _oy = y - 18 + sin(_ang) * 24;
    draw_circle(_ox, _oy, 2.0, false);
}

draw_set_colour(c_white);
draw_set_alpha(1.0);
