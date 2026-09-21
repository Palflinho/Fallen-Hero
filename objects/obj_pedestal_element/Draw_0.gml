var _t = current_time * 0.001;
var _reclaimed = element_is_reclaimed(element_id);

// 1. Sombra da base
draw_set_colour(c_black);
draw_set_alpha(0.35);
draw_ellipse(x - 16, y + 10, x + 16, y + 18, false);

// 2. Pedestal de Pedra Sagrada Talhada
var _stone_col = make_colour_rgb(70, 75, 90);
var _rim_col = make_colour_rgb(110, 115, 135);

// Base larga
draw_set_colour(_stone_col);
draw_set_alpha(1.0);
draw_rectangle(x - 14, y + 6, x + 14, y + 14, false);
draw_set_colour(_rim_col);
draw_rectangle(x - 14, y + 6, x + 14, y + 14, true);

// Coluna central
draw_set_colour(_stone_col);
draw_rectangle(x - 10, y - 10, x + 10, y + 6, false);
draw_set_colour(_rim_col);
draw_rectangle(x - 10, y - 10, x + 10, y + 6, true);

// Prato superior / Bacia
draw_set_colour(_stone_col);
draw_ellipse(x - 13, y - 14, x + 13, y - 8, false);
draw_set_colour(_rim_col);
draw_ellipse(x - 13, y - 14, x + 13, y - 8, true);

// 3. Essência Elemental no Pedestal
var _elem_col = c_aqua;
switch (element_id) {
    case "water": _elem_col = make_colour_rgb(60, 200, 255); break;
    case "fire":  _elem_col = make_colour_rgb(255, 110, 30); break;
    case "wind":  _elem_col = make_colour_rgb(110, 255, 170); break;
    case "earth": _elem_col = make_colour_rgb(255, 210, 60); break;
}

if (_reclaimed) {
    // Essência Restaurada: Orbe místico flutuante com pulso celestial
    var _float_y = y - 24 + sin(_t * 4 + glow_timer) * 3;
    var _pulse = 0.8 + 0.2 * sin(_t * 7);

    // Luz emitida no pedestal e chão
    draw_set_colour(_elem_col);
    draw_set_alpha(0.20 * _pulse);
    draw_circle(x, y - 8, 48 * _pulse, false);

    // Orbe
    draw_set_alpha(0.85);
    draw_circle(x, _float_y, 7 * _pulse, false);
    draw_set_colour(c_white);
    draw_circle(x - 1, _float_y - 2, 2.5, false);

    // Anel orbital de runas
    draw_set_colour(_elem_col);
    draw_set_alpha(0.6 * _pulse);
    var _ang = _t * 3;
    draw_circle(x + cos(_ang) * 11, _float_y + sin(_ang) * 4, 1.8, false);
    draw_circle(x + cos(_ang + pi) * 11, _float_y + sin(_ang + pi) * 4, 1.8, false);

    // Partículas esporádicas
    if (random(1) < 0.1) {
        fx_spawn_sparks(x + random_range(-6, 6), _float_y, _elem_col, 1);
    }
} else {
    // Receptáculo Vazio e Escuro (A essência ainda está sob controle do General)
    draw_set_colour(c_black);
    draw_set_alpha(0.8);
    draw_ellipse(x - 7, y - 13, x + 7, y - 9, false);

    // Racha sutil no receptáculo
    draw_set_colour(make_colour_rgb(40, 45, 55));
    draw_line(x - 3, y - 12, x + 3, y - 10);
}

draw_set_colour(c_white);
draw_set_alpha(1.0);
