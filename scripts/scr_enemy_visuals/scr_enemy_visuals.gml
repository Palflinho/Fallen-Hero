// =========================================================================
// MODELOS PROCEDURAIS DOS INIMIGOS (mesmo estilo chibi dos herois)
// =========================================================================
// Regra visual (Miyamoto): a FORMA diz a funcao, a COR diz o elemento.
//   Slime      = gota/bolha que pula (corpo a corpo)
//   Elemental  = nucleo flutuante (atira a distancia)
//   Conjurador = figura de tunica com cajado (magia em area)
//   Golem      = bloco pesado com bracos (mini-chefe)
//   Espiritos  = silhuetas unicas (chefes das arenas)
// Cada familia tem uma paleta propria dentro do elemento, para que os
// inimigos do mesmo templo nao se confundam (ex.: agua = oceano / turquesa /
// indigo / gelo).
// Chamado pelo Draw de obj_enemy_parent no escopo da propria instancia.
// Arte final pode substituir tudo isso via sprite_index.
// =========================================================================

function enemy_visual_kind() {
    switch (object_index) {
        case obj_slime:             return { family: "slime", elem: "water" };
        case obj_fire_slime:        return { family: "slime", elem: "fire" };
        case obj_wind_slime:        return { family: "slime", elem: "wind" };
        case obj_earth_slime:       return { family: "slime", elem: "earth" };
        case obj_elemental:         return { family: "elemental", elem: "water" };
        case obj_fire_elemental:    return { family: "elemental", elem: "fire" };
        case obj_wind_elemental:    return { family: "elemental", elem: "wind" };
        case obj_earth_elemental:   return { family: "elemental", elem: "earth" };
        case obj_frost_caster:      return { family: "caster", elem: "water" };
        case obj_magma_caster:      return { family: "caster", elem: "fire" };
        case obj_wind_caster:       return { family: "caster", elem: "wind" };
        case obj_earth_caster:      return { family: "caster", elem: "earth" };
        case obj_ice_golem:
            var _et = variable_instance_exists(id, "element_type") ? element_type : "water";
            return { family: "golem", elem: _et };
        case obj_lava_golem:        return { family: "golem", elem: "fire" };
        case obj_storm_golem:       return { family: "golem", elem: "wind" };
        case obj_stone_golem:       return { family: "golem", elem: "earth" };
        case obj_spirit_ondina:     return { family: "ondina", elem: "water" };
        case obj_spirit_salamandra: return { family: "salamandra", elem: "fire" };
        case obj_spirit_silfide:    return { family: "silfide", elem: "wind" };
        case obj_spirit_gnomo:      return { family: "gnomo", elem: "earth" };
    }
    return { family: "", elem: "" };
}

