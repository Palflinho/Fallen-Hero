var _col = elem_colour(element);
// Aura no chao (circulo = area de efeito)
var _pulse = (pulse_fx > 0) ? (pulse_fx / 0.4) : 0;
draw_set_alpha(0.08 + 0.12 * _pulse);
draw_set_color(_col);
draw_circle(x, y, aura_radius, false);
draw_set_alpha(0.45);
draw_circle(x, y, aura_radius, true);
if (_pulse > 0) draw_circle(x, y, aura_radius * (1 - _pulse), true);
draw_set_alpha(1);

// Pilar de pedra com a runa do elemento
var _c = (hit_flash_timer > 0) ? c_white : make_colour_rgb(80, 70, 65);
draw_set_color(_c);
draw_rectangle(x - 10, y - 30, x + 10, y + 12, false);
draw_set_color(c_black);
draw_rectangle(x - 10, y - 30, x + 10, y + 12, true);
draw_set_color(_col);
draw_circle(x, y - 14, 5 + 1.5 * sin(current_time * 0.008), false);
draw_rectangle(x - 12, y - 34, x + 12, y - 30, false);

// Barra de vida
if (hp < hp_max) {
    draw_set_color(c_black);
    draw_rectangle(x - 16, y - 42, x + 16, y - 38, false);
    draw_set_color(c_red);
    draw_rectangle(x - 16, y - 42, x - 16 + 32 * (hp / hp_max), y - 38, false);
}
draw_set_color(c_white);
