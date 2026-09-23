if (!active) exit;

var _w = base_size * image_xscale;
var _h = base_size * image_yscale;
var _cx = x + _w * 0.5;
var _cy = y + _h * 0.5;
var _rx = _w * 0.5;
var _ry = _h * 0.5;

// Lama movediça escura (Causa lentidão severa de 55% e impede dash)
draw_set_alpha(0.65);
draw_set_color(make_colour_rgb(70, 48, 28));
draw_ellipse(_cx - _rx, _cy - _ry, _cx + _rx, _cy + _ry, false);

// Camada viscosa de textura
draw_set_alpha(0.45);
draw_set_color(make_colour_rgb(95, 68, 40));
draw_ellipse(_cx - _rx * 0.72, _cy - _ry * 0.72, _cx + _rx * 0.72, _cy + _ry * 0.72, false);

// Bolhas de lodo ocasionais
var _bub = abs(sin((current_time + bubble_phase) * 0.003));
if (_bub > 0.4) {
    draw_set_alpha(0.6 * _bub);
    draw_set_color(make_colour_rgb(120, 90, 55));
    draw_circle(_cx + _rx * 0.3 * sin(current_time * 0.002), _cy + _ry * 0.3 * cos(current_time * 0.002), 4 * _bub, false);
}

// Contorno irregular de terra
draw_set_alpha(0.85);
draw_set_color(make_colour_rgb(45, 30, 16));
draw_ellipse(_cx - _rx, _cy - _ry, _cx + _rx, _cy + _ry, true);

draw_set_alpha(1.0);
draw_set_color(c_white);