// Paleta [principal, escura, clara, destaque] por familia + elemento
function enemy_visual_palette(_family, _elem) {
    if (_elem == "water") {
        switch (_family) {
            case "slime":     return [make_colour_rgb(45, 115, 225), make_colour_rgb(20, 55, 130), make_colour_rgb(150, 200, 255), make_colour_rgb(230, 245, 255)];
            case "elemental": return [make_colour_rgb(40, 200, 185), make_colour_rgb(15, 105, 105), make_colour_rgb(170, 250, 240), c_white];
            case "caster":    return [make_colour_rgb(70, 55, 150), make_colour_rgb(35, 25, 80), make_colour_rgb(200, 235, 255), make_colour_rgb(150, 235, 255)];
            case "golem":     return [make_colour_rgb(200, 232, 250), make_colour_rgb(105, 145, 185), c_white, make_colour_rgb(110, 205, 255)];
            case "ondina":    return [make_colour_rgb(80, 200, 235), make_colour_rgb(30, 90, 170), make_colour_rgb(200, 245, 255), make_colour_rgb(255, 255, 255)];
        }
    } else if (_elem == "fire") {
        switch (_family) {
            case "slime":      return [make_colour_rgb(255, 125, 40), make_colour_rgb(150, 45, 15), make_colour_rgb(255, 210, 120), c_yellow];
            case "elemental":  return [make_colour_rgb(235, 60, 35), make_colour_rgb(120, 15, 10), make_colour_rgb(255, 170, 60), make_colour_rgb(255, 235, 110)];
            case "caster":     return [make_colour_rgb(115, 25, 30), make_colour_rgb(55, 10, 15), make_colour_rgb(230, 120, 50), make_colour_rgb(255, 200, 60)];
            case "golem":      return [make_colour_rgb(80, 42, 35), make_colour_rgb(35, 18, 15), make_colour_rgb(140, 80, 60), make_colour_rgb(255, 130, 30)];
            case "salamandra": return [make_colour_rgb(235, 90, 30), make_colour_rgb(110, 25, 10), make_colour_rgb(255, 190, 80), c_yellow];
        }
    } else if (_elem == "wind") {
        switch (_family) {
            case "slime":     return [make_colour_rgb(185, 240, 250), make_colour_rgb(95, 155, 175), c_white, make_colour_rgb(140, 225, 255)];
            case "elemental": return [make_colour_rgb(220, 250, 255), make_colour_rgb(110, 170, 195), c_white, make_colour_rgb(160, 255, 220)];
            case "caster":    return [make_colour_rgb(225, 240, 235), make_colour_rgb(85, 150, 150), c_white, make_colour_rgb(120, 230, 210)];
            case "golem":     return [make_colour_rgb(150, 165, 190), make_colour_rgb(65, 75, 100), make_colour_rgb(230, 240, 255), make_colour_rgb(255, 240, 120)];
            case "silfide":   return [make_colour_rgb(210, 255, 240), make_colour_rgb(90, 170, 150), c_white, make_colour_rgb(170, 255, 200)];
        }
    } else if (_elem == "earth") {
        switch (_family) {
            case "slime":     return [make_colour_rgb(140, 105, 65), make_colour_rgb(70, 50, 30), make_colour_rgb(200, 165, 110), make_colour_rgb(120, 170, 70)];
            case "elemental": return [make_colour_rgb(150, 118, 82), make_colour_rgb(75, 58, 40), make_colour_rgb(210, 180, 130), make_colour_rgb(255, 190, 80)];
            case "caster":    return [make_colour_rgb(95, 110, 55), make_colour_rgb(45, 55, 25), make_colour_rgb(200, 170, 110), make_colour_rgb(150, 220, 90)];
            case "golem":     return [make_colour_rgb(125, 105, 85), make_colour_rgb(60, 50, 40), make_colour_rgb(175, 155, 130), make_colour_rgb(120, 175, 70)];
            case "gnomo":     return [make_colour_rgb(150, 110, 70), make_colour_rgb(70, 50, 30), make_colour_rgb(235, 225, 210), make_colour_rgb(80, 150, 70)];
        }
    }
    return [c_gray, c_dkgray, c_white, c_red];
}

// Olhos de monstro: esclera clara com pupila vermelha olhando para a frente
function enemy_draw_eyes(_x, _y, _fh, _gap, _size) {
    draw_set_colour(c_white);
    draw_circle(_x - _gap, _y, _size, false);
    draw_circle(_x + _gap, _y, _size, false);
    draw_set_colour(make_colour_rgb(200, 20, 30));
    draw_circle(_x - _gap + _fh * _size * 0.35, _y + 0.5, _size * 0.55, false);
    draw_circle(_x + _gap + _fh * _size * 0.35, _y + 0.5, _size * 0.55, false);
}

// Olhos brilhantes (seres de energia, conjuradores, golens)
function enemy_draw_glow_eyes(_x, _y, _fh, _gap, _w, _col) {
    draw_set_colour(_col);
    draw_ellipse(_x - _gap - _w + _fh, _y - _w * 0.45, _x - _gap + _w + _fh, _y + _w * 0.45, false);
    draw_ellipse(_x + _gap - _w + _fh, _y - _w * 0.45, _x + _gap + _w + _fh, _y + _w * 0.45, false);
}

// Retorna true se desenhou o corpo (senao o Draw base usa o retangulo antigo)
function enemy_draw_body() {
    var _k = enemy_visual_kind();
    if (_k.family == "") return false;

    var _pal = enemy_visual_palette(_k.family, _k.elem);
    var _main = _pal[0];
    var _dark = _pal[1];
    var _light = _pal[2];
    var _acc = _pal[3];

    // Estados: preparando golpe = brilha; envenenado = esverdeado; atingido = branco
    var _warn = (string_pos("windup", state) > 0 || string_pos("_warn", state) > 0 || state == "cast" || state == "channel");
    if (_warn) _main = merge_colour(_main, c_white, 0.30 + 0.20 * sin(current_time * 0.03));
    if (state == "swell") _main = body_colour; // Slime de Fogo piscando antes de explodir
    if (poison_active) _main = merge_colour(_main, c_lime, 0.35);
    if (hit_flash_timer > 0) {
        _main = c_white;
        _light = c_white;
    }

    var _a = draw_alpha;
    var _seed = variable_instance_exists(id, "anim_seed") ? anim_seed : 0;
    var _t = current_time * 0.001 + _seed * 0.37;
    var _fh = variable_instance_exists(id, "facing_h") ? facing_h : 1;
    var _r = body_radius;
    var _x = x;
    var _y = y - draw_z;
    var _moving = (x != xprevious || y != yprevious);

    draw_set_alpha(_a);
    switch (_k.family) {
        case "slime":      enemy_draw_slime(_x, _y, _r, _fh, _t, _k.elem, _main, _dark, _light, _acc, _a); break;
        case "elemental":  enemy_draw_elemental(_x, _y, _r, _fh, _t, _k.elem, _main, _dark, _light, _acc, _a); break;
        case "caster":     enemy_draw_caster(_x, _y, _r, _fh, _t, _k.elem, _main, _dark, _light, _acc, _a, _moving); break;
        case "golem":      enemy_draw_golem(_x, _y, _r, _fh, _t, _k.elem, _main, _dark, _light, _acc, _a, _moving); break;
        case "ondina":     enemy_draw_ondina(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a); break;
        case "salamandra": enemy_draw_salamandra_head(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a); break;
        case "silfide":    enemy_draw_silfide(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a); break;
        case "gnomo":      enemy_draw_gnomo(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a, _moving); break;
    }
    draw_set_alpha(1);
    draw_set_colour(c_white);
    return true;
}

