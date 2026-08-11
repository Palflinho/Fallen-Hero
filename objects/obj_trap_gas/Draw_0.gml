draw_set_alpha(0.3 + 0.1 * sin(current_time / 90));
draw_set_color(c_lime);
draw_circle(x, y, radius, false);
draw_set_alpha(0.6);
draw_circle(x, y, radius, true);
draw_set_alpha(1);
draw_set_color(c_white);
