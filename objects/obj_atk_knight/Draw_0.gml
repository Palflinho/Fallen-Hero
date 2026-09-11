var _col = c_white;
if (is_counter) {
    _col = c_yellow;
} else if (instance_exists(owner) && variable_instance_exists(owner, "element_affinity")) {
    switch (owner.element_affinity) {
        case "fire": _col = c_orange; break;
        case "water": _col = c_aqua; break;
        case "wind": _col = c_white; break;
        case "earth": _col = make_colour_rgb(210, 140, 70); break;
    }
}

draw_set_alpha(is_counter ? 0.6 : 0.4);
draw_set_color(_col);
draw_circle(x, y, body_radius, false);
draw_set_color(c_white);
draw_circle(x, y, body_radius, true);
draw_set_alpha(1);