// -------------------------------------------------------------------------
// SLIME: bolha gelatinosa com detalhe do elemento
// -------------------------------------------------------------------------
function enemy_draw_slime(_x, _y, _r, _fh, _t, _elem, _main, _dark, _light, _acc, _a) {
    var _w = _r * scale_x * 1.1;
    var _h = _r * scale_y;
    var _top = _y - _h * 1.05;
    var _bot = _y + _h * 0.8;

    // Asinhas do slime de vento (atras do corpo)
    if (_elem == "wind") {
        var _flap = 4 * sin(_t * 18);
        draw_set_colour(_light);
        draw_set_alpha(0.8 * _a);
        draw_ellipse(_x - _w - 9, _y - _h * 0.6 - _flap, _x - _w + 3, _y - _h * 0.1, false);
        draw_ellipse(_x + _w - 3, _y - _h * 0.6 - _flap, _x + _w + 9, _y - _h * 0.1, false);
        draw_set_alpha(_a);
    }

    // Corpo com contorno
    draw_set_colour(_dark);
    draw_ellipse(_x - _w - 1.5, _top - 1.5, _x + _w + 1.5, _bot + 1.5, false);
    draw_set_colour(_main);
    draw_ellipse(_x - _w, _top, _x + _w, _bot, false);
    draw_set_colour(merge_colour(_main, _dark, 0.35));
    draw_ellipse(_x - _w * 0.9, _y + _h * 0.15, _x + _w * 0.9, _bot, false);
    // Brilho gelatinoso
    draw_set_colour(_light);
    draw_ellipse(_x - _w * 0.62, _top + _h * 0.22, _x - _w * 0.15, _top + _h * 0.6, false);

    switch (_elem) {
        case "water":
            // Gota escorrendo e bolha interna
            var _drip = (_t * 18) mod 10;
            draw_set_alpha(_a * (1 - _drip / 10));
            draw_set_colour(_main);
            draw_circle(_x + _fh * _w * 0.7, _bot - 2 + _drip, 2, false);
            draw_set_alpha(_a);
            draw_set_colour(_light);
            draw_circle(_x + _w * 0.35, _y + _h * 0.2, 2.5, true);
            break;
        case "fire":
            // Chamas no topo
            for (var _i = -1; _i <= 1; _i++) {
                var _fx = _x + _i * _w * 0.45;
                var _fl = 6 + 4 * sin(_t * 12 + _i * 2);
                draw_set_colour(_acc);
                draw_triangle(_fx - 4, _top + 3, _fx + 4, _top + 3, _fx, _top - _fl, false);
                draw_set_colour(_light);
                draw_triangle(_fx - 2, _top + 3, _fx + 2, _top + 3, _fx, _top - _fl * 0.5, false);
            }
            break;
        case "wind":
            // Redemoinho no topo
            draw_set_colour(_acc);
            var _sa = _t * 400;
            for (var _s = 0; _s < 3; _s++) {
                var _ang = _sa + _s * 120;
                draw_line_width(_x + lengthdir_x(3, _ang), _top - 2 + lengthdir_y(2, _ang), _x + lengthdir_x(8, _ang + 40), _top - 2 + lengthdir_y(3, _ang + 40), 1.5);
            }
            break;
        case "earth":
            // Placas de pedra e musgo
            draw_set_colour(_dark);
            draw_triangle(_x - _w * 0.6, _top + 5, _x - _w * 0.2, _top + 5, _x - _w * 0.4, _top - 3, false);
            draw_triangle(_x - _w * 0.1, _top + 4, _x + _w * 0.35, _top + 4, _x + _w * 0.12, _top - 5, false);
            draw_triangle(_x + _w * 0.35, _top + 6, _x + _w * 0.7, _top + 6, _x + _w * 0.55, _top - 1, false);
            draw_set_colour(_acc);
            draw_circle(_x + _w * 0.2, _top + 4, 2, false);
            break;
    }

    // Rosto
    var _ey = _y - _h * 0.25;
    enemy_draw_eyes(_x + _fh * _w * 0.2, _ey, _fh, max(3, _w * 0.3), max(1.8, _r * 0.18));
    draw_set_colour(_dark);
    draw_line_width(_x + _fh * _w * 0.2 - 3, _ey + _h * 0.35, _x + _fh * _w * 0.2 + 3, _ey + _h * 0.35, 1.5);
}

