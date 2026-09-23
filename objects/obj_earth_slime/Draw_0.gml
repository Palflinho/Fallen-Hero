// Aviso do rolamento (linha = investida)
if (state == "roll_windup") {
    elem_draw_warning_line(x, y, roll_dir, 190, body_radius * 2, make_colour_rgb(200, 150, 80));
}
event_inherited();
