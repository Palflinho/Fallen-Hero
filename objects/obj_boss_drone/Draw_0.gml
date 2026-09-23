// Cabo de energia ate o traje: mostra que o drone alimenta o escudo
if (instance_exists(owner)) {
    draw_set_alpha(0.35 + 0.2 * sin(current_time * 0.02));
    draw_set_color(make_colour_rgb(40, 220, 255));
    draw_line_width(x, y, owner.x, owner.y, 2);
    draw_set_alpha(1);
}
draw_set_color(hit_flash_timer > 0 ? c_white : make_colour_rgb(30, 40, 55));
draw_circle(x, y, body_radius, false);
draw_set_color(body_colour);
draw_circle(x, y, body_radius, true);
draw_circle(x, y, 4 + sin(current_time * 0.02), false);
if (hp < hp_max) {
    draw_set_color(c_black);
    draw_rectangle(x - 12, y - 20, x + 12, y - 17, false);
    draw_set_color(c_red);
    draw_rectangle(x - 12, y - 20, x - 12 + 24 * (hp / hp_max), y - 17, false);
}
draw_set_color(c_white);
