draw_set_color(c_black);
draw_rectangle(x - radius, y - radius, x + radius, y + radius, false);
draw_set_color(pressed ? c_lime : c_silver);
draw_rectangle(x - radius + 4, y - radius + 4, x + radius - 4, y + radius - 4, false);
draw_set_color(c_white);
draw_rectangle(x - radius, y - radius, x + radius, y + radius, true);
