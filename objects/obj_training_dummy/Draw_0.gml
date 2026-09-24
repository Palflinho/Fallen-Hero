var _flash = (hit_flash_timer > 0);
var _wood = make_colour_rgb(120, 80, 45);
var _straw = _flash ? c_white : make_colour_rgb(215, 180, 110);

// Area de perigo durante o aviso do golpe
if (mode == "attacker" && swing_state == "windup") {
    var _k = 1 - (swing_timer / swing_windup);
    draw_set_alpha(0.12 + 0.2 * _k);
    draw_set_color(c_red);
    draw_circle(x, y, swing_radius * (0.4 + 0.6 * _k), false);
    draw_set_alpha(0.6);
    draw_circle(x, y, swing_radius, true);
    draw_set_alpha(1);
}

// Sombra
draw_set_alpha(0.3);
draw_set_color(c_black);
draw_ellipse(x - 14, y + 10, x + 14, y + 18, false);
draw_set_alpha(1);

// Poste
draw_set_color(_wood);
draw_rectangle(x - 3, y - 6, x + 3, y + 14, false);

// Bracos (giram no golpe do boneco atacante)
var _ax = lengthdir_x(18, swing_angle);
var _ay = lengthdir_y(18, swing_angle);
draw_set_color(_wood);
draw_line_width(x - _ax, y - 16 - _ay, x + _ax, y - 16 + _ay, 4);
if (mode == "attacker") {
    // Espada de madeira na ponta do braco
    var _sx = x + _ax;
    var _sy = y - 16 + _ay;
    draw_set_color(make_colour_rgb(170, 130, 80));
    draw_line_width(_sx, _sy, _sx + lengthdir_x(16, swing_angle - 90), _sy + lengthdir_y(16, swing_angle - 90), 3);
}

// Corpo de palha com alvo
draw_set_color(_straw);
draw_circle(x, y - 16, 12 * scale_x, false);
draw_set_color(make_colour_rgb(190, 50, 45));
draw_circle(x, y - 16, 8 * scale_x, true);
draw_circle(x, y - 16, 3, false);

// Cabeca
draw_set_color(_straw);
draw_circle(x, y - 34, 7, false);
draw_set_color(make_colour_rgb(60, 40, 25));
draw_circle(x - 3, y - 35, 1.2, false);
draw_circle(x + 3, y - 35, 1.2, false);
if (mode == "attacker" && swing_state == "windup") {
    draw_set_color(c_red);
    draw_text_transformed(x - 3, y - 64, "!", 1.4, 1.4, 0);
}

// Dica com o botao da entrada atual (mais forte quando o jogador esta perto)
var _pl = instance_find(obj_player, 0);
var _alpha = 0;
if (_pl != noone) {
    var _d = point_distance(x, y, _pl.x, _pl.y);
    _alpha = clamp(1 - (_d - 140) / 160, 0, 1);
}
if (mode == "attacker") {
    tutorial_draw_key_hint(x, y - 84, "defend", tr("Defender / Esquivar"), _alpha);
    if (result_timer > 0 && !result_ok) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(min(1, result_timer));
        draw_set_color(make_colour_rgb(255, 170, 90));
        draw_text(x, y + 30, tr("Use a defesa quando ele ficar vermelho!"));
        draw_set_alpha(1);
    }
} else {
    tutorial_draw_key_hint(x, y - 70, "attack", tr("Atacar"), _alpha);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
