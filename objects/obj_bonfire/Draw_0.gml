var _t = current_time * 0.001;

// 1. Luz ambiente quente e pulsante no chão de pedra da caverna
var _pulse = 0.85 + 0.15 * sin(_t * 8 + anim_timer);
draw_set_colour(make_colour_rgb(255, 120, 30));
draw_set_alpha(0.18 * _pulse);
draw_circle(x, y + 4, light_radius * _pulse, false);

draw_set_colour(make_colour_rgb(255, 200, 70));
draw_set_alpha(0.28 * _pulse);
draw_circle(x, y + 2, (light_radius * 0.5) * _pulse, false);
draw_set_alpha(1.0);

// 2. Lenhas cruzadas
draw_set_colour(make_colour_rgb(85, 50, 25));
draw_line_width(x - 14, y + 8, x + 14, y - 2, 4.5);
draw_line_width(x - 14, y - 2, x + 14, y + 8, 4.5);
draw_set_colour(make_colour_rgb(50, 30, 15));
draw_line_width(x - 12, y + 6, x + 12, y + 6, 3.5);

// 3. Chamas vivas animadas
var _fh1 = 12 + 4 * sin(_t * 16 + anim_timer);
var _fh2 = 9 + 3 * cos(_t * 14 + anim_timer * 1.3);

// Camada externa de fogo vermelho
draw_set_colour(make_colour_rgb(230, 60, 20));
draw_ellipse(x - 10, y - _fh1 * 1.3, x + 10, y + 4, false);

// Camada intermediária laranja
draw_set_colour(make_colour_rgb(255, 140, 20));
draw_ellipse(x - 7, y - _fh1, x + 7, y + 2, false);

// Núcleo amarelo/branco brilhante
draw_set_colour(make_colour_rgb(255, 225, 70));
draw_ellipse(x - 4, y - _fh2, x + 4, y, false);
draw_set_colour(c_white);
draw_circle(x, y - _fh2 * 0.5, 2.5, false);

draw_set_colour(c_white);
draw_set_alpha(1.0);
