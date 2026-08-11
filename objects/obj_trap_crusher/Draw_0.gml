switch (state) {
    case "hidden":
        draw_set_alpha(0.12);
        draw_set_color(c_gray);
        draw_circle(x, y, radius, true);
        draw_set_alpha(1);
        break;

    case "telegraph":
        draw_set_alpha(0.35 + 0.35 * sin(current_time / 50));
        draw_set_color(c_red);
        draw_circle(x, y, radius, true);
        draw_set_alpha(1);
        break;

    case "erupt":
        draw_set_color(c_silver);
        draw_circle(x, y, radius, false);
        draw_set_color(c_black);
        draw_circle(x, y, radius, true);
        break;
}

draw_set_color(c_white);
