if (target == noone || !instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (target == noone) exit;
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = pad;
var _y = pad;

// HP
draw_set_color(c_black);
draw_rectangle(_x - 2, _y - 2, _x + bar_w + 2, _y + bar_h + 2, false);
draw_set_color(c_red);
draw_rectangle(_x, _y, _x + bar_w * (target.hp / target.hp_max), _y + bar_h, false);
draw_set_color(c_white);
draw_text(_x + 4, _y + 1, "HP " + string(max(0, round(target.hp))) + "/" + string(round(target.hp_max)));

_y += bar_h + bar_gap;

// Level / EXP
draw_set_color(c_black);
draw_rectangle(_x - 2, _y - 2, _x + bar_w + 2, _y + bar_h + 2, false);
draw_set_color(c_yellow);
draw_rectangle(_x, _y, _x + bar_w * (target.xp / target.xp_to_next), _y + bar_h, false);
draw_set_color(c_white);
draw_text(_x + 4, _y + 1, "Nv " + string(target.level) + "  " + string(round(target.xp)) + "/" + string(round(target.xp_to_next)) + " EXP");

_y += bar_h + bar_gap;

// Special ability cooldown
draw_set_color(c_white);
if (target.defend_cooldown_timer > 0) {
    draw_text(_x, _y, "Habilidade: " + string(round(target.defend_cooldown_timer * 10) / 10) + "s");
} else {
    draw_text(_x, _y, "Habilidade: pronta");
}

_y += 20;

if (target.talent_pending_points > 0) {
    draw_set_color(c_yellow);
    draw_text(_x, _y, "Pontos de talento: " + string(target.talent_pending_points) + " (T)");
    draw_set_color(c_white);
    _y += 20;
} else {
    draw_set_color(c_white);
    draw_text(_x, _y, "Atributos: T");
    _y += 20;
}

// Low HP red vignette
if (target.hp / target.hp_max <= 0.3) {
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
if (!boss_room) {
    draw_text(_x, _y + bar_gap, "Botoes: " + string(global.boss_buttons_pressed) + "/4");
}

if (boss_room) {
    var _boss = instance_find(obj_boss, 0);
    if (_boss == noone) _boss = instance_find(obj_boss2, 0);
    if (_boss != noone) {
        var _bw = 500;
        var _bh = 26;
        var _bx = display_get_gui_width() / 2 - _bw / 2;
        var _by = 24;
        var _boss_name = (_boss.object_index == obj_boss2) ? "GENERAL MAGMA" : "GUARDIAO DAS AGUAS";

        draw_set_color(c_black);
        draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + _bh + 2, false);
        draw_set_color(_boss.vulnerable ? c_lime : c_maroon);
        draw_rectangle(_bx, _by, _bx + _bw * (_boss.hp / _boss.hp_max), _by + _bh, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bx + _bw / 2, _by + _bh / 2, _boss.vulnerable ? (_boss_name + " - VULNERAVEL!") : _boss_name);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

if (game_over) {
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2 - 30, "VOCE MORREU");
    draw_set_color(c_white);
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2 + 10, "R - Tentar novamente (ultimo checkpoint)");
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2 + 40, "M - Menu Principal");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
} else if (level_complete) {
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2 - 20, "FASE CONCLUIDA!");
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2 + 20, "Aperte Z para escolher outro personagem");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
} else if (global.attr_window_open) {
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    var _p = target;
    var _cx = display_get_gui_width() / 2;
    var _ty = 50;

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_cx, _ty, "ATRIBUTOS  (T fecha)");
    _ty += 40;

    draw_set_halign(fa_left);
    var _lx = _cx - 260;

    draw_text(_lx, _ty, "Nivel " + string(_p.level) + "   -   Atributos Naturais");
    _ty += 26;
    draw_text(_lx, _ty, "Power " + string(round(_p.nat_power)) + "     Defesa " + string(round(_p.nat_defesa)));
    _ty += 22;
    draw_text(_lx, _ty, "Vel. Ataque " + string(round(_p.nat_atk_spd * 100) / 100) + "     Vel. Movimento " + string(round(_p.nat_move_spd)));
    _ty += 22;
    draw_text(_lx, _ty, "HP " + string(round(_p.nat_hp)));
    _ty += 34;

    draw_text(_lx, _ty, "Atributos Sinteticos (de talentos)");
    _ty += 26;
    draw_text(_lx, _ty, "HP Regen " + string(_p.synth_hp_reg) + "     Critico " + string(round(_p.synth_crit_chance * 100)) + "%");
    _ty += 22;
    draw_text(_lx, _ty, "Reducao Recarga " + string(round(_p.synth_cdr * 100)) + "%     Dodge " + string(round(_p.synth_dodge * 100)) + "%");
    _ty += 22;
    draw_text(_lx, _ty, "Armor (HP) " + string(_p.synth_armor_hp) + "     Pwr Fisica " + string(_p.synth_pwr_fisica) + "     Pwr Magica " + string(_p.synth_pwr_magica));
    _ty += 22;
    draw_text(_lx, _ty, "Def Fisica " + string(_p.synth_def_fisica) + "     Def Magica " + string(_p.synth_def_magica));
    _ty += 34;

    draw_text(_lx, _ty, "Talentos desta run  (pontos disponiveis: " + string(_p.talent_pending_points) + ")");
    _ty += 26;
    for (var _i = 0; _i < array_length(_p.talent_slot_ids); _i++) {
        var _id = _p.talent_slot_ids[_i];
        var _line = string(_i + 1) + " - ";
        if (_id == "") {
            _line += "(vazio)";
        } else {
            var _def = get_talent_def_by_id(_id);
            var _label = is_undefined(_def) ? _id : _def.label;
            _line += _label + "  (rank " + string(_p.talent_slot_ranks[_i]) + ")";
            if (_p.talent_pending_points > 0) _line += "   [aperte " + string(_i + 1) + "]";
        }
        draw_text(_lx, _ty, _line);
        _ty += 22;
    }

    draw_set_halign(fa_left);
} else if (global.paused) {
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _cx2 = display_get_gui_width() / 2;
    var _cy2 = display_get_gui_height() / 2;
    draw_text(_cx2, _cy2 - 50, "PAUSADO");
    draw_text(_cx2, _cy2 - 10, "ESC - Continuar");
    draw_text(_cx2, _cy2 + 20, "M - Menu Principal");
    draw_text(_cx2, _cy2 + 50, "Q - Sair do Jogo");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
