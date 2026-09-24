// =========================================================================
// RENDERIZAÇÃO NO MUNDO: ALOJAMENTO DOS HERÓIS (QUARTEL)
// =========================================================================
var _t = current_time * 0.001;

// 1. Sombra projetada no solo
draw_set_alpha(0.4);
draw_set_colour(c_black);
draw_ellipse(x - 85, y + 25, x + 85, y + 68, false);
draw_set_alpha(1.0);

// 2. Fundação e Paredes de Pedra Talhada
var _wall_col = make_colour_rgb(60, 65, 80);
var _wall_dark = make_colour_rgb(45, 48, 60);
var _wall_hi = make_colour_rgb(85, 92, 110);

draw_set_colour(_wall_col);
draw_rectangle(x - 75, y - 50, x + 75, y + 45, false);

// Linhas de tijolos/pedras talhadas
draw_set_colour(_wall_dark);
draw_line_width(x - 75, y - 18, x + 75, y - 18, 2);
draw_line_width(x - 75, y + 12, x + 75, y + 12, 2);
draw_line(x - 30, y - 50, x - 30, y - 18);
draw_line(x + 30, y - 50, x + 30, y - 18);
draw_line(x - 50, y - 18, x - 50, y + 12);
draw_line(x + 10, y - 18, x + 10, y + 12);

// Pilares laterais de sustentação
draw_set_colour(make_colour_rgb(70, 48, 32));
draw_rectangle(x - 80, y - 52, x - 68, y + 48, false);
draw_rectangle(x + 68, y - 52, x + 80, y + 48, false);

// 3. Telhado de Madeira Nobre e Beiral
var _roof_col = make_colour_rgb(95, 52, 38);
var _roof_dark = make_colour_rgb(65, 35, 25);
var _roof_peak_y = y - 90;

draw_set_colour(_roof_dark);
draw_triangle(x - 90, y - 46, x + 90, y - 46, x, _roof_peak_y - 4, false);
draw_set_colour(_roof_col);
draw_triangle(x - 86, y - 48, x + 86, y - 48, x, _roof_peak_y, false);

// Cumeeira e friso do telhado
draw_set_colour(make_colour_rgb(140, 95, 60));
draw_line_width(x - 88, y - 48, x, _roof_peak_y, 3);
draw_line_width(x + 88, y - 48, x, _roof_peak_y, 3);

// 4. Estandarte Guilda dos Heróis (Escudo e Armas)
var _banner_y = y - 48;
draw_set_colour(make_colour_rgb(150, 30, 35));
draw_rectangle(x - 16, _banner_y, x + 16, _banner_y + 36, false);
draw_triangle(x - 16, _banner_y + 36, x + 16, _banner_y + 36, x, _banner_y + 48, false);

// Brasão bordado no estandarte
draw_set_colour(make_colour_rgb(255, 215, 80));
draw_line_width(x - 8, _banner_y + 8, x + 8, _banner_y + 28, 2);
draw_line_width(x + 8, _banner_y + 8, x - 8, _banner_y + 28, 2);
draw_circle(x, _banner_y + 18, 4, true);

// Placa suspensa balançando com Espada
var _h_sign_sway = sin(_t * 2.4) * 3;
var _h_sign_x = x - 46;
var _h_sign_y = y - 10;
draw_set_colour(make_colour_rgb(50, 40, 35));
draw_line(x - 40, y - 25, _h_sign_x, _h_sign_y - 10);
draw_line(x - 52, y - 25, _h_sign_x, _h_sign_y - 10);
draw_set_colour(make_colour_rgb(90, 65, 45));
draw_rectangle(_h_sign_x + _h_sign_sway - 10, _h_sign_y - 8, _h_sign_x + _h_sign_sway + 10, _h_sign_y + 12, false);
draw_set_colour(make_colour_rgb(60, 40, 25));
draw_rectangle(_h_sign_x + _h_sign_sway - 10, _h_sign_y - 8, _h_sign_x + _h_sign_sway + 10, _h_sign_y + 12, true);
// Ícone da Espada
draw_set_colour(c_white);
draw_line_width(_h_sign_x + _h_sign_sway, _h_sign_y - 4, _h_sign_x + _h_sign_sway, _h_sign_y + 8, 2);
draw_set_colour(make_colour_rgb(255, 215, 80));
draw_line(_h_sign_x + _h_sign_sway - 4, _h_sign_y + 4, _h_sign_x + _h_sign_sway + 4, _h_sign_y + 4);
draw_circle(_h_sign_x + _h_sign_sway, _h_sign_y + 9, 1.5, false);

// 5. Porta Maciça de Carvalho com Arco
var _door_x = x;
var _door_y = y + 45;
var _door_w = 26;
var _door_h = 42;

// Arco de pedra
draw_set_colour(make_colour_rgb(35, 38, 48));
draw_rectangle(_door_x - _door_w - 4, _door_y - _door_h - 4, _door_x + _door_w + 4, _door_y, false);

// Madeira da porta
draw_set_colour(make_colour_rgb(85, 50, 30));
draw_rectangle(_door_x - _door_w, _door_y - _door_h, _door_x + _door_w, _door_y, false);
draw_set_colour(make_colour_rgb(50, 28, 15));
draw_line(_door_x, _door_y - _door_h, _door_x, _door_y); // fresta central

// Pregos de ferro e maçaneta
draw_set_colour(make_colour_rgb(180, 180, 190));
draw_circle(_door_x - 6, _door_y - 18, 2, false);
draw_circle(_door_x + 6, _door_y - 18, 2, false);

// Fresta de luz aconchegante sob a porta
var _glow_alpha = 0.55 + 0.25 * sin(_t * 3.5);
draw_set_alpha(_glow_alpha);
draw_set_colour(make_colour_rgb(255, 200, 90));
draw_line_width(_door_x - _door_w + 2, _door_y, _door_x + _door_w - 2, _door_y, 3);
draw_set_alpha(1.0);

// 6. Tochas / Lanternas com chamas pulsantes
var _lx1 = x - 54;
var _lx2 = x + 54;
var _ly = y - 4;

draw_set_colour(make_colour_rgb(40, 40, 45));
draw_rectangle(_lx1 - 3, _ly - 8, _lx1 + 3, _ly + 10, false);
draw_rectangle(_lx2 - 3, _ly - 8, _lx2 + 3, _ly + 10, false);

var _flame_flicker = 3 + sin(_t * 8.0) * 1.5;
draw_set_colour(make_colour_rgb(255, 170, 40));
draw_circle(_lx1, _ly - 2, _flame_flicker, false);
draw_circle(_lx2, _ly - 2, _flame_flicker, false);
draw_set_colour(make_colour_rgb(255, 240, 150));
draw_circle(_lx1, _ly - 2, _flame_flicker * 0.5, false);
draw_circle(_lx2, _ly - 2, _flame_flicker * 0.5, false);
