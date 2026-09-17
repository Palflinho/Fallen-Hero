// Sombra e base de pedra do portal
draw_set_alpha(0.4);
draw_set_colour(c_black);
draw_ellipse(x - 50, y - 18, x + 50, y + 18, false);

// Pilares de pedra do portal
draw_set_alpha(1.0);
draw_set_colour(make_colour_rgb(50, 54, 65));
draw_roundrect(x - 44, y - 70, x - 30, y + 5, false);
draw_roundrect(x + 30, y - 70, x + 44, y + 5, false);

// Arco superior
draw_roundrect(x - 46, y - 80, x + 46, y - 65, false);

// Vórtice de energia elemental pulsante
var _v_r = 30 + sin(pulse_timer * 3) * 4;

draw_set_alpha(0.35);
draw_set_colour(make_colour_rgb(100, 180, 255));
draw_circle(x, y - 36, _v_r + 6, false);

draw_set_alpha(0.8);
draw_set_colour(make_colour_rgb(140, 220, 255));
draw_circle(x, y - 36, _v_r, false);

draw_set_alpha(1.0);
draw_set_colour(c_white);
draw_circle(x, y - 36, _v_r * 0.45, false);

// Anéis de partículas que giram
for (var i = 0; i < 3; i++) {
    var _a = pulse_timer * 40 + i * 120;
    var _px = x + lengthdir_x(_v_r * 0.75, _a);
    var _py = (y - 36) + lengthdir_y(_v_r * 0.75, _a);
    draw_set_colour(make_colour_rgb(255, 235, 120));
    draw_circle(_px, _py, 4, false);
}

// Rótulo do Portal
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_regular);
draw_set_colour(make_colour_rgb(200, 230, 255));
draw_text(x, y - 88, "Portal Dimensional");

// Balão de interação flutuante
if (is_near && !transitioning) {
    var _by = y - 110 + sin(pulse_timer * 2.5) * 3;
    var _text = "[E] Iniciar Expedicao na Masmorra";
    var _tw = string_width(_text) + 24;
    var _th = 28;
    
    draw_set_alpha(0.9);
    draw_set_colour(make_colour_rgb(15, 18, 25));
    draw_roundrect(x - _tw / 2, _by - _th / 2, x + _tw / 2, _by + _th / 2, false);
    
    draw_set_alpha(1.0);
    draw_set_colour(make_colour_rgb(120, 210, 255));
    draw_roundrect(x - _tw / 2, _by - _th / 2, x + _tw / 2, _by + _th / 2, true);
    
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(x, _by, _text);
}
