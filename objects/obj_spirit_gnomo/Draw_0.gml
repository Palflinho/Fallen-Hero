if (state == "emerge_warn") {
    elem_draw_warning_circle(target_x, target_y, 48, 1 - state_timer / 0.7, elem_colour("earth"));
    // rachaduras no chao
    draw_set_color(make_colour_rgb(90, 60, 30));
    for (var _c = 0; _c < 5; _c++) {
        var _ca = _c * 72 + 15;
        draw_line(target_x, target_y, target_x + lengthdir_x(40, _ca), target_y + lengthdir_y(40, _ca));
    }
}
if (state == "under" || state == "emerge_warn") {
    // Monte de terra que corre por baixo do chao
    draw_set_color(make_colour_rgb(120, 90, 55));
    draw_ellipse(x - 16, y - 6, x + 16, y + 8, false);
    draw_set_color(c_black);
    draw_ellipse(x - 16, y - 6, x + 16, y + 8, true);
}
event_inherited();
if (state == "exposed" && fh_vuln_timer > 0) spirit_draw_exposed();