// -------------------------------------------------------------------------
// ELEMENTAL: nucleo flutuante que atira (forma varia por elemento)
// -------------------------------------------------------------------------
function enemy_draw_elemental(_x, _y, _r, _fh, _t, _elem, _main, _dark, _light, _acc, _a) {
    var _cy = _y - 5 + sin(_t * 3) * 3;
    var _s = _r * max(scale_x, scale_y);

    switch (_elem) {
        case "water":
            // Gota de agua viva com bolhas orbitando
            draw_set_colour(_dark);
            draw_circle(_x, _cy + 2, _s * 0.82 + 1.5, false);
            draw_triangle(_x - _s * 0.72, _cy - 1, _x + _s * 0.72, _cy - 1, _x, _cy - _s * 1.5, false);
            draw_set_colour(_main);
            draw_circle(_x, _cy + 2, _s * 0.8, false);
            draw_triangle(_x - _s * 0.66, _cy, _x + _s * 0.66, _cy, _x, _cy - _s * 1.38, false);
            draw_set_colour(_light);
            draw_ellipse(_x - _s * 0.45, _cy - _s * 0.4, _x - _s * 0.1, _cy + _s * 0.1, false);
            for (var _b = 0; _b < 3; _b++) {
                var _ba = _t * 90 + _b * 120;
                draw_circle(_x + lengthdir_x(_s * 1.15, _ba), _cy + lengthdir_y(_s * 0.6, _ba), 2, true);
            }
            break;
        case "fire":
            // Chama viva em camadas
            var _f1 = _s * (1.5 + 0.15 * sin(_t * 14));
            draw_set_colour(_dark);
            draw_triangle(_x - _s - 1, _cy + _s * 0.7, _x + _s + 1, _cy + _s * 0.7, _x, _cy - _f1 - 2, false);
            draw_set_colour(_main);
            draw_triangle(_x - _s, _cy + _s * 0.7, _x + _s, _cy + _s * 0.7, _x, _cy - _f1, false);
            draw_circle(_x, _cy + _s * 0.3, _s * 0.8, false);
            draw_set_colour(_light);
            draw_triangle(_x - _s * 0.55, _cy + _s * 0.5, _x + _s * 0.55, _cy + _s * 0.5, _x + _fh * 2, _cy - _f1 * 0.6, false);
            draw_set_colour(_acc);
            draw_circle(_x, _cy + _s * 0.3, _s * 0.35, false);
            break;
        case "wind":
            // Nucleo de ar com laminas girando
            var _rot = variable_instance_exists(id, "anim_rot") ? anim_rot : _t * 240;
            draw_set_colour(_dark);
            draw_circle(_x, _cy, _s * 0.55 + 1.5, false);
            draw_set_colour(_main);
            draw_circle(_x, _cy, _s * 0.55, false);
            draw_set_colour(_light);
            for (var _l = 0; _l < 3; _l++) {
                var _la = _rot + _l * 120;
                draw_line_width(_x + lengthdir_x(_s * 0.6, _la), _cy + lengthdir_y(_s * 0.6, _la), _x + lengthdir_x(_s * 1.25, _la + 45), _cy + lengthdir_y(_s * 1.25, _la + 45), 3);
            }
            draw_set_colour(_acc);
            draw_circle(_x, _cy, _s * 0.22, false);
            break;
        case "earth":
            // Nucleo incandescente com rochas orbitando
            draw_set_colour(_dark);
            draw_circle(_x, _cy, _s * 0.6 + 1.5, false);
            draw_set_colour(_main);
            draw_circle(_x, _cy, _s * 0.6, false);
            draw_set_colour(_acc);
            draw_circle(_x, _cy, _s * 0.28 + 1.5 * sin(_t * 5), false);
            for (var _o = 0; _o < 4; _o++) {
                var _oa = _t * 70 + _o * 90;
                var _ox = _x + lengthdir_x(_s * 1.05, _oa);
                var _oy = _cy + lengthdir_y(_s * 0.75, _oa);
                draw_set_colour(_dark);
                draw_triangle(_ox - 4, _oy + 3, _ox + 4, _oy + 3, _ox, _oy - 5, false);
                draw_set_colour(_light);
                draw_triangle(_ox - 2, _oy + 2, _ox + 2, _oy + 2, _ox, _oy - 3, false);
            }
            break;
    }
    // Olhos de energia
    enemy_draw_glow_eyes(_x + _fh * 2, _cy - 1, _fh, _s * 0.28, max(1.8, _s * 0.14), (_elem == "fire") ? c_white : _dark);
}

