// Aviso de erupcao (circulo = area)
if (state == "erupt_warn") {
    elem_draw_warning_circle(target_x, target_y, 50, 1 - state_timer / 0.7, c_orange);
}
// Marca de lava borbulhando enquanto esta submersa
if (state == "under" || state == "erupt_warn") {
    draw_set_alpha(0.6);
    draw_set_color(c_orange);
    draw_ellipse(x - 14, y - 5, x + 14, y + 5, true);
    draw_set_alpha(1);
}
// Corpo de serpente (segmentos que seguem a cabeca)
if (draw_alpha > 0.05) {
    draw_set_alpha(draw_alpha);
    for (var _i = trail_len - 1; _i >= 4; _i -= 4) {
        var _k = 1 - _i / trail_len;
        var _col = merge_colour(make_colour_rgb(120, 30, 10), body_colour, _k);
        draw_set_color(_col);
        draw_circle(trail_x[_i], trail_y[_i], 5 + body_radius * 0.6 * _k, false);
    }
    draw_set_alpha(1);
}
event_inherited();
if (state == "exposed" && fh_vuln_timer > 0) spirit_draw_exposed();
