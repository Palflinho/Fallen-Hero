// 1. Sombra projetada
draw_set_colour(c_black);
draw_set_alpha(0.35);
draw_ellipse(x - body_radius, y + body_radius * 0.4, x + body_radius, y + body_radius * 0.9, false);

// 2. Desenho do Feixe Laser (se carregando ou disparando)
if (state == "laser_charge") {
    // Linha vermelha fina de telegrafia
    var _lx1 = x + lengthdir_x(36, laser_angle);
    var _ly1 = y + lengthdir_y(36, laser_angle);
    var _lx2 = x + lengthdir_x(800, laser_angle);
    var _ly2 = y + lengthdir_y(800, laser_angle);

    draw_set_alpha(0.6 + 0.3 * sin(current_time * 0.03));
    draw_set_colour(c_red);
    draw_line_width(_lx1, _ly1, _lx2, _ly2, 2);

    // Ponto de mira no final
    draw_circle(_lx2, _ly2, 4, false);
} else if (state == "laser_fire") {
    var _lx1 = x + lengthdir_x(36, laser_angle);
    var _ly1 = y + lengthdir_y(36, laser_angle);
    var _lx2 = x + lengthdir_x(800, laser_angle);
    var _ly2 = y + lengthdir_y(800, laser_angle);

    // Feixe externo ciano espesso
    draw_set_alpha(0.7);
    draw_set_colour(make_colour_rgb(50, 220, 255));
    draw_line_width(_lx1, _ly1, _lx2, _ly2, 14);

    // Núcleo branco brilhante do laser
    draw_set_alpha(0.95);
    draw_set_colour(c_white);
    draw_line_width(_lx1, _ly1, _lx2, _ly2, 6);

    // Clarão no canhão
    draw_circle(_lx1, _ly1, 14, false);
}

// 3. Drones Auxiliares Orbitais
if (drones_active) {
    for (var _d = 0; _d < 2; _d++) {
        var _da = drone_angle + _d * 180;
        var _dx = x + lengthdir_x(70, _da);
        var _dy = y + lengthdir_y(70, _da);

        // Corpo do drone
        draw_set_alpha(1.0);
        draw_set_colour(make_colour_rgb(30, 40, 55));
        draw_circle(_dx, _dy, 10, false);
        draw_set_colour(accent_colour);
        draw_circle(_dx, _dy, 10, true);
        draw_circle(_dx, _dy, 4, false);
    }
}

// 4. Corpo do Exoesqueleto Cibernético
draw_set_alpha(1.0);

// Carapaça blindada externa
draw_set_colour(body_colour);
draw_circle(x, y, body_radius, false);

// Placas metálicas chanfradas
draw_set_colour(make_colour_rgb(35, 45, 60));
draw_circle(x, y, body_radius - 8, false);

// Viseira cibernética / visor óptico
var _vx = x + lengthdir_x(18, facing_dir);
var _vy = y + lengthdir_y(18, facing_dir);
var _visor_col = (vulnerable) ? c_red : ((state == "laser_charge" || state == "laser_fire") ? c_red : accent_colour);
draw_set_colour(_visor_col);
draw_ellipse(_vx - 14, _vy - 6, _vx + 14, _vy + 6, false);

// Núcleo reator no peito
var _pulse = 0.5 + 0.5 * sin(current_time * 0.006);
draw_set_colour(merge_colour(accent_colour, c_white, _pulse));
draw_circle(x, y, 9, false);
draw_set_colour(c_white);
draw_circle(x, y, 4, false);

// Canhões de ombro
for (var _s = -1; _s <= 1; _s += 2) {
    var _sa = facing_dir + _s * 60;
    var _sx = x + lengthdir_x(body_radius - 4, _sa);
    var _sy = y + lengthdir_y(body_radius - 4, _sa);
    draw_set_colour(make_colour_rgb(20, 25, 35));
    draw_circle(_sx, _sy, 8, false);
    draw_set_colour(accent_colour);
    draw_circle(_sx, _sy, 8, true);
}

// Borda metálica
draw_set_colour(make_colour_rgb(180, 200, 220));
draw_circle(x, y, body_radius, true);
draw_circle(x, y, body_radius - 1, true);

// 5. Escudo de Energia Hexagonal Ativo
if (shield_active) {
    var _s_pulse = 0.6 + 0.25 * sin(current_time * 0.012);
    draw_set_alpha(_s_pulse);
    draw_set_colour(make_colour_rgb(40, 200, 255));
    draw_circle(x, y, body_radius + 18, true);
    draw_circle(x, y, body_radius + 20, true);

    draw_set_alpha(0.15);
    draw_circle(x, y, body_radius + 18, false);
}

draw_set_alpha(1.0);
