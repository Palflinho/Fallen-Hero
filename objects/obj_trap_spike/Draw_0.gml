var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

switch (state) {
    case "hidden":
        draw_set_alpha(0.15);
        draw_set_color(c_gray);
        draw_rectangle(x, y, x + _w, y + _h, false);
        draw_set_alpha(1);
        break;

    case "delay":
        draw_set_alpha(0.4 + 0.4 * sin(current_time / 60));
        draw_set_color(c_red);
        draw_rectangle(x, y, x + _w, y + _h, false);
        draw_set_alpha(1);
        break;

    case "erupt":
        draw_set_color(c_silver);
        draw_rectangle(x, y, x + _w, y + _h, false);
        draw_set_color(c_gray);
        for (var _i = 0; _i < 3; _i++) {
            var _sx = x + _w * (_i + 0.5) / 3;
            draw_triangle(_sx - 6, y + _h, _sx + 6, y + _h, _sx, y + 6, false);
        }
        break;

    case "cooldown":
        draw_set_alpha(0.15);
        draw_set_color(c_gray);
        draw_rectangle(x, y, x + _w, y + _h, false);
        draw_set_alpha(1);
        break;
}

draw_set_color(c_white);
