event_inherited();

if (state == "cast" && cast_timer > 0) {
    var _alpha = (1 - (cast_timer / telegraph_time)) * 0.65;
    draw_set_alpha(_alpha);
    draw_set_color(make_colour_rgb(180, 130, 70));
    draw_circle(cast_target_x, cast_target_y, aoe_radius, false);

    draw_set_alpha(0.9);
    draw_set_color(make_colour_rgb(120, 85, 45));
    draw_circle(cast_target_x, cast_target_y, aoe_radius, true);

    // Linhas de fratura sísmica no círculo
    for (var _i = 0; _i < 4; _i++) {
        var _ang = _i * 90 + 45;
        draw_line(cast_target_x, cast_target_y, cast_target_x + lengthdir_x(aoe_radius, _ang), cast_target_y + lengthdir_y(aoe_radius, _ang));
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}
