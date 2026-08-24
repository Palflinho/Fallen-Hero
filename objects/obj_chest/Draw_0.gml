draw_set_alpha(0.6 + 0.15 * sin(current_time / 150));
draw_set_color(c_yellow);
draw_rectangle(x - radius, y - radius, x + radius, y + radius, false);
draw_set_alpha(1);

draw_set_color(c_orange);
draw_rectangle(x - radius, y - radius, x + radius, y + radius, true);
draw_rectangle(x - radius, y - 4, x + radius, y + 4, true);

draw_set_color(c_white);
