var _t = current_time * 0.001;

// 1. Sombra no Chão
draw_set_colour(c_black);
draw_set_alpha(0.35);
draw_ellipse(x - 12, y + 8, x + 12, y + 14, false);
draw_set_alpha(1.0);

// 2. Corpo do Ancião Tatupóba
var _shell_col = make_colour_rgb(140, 105, 75);
var _cape_col = make_colour_rgb(105, 55, 45);
var _beard_col = make_colour_rgb(225, 230, 235);

// Carapaça curvada pela idade
draw_set_colour(_shell_col);
draw_circle(x, y - 2, 10, false);
draw_set_colour(make_colour_rgb(100, 75, 50));
draw_arc_sim(x, y - 2, 10, -1);

// Manta de viagem / capa aconchegante
draw_set_colour(_cape_col);
draw_triangle(x, y - 8, x - 10, y + 8, x + 10, y + 8, false);

// Cabeça Chibi
draw_set_colour(_shell_col);
draw_circle(x, y - 8, 8, false);

// Barba/Penugem branca de ancião
draw_set_colour(_beard_col);
draw_circle(x + 2, y - 4, 4, false);
draw_circle(x + 4, y - 2, 3, false);

// Olho bondoso e sábio
draw_set_colour(c_black);
draw_circle(x + 2, y - 8, 1.8, false);
draw_set_colour(c_white);
draw_circle(x + 2, y - 8.5, 0.8, false);

// Bastão de Caminhada de Madeira
draw_set_colour(make_colour_rgb(105, 70, 40));
draw_line_width(x + 10, y - 14, x + 10, y + 10, 2.5);
draw_set_colour(make_colour_rgb(255, 215, 80));
draw_circle(x + 10, y - 15, 2.5, false); // Pomo dourado do cajado
