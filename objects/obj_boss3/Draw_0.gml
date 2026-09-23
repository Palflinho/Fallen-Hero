var _by = y - draw_z;

// 0. Vendaval (fase 3): riscos de vento atravessando a tela na direcao do empurrao
if (gust_active > 0) {
    var _pl = instance_find(obj_player, 0);
    if (_pl != noone) {
        draw_set_alpha(0.35);
        draw_set_color(c_white);
        for (var _g = 0; _g < 10; _g++) {
            var _off = ((current_time * 0.6 + _g * 97) mod 600) - 300;
            var _side = (_g - 5) * 40;
            var _gx = _pl.x + lengthdir_x(_off, gust_dir) + lengthdir_x(_side, gust_dir + 90);
            var _gy = _pl.y + lengthdir_y(_off, gust_dir) + lengthdir_y(_side, gust_dir + 90);
            draw_line_width(_gx, _gy, _gx + lengthdir_x(40, gust_dir), _gy + lengthdir_y(40, gust_dir), 2);
        }
        draw_set_alpha(1);
    }
}

// 1. Marca do mergulho (circulo = area) e sombra no chao
if (state == "dive_mark" || state == "dive") {
    var _k = (state == "dive") ? 1 : clamp(1 - state_timer / 1.1, 0, 1);
    var _locked = (state == "dive" || state_timer <= 0.5);
    elem_draw_warning_circle(dive_x, dive_y, dive_radius, _k, _locked ? c_red : c_white);
}
var _sh = clamp(1 - draw_z / 160, 0.35, 1);
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(x - body_radius * _sh, y + body_radius * 0.5 - 8 * _sh, x + body_radius * _sh, y + body_radius * 0.5 + 8 * _sh, false);
draw_set_alpha(1);

// 2. Aura
if (vulnerable) {
    var _pulse = 0.5 + 0.5 * sin(current_time * 0.015);
    draw_set_alpha(0.3 + 0.2 * _pulse);
    draw_set_color(c_lime);
    draw_circle(x, _by, (body_radius + 18) * scale_x, false);
    draw_set_alpha(0.8);
    draw_circle(x, _by, (body_radius + 18) * scale_x, true);
} else {
    draw_set_alpha((fh_untargetable ? 0.15 : 0.25) + 0.1 * sin(current_time / 60));
    draw_set_color(make_colour_rgb(180, 240, 255));
    draw_circle(x, _by, body_radius + 14, false);
}

// 3. Asas giratorias de vento (cravadas no chao quando presas)
draw_set_alpha(vulnerable ? 0.35 : 0.65);
draw_set_color(vulnerable ? c_lime : c_white);
for (var _a = 0; _a < 4; _a++) {
    var _ang = rot_angle + _a * 90;
    var _wx = x + lengthdir_x(body_radius + 8, _ang);
    var _wy = _by + lengthdir_y(body_radius + 8, _ang);
    draw_line_width(x, _by, _wx, _wy, 4);
    draw_circle(_wx, _wy, 6, false);
}

// 4. Corpo principal (translucido no ar: intangivel)
draw_set_alpha(fh_untargetable ? 0.6 : 1);
draw_set_color(hit_flash_timer > 0 ? c_white : body_colour);
draw_circle(x, _by, body_radius * scale_x, false);
draw_set_color(vulnerable ? c_green : make_colour_rgb(60, 140, 200));
draw_circle(x, _by, body_radius * scale_x, true);
draw_circle(x, _by, body_radius * scale_x - 3, true);
draw_set_alpha(1);

// 5. Olhos
if (vulnerable) {
    draw_set_color(c_yellow);
    draw_line_width(x - 14, _by - 12, x - 6, _by - 4, 2);
    draw_line_width(x - 14, _by - 4, x - 6, _by - 12, 2);
    draw_line_width(x + 6, _by - 12, x + 14, _by - 4, 2);
    draw_line_width(x + 6, _by - 4, x + 14, _by - 12, 2);
    for (var _s = 0; _s < 3; _s++) {
        var _sang = current_time * 0.005 + _s * (2 * pi / 3);
        draw_set_color(c_yellow);
        draw_circle(x + cos(_sang) * 26, _by - body_radius - 12 + sin(_sang) * 8, 3.5, false);
    }
} else {
    draw_set_color(c_yellow);
    draw_circle(x - 10, _by - 8, 4, false);
    draw_circle(x + 10, _by - 8, 4, false);
}

if (fh_untargetable && fh_air_hits > 0) {
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(x, _by + body_radius + 8, tr("PENAS ") + string(fh_air_hits) + "/5");
    draw_set_halign(fa_left);
}
var _hint = tr("ASAS PRESAS! ATAQUE!");
var _name = fh_untargetable ? tr("Zephyrus (no ar - intangivel)") : tr("General Zephyrus");
boss_draw_label(_name, _hint);
draw_set_color(c_white);
