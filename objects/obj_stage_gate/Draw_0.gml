var _ready = false;
if (trigger_mode == "boss_dead") {
    _ready = (instance_number(obj_boss) == 0 && instance_number(obj_boss2) == 0);
} else if (trigger_mode == "clear_mobs") {
    _ready = (instance_number(obj_enemy_parent) == 0);
} else {
    _ready = (global.boss_buttons_pressed >= 4);
}

// Círculo base do portal
draw_set_alpha(_ready ? (0.55 + 0.25 * sin(current_time / 70)) : 0.15);
draw_set_color(_ready ? gate_colour : c_dkgray);
draw_circle(x, y, radius, false);

// Anéis mágicos giratórios
if (_ready) {
    draw_set_alpha(0.40);
    draw_set_color(c_white);
    var _rot = current_time / 50;
    for (var _a = 0; _a < 3; _a++) {
        var _ang = _rot + _a * 120;
        var _rx = x + lengthdir_x(radius * 0.55, _ang);
        var _ry = y + lengthdir_y(radius * 0.55, _ang);
        draw_circle(_rx, _ry, 4, false);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_circle(x, y, radius, true);

// Brasão / Ícone flutuante estilo Hades acima do portal
var _float_y = y - radius - 24 + 4 * sin(current_time / 100);

if (_ready) {
    // Plaqueta de recompensa
    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(15, 20, 32));
    var _bw = string_width(gate_label) + 24;
    var _bh = 22;
    draw_rectangle(x - _bw * 0.5, _float_y - _bh * 0.5, x + _bw * 0.5, _float_y + _bh * 0.5, false);
    draw_set_alpha(1);

    draw_set_color(gate_colour);
    draw_rectangle(x - _bw * 0.5, _float_y - _bh * 0.5, x + _bw * 0.5, _float_y + _bh * 0.5, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(gate_colour);
    draw_text(x, _float_y, gate_label);
} else {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(make_colour_rgb(180, 190, 205));
    var _msg = (trigger_mode == "boss_dead") ? "Derrote o General para abrir" : ((trigger_mode == "clear_mobs") ? "Elimine os monstros para abrir" : "Ative os 4 botoes selados (" + string(global.boss_buttons_pressed) + "/4)");
    draw_text(x, y - radius - 12, _msg);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
