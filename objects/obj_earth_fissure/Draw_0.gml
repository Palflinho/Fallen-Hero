var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

if (state == "active") {
    // Estacas de rocha erguidas
    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(110, 85, 55));
    draw_rectangle(x, y, x + _w, y + _h, false);

    draw_set_color(make_colour_rgb(200, 180, 150));
    // Triângulos pontiagudos de pedra
    draw_triangle(x + 4, y + _h - 4, x + _w * 0.3, y + 4, x + _w * 0.6, y + _h - 4, false);
    draw_triangle(x + _w * 0.4, y + _h - 4, x + _w * 0.7, y + 6, x + _w - 4, y + _h - 4, false);

    draw_set_color(make_colour_rgb(170, 130, 90));
    draw_rectangle(x, y, x + _w, y + _h, true);
} else if (state == "warning") {
    // Fenda tremula
    var _pulse = 0.5 + 0.4 * sin(current_time / 45);
    draw_set_alpha(0.5);
    draw_set_color(make_colour_rgb(60, 42, 28));
    draw_rectangle(x, y, x + _w, y + _h, false);

    draw_set_alpha(_pulse);
    draw_set_color(make_colour_rgb(230, 180, 70));
    draw_line_width(x + 4, y + 4, x + _w - 4, y + _h - 4, 3);
    draw_line_width(x + _w - 4, y + 4, x + 4, y + _h - 4, 3);
    draw_rectangle(x, y, x + _w, y + _h, true);
} else {
    // Dormant: fendas secas na rocha
    draw_set_alpha(0.35);
    draw_set_color(make_colour_rgb(38, 26, 18));
    draw_rectangle(x, y, x + _w, y + _h, false);

    draw_set_alpha(0.5);
    draw_set_color(make_colour_rgb(75, 55, 38));
    draw_line(x + 6, y + 6, x + _w - 6, y + _h - 6);
    draw_rectangle(x, y, x + _w, y + _h, true);
}

draw_set_alpha(1);
draw_set_color(c_white);
