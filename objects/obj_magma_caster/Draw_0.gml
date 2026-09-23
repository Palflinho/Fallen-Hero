if (state == "channel") {
    // bracos erguidos e orbe de magma sobre a cabeca
    draw_set_alpha(0.8);
    draw_set_color(c_orange);
    draw_circle(x, y - body_radius - 14, 6 + 2 * sin(current_time * 0.03), false);
    draw_set_alpha(1);
}
event_inherited();
