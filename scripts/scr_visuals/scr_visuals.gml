// =========================================================================
// SISTEMA VISUAL CHIBI AUTORAL (Fallen Hero)
// =========================================================================
// Renderização artística autoral dos 4 heróis da fauna brasileira e do
// General da Água (Chefe), respeitando proporções chibi, telegrafia e estilo.
// =========================================================================

function chibi_draw_hero(_inst, _x, _y, _fx, _fy, _state, _blend, _alpha) {
    var _char = _inst.character_class;
    var _elem = _inst.element_affinity;
    var _fh = (_fx < 0) ? -1 : 1;
    
    var _moving = (_inst.x != _inst.xprevious || _inst.y != _inst.yprevious);
    var _t = current_time * 0.001;
    var _bob = _moving ? (sin(_t * 14) * 2.5) : (sin(_t * 4) * 0.8);
    var _py = _y + _bob;

    // 1. Sombra Suave no Chão
    draw_set_colour(c_black);
    draw_set_alpha(0.32 * _alpha);
    draw_ellipse(_x - 12, _y + 8, _x + 12, _y + 14, false);

    // Efeito de Furtividade / Invisibilidade do Assassino
    if (_inst.invisible) {
        draw_set_colour(make_colour_rgb(60, 20, 80));
        draw_set_alpha(0.18 + 0.08 * sin(_t * 8));
        draw_circle(_x, _py, 16, false);
    }

    draw_set_alpha(_alpha);

    // =====================================================================
    // LOBO-GUARÁ MAGA (Chibi Místico)
    // =====================================================================
    if (_char == "mage") {
        var _fur_col = make_colour_rgb(225, 105, 35);
        var _dark_col = make_colour_rgb(35, 30, 40);
        var _belly_col = make_colour_rgb(255, 240, 220);
        var _robe_col = make_colour_rgb(38, 48, 85);
        if (_blend != c_white) _robe_col = merge_colour(_robe_col, _blend, 0.5);

        // Cauda Espessa com ponta branca balançando
        var _tail_ang = sin(_t * 6 + (_moving ? 4 : 0)) * 14;
        var _tx = _x - _fh * 10;
        var _ty = _py + 2;
        draw_set_colour(_fur_col);
        draw_ellipse(_tx - _fh * 6, _ty - 4 + _tail_ang * 0.3, _tx + _fh * 6, _ty + 4 + _tail_ang * 0.3, false);
        draw_set_colour(c_white);
        draw_circle(_tx - _fh * 8, _ty + _tail_ang * 0.3, 3.5, false);

        // Patas com "meias" pretas distintivas do Lobo-Guará
        draw_set_colour(_dark_col);
        draw_circle(_x - 5, _py + 10, 2.5, false);
        draw_circle(_x + 5, _py + 10, 2.5, false);

        // Túnica Mística
        draw_set_colour(_robe_col);
        draw_rectangle(_x - 7, _py - 3, _x + 7, _py + 9, false);
        draw_set_colour(make_colour_rgb(255, 215, 80));
        draw_rectangle(_x - 7, _py + 2, _x + 7, _py + 4, false); // Cinto rúnico dourado

        // Cabeça Chibi Arredondada
        draw_set_colour(_fur_col);
        draw_circle(_x, _py - 8, 9.5, false);

        // Focinho e Bochechas Claras
        draw_set_colour(_belly_col);
        draw_ellipse(_x + _fh * 2 - 4, _py - 7, _x + _fh * 2 + 4, _py - 3, false);
        draw_set_colour(_dark_col);
        draw_circle(_x + _fh * 4, _py - 5, 1.2, false); // Focinho preto

        // Orelhas Grandes Pontudas com penugem interna
        var _ear_x1 = _x - 6;
        var _ear_x2 = _x + 4;
        var _ear_y = _py - 16;
        draw_set_colour(_fur_col);
        draw_triangle(_ear_x1 - 3, _py - 12, _ear_x1 + 3, _py - 12, _ear_x1, _ear_y, false);
        draw_triangle(_ear_x2 - 3, _py - 12, _ear_x2 + 3, _py - 12, _ear_x2, _ear_y, false);
        draw_set_colour(_dark_col);
        draw_circle(_ear_x1, _ear_y + 1, 1.5, false); // Ponta escura
        draw_circle(_ear_x2, _ear_y + 1, 1.5, false);
        draw_set_colour(c_white);
        draw_circle(_ear_x1, _py - 13, 1.8, false); // Penugem branca
        draw_circle(_ear_x2, _py - 13, 1.8, false);

        // Olhos Inteligentes
        draw_set_colour(make_colour_rgb(255, 185, 40));
        draw_circle(_x + _fh * 2, _py - 9, 2.2, false);
        draw_set_colour(_dark_col);
        draw_circle(_x + _fh * 2.5, _py - 9, 1.2, false);

        // Cajado Mágico de Madeira com Orbe Cristalino
        var _st_x = _x + _fh * 11;
        var _st_y = (_state == "attack") ? (_py - 14) : (_py - 6);
        draw_set_colour(make_colour_rgb(110, 75, 45));
        draw_line_width(_st_x, _st_y - 12, _st_x, _st_y + 16, 2.5);

        // Orbe Elemental Brilhante
        var _orb_col = (_elem == "water") ? c_aqua : ((_elem == "fire") ? c_orange : ((_elem == "wind") ? c_lime : make_colour_rgb(210, 160, 60)));
        draw_set_colour(_orb_col);
        draw_circle(_st_x, _st_y - 14, 4.5, false);
        draw_set_colour(c_white);
        draw_circle(_st_x - 1, _st_y - 15, 1.8, false);

        if (_state == "attack") {
            draw_set_alpha(0.6 * _alpha);
            draw_circle(_st_x, _st_y - 14, 8 + sin(_t * 20) * 3, true);
            draw_set_alpha(_alpha);
        }
    }
    // =====================================================================
    // LAGARTO ARQUEIRO (Chibi Estilo Referência)
    // =====================================================================
    else if (_char == "archer") {
        var _skin_col = make_colour_rgb(60, 180, 85);
        var _belly_col = make_colour_rgb(180, 235, 120);
        var _scale_col = make_colour_rgb(35, 125, 55);
        var _leather_col = make_colour_rgb(120, 80, 45);
        if (_blend != c_white) _skin_col = merge_colour(_skin_col, _blend, 0.5);

        // Cauda Espiral de Camaleão/Lagarto
        var _tail_curl = sin(_t * 7) * 2;
        draw_set_colour(_skin_col);
        draw_circle(_x - _fh * 9, _py + 6 + _tail_curl, 4, false);
        draw_set_colour(_scale_col);
        draw_circle(_x - _fh * 10, _py + 5 + _tail_curl, 2, false);

        // Patinhas Ágeis
        draw_set_colour(_scale_col);
        draw_circle(_x - 5, _py + 9, 2.5, false);
        draw_circle(_x + 5, _py + 9, 2.5, false);

        // Corpo Chibi Arredondado
        draw_set_colour(_skin_col);
        draw_ellipse(_x - 7, _py - 3, _x + 7, _py + 8, false);
        draw_set_colour(_belly_col);
        draw_ellipse(_x + _fh * 1 - 4, _py, _x + _fh * 1 + 4, _py + 7, false); // Peito claro

        // Aljava de Couro com flechas nas costas
        draw_set_colour(_leather_col);
        draw_line_width(_x - _fh * 3, _py - 4, _x + _fh * 3, _py + 5, 2.5);
        draw_rectangle(_x - _fh * 6 - 2, _py - 8, _x - _fh * 6 + 2, _py + 2, false);
        draw_set_colour(c_white);
        draw_line(_x - _fh * 6, _py - 8, _x - _fh * 6, _py - 12); // Penas da flecha

        // Cabeça Chibi Expressiva
        draw_set_colour(_skin_col);
        draw_circle(_x, _py - 8, 9.5, false);

        // Pequenas Escamas Dorsais
        draw_set_colour(_scale_col);
        draw_circle(_x - _fh * 5, _py - 14, 2, false);
        draw_circle(_x - _fh * 2, _py - 16, 2.2, false);
        draw_circle(_x + _fh * 2, _py - 15, 1.8, false);

        // Olho Grande e Curioso de Camaleão
        draw_set_colour(_belly_col);
        draw_circle(_x + _fh * 3, _py - 9, 4.5, false);
        draw_set_colour(c_black);
        draw_circle(_x + _fh * 4.5, _py - 9, 2.2, false);
        draw_set_colour(c_white);
        draw_circle(_x + _fh * 5, _py - 10, 1.0, false); // Brilho no olho

        // Arco de Madeira
        var _bow_x = _x + _fh * 9;
        var _bow_y = _py - 4;
        draw_set_colour(_leather_col);
        draw_arc_sim(_bow_x, _bow_y, 9, _fh);

        // Corda e Flecha Nocada
        draw_set_colour(c_silver);
        if (_state == "attack") {
            draw_line(_bow_x, _bow_y - 9, _bow_x - _fh * 5, _bow_y);
            draw_line(_bow_x, _bow_y + 9, _bow_x - _fh * 5, _bow_y);
            draw_set_colour(c_yellow);
            draw_line_width(_bow_x - _fh * 5, _bow_y, _bow_x + _fh * 10, _bow_y, 2);
        } else {
            draw_line(_bow_x, _bow_y - 9, _bow_x, _bow_y + 9);
        }
    }
    // =====================================================================
    // URUTAU ASSASSINO (Chibi Espectro)
    // =====================================================================
    else if (_char == "assassin") {
        var _bark_col = make_colour_rgb(95, 75, 65);
        var _light_feather = make_colour_rgb(145, 130, 115);
        var _dark_feather = make_colour_rgb(45, 38, 35);
        if (_blend != c_white) _bark_col = merge_colour(_bark_col, _blend, 0.5);

        // Patas com garras silenciosas
        draw_set_colour(_dark_feather);
        draw_circle(_x - 4, _py + 9, 2.2, false);
        draw_circle(_x + 4, _py + 9, 2.2, false);

        // Poncho Emplumado com Textura de Tronco/Camuflagem
        draw_set_colour(_bark_col);
        draw_triangle(_x, _py - 8, _x - 9, _py + 8, _x + 9, _py + 8, false);
        draw_set_colour(_light_feather);
        draw_line(_x - 5, _py, _x - 2, _py + 6);
        draw_line(_x + 5, _py, _x + 2, _py + 6);

        // Cabeça Chibi Arredondada
        draw_set_colour(_bark_col);
        draw_circle(_x, _py - 7, 9, false);

        // Penachos Superiores (Orelhas de Coruja/Urutau)
        draw_set_colour(_dark_feather);
        draw_triangle(_x - 6, _py - 12, _x - 2, _py - 12, _x - 5, _py - 16, false);
        draw_triangle(_x + 2, _py - 12, _x + 6, _py - 12, _x + 5, _py - 16, false);

        // Olhos Hipnóticos Grandes e Dourados de Ave Noturna
        draw_set_colour(make_colour_rgb(255, 205, 30));
        draw_circle(_x - 3, _py - 7, 4.0, false);
        draw_circle(_x + 4, _py - 7, 4.0, false);
        draw_set_colour(_dark_feather);
        draw_circle(_x - 3 + _fh * 0.8, _py - 7, 2.4, false);
        draw_circle(_x + 4 + _fh * 0.8, _py - 7, 2.4, false);
        draw_set_colour(c_white);
        draw_circle(_x - 4, _py - 8, 1.2, false);
        draw_circle(_x + 3, _py - 8, 1.2, false);

        // Bico Curto de Urutau
        draw_set_colour(_dark_feather);
        draw_triangle(_x + _fh * 1 - 2, _py - 4, _x + _fh * 1 + 2, _py - 4, _x + _fh * 3, _py - 2, false);

        // Adagas Duplas Obsidiana Cruzadas
        var _dag_x = _x + _fh * 8;
        var _dag_y = _py - 1;
        draw_set_colour(c_dkgray);
        draw_line_width(_dag_x, _dag_y, _dag_x + _fh * 7, _dag_y - 5, 2.5);
        draw_line_width(_dag_x, _dag_y + 4, _dag_x + _fh * 6, _dag_y + 9, 2.5);
        draw_set_colour(c_silver);
        draw_line(_dag_x + 1, _dag_y, _dag_x + _fh * 7, _dag_y - 5);

        if (_state == "attack") {
            draw_set_colour(c_white);
            draw_circle(_dag_x + _fh * 6, _dag_y, 6, true);
        }
    }
    // =====================================================================
    // TATU CAVALEIRO (Fallback se não estiver usando spritesheet)
    // =====================================================================
    else {
        var _shell_col = make_colour_rgb(175, 125, 75);
        var _armor_col = make_colour_rgb(190, 195, 210);
        if (_blend != c_white) _shell_col = merge_colour(_shell_col, _blend, 0.5);

        // Pés com garras firmes
        draw_set_colour(c_dkgray);
        draw_circle(_x - 6, _py + 9, 3, false);
        draw_circle(_x + 6, _py + 9, 3, false);

        // Carapaça Bandada Arredondada
        draw_set_colour(_shell_col);
        draw_circle(_x, _py - 1, 10, false);
        draw_set_colour(make_colour_rgb(130, 90, 50));
        draw_arc_sim(_x, _py - 1, 10, -_fh);

        // Elmo de Cavaleiro com Focinho de Tatu
        draw_set_colour(_armor_col);
        draw_circle(_x + _fh * 2, _py - 8, 8, false);
        draw_set_colour(c_navy);
        draw_rectangle(_x + _fh * 3 - 2, _py - 9, _x + _fh * 5, _py - 7, false); // Fresta do visor

        // Espada Larga de Aço
        var _sw_x = _x + _fh * 10;
        var _sw_y = _py - 4;
        draw_set_colour(c_silver);
        draw_line_width(_sw_x, _sw_y - 12, _sw_x, _sw_y + 8, 3);
        draw_set_colour(make_colour_rgb(255, 215, 80));
        draw_line_width(_sw_x - 4, _sw_y + 2, _sw_x + 4, _sw_y + 2, 2.5); // Guarda
    }

    draw_set_alpha(1.0);
    draw_set_colour(c_white);
}