// -------------------------------------------------------------------------
// CONJURADOR: figura de tunica e capuz com cajado elemental
// -------------------------------------------------------------------------
function enemy_draw_caster(_x, _y, _r, _fh, _t, _elem, _main, _dark, _light, _acc, _a, _moving) {
    var _s = _r * max(scale_x, scale_y);
    var _fy = _y - 2 + sin(_t * 2.5) * 1.5; // leve levitacao

    // Cajado atras do corpo
    var _sx = _x + _fh * _s * 0.85;
    draw_set_colour(make_colour_rgb(90, 60, 35));
    draw_line_width(_sx, _fy + _s * 0.9, _sx, _fy - _s * 1.2, 2.5);

    // Tunica (triangulo = conjurador)
    draw_set_colour(_dark);
    draw_triangle(_x - _s - 1, _fy + _s * 0.95, _x + _s + 1, _fy + _s * 0.95, _x, _fy - _s * 0.75, false);
    draw_set_colour(_main);
    draw_triangle(_x - _s, _fy + _s * 0.9, _x + _s, _fy + _s * 0.9, _x, _fy - _s * 0.65, false);
    draw_set_colour(_light);
    draw_line_width(_x - _s * 0.85, _fy + _s * 0.75, _x + _s * 0.85, _fy + _s * 0.75, 2);
    // Capuz
    draw_set_colour(_dark);
    draw_circle(_x, _fy - _s * 0.55, _s * 0.5 + 1, false);
    draw_set_colour(_main);
    draw_circle(_x, _fy - _s * 0.55, _s * 0.5, false);
    draw_set_colour(merge_colour(_dark, c_black, 0.5));
    draw_ellipse(_x + _fh * 1 - _s * 0.32, _fy - _s * 0.72, _x + _fh * 1 + _s * 0.32, _fy - _s * 0.32, false);
    enemy_draw_glow_eyes(_x + _fh * 2, _fy - _s * 0.52, _fh, _s * 0.14, max(1.3, _s * 0.08), _acc);

    // Orbe/cristal no topo do cajado
    var _oy = _fy - _s * 1.2;
    var _pulse = 1 + 0.15 * sin(_t * 6);
    switch (_elem) {
        case "water":
            draw_set_colour(_acc);
            draw_triangle(_sx - 4 * _pulse, _oy, _sx + 4 * _pulse, _oy, _sx, _oy - 9 * _pulse, false);
            draw_triangle(_sx - 4 * _pulse, _oy, _sx + 4 * _pulse, _oy, _sx, _oy + 6 * _pulse, false);
            draw_set_colour(c_white);
            draw_line(_sx, _oy - 6, _sx, _oy + 3);
            break;
        case "fire":
            draw_set_colour(_acc);
            draw_circle(_sx, _oy, 4.5 * _pulse, false);
            draw_set_colour(_light);
            draw_triangle(_sx - 3, _oy - 2, _sx + 3, _oy - 2, _sx, _oy - 9 - 3 * sin(_t * 12), false);
            break;
        case "wind":
            draw_set_colour(_acc);
            draw_circle(_sx, _oy, 4 * _pulse, true);
            for (var _w = 0; _w < 3; _w++) {
                var _wa = _t * 300 + _w * 120;
                draw_line(_sx, _oy, _sx + lengthdir_x(7, _wa), _oy + lengthdir_y(7, _wa));
            }
            break;
        case "earth":
            draw_set_colour(_light);
            draw_rectangle(_sx - 4, _oy - 4, _sx + 4, _oy + 4, false);
            draw_set_colour(_acc);
            draw_circle(_sx, _oy, 2 * _pulse, false);
            break;
    }
}

