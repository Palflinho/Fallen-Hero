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
draw_text(_x + 4, _y + 1, "HP " + string(max(0, round(target.hp))) + "/" + string(target.hp_max));

_y += bar_h + bar_gap;

// Stamina
draw_set_color(c_black);
draw_rectangle(_x - 2, _y - 2, _x + bar_w + 2, _y + bar_h + 2, false);
draw_set_color(c_orange);
draw_rectangle(_x, _y, _x + bar_w * (target.stamina / target.stamina_max), _y + bar_h, false);
draw_set_color(c_white);
draw_text(_x + 4, _y + 1, "STA " + string(max(0, round(target.stamina))) + "/" + string(target.stamina_max));

_y += bar_h + bar_gap;

// Mana (only characters that use mana)
if (target.mana_max > 0) {
    draw_set_color(c_black);
    draw_rectangle(_x - 2, _y - 2, _x + bar_w + 2, _y + bar_h + 2, false);
    draw_set_color(c_blue);
    draw_rectangle(_x, _y, _x + bar_w * (target.mana / target.mana_max), _y + bar_h, false);
    draw_set_color(c_white);
    draw_text(_x + 4, _y + 1, "MP " + string(max(0, round(target.mana))) + "/" + string(target.mana_max));
}

// Low HP red vignette
if (target.hp / target.hp_max <= 0.3) {
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}

draw_set_color(c_white);

if (level_complete) {
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
}