// -------------------------------------------------------------------------
// RENDERIZADOR ARTISTICO DO GENERAL DA AGUA (Chefe do MVP)
// -------------------------------------------------------------------------
function chibi_draw_boss_water(_inst, _x, _y, _state, _scale_x, _scale_y, _vuln) {
    var _t = current_time * 0.001;
    var _r = _inst.body_radius;
    var _fh = (_inst.facing_dir > 90 && _inst.facing_dir < 270) ? -1 : 1;

    // 1. Vortex Aquático Sombrio sob os Pés
    var _vort_pulse = 0.85 + 0.15 * sin(_t * 6);
    draw_set_colour(make_colour_rgb(20, 60, 110));
    draw_set_alpha(0.35 * _vort_pulse);
    draw_ellipse(_x - _r * 1.3, _y + _r * 0.4, _x + _r * 1.3, _y + _r * 0.95, false);
    draw_set_colour(c_aqua);
    draw_set_alpha(0.6 * _vort_pulse);
    draw_ellipse(_x - _r * 1.2, _y + _r * 0.45, _x + _r * 1.2, _y + _r * 0.90, true);
    draw_set_alpha(1.0);

    // 2. Cores do Guardião da Água
    var _plate_col = _vuln ? make_colour_rgb(180, 220, 90) : make_colour_rgb(22, 45, 85);
    var _glow_col = _vuln ? c_yellow : make_colour_rgb(60, 210, 255);
    var _gold_trim = make_colour_rgb(220, 175, 60);

    var _hw = _r * _scale_x;
    var _hh = _r * _scale_y;
    var _by = _y - (_scale_y - 1.0) * 15;

    // Barbatanas Dorsais Espinhadas nas Costas
    draw_set_colour(_glow_col);
    draw_triangle(_x - _fh * (_hw * 0.5), _by - _hh * 0.9, _x - _fh * (_hw * 0.8), _by - _hh * 1.3, _x - _fh * (_hw * 0.2), _by - _hh * 0.7, false);
    draw_triangle(_x - _fh * (_hw * 0.2), _by - _hh * 0.7, _x - _fh * (_hw * 0.5), _by - _hh * 1.15, _x + _fh * (_hw * 0.2), _by - _hh * 0.5, false);

    // Carapaça Principal Abissal
    draw_set_colour(_plate_col);
    draw_ellipse(_x - _hw * 0.85, _by - _hh * 0.85, _x + _hw * 0.85, _by + _hh * 0.85, false);
    draw_set_colour(_gold_trim);
    draw_ellipse(_x - _hw * 0.85, _by - _hh * 0.85, _x + _hw * 0.85, _by + _hh * 0.85, true);

    // Ombreiras de Coral Pesadas
    draw_set_colour(_plate_col);
    draw_circle(_x - _hw * 0.7, _by - _hh * 0.3, _hw * 0.35, false);
    draw_circle(_x + _hw * 0.7, _by - _hh * 0.3, _hw * 0.35, false);
    draw_set_colour(_gold_trim);
    draw_circle(_x - _hw * 0.7, _by - _hh * 0.3, _hw * 0.35, true);
    draw_circle(_x + _hw * 0.7, _by - _hh * 0.3, _hw * 0.35, true);

    // Elmo / Cabeça do General com Crista Marinha
    draw_set_colour(_plate_col);
    draw_circle(_x, _by - _hh * 0.75, _hw * 0.45, false);
    draw_set_colour(_gold_trim);
    draw_circle(_x, _by - _hh * 0.75, _hw * 0.45, true);

    // Visor Sombrio com Olhos Cyan Ameaçadores
    draw_set_colour(c_black);
    draw_rectangle(_x - _hw * 0.3, _by - _hh * 0.85, _x + _hw * 0.3, _by - _hh * 0.70, false);
    draw_set_colour(_glow_col);
    draw_circle(_x - _hw * 0.15 + _fh * 2, _by - _hh * 0.78, 3.5, false);
    draw_circle(_x + _hw * 0.15 + _fh * 2, _by - _hh * 0.78, 3.5, false);
    draw_set_colour(c_white);
    draw_circle(_x - _hw * 0.15 + _fh * 2, _by - _hh * 0.78, 1.2, false);
    draw_circle(_x + _hw * 0.15 + _fh * 2, _by - _hh * 0.78, 1.2, false);

    // Núcleo da Essência (Brilha quando Vulnerável)
    if (_vuln) {
        var _core_pulse = 0.5 + 0.5 * sin(_t * 12);
        draw_set_colour(c_yellow);
        draw_set_alpha(0.85);
        draw_circle(_x, _by, _hw * 0.35 * _core_pulse, false);
        draw_set_colour(c_white);
        draw_circle(_x, _by, _hw * 0.18, false);
        draw_set_alpha(1.0);
    } else {
        // Runas de Água no Peitoral
        draw_set_colour(_glow_col);
        draw_circle(_x, _by, 6, false);
        draw_line_width(_x, _by - 12, _x, _by + 12, 2.5);
    }

    // Tridente Titânico das Marés
    var _tri_x = _x + _fh * (_hw * 0.9);
    var _tri_y = (_state == "slam_windup") ? (_by - _hh * 1.3) : (_by - 10);
    draw_set_colour(make_colour_rgb(180, 150, 60));
    draw_line_width(_tri_x, _tri_y - 35, _tri_x, _tri_y + 40, 5); // Haste
    draw_set_colour(_glow_col);
    // Pontas do Tridente
    draw_line_width(_tri_x - 14, _tri_y - 20, _tri_x - 14, _tri_y - 45, 4);
    draw_line_width(_tri_x + 14, _tri_y - 20, _tri_x + 14, _tri_y - 45, 4);
    draw_line_width(_tri_x, _tri_y - 20, _tri_x, _tri_y - 52, 5);
    draw_line_width(_tri_x - 14, _tri_y - 20, _tri_x + 14, _tri_y - 20, 4);

    // Efeito de Carga no Slam Windup
    if (_state == "slam_windup") {
        draw_set_alpha(0.6 + 0.3 * sin(_t * 25));
        draw_set_colour(c_aqua);
        draw_circle(_tri_x, _tri_y - 45, 18, true);
        draw_circle(_tri_x, _tri_y - 45, 26, true);
        draw_set_alpha(1.0);
    }

    draw_set_colour(c_white);
}

// Função auxiliar simples para arco de círculo
function draw_arc_sim(_cx, _cy, _radius, _dir) {
    var _steps = 8;
    var _start_a = (_dir > 0) ? -60 : 120;
    var _end_a   = (_dir > 0) ?  60 : 240;
    for (var _i = 0; _i < _steps; _i++) {
        var _a1 = lerp(_start_a, _end_a, _i / _steps);
        var _a2 = lerp(_start_a, _end_a, (_i + 1) / _steps);
        draw_line(_cx + lengthdir_x(_radius, _a1), _cy + lengthdir_y(_radius, _a1),
                  _cx + lengthdir_x(_radius, _a2), _cy + lengthdir_y(_radius, _a2));
    }
}
