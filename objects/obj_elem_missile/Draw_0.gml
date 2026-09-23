switch (kind) {
    case "bubble":
        var _wob = 1 + 0.08 * sin((current_time + anim_seed) * 0.012);
        draw_set_alpha(0.35);
        draw_set_color(colour);
        draw_circle(x, y, radius * _wob, false);
        draw_set_alpha(0.9);
        draw_set_color(c_white);
        draw_circle(x, y, radius * _wob, true);
        draw_circle(x - radius * 0.35, y - radius * 0.35, 2, false);
        break;

    case "fire_shot":
        // seta = projetil
        var _tip_x = x + lengthdir_x(radius + 4, dir);
        var _tip_y = y + lengthdir_y(radius + 4, dir);
        draw_set_color(colour);
        draw_triangle(_tip_x, _tip_y, x + lengthdir_x(radius, dir + 140), y + lengthdir_y(radius, dir + 140), x + lengthdir_x(radius, dir - 140), y + lengthdir_y(radius, dir - 140), false);
        draw_set_color(c_yellow);
        draw_circle(x, y, 3, false);
        break;

    case "boomerang":
        var _spin = (current_time * 0.9 + anim_seed) mod 360;
        draw_set_color(colour);
        for (var _b = 0; _b < 3; _b++) {
            var _ba = _spin + _b * 120;
            draw_line_width(x, y, x + lengthdir_x(radius + 4, _ba), y + lengthdir_y(radius + 4, _ba), 3);
        }
        draw_set_color(c_white);
        draw_circle(x, y, 3, false);
        break;

    case "stake":
        if (phase == 0) {
            var _sink = 1 - timer / 0.25;
            draw_set_color(colour);
            draw_triangle(x - 5, y, x + 5, y, x, y - 18 * _sink, false);
        } else if (phase == 1) {
            var _pulse = (timer >= 0.35) ? (0.5 + 0.5 * sin(current_time * 0.06)) : 0.4;
            elem_draw_warning_circle(target_x, target_y, 24, timer / 0.8, colour);
            draw_set_alpha(_pulse);
            draw_set_color(c_white);
            draw_line(target_x - 6, target_y - 6, target_x + 6, target_y + 6);
            draw_line(target_x - 6, target_y + 6, target_x + 6, target_y - 6);
            draw_set_alpha(1);
        } else {
            var _h = 34 * (1 - timer / 0.3);
            draw_set_color(colour);
            draw_triangle(target_x - 10, target_y + 6, target_x + 10, target_y + 6, target_x, target_y - _h, false);
            draw_triangle(target_x - 16, target_y + 6, target_x - 4, target_y + 6, target_x - 12, target_y - _h * 0.6, false);
            draw_triangle(target_x + 4, target_y + 6, target_x + 16, target_y + 6, target_x + 12, target_y - _h * 0.6, false);
        }
        break;

    case "meteor":
        if (delay > 0 || phase == 0) break;
        var _mt = clamp(timer / 0.85, 0, 1);
        elem_draw_warning_circle(target_x, target_y, 34, _mt, colour);
        // rocha caindo
        var _fall_y = target_y - (1 - _mt) * 220;
        draw_set_color(make_colour_rgb(90, 40, 20));
        draw_circle(target_x, _fall_y, 9, false);
        draw_set_color(colour);
        draw_circle(target_x, _fall_y, 9, true);
        break;

    case "ice_cross":
        var _it = clamp(timer / 0.75, 0, 1);
        var _dirs = [0, 90, 180, 270];
        draw_set_color(colour);
        for (var _k = 0; _k <= 4 * cell_arm; _k++) {
            var _cx = target_x;
            var _cy = target_y;
            if (_k > 0) {
                var _d = _dirs[(_k - 1) mod 4];
                var _n = 1 + floor((_k - 1) / 4);
                _cx += lengthdir_x(_n * cell_step, _d);
                _cy += lengthdir_y(_n * cell_step, _d);
            }
            draw_set_alpha(0.15 + 0.35 * _it);
            draw_rectangle(_cx - 16, _cy - 16, _cx + 16, _cy + 16, false);
            draw_set_alpha(0.8);
            draw_rectangle(_cx - 16, _cy - 16, _cx + 16, _cy + 16, true);
        }
        draw_set_alpha(1);
        break;

    case "boulder":
        // sombra no chao (cresce ao se aproximar)
        var _bt = clamp(timer / flight_time, 0, 1);
        draw_set_alpha(0.35);
        draw_set_color(c_black);
        draw_ellipse(target_x - 10 - 8 * _bt, target_y - 4 - 3 * _bt, target_x + 10 + 8 * _bt, target_y + 4 + 3 * _bt, false);
        draw_set_alpha(0.6);
        draw_set_color(colour);
        draw_circle(target_x, target_y, 30, true);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(120, 88, 55));
        draw_circle(x, y - draw_z, 12, false);
        draw_set_color(c_black);
        draw_circle(x, y - draw_z, 12, true);
        break;
    case "glacial_orb":
        var _gp = 1 + 0.1 * sin(current_time * 0.02);
        draw_set_alpha(0.3);
        draw_set_color(heading == 0 ? colour : c_white);
        draw_circle(x, y, (radius + 6) * _gp, false);
        draw_set_alpha(1);
        draw_set_color(heading == 0 ? colour : c_white);
        draw_circle(x, y, radius, false);
        draw_set_color(c_white);
        draw_circle(x, y, radius, true);
        // espinhos de gelo girando
        for (var _gs = 0; _gs < 6; _gs++) {
            var _ga = current_time * 0.3 + _gs * 60;
            draw_line(x + lengthdir_x(radius, _ga), y + lengthdir_y(radius, _ga), x + lengthdir_x(radius + 6, _ga), y + lengthdir_y(radius + 6, _ga));
        }
        break;

    case "tidal_wave":
        var _len = wave_vertical ? room_height : room_width;
        var _g1 = gap_center - gap_size * 0.5;
        var _g2 = gap_center + gap_size * 0.5;
        if (timer < 1.0) {
            // aviso: setas na borda de onde a onda vem + brecha destacada
            draw_set_alpha(0.35 + 0.3 * sin(current_time * 0.03));
            draw_set_color(colour);
            for (var _w = 20; _w < _len; _w += 60) {
                if (_w > _g1 && _w < _g2) continue;
                var _ax = wave_vertical ? wave_pos + wave_sign * 20 : _w;
                var _ay = wave_vertical ? _w : wave_pos + wave_sign * 20;
                var _ad = wave_vertical ? (wave_sign > 0 ? 0 : 180) : (wave_sign > 0 ? 270 : 90);
                draw_triangle(_ax + lengthdir_x(12, _ad), _ay + lengthdir_y(12, _ad), _ax + lengthdir_x(8, _ad + 130), _ay + lengthdir_y(8, _ad + 130), _ax + lengthdir_x(8, _ad - 130), _ay + lengthdir_y(8, _ad - 130), false);
            }
            draw_set_color(c_white);
            if (wave_vertical) draw_rectangle(wave_pos - 4, _g1, wave_pos + 4, _g2, true);
            else draw_rectangle(_g1, wave_pos - 4, _g2, wave_pos + 4, true);
        } else {
            draw_set_alpha(0.55);
            draw_set_color(colour);
            if (wave_vertical) {
                draw_rectangle(wave_pos - 18, 0, wave_pos + 18, _g1, false);
                draw_rectangle(wave_pos - 18, _g2, wave_pos + 18, _len, false);
            } else {
                draw_rectangle(0, wave_pos - 18, _g1, wave_pos + 18, false);
                draw_rectangle(_g2, wave_pos - 18, _len, wave_pos + 18, false);
            }
            draw_set_alpha(0.9);
            draw_set_color(c_white);
            if (wave_vertical) {
                draw_line(wave_pos + wave_sign * 18, 0, wave_pos + wave_sign * 18, _g1);
                draw_line(wave_pos + wave_sign * 18, _g2, wave_pos + wave_sign * 18, _len);
            } else {
                draw_line(0, wave_pos + wave_sign * 18, _g1, wave_pos + wave_sign * 18);
                draw_line(_g2, wave_pos + wave_sign * 18, _len, wave_pos + wave_sign * 18);
            }
        }
        break;
}
draw_set_alpha(1);
draw_set_color(c_white);
