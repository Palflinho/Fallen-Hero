// 1. Telegrafia Miyamoto: Circulo de perigo do Grande Esmagamento
if (state == "windup") {
    var _t = clamp(1.0 - (stomp_windup_timer / stomp_windup), 0, 1);
    draw_set_alpha(0.20 + 0.15 * sin(current_time * 0.03));
    draw_set_color(c_red);
    draw_circle(x, y, stomp_hit_radius * _t, false);
    draw_set_alpha(0.85);
    draw_circle(x, y, stomp_hit_radius, true);
    draw_set_color(make_colour_rgb(220, 160, 60));
    draw_circle(x, y, stomp_hit_radius * 0.5, true);
    draw_set_alpha(1);
}

// 2. Sombra sismica
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(x - body_radius * 1.2, y + body_radius * 0.7, x + body_radius * 1.2, y + body_radius * 1.1, false);

// 3. Aura de Vulnerabilidade Sakurai
if (vulnerable) {
    var _vp = 0.5 + 0.5 * sin(current_time * 0.015);
    draw_set_alpha(0.30 + 0.20 * _vp);
    draw_set_color(c_yellow);
    draw_circle(x, y, (body_radius + 20) * scale_x, false);
    draw_set_alpha(0.9);
    draw_set_color(make_colour_rgb(255, 215, 0));
    draw_circle(x, y, (body_radius + 20) * scale_x, true);
    draw_set_alpha(1);
}

// 4. Corpo de granito bruto
draw_set_alpha(1);
var _bcol = (hit_flash_timer > 0) ? c_white : (vulnerable ? make_colour_rgb(170, 140, 90) : body_colour);
draw_set_color(_bcol);
draw_circle(x, y, body_radius * scale_x, false);

// 5. Fissuras incandescentes na rocha
var _pulse = 0.5 + 0.5 * sin(current_time / 80);
draw_set_color(vulnerable ? c_yellow : merge_colour(make_colour_rgb(180, 100, 30), c_yellow, _pulse));
draw_line_width(x - 20, y - 10, x, y + 15, vulnerable ? 4 : 3);
draw_line_width(x, y + 15, x + 25, y - 5, vulnerable ? 4 : 3);

// 6. Borda de pedra pesada
draw_set_color(vulnerable ? c_yellow : make_colour_rgb(70, 50, 30));
draw_circle(x, y, body_radius * scale_x, true);
draw_circle(x, y, body_radius * scale_x - 3, true);

// 7. Olhos runicos / Olhos tontos
if (vulnerable) {
    // Olhos em X
    draw_set_color(c_yellow);
    draw_line_width(x - 18, y - 18, x - 10, y - 10, 2);
    draw_line_width(x - 18, y - 10, x - 10, y - 18, 2);
    draw_line_width(x + 10, y - 18, x + 18, y - 10, 2);
    draw_line_width(x + 10, y - 10, x + 18, y - 18, 2);

    // Estrelas de tontura orbitando
    for (var _s = 0; _s < 4; _s++) {
        var _sang = current_time * 0.005 + _s * (pi / 2);
        var _sx = x + cos(_sang) * 32;
        var _sy = y - body_radius - 14 + sin(_sang) * 10;
        draw_set_color(c_yellow);
        draw_circle(_sx, _sy, 4, false);
    }
} else {
    draw_set_color(make_colour_rgb(255, 200, 50));
    draw_circle(x - 14, y - 14, 5, false);
    draw_circle(x + 14, y - 14, 5, false);
}

// 8. Rotulo tatico
var _label = "Colosso Tita";
if (vulnerable) _label = "COURACA FRATURADA! VULNERAVEL!";
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(vulnerable ? c_yellow : c_white);
draw_text(x, y - body_radius - 24, _label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
