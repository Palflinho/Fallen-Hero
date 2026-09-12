var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

if (state == "active") {
    // Magma ativo em erupção
    draw_set_alpha(0.72 + 0.18 * sin(current_time / 45));
    draw_set_color(make_colour_rgb(255, 95, 10));
    draw_rectangle(x, y, x + _w, y + _h, false);

    // Núcleo central incandescente
    draw_set_alpha(0.85);
    draw_set_color(c_yellow);
    draw_circle(x + _w * 0.5, y + _h * 0.5, min(_w, _h) * 0.32, false);

    // Borda de fogo ardente
    draw_set_color(c_red);
    draw_rectangle(x, y, x + _w, y + _h, true);
    draw_rectangle(x + 1, y + 1, x + _w - 1, y + _h - 1, true);
} else if (state == "warning") {
    // Telegrafia Rítmica: fendas piscando em amarelo-laranja
    var _pulse = 0.50 + 0.40 * sin(current_time / 40);
    draw_set_alpha(0.45);
    draw_set_color(make_colour_rgb(50, 20, 10));
    draw_rectangle(x, y, x + _w, y + _h, false);

    draw_set_alpha(_pulse);
    draw_set_color(c_orange);
    draw_line_width(x + 4, y + 4, x + _w - 4, y + _h - 4, 3);
    draw_line_width(x + _w - 4, y + 4, x + 4, y + _h - 4, 3);

    draw_set_color(c_yellow);
    draw_rectangle(x, y, x + _w, y + _h, true);
} else {
    // Dormant: fendas de carvão apagado
    draw_set_alpha(0.32);
    draw_set_color(make_colour_rgb(26, 12, 12));
    draw_rectangle(x, y, x + _w, y + _h, false);

    draw_set_alpha(0.5);
    draw_set_color(make_colour_rgb(55, 22, 18));
    draw_rectangle(x, y, x + _w, y + _h, true);
}

draw_set_alpha(1);
draw_set_color(c_white);
