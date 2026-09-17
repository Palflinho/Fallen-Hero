var _sx = scale_x;
var _sy = scale_y;
var _ox = (shake_timer > 0) ? random_range(-3, 3) : 0;
var _oy = (shake_timer > 0) ? random_range(-3, 3) : 0;

var _draw_x = x + _ox;
var _draw_y = y + _oy;

// Sombra
draw_set_alpha(0.35);
draw_set_colour(c_black);
draw_ellipse(x - 24, y - 10, x + 24, y + 10, false);

draw_set_alpha(1.0);

// Poste de madeira base
draw_set_colour(make_colour_rgb(80, 50, 25));
draw_rectangle(_draw_x - 4, _draw_y - 30, _draw_x + 4, _draw_y, false);

// Corpo de palha do boneco
var _body_color = (hit_flash_timer > 0) ? c_white : make_colour_rgb(190, 160, 95);
draw_set_colour(_body_color);
draw_ellipse((_draw_x - 18 * _sx), (_draw_y - 46 * _sy), (_draw_x + 18 * _sx), (_draw_y - 12 * _sy), false);

// Cabeça de palha
draw_ellipse((_draw_x - 12 * _sx), (_draw_y - 62 * _sy), (_draw_x + 12 * _sx), (_draw_y - 42 * _sy), false);

// Alvo no peito (bullseye vermelho)
if (hit_flash_timer <= 0) {
    draw_set_colour(c_red);
    draw_circle(_draw_x, _draw_y - 28 * _sy, 8, false);
    draw_set_colour(c_white);
    draw_circle(_draw_x, _draw_y - 28 * _sy, 4, false);
    draw_set_colour(c_red);
    draw_circle(_draw_x, _draw_y - 28 * _sy, 2, false);
}

// Braços de poste de madeira
draw_set_colour(make_colour_rgb(80, 50, 25));
draw_rectangle(_draw_x - 28, _draw_y - 36, _draw_x + 28, _draw_y - 30, false);

// Indicador de Treino / DPS
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_regular);

if (dps_accum > 0) {
    draw_set_colour(make_colour_rgb(255, 215, 80));
    draw_text(x, y - 72, "Dano: " + string(dps_accum));
} else if (last_dps > 0) {
    draw_set_colour(make_colour_rgb(140, 230, 255));
    draw_text(x, y - 72, "Ultimo DPS: " + string(last_dps));
} else {
    draw_set_colour(c_ltgray);
    draw_text(x, y - 72, "Boneco de Treino");
}
