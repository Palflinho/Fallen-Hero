// 1. Runa Central da Arena no Chão
var _pulse = 0.5 + 0.5 * sin(current_time * 0.004);
draw_set_alpha(0.35 + 0.15 * _pulse);
draw_set_color(theme_colour);
draw_circle(x, y, 64, false);

draw_set_alpha(0.8);
draw_set_color(c_white);
draw_circle(x, y, 64, true);
draw_circle(x, y, 32, true);

// Runas giratórias
var _rot = current_time * 0.04;
for (var _i = 0; _i < 4; _i++) {
    var _a = _rot + _i * 90;
    var _rx = x + lengthdir_x(48, _a);
    var _ry = y + lengthdir_y(48, _a);
    draw_circle(_rx, _ry, 4, false);
}
draw_set_alpha(1);

// 2. Barreira Mágica da Arena enquanto o combate estiver ocorrendo
if (arena_barrier_active) {
    var _b_alpha = 0.25 + 0.15 * sin(current_time * 0.006);
    draw_set_alpha(_b_alpha);
    draw_set_color(theme_colour);
    draw_circle(x, y, arena_barrier_radius, false);

    draw_set_alpha(0.85);
    draw_set_color(c_white);
    draw_circle(x, y, arena_barrier_radius, true);
    draw_circle(x, y, arena_barrier_radius - 4, true);
    draw_set_alpha(1);
}

// 3. Prompt de Espera
if (arena_state == "waiting") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(x, y - 72, "* APROXIME-SE PARA INICIAR A ARENA *");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
