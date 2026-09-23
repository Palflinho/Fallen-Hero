if (state == "windup") {
    // mao erguida carregando a estaca
    draw_set_color(make_colour_rgb(200, 150, 80));
    draw_triangle(x - 5, y - body_radius - 4, x + 5, y - body_radius - 4, x, y - body_radius - 22, false);
}
event_inherited();
