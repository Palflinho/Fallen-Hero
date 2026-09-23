if (!active) exit;

var _w = base_size * image_xscale;
var _h = base_size * image_yscale;
var _cx = x + _w * 0.5;
var _cy = y + _h * 0.5;
var _rx = _w * 0.5;
var _ry = _h * 0.5;

// Poça d'água com ondulações dinâmicas (Feedback Lele: Causa lentidão de 40%)
draw_set_alpha(0.38 + 0.08 * sin((current_time + ripple_phase) * 0.003));
draw_set_color(make_colour_rgb(30, 110, 195));
draw_ellipse(_cx - _rx, _cy - _ry, _cx + _rx, _cy + _ry, false);

// Ondulação interna sutil
var _rip = abs(sin((current_time + ripple_phase) * 0.004));
draw_set_alpha(0.25 * (1 - _rip));
draw_set_color(make_colour_rgb(140, 220, 255));
draw_ellipse(_cx - _rx * _rip, _cy - _ry * _rip, _cx + _rx * _rip, _cy + _ry * _rip, true);

// Contorno aquoso cristalino
draw_set_alpha(0.65);
draw_set_color(make_colour_rgb(70, 165, 245));
draw_ellipse(_cx - _rx, _cy - _ry, _cx + _rx, _cy + _ry, true);

draw_set_alpha(1.0);
draw_set_color(c_white);