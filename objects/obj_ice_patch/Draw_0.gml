if (!active) exit;

var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

// Superfície de gelo com transparência cristalina
draw_set_alpha(0.38 + 0.08 * sin(current_time / 140));
draw_set_color(make_colour_rgb(130, 215, 255));
draw_rectangle(x, y, x + _w, y + _h, false);

// Linhas internas de fratura do gelo
draw_set_alpha(0.22);
draw_set_color(c_white);
draw_line(x + 6, y + 6, x + _w - 6, y + _h - 6);
draw_line(x + _w - 6, y + 6, x + 6, y + _h - 6);

// Borda congelada cintilante
draw_set_alpha(0.75 + 0.15 * sin(current_time / 90));
draw_set_color(make_colour_rgb(210, 245, 255));
draw_rectangle(x, y, x + _w, y + _h, true);
draw_rectangle(x + 1, y + 1, x + _w - 1, y + _h - 1, true);

draw_set_alpha(1);
draw_set_color(c_white);
