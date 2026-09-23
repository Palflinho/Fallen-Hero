// Fio de energia ate o aliado alvo
if (instance_exists(target)) {
    var _k = (state == "infuse") ? (1 - infuse_timer / infuse_time) : 0.2;
    draw_set_alpha(0.25 + 0.6 * _k);
    draw_set_color(elem_colour(element));
    draw_line_width(x, y - draw_z, target.x, target.y, 1 + 2 * _k);
    draw_set_alpha(1);
}
// Chama tremulante (em vez do corpo quadrado padrao)
var _fy = y - draw_z;
draw_set_alpha(0.3);
draw_set_color(body_colour);
draw_circle(x, _fy, body_radius + 5 + 2 * sin(bob * 9), false);
draw_set_alpha(1);
draw_set_color(body_colour);
draw_triangle(x - body_radius, _fy, x + body_radius, _fy, x, _fy - body_radius * 2.2, false);
draw_circle(x, _fy, body_radius, false);
draw_set_color(c_white);
draw_circle(x, _fy, body_radius * 0.4, false);
// Barra de vida quando ferido
if (hp < hp_max) {
    draw_set_color(c_black);
    draw_rectangle(x - 10, _fy - body_radius * 2.4 - 5, x + 10, _fy - body_radius * 2.4 - 2, false);
    draw_set_color(c_red);
    draw_rectangle(x - 10, _fy - body_radius * 2.4 - 5, x - 10 + 20 * (hp / hp_max), _fy - body_radius * 2.4 - 2, false);
}
draw_set_color(c_white);
