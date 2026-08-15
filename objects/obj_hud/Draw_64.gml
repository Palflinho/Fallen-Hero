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
    if (_boss != noone) {
        var _bw = 500;
        var _bh = 26;
        var _bx = display_get_gui_width() / 2 - _bw / 2;
        var _by = 24;

        draw_set_color(c_black);
        draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + _bh + 2, false);
        draw_set_color(_boss.vulnerable ? c_lime : c_maroon);
        draw_rectangle(_bx, _by, _bx + _bw * (_boss.hp / _boss.hp_max), _by + _bh, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bx + _bw / 2, _by + _bh / 2, _boss.vulnerable ? "GUARDIAO DAS AGUAS - VULNERAVEL!" : "GUARDIAO DAS AGUAS");
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
} else if (global.paused) {
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() / 2;
    draw_text(_cx, _cy - 50, "PAUSADO");
    draw_text(_cx, _cy - 10, "ESC - Continuar");
    draw_text(_cx, _cy + 20, "M - Menu Principal");
    draw_text(_cx, _cy + 50, "Q - Sair do Jogo");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
