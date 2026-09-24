// =========================================================================
// RENDERIZAÇÃO NO MUNDO: EMPÓRIO DA FENDA (LOJA PERMANENTE)
// =========================================================================
var _t = current_time * 0.001;

// 1. Sombra projetada no chão
draw_set_alpha(0.4);
draw_set_colour(c_black);
draw_ellipse(x - 85, y + 25, x + 85, y + 68, false);
draw_set_alpha(1.0);

// 2. Paredes de Pedra e Tijolo
var _wall_col = make_colour_rgb(72, 60, 52);
var _wall_dark = make_colour_rgb(52, 42, 36);

draw_set_colour(_wall_col);
draw_rectangle(x - 75, y - 50, x + 75, y + 45, false);

// Linhas de textura rústica
draw_set_colour(_wall_dark);
draw_line_width(x - 75, y - 15, x + 75, y - 15, 2);
draw_line_width(x - 75, y + 15, x + 75, y + 15, 2);

// 3. Telhado de Telhas Arredondadas
var _roof_col = make_colour_rgb(45, 80, 65);
var _roof_peak_y = y - 88;

draw_set_colour(make_colour_rgb(30, 55, 45));
draw_triangle(x - 90, y - 46, x + 90, y - 46, x, _roof_peak_y - 4, false);
draw_set_colour(_roof_col);
draw_triangle(x - 86, y - 48, x + 86, y - 48, x, _roof_peak_y, false);

// 4. Toldo Listrado do Empório (Burgundy & Dourado)
var _awning_y = y - 48;
var _awning_w = 140;
var _awning_h = 24;
var _aw_x1 = x - _awning_w * 0.5;

for (var _s = 0; _s < 8; _s++) {
    var _col_stripe = (_s mod 2 == 0) ? make_colour_rgb(175, 45, 45) : make_colour_rgb(235, 215, 160);
    draw_set_colour(_col_stripe);
    draw_rectangle(_aw_x1 + _s * 17.5, _awning_y, _aw_x1 + (_s + 1) * 17.5, _awning_y + _awning_h, false);
}
draw_set_colour(make_colour_rgb(70, 20, 20));
draw_line_width(_aw_x1, _awning_y + _awning_h, _aw_x1 + _awning_w, _awning_y + _awning_h, 2);

// 5. Vitrine com Frascos de Alquimia Iluminados
var _win_x = x - 42;
var _win_y = y + 5;
draw_set_colour(make_colour_rgb(20, 24, 34));
draw_rectangle(_win_x - 18, _win_y - 14, _win_x + 18, _win_y + 14, false);
draw_set_colour(make_colour_rgb(110, 80, 50));
draw_rectangle(_win_x - 18, _win_y - 14, _win_x + 18, _win_y + 14, true);

// Frascos brilhantes na vitrine
var _glow_pulse = 0.7 + 0.3 * sin(_t * 4);
draw_set_colour(make_colour_rgb(80, 240, 140));
draw_circle(_win_x - 8, _win_y + 4, 3.5, false); // poção verde
draw_set_colour(make_colour_rgb(80, 160, 255));
draw_circle(_win_x, _win_y + 4, 3.5, false); // poção azul
draw_set_colour(make_colour_rgb(255, 80, 90));
draw_circle(_win_x + 8, _win_y + 4, 3.5, false); // poção vermelha

// 6. Placa Suspensa Balançando com Moeda de Ouro
var _sign_sway = sin(_t * 2.2) * 3;
var _sign_x = x + 46;
var _sign_y = y - 10;

draw_set_colour(make_colour_rgb(50, 40, 35));
draw_line(x + 40, y - 25, _sign_x, _sign_y - 10);
draw_line(x + 52, y - 25, _sign_x, _sign_y - 10);

draw_set_colour(make_colour_rgb(255, 215, 60));
draw_circle(_sign_x + _sign_sway, _sign_y, 11, false);
draw_set_colour(make_colour_rgb(180, 140, 20));
draw_circle(_sign_x + _sign_sway, _sign_y, 11, true);
draw_circle(_sign_x + _sign_sway, _sign_y, 6, true);

// 7. Porta de Entrada e Balcão
var _door_x = x + 15;
var _door_y = y + 45;
var _door_w = 20;
var _door_h = 38;

draw_set_colour(make_colour_rgb(28, 22, 18));
draw_rectangle(_door_x - _door_w, _door_y - _door_h, _door_x + _door_w, _door_y, false);
draw_set_colour(make_colour_rgb(70, 45, 30));
draw_rectangle(_door_x - _door_w + 2, _door_y - _door_h + 2, _door_x + _door_w - 2, _door_y, false);

// Sino de latão sobre a porta
draw_set_colour(make_colour_rgb(255, 220, 90));
draw_circle(_door_x, _door_y - _door_h - 4, 3, false);

// Feixe de luz sob a soleira
draw_set_alpha(0.6 + 0.3 * sin(_t * 3));
draw_set_colour(make_colour_rgb(255, 220, 100));
draw_line_width(_door_x - _door_w + 2, _door_y, _door_x + _door_w - 2, _door_y, 3);
draw_set_alpha(1.0);
