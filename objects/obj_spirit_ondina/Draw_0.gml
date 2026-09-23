if (state == "heal") {
    // Coluna de agua curativa (circulo = pare-a com dano)
    draw_set_alpha(0.25 + 0.15 * sin(current_time * 0.02));
    draw_set_color(c_aqua);
    draw_circle(x, y, body_radius + 26, false);
    draw_set_alpha(0.9);
    draw_circle(x, y, body_radius + 26, true);
    draw_set_alpha(1);
    // Barra de interrupcao
    var _k = clamp(heal_dmg_taken / (hp_max * 0.08), 0, 1);
    draw_set_color(c_black);
    draw_rectangle(x - 24, y + body_radius + 10, x + 24, y + body_radius + 15, false);
    draw_set_color(c_yellow);
    draw_rectangle(x - 24, y + body_radius + 10, x - 24 + 48 * _k, y + body_radius + 15, false);
}
if (!is_clone && state != "intro") {
    // A verdadeira Ondina tem uma coroa de gotas brilhantes
    draw_set_color(c_white);
    for (var _g = 0; _g < 3; _g++) {
        draw_circle(x - 8 + _g * 8, y - draw_z - body_radius - 6 - 2 * sin(current_time * 0.01 + _g), 2, false);
    }
}
event_inherited();
if (state == "exposed") spirit_draw_exposed();
// Lamina Espectral enxerga atraves das ilusoes: clones marcados com X
if (is_clone && player_is_archetype(instance_find(obj_player, 0), "assassin", "water")) {
    draw_set_color(c_red);
    draw_line_width(x - 12, y - draw_z - 12, x + 12, y - draw_z + 12, 3);
    draw_line_width(x - 12, y - draw_z + 12, x + 12, y - draw_z - 12, 3);
    draw_set_color(c_white);
}