// -------------------------------------------------------------------------
// GOLEM: bloco pesado com bracos e detalhes do elemento
// -------------------------------------------------------------------------
function enemy_draw_golem(_x, _y, _r, _fh, _t, _elem, _main, _dark, _light, _acc, _a, _moving) {
    var _w = _r * scale_x * 0.85;
    var _h = _r * scale_y * 0.8;
    var _step = _moving ? sin(_t * 8) * 3 : 0;
    var _ty = _y + abs(_step) * 0.3;

    // Pernas
    draw_set_colour(_dark);
    draw_rectangle(_x - _w * 0.6, _ty + _h * 0.6, _x - _w * 0.15, _ty + _h + 4 + _step, false);
    draw_rectangle(_x + _w * 0.15, _ty + _h * 0.6, _x + _w * 0.6, _ty + _h + 4 - _step, false);
    // Bracos
    draw_set_colour(_dark);
    draw_rectangle(_x - _w - _r * 0.45, _ty - _h * 0.5 - _step, _x - _w + 2, _ty + _h * 0.55 - _step, false);
    draw_rectangle(_x + _w - 2, _ty - _h * 0.5 + _step, _x + _w + _r * 0.45, _ty + _h * 0.55 + _step, false);
    draw_set_colour(_main);
    draw_rectangle(_x - _w - _r * 0.4, _ty - _h * 0.45 - _step, _x - _w, _ty + _h * 0.5 - _step, false);
    draw_rectangle(_x + _w, _ty - _h * 0.45 + _step, _x + _w + _r * 0.4, _ty + _h * 0.5 + _step, false);
    // Tronco
    draw_set_colour(_dark);
    draw_rectangle(_x - _w - 1.5, _ty - _h - 1.5, _x + _w + 1.5, _ty + _h * 0.7 + 1.5, false);
    draw_set_colour(_main);
    draw_rectangle(_x - _w, _ty - _h, _x + _w, _ty + _h * 0.7, false);
    draw_set_colour(_light);
    draw_rectangle(_x - _w, _ty - _h, _x + _w, _ty - _h + 3, false);
    // Cabeca pequena encaixada
    var _hy = _ty - _h - _r * 0.25;
    draw_set_colour(_dark);
    draw_rectangle(_x - _w * 0.45, _hy - _r * 0.35, _x + _w * 0.45, _hy + _r * 0.2, false);
    draw_set_colour(_main);
    draw_rectangle(_x - _w * 0.4, _hy - _r * 0.3, _x + _w * 0.4, _hy + _r * 0.15, false);
    enemy_draw_glow_eyes(_x + _fh * 2, _hy - _r * 0.05, _fh, _w * 0.18, max(2, _r * 0.07), _acc);

    switch (_elem) {
        case "water":
            // Espinhos de gelo nos ombros e rachaduras azuladas
            draw_set_colour(_light);
            draw_triangle(_x - _w - 2, _ty - _h, _x - _w + 8, _ty - _h, _x - _w + 1, _ty - _h - 12, false);
            draw_triangle(_x + _w - 8, _ty - _h, _x + _w + 2, _ty - _h, _x + _w - 1, _ty - _h - 12, false);
            draw_set_colour(_acc);
            draw_line_width(_x - _w * 0.5, _ty - _h * 0.4, _x, _ty + _h * 0.2, 1.5);
            draw_line_width(_x, _ty + _h * 0.2, _x + _w * 0.4, _ty - _h * 0.1, 1.5);
            break;
        case "fire":
            // Fendas de lava brilhando
            draw_set_colour(merge_colour(_acc, c_yellow, 0.5 + 0.5 * sin(_t * 6)));
            draw_line_width(_x - _w * 0.6, _ty - _h * 0.6, _x - _w * 0.1, _ty, 2);
            draw_line_width(_x - _w * 0.1, _ty, _x + _w * 0.5, _ty - _h * 0.3, 2);
            draw_line_width(_x + _w * 0.1, _ty + _h * 0.2, _x + _w * 0.3, _ty + _h * 0.6, 2);
            draw_circle(_x, _ty - _h * 0.2, _r * 0.18, false);
            break;
        case "wind":
            // Nuvens nos ombros e faisca
            draw_set_colour(_light);
            draw_circle(_x - _w, _ty - _h, 5, false);
            draw_circle(_x - _w + 6, _ty - _h - 3, 4, false);
            draw_circle(_x + _w, _ty - _h, 5, false);
            draw_circle(_x + _w - 6, _ty - _h - 3, 4, false);
            if (sin(_t * 9) > 0.7) {
                draw_set_colour(_acc);
                draw_line_width(_x - 4, _ty - _h * 0.5, _x + 2, _ty - _h * 0.1, 2);
                draw_line_width(_x + 2, _ty - _h * 0.1, _x - 2, _ty + _h * 0.3, 2);
            }
            break;
        case "earth":
            // Musgo e placas sobrepostas
            draw_set_colour(_light);
            draw_rectangle(_x - _w * 0.8, _ty - _h * 0.6, _x - _w * 0.1, _ty - _h * 0.2, false);
            draw_rectangle(_x + _w * 0.1, _ty - _h * 0.3, _x + _w * 0.8, _ty + _h * 0.1, false);
            draw_set_colour(_acc);
            draw_circle(_x - _w * 0.7, _ty - _h * 0.9, 3, false);
            draw_circle(_x - _w * 0.5, _ty - _h * 0.95, 2.5, false);
            draw_circle(_x + _w * 0.6, _ty + _h * 0.5, 2.5, false);
            break;
    }
}

