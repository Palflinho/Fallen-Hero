draw_set_color(state == "telegraph" ? c_red : c_dkgray);
draw_rectangle(x - 12, y - 12, x + 12, y + 12, false);
draw_set_color(c_black);
draw_rectangle(x - 12, y - 12, x + 12, y + 12, true);

draw_set_color(c_white);
draw_line_width(x, y, x + fire_dir_x * 20, y + fire_dir_y * 20, 4);
