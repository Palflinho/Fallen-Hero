event_inherited();

if (state == "cast" && cast_timer > 0) {
    var _alpha = (1 - (cast_timer / telegraph_time)) * 0.55;
    draw_set_alpha(_alpha);
    draw_set_color(make_colour_rgb(180, 245, 255));
    draw_circle(cast_target_x, cast_target_y, aoe_radius, false);

    draw_set_alpha(0.85);
    draw_set_color(c_white);
    draw_circle(cast_target_x, cast_target_y, aoe_radius, true);

    // Espiral de vento no ponto de impacto
    for (var _i = 0; _i < 3; _i++) {
        var _ang = (current_time * 0.4 + _i * 120) % 360;
        var _rad = aoe_radius * 0.65;
        draw_circle(cast_target_x + lengthdir_x(_rad, _ang), cast_target_y + lengthdir_y(_rad, _ang), 4, false);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}