// -------------------------------------------------------------------------
// ESPIRITOS (chefes das arenas)
// -------------------------------------------------------------------------
// ONDINA: dama de agua com cauda de peixe e cabelos em ondas
function enemy_draw_ondina(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a) {
    var _fy = _y - 4 + sin(_t * 2.5) * 2;
    var _sway = sin(_t * 3) * 4;
    // Cauda
    draw_set_colour(_dark);
    draw_triangle(_x - _r * 0.55, _fy + _r * 0.2, _x + _r * 0.55, _fy + _r * 0.2, _x + _sway, _fy + _r * 1.25, false);
    draw_set_colour(_main);
    draw_triangle(_x - _r * 0.45, _fy + _r * 0.2, _x + _r * 0.45, _fy + _r * 0.2, _x + _sway, _fy + _r * 1.15, false);
    draw_triangle(_x + _sway - 9, _fy + _r * 1.35, _x + _sway + 9, _fy + _r * 1.35, _x + _sway, _fy + _r * 1.05, false);
    // Tronco
    draw_set_colour(_main);
    draw_ellipse(_x - _r * 0.5, _fy - _r * 0.45, _x + _r * 0.5, _fy + _r * 0.35, false);
    // Cabelo em ondas (atras da cabeca)
    draw_set_colour(_dark);
    for (var _i = 0; _i < 4; _i++) {
        var _hx = _x - _fh * (4 + _i * 4);
        draw_circle(_hx, _fy - _r * 0.75 + _i * 4 + sin(_t * 4 + _i) * 1.5, 5, false);
    }
    // Cabeca
    draw_set_colour(_light);
    draw_circle(_x, _fy - _r * 0.8, _r * 0.45, false);
    draw_set_colour(_dark);
    draw_circle(_x + _fh * 3 - 3, _fy - _r * 0.82, 1.6, false);
    draw_circle(_x + _fh * 3 + 3, _fy - _r * 0.82, 1.6, false);
}

// SALAMANDRA: cabeca de lagarto flamejante (os segmentos do corpo sao desenhados no Draw dela)
function enemy_draw_salamandra_head(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a) {
    var _dir = variable_instance_exists(id, "facing_dir") ? facing_dir : 0;
    var _hx = _x + lengthdir_x(4, _dir);
    var _hy = _y + lengthdir_y(4, _dir);
    // Crista de fogo
    for (var _c = -1; _c <= 1; _c++) {
        var _ca = _dir + 180 + _c * 30;
        var _cl = 10 + 4 * sin(_t * 12 + _c);
        draw_set_colour(_acc);
        draw_triangle(_hx + lengthdir_x(_r * 0.4, _ca + 90), _hy + lengthdir_y(_r * 0.4, _ca + 90), _hx + lengthdir_x(_r * 0.4, _ca - 90), _hy + lengthdir_y(_r * 0.4, _ca - 90), _hx + lengthdir_x(_r * 0.6 + _cl, _ca), _hy + lengthdir_y(_r * 0.6 + _cl, _ca), false);
    }
    // Cabeca alongada
    draw_set_colour(_dark);
    draw_circle(_hx, _hy, _r * 0.8 + 1.5, false);
    draw_set_colour(_main);
    draw_circle(_hx, _hy, _r * 0.8, false);
    draw_circle(_hx + lengthdir_x(_r * 0.55, _dir), _hy + lengthdir_y(_r * 0.55, _dir), _r * 0.5, false);
    // Olhos laterais
    draw_set_colour(_acc);
    draw_circle(_hx + lengthdir_x(_r * 0.35, _dir + 55), _hy + lengthdir_y(_r * 0.35, _dir + 55), 3, false);
    draw_circle(_hx + lengthdir_x(_r * 0.35, _dir - 55), _hy + lengthdir_y(_r * 0.35, _dir - 55), 3, false);
    draw_set_colour(c_black);
    draw_circle(_hx + lengthdir_x(_r * 0.38, _dir + 55), _hy + lengthdir_y(_r * 0.38, _dir + 55), 1.2, false);
    draw_circle(_hx + lengthdir_x(_r * 0.38, _dir - 55), _hy + lengthdir_y(_r * 0.38, _dir - 55), 1.2, false);
}

