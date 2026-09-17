var _p = instance_find(obj_player, 0);
var _is_active = (instance_exists(_p) && _p.character_class == target_class);

// Sombra do pedestal
draw_set_alpha(0.3);
draw_set_colour(c_black);
draw_ellipse(x - 36, y - 16, x + 36, y + 16, false);

// Base de pedra
draw_set_alpha(1.0);
draw_set_colour(make_colour_rgb(38, 42, 50));
draw_roundrect(x - 30, y - 18, x + 30, y + 18, false);

// Anel de status
if (_is_active) {
    var _glow = 32 + sin(pulse_timer * 3) * 3;
    draw_set_alpha(0.4);
    draw_set_colour(class_color);
    draw_circle(x, y, _glow, false);
    
    draw_set_alpha(1.0);
    draw_set_colour(make_colour_rgb(255, 220, 100));
    draw_circle(x, y, 28, true);
    draw_circle(x, y, 29, true);
} else {
    draw_set_alpha(0.7);
    draw_set_colour(class_color);
    draw_circle(x, y, 26, true);
}

// Orbe flutuante do símbolo da classe
var _float_y = y - 36 + sin(pulse_timer * 2) * 5;

draw_set_alpha(0.35);
draw_set_colour(class_color);
draw_circle(x, _float_y, 16, false);

draw_set_alpha(1.0);
draw_set_colour(class_color);
draw_circle(x, _float_y, 12, false);
draw_set_colour(c_white);
draw_circle(x, _float_y, 5, false);

// Texto da Classe acima do pedestal
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_regular);

if (_is_active) {
    draw_set_colour(make_colour_rgb(100, 255, 140));
    draw_text(x, _float_y - 20, "[EM USO]");
    draw_set_colour(c_white);
    draw_text(x, _float_y - 36, class_label);
} else {
    draw_set_colour(c_ltgray);
    draw_text(x, _float_y - 20, class_label);
}

// Balão de interação
if (is_near && !_is_active) {
    var _by = y - 82 + sin(pulse_timer * 3) * 3;
    var _text = "[E] Escolher " + class_label;
    var _tw = string_width(_text) + 20;
    var _th = 26;
    
    draw_set_alpha(0.9);
    draw_set_colour(make_colour_rgb(18, 20, 26));
    draw_roundrect(x - _tw / 2, _by - _th / 2, x + _tw / 2, _by + _th / 2, false);
    
    draw_set_alpha(1.0);
    draw_set_colour(class_color);
    draw_roundrect(x - _tw / 2, _by - _th / 2, x + _tw / 2, _by + _th / 2, true);
    
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(x, _by, _text);
}
