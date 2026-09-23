// 1. Telegrafias (circulo = area, cone = varredura)
if (state == "windup") {
    var _t = clamp(1.0 - (stomp_windup_timer / stomp_windup), 0, 1);
    elem_draw_warning_circle(x, y, stomp_hit_radius, _t, c_red);
}
if (state == "sweep_windup") {
    var _st = clamp(1 - action_timer / sweep_windup, 0, 1);
    draw_set_alpha(0.2 + 0.25 * _st);
    draw_set_color(c_red);
    for (var _a = -sweep_arc; _a < sweep_arc; _a += 10) {
        draw_triangle(x, y, x + lengthdir_x(sweep_radius, facing_dir + _a), y + lengthdir_y(sweep_radius, facing_dir + _a), x + lengthdir_x(sweep_radius, facing_dir + _a + 10), y + lengthdir_y(sweep_radius, facing_dir + _a + 10), false);
    }
    draw_set_alpha(1);
}
if (state == "spin_windup") {
    elem_draw_warning_circle(x, y, spin_radius, 1 - action_timer / 0.6, c_red);
}
if (ring_active) {
    draw_set_alpha(0.8 * (1 - ring_r / ring_max) + 0.2);
    draw_set_color(make_colour_rgb(210, 160, 90));
    draw_circle(x, y, ring_r, true);
    draw_circle(x, y, ring_r - 3, true);
    draw_circle(x, y, ring_r + 3, true);
    draw_set_alpha(1);
}

// 2. Sombra sismica
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(x - body_radius * 1.2, y + body_radius * 0.7, x + body_radius * 1.2, y + body_radius * 1.1, false);

// 3. Aura de vulnerabilidade
if (vulnerable) {
    var _vp = 0.5 + 0.5 * sin(current_time * 0.015);
    draw_set_alpha(0.30 + 0.20 * _vp);
    draw_set_color(c_yellow);
    draw_circle(x, y, (body_radius + 20) * scale_x, false);
    draw_set_alpha(1);
}

// 4. Corpo de granito
draw_set_alpha(1);
var _bcol = (hit_flash_timer > 0) ? c_white : (vulnerable ? make_colour_rgb(170, 140, 90) : body_colour);
draw_set_color(_bcol);
draw_circle(x, y, body_radius * scale_x, false);

// 5. NUCLEO nas costas (o ponto fraco) - pulsa para chamar a atencao
var _back = facing_dir + 180;
var _cx = x + lengthdir_x(body_radius * 0.72 * scale_x, _back);
var _cy = y + lengthdir_y(body_radius * 0.72 * scale_x, _back);
var _cp = 0.5 + 0.5 * sin(current_time * 0.012);
draw_set_color(merge_colour(make_colour_rgb(255, 140, 30), c_yellow, _cp));
draw_circle(_cx, _cy, 9 + 3 * _cp + (vulnerable ? 4 : 0), false);
draw_set_color(c_white);
draw_circle(_cx, _cy, 4, false);

// 6. Placa frontal blindada (arco grosso na frente; rachada quando preso)
draw_set_color(vulnerable ? make_colour_rgb(120, 90, 60) : make_colour_rgb(70, 55, 40));
var _pr = body_radius * scale_x + 4;
for (var _p = -fh_shell_arc + 10; _p < fh_shell_arc - 10; _p += 10) {
    var _a1 = facing_dir + _p;
    var _a2 = facing_dir + _p + 10;
    draw_line_width(x + lengthdir_x(_pr, _a1), y + lengthdir_y(_pr, _a1), x + lengthdir_x(_pr, _a2), y + lengthdir_y(_pr, _a2), vulnerable ? 3 : 8);
}

// 7. Borda
draw_set_color(vulnerable ? c_yellow : make_colour_rgb(70, 50, 30));
draw_circle(x, y, body_radius * scale_x, true);

// 8. Olhos (na frente)
var _ex = x + lengthdir_x(body_radius * 0.45, facing_dir);
var _ey = y + lengthdir_y(body_radius * 0.45, facing_dir);
if (vulnerable) {
    draw_set_color(c_yellow);
    draw_line_width(_ex - 14, _ey - 6, _ex - 6, _ey + 2, 2);
    draw_line_width(_ex - 14, _ey + 2, _ex - 6, _ey - 6, 2);
    draw_line_width(_ex + 6, _ey - 6, _ex + 14, _ey + 2, 2);
    draw_line_width(_ex + 6, _ey + 2, _ex + 14, _ey - 6, 2);
    for (var _s = 0; _s < 4; _s++) {
        var _sang = current_time * 0.005 + _s * (pi / 2);
        draw_circle(x + cos(_sang) * 32, y - body_radius - 14 + sin(_sang) * 10, 4, false);
    }
} else {
    draw_set_color(make_colour_rgb(255, 200, 50));
    draw_circle(_ex - 10, _ey, 5, false);
    draw_circle(_ex + 10, _ey, 5, false);
}

boss_draw_label("Tita Monolito - ataque o NUCLEO nas costas", "PRESO AO CHAO! ATAQUE!");