// SILFIDE: fada do vento com quatro asas translucidas
function enemy_draw_silfide(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a) {
    var _fy = _y - 8 + sin(_t * 4) * 3;
    var _flap = 0.6 + 0.4 * abs(sin(_t * 16));
    draw_set_alpha(0.55 * _a);
    draw_set_colour(_acc);
    draw_ellipse(_x - _r * 1.4 * _flap, _fy - _r * 0.9, _x - 2, _fy - _r * 0.05, false);
    draw_ellipse(_x + 2, _fy - _r * 0.9, _x + _r * 1.4 * _flap, _fy - _r * 0.05, false);
    draw_ellipse(_x - _r * 1.05 * _flap, _fy - _r * 0.1, _x - 2, _fy + _r * 0.55, false);
    draw_ellipse(_x + 2, _fy - _r * 0.1, _x + _r * 1.05 * _flap, _fy + _r * 0.55, false);
    draw_set_alpha(_a);
    // Corpo e vestido de folhas
    draw_set_colour(_dark);
    draw_triangle(_x - _r * 0.45, _fy + _r * 0.6, _x + _r * 0.45, _fy + _r * 0.6, _x, _fy - _r * 0.2, false);
    draw_set_colour(_main);
    draw_triangle(_x - _r * 0.38, _fy + _r * 0.55, _x + _r * 0.38, _fy + _r * 0.55, _x, _fy - _r * 0.15, false);
    // Cabeca e cabelo esvoacante
    draw_set_colour(_light);
    draw_circle(_x, _fy - _r * 0.45, _r * 0.35, false);
    draw_set_colour(_dark);
    draw_triangle(_x - _fh * 2, _fy - _r * 0.75, _x - _fh * _r * 0.9, _fy - _r * 0.6 + sin(_t * 6) * 3, _x - _fh * 2, _fy - _r * 0.3, false);
    draw_circle(_x + _fh * 2 - 2.5, _fy - _r * 0.47, 1.3, false);
    draw_circle(_x + _fh * 2 + 2.5, _fy - _r * 0.47, 1.3, false);
}

// GNOMO: baixinho, barba enorme, gorro pontudo e nariz de batata
function enemy_draw_gnomo(_x, _y, _r, _fh, _t, _main, _dark, _light, _acc, _a, _moving) {
    var _bob = _moving ? abs(sin(_t * 10)) * 2 : 0;
    var _gy = _y - _bob;
    // Botas
    draw_set_colour(_dark);
    draw_ellipse(_x - _r * 0.7, _gy + _r * 0.6, _x - _r * 0.1, _gy + _r * 0.95, false);
    draw_ellipse(_x + _r * 0.1, _gy + _r * 0.6, _x + _r * 0.7, _gy + _r * 0.95, false);
    // Corpo redondo
    draw_set_colour(_dark);
    draw_circle(_x, _gy + _r * 0.2, _r * 0.7 + 1.5, false);
    draw_set_colour(_main);
    draw_circle(_x, _gy + _r * 0.2, _r * 0.7, false);
    // Rosto
    draw_set_colour(make_colour_rgb(230, 180, 150));
    draw_circle(_x + _fh * 2, _gy - _r * 0.35, _r * 0.42, false);
    // Barba
    draw_set_colour(_light);
    draw_triangle(_x + _fh * 2 - _r * 0.45, _gy - _r * 0.3, _x + _fh * 2 + _r * 0.45, _gy - _r * 0.3, _x + _fh * 2, _gy + _r * 0.55, false);
    // Nariz de batata
    draw_set_colour(make_colour_rgb(210, 130, 110));
    draw_circle(_x + _fh * 5, _gy - _r * 0.3, 3, false);
    // Olhos
    draw_set_colour(c_black);
    draw_circle(_x + _fh * 2 - 3, _gy - _r * 0.48, 1.3, false);
    draw_circle(_x + _fh * 2 + 3, _gy - _r * 0.48, 1.3, false);
    // Gorro pontudo
    draw_set_colour(_acc);
    draw_triangle(_x + _fh * 2 - _r * 0.5, _gy - _r * 0.6, _x + _fh * 2 + _r * 0.5, _gy - _r * 0.6, _x - _fh * 4, _gy - _r * 1.6, false);
    draw_set_colour(merge_colour(_acc, c_black, 0.35));
    draw_rectangle(_x + _fh * 2 - _r * 0.5, _gy - _r * 0.66, _x + _fh * 2 + _r * 0.5, _gy - _r * 0.56, false);
}
