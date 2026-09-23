// Anel do tornado (circulo = area)
if (state == "windup") {
    elem_draw_warning_circle(x, y, tornado_radius, 1 - phase_timer / 0.8, c_white);
}
if (state == "tornado" || state == "windup") {
    draw_set_alpha(0.35);
    draw_set_color(c_white);
    for (var _t = 0; _t < 4; _t++) {
        var _ta = spin + _t * 90;
        draw_line_width(x + lengthdir_x(body_radius * 0.5, _ta), y + lengthdir_y(body_radius * 0.5, _ta), x + lengthdir_x(tornado_radius, _ta + 50), y + lengthdir_y(tornado_radius, _ta + 50), 3);
    }
    draw_set_alpha(1);
}
if (state == "mist") {
    // aviso de que esta intangivel: particulas de nevoa
    draw_set_alpha(0.25);
    draw_set_color(c_white);
    draw_circle(x + 8 * sin(current_time * 0.004), y, body_radius * 1.2, false);
    draw_set_alpha(1);
}
if (state == "dizzy") {
    var _sy = y - body_radius - 20;
    draw_set_color(c_yellow);
    for (var _s = 0; _s < 3; _s++) {
        var _sa = current_time * 0.01 + _s * 2.09;
        draw_circle(x + cos(_sa) * 16, _sy + sin(_sa) * 5, 3, false);
    }
}
event_inherited();
