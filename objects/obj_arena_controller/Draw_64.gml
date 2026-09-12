if (is_world_paused()) exit;

var _gw = display_get_gui_width();
var _cx = _gw / 2;

// 1. Banner de Transição de Onda / Início
if (banner_timer > 0) {
    var _by = 76;
    var _alpha = clamp(banner_timer * 1.5, 0, 0.95);
    draw_set_alpha(_alpha);
    draw_set_color(make_colour_rgb(12, 16, 26));
    draw_rectangle(_cx - 260, _by - 18, _cx + 260, _by + 18, false);
    draw_set_color(theme_colour);
    draw_rectangle(_cx - 260, _by - 18, _cx + 260, _by + 18, true);
    draw_set_color(c_white);
    draw_rectangle(_cx - 258, _by - 16, _cx + 258, _by + 16, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text_transformed(_cx, _by, banner_text, 1.15, 1.15, 0);
    draw_set_alpha(1);
}

// 2. Indicador Fixo de Onda e Inimigos Restantes durante o Combate
if (arena_state == "active" || arena_state == "wave_cleared") {
    var _iy = 36;
    var _living = instance_number(obj_enemy_parent);

    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(14, 18, 30));
    draw_rectangle(_cx - 180, _iy - 14, _cx + 180, _iy + 14, false);
    draw_set_color(theme_colour);
    draw_rectangle(_cx - 180, _iy - 14, _cx + 180, _iy + 14, true);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    var _str = biome_title + "  |  ONDA " + string(current_wave) + "/" + string(total_waves);
    if (arena_state == "active") {
        _str += "  (" + string(_living) + " restantes)";
    } else {
        _str += "  (Onda Vencida!)";
    }
    draw_text(_cx, _iy, _str);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
