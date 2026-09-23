// =========================================================================
// SISTEMA MODULAR DE INTERFACE E HUD (NINTENDO PILLARS - IWATA MODULARITY)
// =========================================================================

function hud_draw_damage_flash(_gw, _gh) {
    if (variable_global_exists("screen_damage_flash") && global.screen_damage_flash > 0) {
        draw_set_alpha(clamp(global.screen_damage_flash * 0.9, 0, 0.32));
        draw_set_color(c_red);
        draw_rectangle(0, 0, _gw, _gh, false);
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

function hud_draw_player_card(_hud, target, pad, _gw, _gh, boss_room) {
    // ================= 1. STATUS CARD DO JOGADOR (TOP-LEFT) =================
    var _card_x = pad;
    var _card_y = pad;
    var _card_w = 345;
    var _card_h = (target.talent_pending_points > 0) ? 132 : 124;
    
    // Transparência Inteligente por Oclusão (Sakurai: A interface nunca deve tampar o combate nos cantos)
    var _hud_target_alpha = 1.0;
    if (view_enabled && view_visible[0] && target != noone) {
        var _cam = view_camera[0];
        var _cx = camera_get_view_x(_cam);
        var _cy = camera_get_view_y(_cam);
        var _p_scr_x = target.x - _cx;
        var _p_scr_y = target.y - _cy;
        
        if (_p_scr_x >= 0 && _p_scr_x <= (_card_x + _card_w + 35) && _p_scr_y >= 0 && _p_scr_y <= (_card_y + _card_h + 35)) {
            _hud_target_alpha = 0.22;
        } else {
            with (obj_enemy_parent) {
                var _ex = x - _cx;
                var _ey = y - _cy;
                if (_ex >= 0 && _ex <= (_card_x + _card_w + 20) && _ey >= 0 && _ey <= (_card_y + _card_h + 20)) {
                    _hud_target_alpha = 0.22;
                    break;
                }
            }
        }
    }
    if (!variable_instance_exists(id, "_hud.hud_card_alpha")) _hud.hud_card_alpha = 1.0;
    _hud.hud_card_alpha = lerp(_hud.hud_card_alpha, _hud_target_alpha, 0.15);
    
    // Fundo escuro fosco translúcido
    draw_set_alpha(0.88 * _hud.hud_card_alpha);
    draw_set_color(make_colour_rgb(12, 16, 26));
    draw_rectangle(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, false);
    draw_set_alpha(_hud.hud_card_alpha);
    
    // Cor elemental temática
    var _elem_col = make_colour_rgb(80, 200, 255); // agua
    if (target.element_affinity == "fire") _elem_col = make_colour_rgb(255, 120, 40);
    else if (target.element_affinity == "wind") _elem_col = make_colour_rgb(160, 240, 230);
    else if (target.element_affinity == "earth") _elem_col = make_colour_rgb(140, 220, 100);
    
    // Moldura com borda dupla e topo elemental
    draw_set_color(make_colour_rgb(45, 60, 85));
    draw_rectangle(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, true);
    draw_set_color(make_colour_rgb(25, 35, 50));
    draw_rectangle(_card_x + 1, _card_y + 1, _card_x + _card_w - 1, _card_y + _card_h - 1, true);
    
    // Friso elemental no topo do card
    draw_set_color(_elem_col);
    draw_rectangle(_card_x + 2, _card_y, _card_x + _card_w - 2, _card_y + 2, false);
    
    // Cantos decorativos dourados estilo Hades
    draw_set_color(make_colour_rgb(210, 175, 75));
    draw_rectangle(_card_x, _card_y, _card_x + 4, _card_y + 4, false);
    draw_rectangle(_card_x + _card_w - 4, _card_y, _card_x + _card_w, _card_y + 4, false);
    draw_rectangle(_card_x, _card_y + _card_h - 4, _card_x + 4, _card_y + _card_h, false);
    draw_rectangle(_card_x + _card_w - 4, _card_y + _card_h - 4, _card_x + _card_w, _card_y + _card_h, false);
    
    // ---- COLUNA ESQUERDA: RETRATO DO HERÓI, NÍVEL E OURO ----
    var _port_x = _card_x + 10;
    var _port_y = _card_y + 10;
    var _port_size = 52;
    
    // Fundo do quadro do herói
    draw_set_color(make_colour_rgb(16, 22, 34));
    draw_rectangle(_port_x, _port_y, _port_x + _port_size, _port_y + _port_size, false);
    
    // Centro do quadro
    var _cx = _port_x + _port_size / 2;
    var _cy = _port_y + _port_size / 2;
    var _body_col = variable_instance_exists(target, "body_colour") ? target.body_colour : _elem_col;
    
    // Insígnia da classe (bloco geométrico translúcido com contorno na cor do herói)
    draw_set_alpha(0.25);
    draw_set_color(_body_col);
    draw_rectangle(_cx - 16, _cy - 16, _cx + 16, _cy + 16, false);
    draw_set_alpha(1);
    draw_set_color(_body_col);
    draw_rectangle(_cx - 16, _cy - 16, _cx + 16, _cy + 16, true);
    
    // Símbolo representativo da classe (ícone vetorial procedural da arma/estilo)
    var _c_icon = "sword";
    if (target.character_class == "knight") {
        _c_icon = (target.element_affinity == "earth") ? "shield" : "sword";
    } else if (target.character_class == "mage") {
        _c_icon = "magic_def";
    } else if (target.character_class == "archer") {
        _c_icon = "bow";
    } else if (target.character_class == "assassin") {
        _c_icon = "dagger";
    }
    
    // Sombra de profundidade e ícone estilizado da classe
    draw_talent_icon(_c_icon, _cx + 1, _cy + 1, 28, c_black);
    draw_talent_icon(_c_icon, _cx, _cy, 28, _body_col);
    
    // Borda externa do quadro com cor elemental
    draw_set_color(_elem_col);
    draw_rectangle(_port_x, _port_y, _port_x + _port_size, _port_y + _port_size, true);
    
    // Chip de Nível
    var _lvl_y = _port_y + _port_size + 6;
    draw_set_alpha(0.9);
    draw_set_color(make_colour_rgb(20, 26, 38));
    draw_rectangle(_port_x, _lvl_y, _port_x + _port_size, _lvl_y + 16, false);
    draw_set_alpha(1);
    draw_set_color(make_colour_rgb(60, 75, 100));
    draw_rectangle(_port_x, _lvl_y, _port_x + _port_size, _lvl_y + 16, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(_port_x + _port_size / 2, _lvl_y + 8, tr("Nv. ") + string(target.level));
    
    // Chip de Ouro
    var _gold_y = _lvl_y + 18;
    draw_set_alpha(0.9);
    draw_set_color(make_colour_rgb(24, 22, 16));
    draw_rectangle(_port_x, _gold_y, _port_x + _port_size, _gold_y + 16, false);
    draw_set_alpha(1);
    draw_set_color(make_colour_rgb(120, 95, 30));
    draw_rectangle(_port_x, _gold_y, _port_x + _port_size, _gold_y + 16, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(_port_x + _port_size / 2, _gold_y + 8, "$" + string(global.gold));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // ---- COLUNA DIREITA: NOME, BARRAS E HABILIDADES ----
    var _col_x = _port_x + _port_size + 10;
    var _col_w = _card_w - (_col_x - _card_x) - 10;
    var _cur_y = _card_y + 10;
    
    // Linha 1: Nome do Arquétipo & Badge de Afinidade
    var _hero_title = string_upper(target.character_class);
    if (variable_instance_exists(target, "archetype_name") && target.archetype_name != "") {
        _hero_title = string_upper(target.archetype_name);
    }
    draw_set_color(c_white);
    draw_text(_col_x, _cur_y, _hero_title);
    
    var _elem_label = "[" + string_upper(target.element_affinity) + "]";
    draw_set_halign(fa_right);
    draw_set_color(_elem_col);
    draw_text(_col_x + _col_w, _cur_y, _elem_label);
    draw_set_halign(fa_left);
    _cur_y += 18;
    
    // Linha 2: Barra de HP (Sakurai Juice)
    var _hp_h = 16;
    var _hp_ratio = clamp(target.hp / max(1, target.hp_max), 0, 1);
    
    draw_set_color(make_colour_rgb(34, 12, 16));
    draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _hp_h, false);
    
    if (_hp_ratio > 0) {
        draw_set_color(make_colour_rgb(220, 38, 54));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w * _hp_ratio, _cur_y + _hp_h, false);
    
        // Brilho superior de profundidade
        draw_set_alpha(0.5);
        draw_set_color(make_colour_rgb(255, 120, 130));
        draw_line(_col_x, _cur_y + 1, _col_x + _col_w * _hp_ratio, _cur_y + 1);
        draw_set_alpha(1);
    }
    
    // Escudo de Sobrevida do Lanceiro
    if (variable_instance_exists(target, "paladin_barrier_active") && target.paladin_barrier_active > 0) {
        draw_set_alpha(0.55);
        draw_set_color(c_aqua);
        var _bar_ratio = min(1, target.paladin_barrier_active / max(1, target.hp_max));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w * _bar_ratio, _cur_y + _hp_h, false);
        draw_set_alpha(1);
    }
    
    // Borda da barra de HP (pulsa em vermelho quando crítico <= 30%)
    var _is_danger = (target.hp / max(1, target.hp_max) <= 0.3);
    var _hp_border = _is_danger ? merge_colour(c_red, c_white, 0.5 + 0.5 * sin(current_time * 0.01)) : make_colour_rgb(80, 25, 30);
    draw_set_color(_hp_border);
    draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _hp_h, true);
    
    // Texto de HP centralizado com sombra
    var _hp_str = tr("HP ") + string(max(0, round(target.hp))) + " / " + string(round(target.hp_max));
    if (variable_instance_exists(target, "paladin_barrier_active") && target.paladin_barrier_active > 0) {
        _hp_str += " (+" + string(round(target.paladin_barrier_active)) + ")";
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text(_col_x + _col_w / 2 + 1, _cur_y + _hp_h / 2 + 1, _hp_str);
    draw_set_color(c_white);
    draw_text(_col_x + _col_w / 2, _cur_y + _hp_h / 2, _hp_str);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    _cur_y += _hp_h + 4;
    
    // Linha 3: Barra de EXP
    var _exp_h = 6;
    var _exp_ratio = clamp(target.xp / max(1, target.xp_to_next), 0, 1);
    draw_set_color(make_colour_rgb(22, 26, 36));
    draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _exp_h, false);
    if (_exp_ratio > 0) {
        draw_set_color(make_colour_rgb(230, 180, 40));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w * _exp_ratio, _cur_y + _exp_h, false);
    }
    draw_set_color(make_colour_rgb(60, 75, 100));
    draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _exp_h, true);
    _cur_y += _exp_h + 5;
    
    // Linha 4: Habilidade Defensiva / Especial (Tactical Pill)
    var _skill_name = tr("Habilidade");
    if (target.defend_mode == "paladin_aura") _skill_name = tr("Aura Sobrevida");
    else if (target.defend_mode == "berserk_fury") _skill_name = tr("Furia Ardente");
    else if (target.defend_mode == "parry") _skill_name = tr("Aparar");
    else if (target.defend_mode == "guardian_aegis") _skill_name = tr("Bastiao");
    else if (target.defend_mode == "block") _skill_name = tr("Bloqueio");
    else if (target.defend_mode == "manashield") _skill_name = tr("Escudo Magico");
    else if (target.defend_mode == "cryo_prison") _skill_name = tr("Tumba de Gelo");
    else if (target.defend_mode == "pyro_blast") _skill_name = tr("Onda Piroclastica");
    else if (target.defend_mode == "voltaic_blink") _skill_name = tr("Blink Voltaico");
    else if (target.defend_mode == "basalt_pillar") _skill_name = tr("Muralha Basalto");
    else if (target.defend_mode == "mist_roll") _skill_name = tr("Rolamento Nevoa");
    else if (target.defend_mode == "fire_recoil") _skill_name = tr("Salto Propulsor");
    else if (target.defend_mode == "cyclone_roll") _skill_name = tr("Rolamento Vendaval");
    else if (target.defend_mode == "earth_anchor") _skill_name = tr("Ancoragem");
    else if (target.defend_mode == "spectral_mist") _skill_name = tr("Manto Espectral");
    else if (target.defend_mode == "ash_bomb") _skill_name = tr("Bomba de Cinzas");
    else if (target.defend_mode == "shadowstep") _skill_name = tr("Passo das Sombras");
    else if (target.defend_mode == "obsidian_skin") _skill_name = tr("Pele Obsidiana");
    else if (target.defend_mode == "roll") _skill_name = tr("Esquiva");
    else if (target.defend_mode == "invisible") _skill_name = tr("Invisivel");
    
    var _skill_pill_h = 16;
    if (target.state == "defend" && target.defend_active) {
        draw_set_alpha(0.85);
        draw_set_color(make_colour_rgb(15, 45, 25));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _skill_pill_h, false);
        draw_set_alpha(1);
        draw_set_color(c_lime);
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _skill_pill_h, true);
        draw_set_valign(fa_middle);
        draw_text(_col_x + 6, _cur_y + _skill_pill_h / 2, "* [X] " + _skill_name + tr(": ATIVA (") + string(round(target.defend_timer * 10) / 10) + "s)");
    } else if (target.defend_cooldown_timer > 0) {
        draw_set_alpha(0.7);
        draw_set_color(make_colour_rgb(20, 24, 32));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _skill_pill_h, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(60, 70, 85));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _skill_pill_h, true);
        draw_set_color(c_ltgray);
        draw_set_valign(fa_middle);
        draw_text(_col_x + 6, _cur_y + _skill_pill_h / 2, "[X] " + _skill_name + ": " + string(round(target.defend_cooldown_timer * 10) / 10) + "s");
    } else {
        draw_set_alpha(0.8);
        draw_set_color(make_colour_rgb(16, 32, 24));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _skill_pill_h, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(80, 180, 100));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _skill_pill_h, true);
        draw_set_color(merge_colour(c_lime, c_white, 0.3));
        draw_set_valign(fa_middle);
        draw_text(_col_x + 6, _cur_y + _skill_pill_h / 2, "[X] " + _skill_name + tr(": PRONTA"));
    }
    draw_set_valign(fa_top);
    _cur_y += _skill_pill_h + 5;
    
    // Linha 5: Pontos de Atributos ou Atalho
    if (target.talent_pending_points > 0) {
        var _pulse = 0.55 + 0.45 * abs(sin(current_time * 0.007));
        var _pts_banner_h = 18;
        draw_set_alpha(0.85);
        draw_set_color(merge_colour(make_colour_rgb(45, 35, 12), make_colour_rgb(90, 70, 20), _pulse));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _pts_banner_h, false);
        draw_set_alpha(1);
        draw_set_color(merge_colour(c_yellow, c_white, _pulse));
        draw_rectangle(_col_x, _cur_y, _col_x + _col_w, _cur_y + _pts_banner_h, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _plural = (target.talent_pending_points > 1) ? tr(" PONTOS DISPONIVEIS") : tr(" PONTO DISPONIVEL");
        draw_text(_col_x + _col_w / 2, _cur_y + _pts_banner_h / 2, "* " + string(target.talent_pending_points) + _plural + tr(" [T / ESC]"));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    } else {
        draw_set_color(make_colour_rgb(130, 145, 170));
        draw_set_valign(fa_middle);
        draw_text(_col_x + 2, _cur_y + 8, tr("[T] Ficha / Talentos"));
        draw_set_valign(fa_top);
    }
    
    // ---- CHIP DE OBJETIVO DA SALA (ABAIXO DO CARD DO JOGADOR) ----
    var _obj_y = _card_y + _card_h + 8;
    if (!boss_room && instance_number(obj_boss_button) > 0) {
        var _all_pressed = (global.boss_buttons_pressed >= 4);
        var _obj_w = 260;
        var _obj_h = 22;
    
        draw_set_alpha(0.85);
        draw_set_color(_all_pressed ? make_colour_rgb(14, 36, 22) : make_colour_rgb(26, 20, 14));
        draw_rectangle(_card_x, _obj_y, _card_x + _obj_w, _obj_y + _obj_h, false);
        draw_set_alpha(1);
    
        draw_set_color(_all_pressed ? c_lime : make_colour_rgb(220, 140, 40));
        draw_rectangle(_card_x, _obj_y, _card_x + _obj_w, _obj_y + _obj_h, true);
    
        draw_set_valign(fa_middle);
        if (_all_pressed) {
            draw_set_color(c_lime);
            draw_text(_card_x + 8, _obj_y + _obj_h / 2, tr("4/4 Selos! O Portal foi aberto!"));
        } else {
            draw_set_color(make_colour_rgb(255, 200, 100));
            draw_text(_card_x + 8, _obj_y + _obj_h / 2, tr("* Selos Antigos: ") + string(global.boss_buttons_pressed) + tr("/4 ativados"));
        }
        draw_set_valign(fa_top);
    }
    draw_set_alpha(1.0);
    
    // Indicador do Modo Dev (Posicionado discretamente no rodapé central)
    if (variable_global_exists("dev_mode") && global.dev_mode) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_aqua);
        draw_text(_gw / 2, _gh - 10, tr("[MODO DEV ATIVO - F1/F2]"));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    
    // Low HP red vignette
    if (target.hp / max(1, target.hp_max) <= 0.3) {
        draw_set_alpha(0.25);
        draw_set_color(c_red);
        draw_rectangle(0, 0, _gw, _gh, false);
        draw_set_alpha(1);
    }
}

function hud_draw_boss_bar(_gw, _gh, boss_room) {
    // ================= BARRA DO CHEFE DA FASE =================
    if (boss_room) {
        var _boss = instance_find(obj_boss, 0);
        if (_boss == noone) _boss = instance_find(obj_boss2, 0);
        if (_boss == noone && object_exists(asset_get_index("obj_boss3"))) _boss = instance_find(asset_get_index("obj_boss3"), 0);
        if (_boss == noone && object_exists(asset_get_index("obj_boss4"))) _boss = instance_find(asset_get_index("obj_boss4"), 0);
        if (_boss == noone && object_exists(asset_get_index("obj_boss_human"))) _boss = instance_find(asset_get_index("obj_boss_human"), 0);
        if (_boss != noone) {
            var _bw = 520;
            var _bh = 26;
            var _bx = _gw / 2 - _bw / 2;
            var _by = 24;
            var _boss_name = loc("boss", "CHEFE");
            if (_boss.object_index == obj_boss) _boss_name = loc("boss_water_title", "GENERAL GLACIAL (AGUA)");
            else if (_boss.object_index == obj_boss2) _boss_name = tr("GENERAL MAGMA (FOGO)");
            else if (object_exists(asset_get_index("obj_boss3")) && _boss.object_index == asset_get_index("obj_boss3")) _boss_name = loc("boss_wind_title", "GENERAL ZEPHYRUS (VENTO)");
            else if (object_exists(asset_get_index("obj_boss4")) && _boss.object_index == asset_get_index("obj_boss4")) _boss_name = tr("TITA MONOLITO (TERRA)");
            else if (object_exists(asset_get_index("obj_boss_human")) && _boss.object_index == asset_get_index("obj_boss_human")) _boss_name = loc("boss_human_title", "O SALVADOR (HUMANO)");
            if (variable_instance_exists(_boss, "boss_phase")) _boss_name += tr("  [FASE ") + string(_boss.boss_phase) + "]";
    
            // Fundo do quadro do chefe
            draw_set_alpha(0.85);
            draw_set_color(make_colour_rgb(14, 18, 28));
            draw_rectangle(_bx - 4, _by - 4, _bx + _bw + 4, _by + _bh + 4, false);
            draw_set_alpha(1);
    
            // Borda dourada ornamentada
            draw_set_color(make_colour_rgb(210, 175, 75));
            draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + _bh + 2, true);
    
            // Preenchimento de vida
            draw_set_color(make_colour_rgb(34, 12, 16));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
    
            var _bhp_ratio = clamp(_boss.hp / max(1, _boss.hp_max), 0, 1);
            if (_bhp_ratio > 0) {
                draw_set_color(make_colour_rgb(190, 40, 50));
                draw_rectangle(_bx, _by, _bx + _bw * _bhp_ratio, _by + _bh, false);
                draw_set_alpha(0.4);
                draw_set_color(c_white);
                draw_line(_bx, _by + 1, _bx + _bw * _bhp_ratio, _by + 1);
                draw_set_alpha(1);
            }

            // Marcas das fases (66% e 33%) e janela de dano
            draw_set_color(c_white);
            draw_line_width(_bx + _bw * 0.66, _by - 2, _bx + _bw * 0.66, _by + _bh + 2, 2);
            draw_line_width(_bx + _bw * 0.33, _by - 2, _bx + _bw * 0.33, _by + _bh + 2, 2);
            if (variable_instance_exists(_boss, "vulnerable") && _boss.vulnerable) {
                draw_set_halign(fa_center);
                draw_set_valign(fa_top);
                draw_set_color(c_yellow);
                draw_text(_bx + _bw / 2, _by + _bh + 6, tr("JANELA DE DANO! (+50%)"));
            }
    
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            draw_text(_bx + _bw / 2, _by + _bh / 2, _boss_name + " - " + string(round(_boss.hp)) + "/" + string(round(_boss.hp_max)));
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }
}

function hud_draw_minimap_and_tracker(_hud, target, _gw, _gh, game_over, level_complete) {
    // ================= 2. MINIMAPA E PROGRESSÃO (TOP-RIGHT) =================
    if (!game_over && !level_complete && !(variable_global_exists("run_victory") && global.run_victory) && !global.chest_reward_open && !global.paused && !global.attr_window_open && (!variable_global_exists("midrun_shop_open") || !global.midrun_shop_open)) {
        run_update_current_room_state();
        var _map_w = 192;
        var _map_h = 104;
        var _map_x = _gw - _map_w - 24;
        var _map_y = 20;
    
        // Transparência Inteligente no Mapa se o jogador estiver no canto superior direito
        var _map_target_alpha = 1.0;
        if (view_enabled && view_visible[0] && target != noone) {
            var _cam = view_camera[0];
            var _cx = camera_get_view_x(_cam);
            var _cy = camera_get_view_y(_cam);
            var _p_scr_x = target.x - _cx;
            var _p_scr_y = target.y - _cy;
            if (_p_scr_x >= (_map_x - 30) && _p_scr_x <= _gw && _p_scr_y >= 0 && _p_scr_y <= (_map_y + _map_h + 30)) {
                _map_target_alpha = 0.25;
            }
        }
        if (!variable_instance_exists(id, "_hud.hud_map_alpha")) _hud.hud_map_alpha = 1.0;
        _hud.hud_map_alpha = lerp(_hud.hud_map_alpha, _map_target_alpha, 0.15);
    
        // Fundo do radar
        draw_set_alpha(0.85 * _hud.hud_map_alpha);
        draw_set_color(make_colour_rgb(12, 16, 26));
        draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _map_h, false);
        draw_set_alpha(_hud.hud_map_alpha);
    
        // Borda do radar
        draw_set_color(make_colour_rgb(50, 70, 100));
        draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _map_h, true);
        draw_set_color(make_colour_rgb(26, 36, 54));
        draw_rectangle(_map_x + 1, _map_y + 1, _map_x + _map_w - 1, _map_y + _map_h - 1, true);
    
        // Barra de Título do Radar com friso elemental
        var _header_h = 22;
        draw_set_color(make_colour_rgb(18, 24, 38));
        draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _header_h, false);
        var _elem_col = make_colour_rgb(80, 200, 255); // agua
        if (target.element_affinity == "fire") _elem_col = make_colour_rgb(255, 120, 40);
        else if (target.element_affinity == "wind") _elem_col = make_colour_rgb(160, 240, 230);
        else if (target.element_affinity == "earth") _elem_col = make_colour_rgb(140, 220, 100);
        draw_set_color(_elem_col);
        draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + 2, false);
        draw_set_color(make_colour_rgb(50, 70, 100));
        draw_line(_map_x, _map_y + _header_h, _map_x + _map_w, _map_y + _header_h);
    
        // Título do bioma e etapa com proteção contra vazamento
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        var _b_name = run_get_biome_name(global.run_biome);
        var _step_str = (global.run_room_step == 2.5) ? tr("ARENA (2.5)") : (tr("SALA ") + string(global.run_room_step) + "/6");
        var _header_txt = _b_name + " · " + _step_str;
        var _tw = string_width(_header_txt);
        var _max_tw = _map_w - 12;
        var _t_scale = (_tw > _max_tw) ? (_max_tw / _tw) : 1;
        draw_text_transformed(_map_x + _map_w / 2, _map_y + 2 + (_header_h - 2) / 2, _header_txt, _t_scale, _t_scale, 0);
        draw_set_valign(fa_top);
    
        // Área interna do radar
        var _inner_x = _map_x + 6;
        var _inner_y = _map_y + _header_h + 4;
        var _inner_w = _map_w - 12;
        var _inner_h = _map_h - _header_h - 8;
    
        var _scale_x = (room_width > 0) ? (_inner_w / room_width) : 1;
        var _scale_y = (room_height > 0) ? (_inner_h / room_height) : 1;
    
        // Paredes no radar
        draw_set_color(make_colour_rgb(60, 75, 105));
        with (obj_wall) {
            var _wx = _inner_x + x * _scale_x;
            var _wy = _inner_y + y * _scale_y;
            var _ww = max(2, (sprite_width > 0 ? sprite_width : (base_size * image_xscale)) * _scale_x);
            var _wh = max(2, (sprite_height > 0 ? sprite_height : (base_size * image_yscale)) * _scale_y);
            draw_rectangle(_wx, _wy, _wx + _ww, _wy + _wh, false);
        }
    
        // Botões e Portas no radar
        with (obj_boss_button) {
            var _bx = _inner_x + x * _scale_x;
            var _by = _inner_y + y * _scale_y;
            draw_set_color(pressed ? c_gray : c_orange);
            draw_rectangle(_bx - 1, _by - 1, _bx + 1, _by + 1, false);
        }
        with (obj_boss_door) {
            var _dx = _inner_x + x * _scale_x;
            var _dy = _inner_y + y * _scale_y;
            draw_set_color(c_red);
            draw_rectangle(_dx - 1, _dy - 1, _dx + 4, _dy + 2, false);
        }
    
        // Baús no radar
        draw_set_color(c_yellow);
        with (obj_chest) {
            var _cx = _inner_x + x * _scale_x;
            var _cy = _inner_y + y * _scale_y;
            draw_circle(_cx, _cy, 2, false);
        }
    
        // Mercador no radar
        if (object_exists(asset_get_index("obj_midrun_shop"))) {
            draw_set_color(c_yellow);
            with (asset_get_index("obj_midrun_shop")) {
                var _mx = _inner_x + x * _scale_x;
                var _my = _inner_y + y * _scale_y;
                draw_rectangle(_mx - 2, _my - 2, _mx + 2, _my + 2, false);
            }
        }
    
        // Portal de Saída no radar
        draw_set_color(make_colour_rgb(100, 220, 255));
        with (obj_stage_gate) {
            var _gx = _inner_x + x * _scale_x;
            var _gy = _inner_y + y * _scale_y;
            draw_circle(_gx, _gy, 3, false);
        }
        if (object_exists(asset_get_index("obj_stage_gate2"))) {
            with (asset_get_index("obj_stage_gate2")) {
                var _gx = _inner_x + x * _scale_x;
                var _gy = _inner_y + y * _scale_y;
                draw_circle(_gx, _gy, 3, false);
            }
        }
    
        // Inimigos no radar
        with (obj_enemy_parent) {
            var _ex = _inner_x + x * _scale_x;
            var _ey = _inner_y + y * _scale_y;
            var _is_b = (object_index == obj_boss || object_index == obj_boss2 || (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) || (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")));
            if (_is_b) {
                draw_set_color(c_red);
                draw_circle(_ex, _ey, 4, false);
                draw_set_color(c_white);
                draw_circle(_ex, _ey, 4, true);
            } else {
                draw_set_color(c_red);
                draw_circle(_ex, _ey, 2, false);
            }
        }
    
        // Jogador no radar
        if (target != noone && instance_exists(target)) {
            var _px = _inner_x + target.x * _scale_x;
            var _py = _inner_y + target.y * _scale_y;
            draw_set_color(c_lime);
            draw_circle(_px, _py, 3, false);
            draw_set_color(c_white);
            var _fx = variable_instance_exists(target, "facing_x") ? target.facing_x : 0;
            var _fy = variable_instance_exists(target, "facing_y") ? target.facing_y : 1;
            var _p_dir = (variable_instance_exists(target, "move_dir")) ? target.move_dir : point_direction(0, 0, _fx, _fy);
            draw_set_color(c_yellow);
            draw_line(_px, _py, _px + lengthdir_x(5, _p_dir), _py + lengthdir_y(5, _p_dir));
        }
    
        // ================= TRILHA DE NÓS (7 ETAPAS DO BIOMA) =================
        var _trail_y = _map_y + _map_h + 6;
        var _step_keys = [1, 2, 2.5, 3, 4, 5, 6];
        var _node_labels = ["1", "2", "2.5", "3", "4", "5", "6"];
        var _node_count = array_length(_step_keys);
        var _node_gap = 4;
        var _node_w = 24;
        var _node_h = 18;
    
        for (var _n = 0; _n < _node_count; _n++) {
            var _nx = _map_x + _n * (_node_w + _node_gap);
            var _step_val = _step_keys[_n];
            var _is_cur = (_step_val == global.run_room_step);
            var _is_past = (_step_val < global.run_room_step);
    
            draw_set_alpha(0.85);
            if (_is_cur) {
                var _p = 0.5 + 0.5 * sin(current_time * 0.008);
                draw_set_color(merge_colour(make_colour_rgb(50, 40, 15), make_colour_rgb(90, 70, 20), _p));
                draw_rectangle(_nx, _trail_y, _nx + _node_w, _trail_y + _node_h, false);
                draw_set_alpha(1);
                draw_set_color(merge_colour(c_yellow, c_white, _p));
                draw_rectangle(_nx, _trail_y, _nx + _node_w, _trail_y + _node_h, true);
            } else if (_is_past) {
                draw_set_color(make_colour_rgb(18, 32, 24));
                draw_rectangle(_nx, _trail_y, _nx + _node_w, _trail_y + _node_h, false);
                draw_set_alpha(1);
                draw_set_color(make_colour_rgb(60, 120, 80));
                draw_rectangle(_nx, _trail_y, _nx + _node_w, _trail_y + _node_h, true);
            } else {
                draw_set_color(make_colour_rgb(16, 20, 28));
                draw_rectangle(_nx, _trail_y, _nx + _node_w, _trail_y + _node_h, false);
                draw_set_alpha(1);
                draw_set_color(make_colour_rgb(45, 55, 75));
                draw_rectangle(_nx, _trail_y, _nx + _node_w, _trail_y + _node_h, true);
            }
    
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(_is_cur ? c_yellow : (_is_past ? make_colour_rgb(140, 220, 160) : c_gray));
            draw_text(_nx + _node_w / 2, _trail_y + _node_h / 2, _node_labels[_n]);
            draw_set_valign(fa_top);
        }
    
        // Subtítulo descritivo da sala atual (abaixo dos nós)
        var _sub_y = _trail_y + _node_h + 4;
        draw_set_alpha(0.85);
        draw_set_color(make_colour_rgb(14, 18, 26));
        draw_rectangle(_map_x, _sub_y, _map_x + _map_w, _sub_y + 18, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(45, 60, 85));
        draw_rectangle(_map_x, _sub_y, _map_x + _map_w, _sub_y + 18, true);
    
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_colour_rgb(220, 230, 255));
        var _r_title = run_get_room_title(global.run_room_step);
        var _title_txt = "* " + _r_title + " *";
        var _sub_tw = string_width(_title_txt);
        var _sub_scale = (_sub_tw > _map_w - 8) ? ((_map_w - 8) / _sub_tw) : 1;
        draw_text_transformed(_map_x + _map_w / 2, _sub_y + 9, _title_txt, _sub_scale, _sub_scale, 0);
    
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1);
    }
}

function hud_draw_game_over(_gw, _gh, death_gold_earned, death_gold_lost, death_gold_kept) {
        // Fundo escurecido com tom avermelhado
        draw_set_alpha(0.88);
        draw_set_color(make_colour_rgb(18, 10, 14));
        draw_rectangle(0, 0, _gw, _gh, false);
        draw_set_alpha(1);
    
        var _box_w = min(680, _gw - 40);
        var _box_h = 360;
        var _bx = (_gw - _box_w) / 2;
        var _by = (_gh - _box_h) / 2;
    
        // Janela de Game Over
        draw_set_alpha(0.95);
        draw_set_color(make_colour_rgb(22, 16, 20));
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);
        draw_set_alpha(1);
    
        draw_set_color(make_colour_rgb(140, 45, 55));
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);
        draw_rectangle(_bx - 1, _by - 1, _bx + _box_w + 1, _by + _box_h + 1, true);
    
        // Titulo
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(make_colour_rgb(255, 75, 75));
        draw_text(_bx + _box_w / 2, _by + 24, tr("VOCE FOI DERROTADO"));
    
        draw_set_color(c_ltgray);
        draw_text(_bx + _box_w / 2, _by + 52, tr("Sua jornada nesta masmorra chegou ao fim."));
    
        // Divisor
        draw_set_color(make_colour_rgb(70, 30, 40));
        draw_line(_bx + 30, _by + 80, _bx + _box_w - 30, _by + 80);
    
        // Extrato de Ouro da Partida (60% retido)
        var _ry = _by + 98;
        draw_set_halign(fa_left);
    
        draw_set_color(c_white);
        draw_text(_bx + 50, _ry, tr("Ouro obtido nesta partida:"));
        draw_set_halign(fa_right);
        draw_set_color(c_yellow);
        draw_text(_bx + _box_w - 50, _ry, "+" + string(death_gold_earned) + tr(" Ouro"));
        _ry += 30;
    
        draw_set_halign(fa_left);
        draw_set_color(make_colour_rgb(240, 95, 95));
        draw_text(_bx + 50, _ry, tr("Penalidade por Morte (40%):"));
        draw_set_halign(fa_right);
        draw_text(_bx + _box_w - 50, _ry, "-" + string(death_gold_lost) + tr(" Ouro"));
        _ry += 30;
    
        draw_set_halign(fa_left);
        draw_set_color(make_colour_rgb(80, 220, 120));
        draw_text(_bx + 50, _ry, tr("Ouro resgatado ao cofre (60%):"));
        draw_set_halign(fa_right);
        draw_text(_bx + _box_w - 50, _ry, "+" + string(death_gold_kept) + tr(" Ouro"));
        _ry += 34;
    
        // Divisor
        draw_set_color(make_colour_rgb(70, 30, 40));
        draw_line(_bx + 30, _ry, _bx + _box_w - 30, _ry);
        _ry += 16;
    
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(_bx + 50, _ry, tr("Saldo Atual no Cofre:"));
        draw_set_halign(fa_right);
        draw_set_color(c_yellow);
        draw_text(_bx + _box_w - 50, _ry, string(global.gold) + tr(" Ouro"));
        _ry += 40;
    
        // Botoes de Acao
        draw_set_halign(fa_center);
        var _pulse = 0.6 + 0.4 * abs(sin(current_time * 0.006));
        var _is_mob = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));
        draw_set_color(merge_colour(c_yellow, c_white, _pulse));
        var _cont_str = _is_mob ? tr("Toque na tela para Voltar a Selecao de Herois") : (input_get_btn_label("confirm") + tr(" Voltar para Selecao de Personagem"));
        draw_text(_bx + _box_w / 2, _ry, _cont_str);
        _ry += 26;
    
        if (!_is_mob) {
            draw_set_color(c_ltgray);
            draw_text(_bx + _box_w / 2, _ry, tr("[R] Reiniciar Expedicao   -   [M] Menu Principal"));
        }
    
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
}

function hud_draw_victory(target, _gw, _gh) {
        draw_set_alpha(0.88);
        draw_set_color(make_colour_rgb(10, 14, 24));
        draw_rectangle(0, 0, _gw, _gh, false);
        draw_set_alpha(1);
    
        var _box_w = 640;
        var _box_h = 360;
        var _bx = (_gw - _box_w) / 2;
        var _by = (_gh - _box_h) / 2;
    
        // Fundo do Modal
        draw_set_color(make_colour_rgb(18, 26, 40));
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, false);
    
        // Borda Dourada Triunfante
        draw_set_color(c_yellow);
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);
        draw_rectangle(_bx - 2, _by - 2, _bx + _box_w + 2, _by + _box_h + 2, true);
    
        // Cabecalho de Vitoria
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _pulse = 0.7 + 0.3 * abs(sin(current_time * 0.005));
        draw_set_color(merge_colour(c_yellow, c_white, _pulse));
        draw_text_transformed(_bx + _box_w / 2, _by + 36, tr("EXPEDICAO CONCLUIDA COM SUCESSO!"), 1.35, 1.35, 0);
    
        draw_set_color(make_colour_rgb(140, 210, 255));
        draw_text(_bx + _box_w / 2, _by + 68, tr("Todos os 4 Reinos Elementais foram Conquistados!"));
    
        draw_set_color(make_colour_rgb(60, 85, 125));
        draw_line(_bx + 30, _by + 92, _bx + _box_w - 30, _by + 92);
    
        // Dados da Partida
        var _sy = _by + 118;
        draw_set_halign(fa_left);
    
        var _p_class = (target != noone) ? target.character_class : "Heroi";
        var _p_arch = (target != noone && variable_instance_exists(target, "archetype_name")) ? target.archetype_name : tr("Guerreiro");
        var _p_lvl = (target != noone) ? target.level : 1;
    
        draw_set_color(c_white);
        draw_text(_bx + 50, _sy, tr("Heroi:"));
        draw_set_halign(fa_right);
        draw_set_color(c_yellow);
        draw_text(_bx + _box_w - 50, _sy, string_upper(_p_class) + " (" + _p_arch + ")");
        _sy += 28;
    
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(_bx + 50, _sy, tr("Nivel Final:"));
        draw_set_halign(fa_right);
        draw_set_color(c_aqua);
        draw_text(_bx + _box_w - 50, _sy, tr("Nivel ") + string(_p_lvl));
        _sy += 28;
    
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(_bx + 50, _sy, tr("Ouro Resgatado:"));
        draw_set_halign(fa_right);
        draw_set_color(c_yellow);
        draw_text(_bx + _box_w - 50, _sy, "+" + string(global.gold) + tr(" Ouro"));
        _sy += 28;
    
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(_bx + 50, _sy, tr("Afinidades Desbloqueadas:"));
        draw_set_halign(fa_right);
        draw_set_color(make_colour_rgb(100, 240, 160));
        draw_text(_bx + _box_w - 50, _sy, tr("Agua, Fogo, Vento e Terra Conquistados!"));
        _sy += 38;
    
        // Linha divisoria
        draw_set_color(make_colour_rgb(60, 85, 125));
        draw_line(_bx + 30, _sy, _bx + _box_w - 30, _sy);
        _sy += 24;
    
        // Botao de Retorno
        draw_set_halign(fa_center);
        var _b_pulse = 0.6 + 0.4 * abs(sin(current_time * 0.007));
        var _is_mob_vic = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));
        draw_set_color(merge_colour(c_yellow, c_white, _b_pulse));
        var _vic_str = _is_mob_vic ? tr("Toque na tela para Retornar a Selecao de Herois") : (input_get_btn_label("confirm") + tr(" Retornar a Selecao de Personagens"));
        draw_text(_bx + _box_w / 2, _sy, _vic_str);
    
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
}

function hud_draw_chest_reward(_hud, target, _gw, _gh) {
        // Fundo escurecido semitransparente permitindo ver o jogo congelado
        draw_set_alpha(0.86);
        draw_set_color(make_colour_rgb(10, 14, 22));
        draw_rectangle(0, 0, _gw, _gh, false);
        draw_set_alpha(1);
    
        // ================= DADOS DO TALENTO ENCONTRADO =================
        var _found_def = get_talent_def_by_id(global.chest_reward_talent_id);
        var _found_label = is_undefined(_found_def) ? global.chest_reward_talent_id : talent_get_label(_found_def);
        var _found_icon = is_undefined(_found_def) ? "sword" : talent_get_icon_type(_found_def);
        var _found_desc_val = is_undefined(_found_def) ? "" : talent_get_desc_value(_found_def);
        var _found_desc_flv = is_undefined(_found_def) ? "" : talent_get_desc_flavor(_found_def);
    
        // Dimensoes responsivas calculadas dinamicamente
        var _win_w = min(880, _gw - 40);
        var _win_h = min(510, _gh - 24);
        var _win_x = floor((_gw - _win_w) / 2);
        var _win_y = floor((_gh - _win_h) / 2);
    
        var _card_top_w = _win_w - 60;
        var _text_max_w = _card_top_w - 110;
    
        var _eff_str = tr("Efeito: ") + _found_desc_val;
        var _eff_sep = 15;
        var _eff_h = string_height_ext(_eff_str, _eff_sep, _text_max_w);
    
        var _flv_sep = 13;
        var _flv_h = (_found_desc_flv != "") ? min(28, string_height_ext(_found_desc_flv, _flv_sep, _text_max_w)) : 0;
    
        var _card_top_h = clamp(48 + _eff_h + (_found_desc_flv != "" ? (4 + _flv_h) : 0), 84, 106);
    
        // Fundo da Janela
        draw_set_alpha(0.95);
        draw_set_color(make_colour_rgb(16, 20, 32));
        draw_rectangle(_win_x, _win_y, _win_x + _win_w, _win_y + _win_h, false);
        draw_set_alpha(1);
    
        // Borda dupla estilizada dourada (Sakurai: impacto de tesouro)
        draw_set_color(make_colour_rgb(220, 175, 50));
        draw_rectangle(_win_x, _win_y, _win_x + _win_w, _win_y + _win_h, true);
        draw_set_color(make_colour_rgb(90, 70, 25));
        draw_rectangle(_win_x + 2, _win_y + 2, _win_x + _win_w - 2, _win_y + _win_h - 2, true);
    
        // ================= CABECALHO DO BAU =================
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
    
        var _pulse = 0.6 + 0.4 * abs(sin(current_time * 0.007));
        draw_set_color(merge_colour(c_yellow, c_white, _pulse));
        draw_text(_win_x + _win_w / 2, _win_y + 12, tr("*  BAU DE TESOURO ABERTO!  *"));
    
        draw_set_color(c_ltgray);
        draw_text(_win_x + _win_w / 2, _win_y + 32, tr("Voce encontrou um novo talento! Escolha um slot para equipar ou descarte-o."));
    
        draw_set_color(make_colour_rgb(60, 50, 30));
        draw_line(_win_x + 30, _win_y + 50, _win_x + _win_w - 30, _win_y + 50);
    
        // ================= CARD DO NOVO TALENTO ENCONTRADO =================
        var _card_top_x = _win_x + 30;
        var _card_top_y = _win_y + 58;
    
        // Fundo do card de destaque
        draw_set_alpha(0.85);
        draw_set_color(make_colour_rgb(22, 30, 46));
        draw_rectangle(_card_top_x, _card_top_y, _card_top_x + _card_top_w, _card_top_y + _card_top_h, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(215, 170, 50));
        draw_rectangle(_card_top_x, _card_top_y, _card_top_x + _card_top_w, _card_top_y + _card_top_h, true);
    
        // Icone do talento encontrado (centralizado verticalmente no card)
        var _icon_box_s = 56;
        var _icon_box_x = _card_top_x + 14;
        var _icon_box_y = _card_top_y + floor((_card_top_h - _icon_box_s) / 2);
        draw_set_color(make_colour_rgb(14, 18, 28));
        draw_rectangle(_icon_box_x, _icon_box_y, _icon_box_x + _icon_box_s, _icon_box_y + _icon_box_s, false);
        draw_set_color(make_colour_rgb(215, 170, 50));
        draw_rectangle(_icon_box_x, _icon_box_y, _icon_box_x + _icon_box_s, _icon_box_y + _icon_box_s, true);
        draw_talent_icon(_found_icon, _icon_box_x + _icon_box_s / 2, _icon_box_y + _icon_box_s / 2, 32, c_yellow);
    
        // Textos do novo talento
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_yellow);
        draw_text(_card_top_x + 82, _card_top_y + 8, tr("NOVO TALENTO ENCONTRADO:  ") + _found_label);
    
        var _eff_y = _card_top_y + 28;
        draw_set_color(make_colour_rgb(160, 220, 255));
        draw_text_ext(_card_top_x + 82, _eff_y, _eff_str, _eff_sep, _text_max_w);
    
        if (_found_desc_flv != "") {
            var _flv_y = _eff_y + _eff_h + 4;
            draw_set_color(make_colour_rgb(180, 190, 205));
            draw_text_ext(_card_top_x + 82, _flv_y, _found_desc_flv, _flv_sep, _text_max_w);
        }
    
        // ================= SLOTS COMPARATIVOS =================
        var _slots_y = _card_top_y + _card_top_h + 10;
        draw_set_halign(fa_center);
        draw_set_color(c_yellow);
        draw_text(_win_x + _win_w / 2, _slots_y, tr("SELECIONE O SLOT PARA SUBSTITUIR  (O NOVO TALENTO HERDARA O RANK DO SLOT):"));
    
        var _col_w = (_win_w - 60 - 2 * 16) / 3;
        var _cols_start_y = _slots_y + 20;
    
        var _discard_w = min(500, _win_w - 60);
        var _discard_h = 28;
        var _discard_x = _win_x + (_win_w - _discard_w) / 2;
        var _discard_y = _win_y + _win_h - 36;
        var _footer_y = _discard_y - 8;
    
        var _col_h = clamp(_footer_y - _cols_start_y - 8, 140, 190);
    
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _m_click = mouse_check_button_pressed(mb_left);
    
        for (var _i = 0; _i < array_length(target.talent_slot_ids); _i++) {
            var _cur_id = target.talent_slot_ids[_i];
            var _cur_rank = target.talent_slot_ranks[_i];
            var _cx = _win_x + 30 + _i * (_col_w + 16);
    
            var _slot_hover = (_mx >= _cx && _mx <= _cx + _col_w && _my >= _cols_start_y && _my <= _cols_start_y + _col_h);
            var _is_cur_slot = (input_has_gamepad_connected() && _hud.hud_chest_slot_cursor == _i);
            var _highlight = _slot_hover || _is_cur_slot;
            if (_slot_hover && _m_click) {
                equip_chest_talent(target, _i);
            }
    
            // Fundo do card de slot
            draw_set_alpha(0.85);
            draw_set_color(_highlight ? make_colour_rgb(26, 36, 56) : make_colour_rgb(18, 22, 34));
            draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + _col_h, false);
            draw_set_alpha(1);
            draw_set_color(_highlight ? make_colour_rgb(220, 180, 60) : make_colour_rgb(50, 70, 100));
            draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + _col_h, true);
            if (_is_cur_slot) {
                draw_rectangle(_cx - 1, _cols_start_y - 1, _cx + _col_w + 1, _cols_start_y + _col_h + 1, true);
            }
    
            // Cabecalho do Slot
            draw_set_color(_highlight ? make_colour_rgb(36, 50, 78) : make_colour_rgb(26, 34, 52));
            draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + 24, false);
            draw_set_color(c_yellow);
            draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + 24, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_cx + _col_w / 2, _cols_start_y + 12, tr("SLOT ") + string(_i + 1));
            draw_set_valign(fa_top);
    
            // Detalhes do Talento Atual do Slot
            if (_cur_id == "") {
                draw_set_color(c_gray);
                draw_text(_cx + _col_w / 2, _cols_start_y + 44, tr("(Slot Vazio)"));
                draw_set_color(make_colour_rgb(80, 220, 120));
                draw_text_ext(_cx + _col_w / 2, _cols_start_y + 68, tr("Instale com Rank ") + string(_cur_rank) + "!", 15, _col_w - 20);
            } else {
                var _cur_def = get_talent_def_by_id(_cur_id);
                var _cur_label = is_undefined(_cur_def) ? _cur_id : talent_get_label(_cur_def);
                var _cur_icon = is_undefined(_cur_def) ? "sword" : talent_get_icon_type(_cur_def);
    
                draw_talent_icon(_cur_icon, _cx + _col_w / 2, _cols_start_y + 42, 22, c_yellow);
    
                draw_set_color(c_white);
                draw_text_ext(_cx + _col_w / 2, _cols_start_y + 56, _cur_label, 13, _col_w - 20);
    
                draw_set_color(c_yellow);
                var _r_str = tr("Rank ") + string(_cur_rank) + "  ";
                for (var _s = 1; _s <= 3; _s++) _r_str += (_s <= _cur_rank) ? "[X] " : "[ ] ";
                draw_text(_cx + _col_w / 2, _cols_start_y + 74, _r_str);
    
                draw_set_color(make_colour_rgb(240, 110, 110));
                draw_text_ext(_cx + _col_w / 2, _cols_start_y + 92, tr("Substituira ") + _cur_label, 13, _col_w - 18);
            }
    
            // Botao de Acao
            var _btn_y = _cols_start_y + _col_h - 30;
            draw_set_color(_highlight ? make_colour_rgb(45, 75, 120) : make_colour_rgb(30, 45, 70));
            draw_rectangle(_cx + 8, _btn_y, _cx + _col_w - 8, _btn_y + 24, false);
            draw_set_color(c_yellow);
            draw_rectangle(_cx + 8, _btn_y, _cx + _col_w - 8, _btn_y + 24, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var _slot_txt = "";
            if (input_has_gamepad_connected()) {
                if (_hud.hud_chest_slot_cursor == _i) {
                    _slot_txt = input_get_btn_label("confirm") + tr(" Equipar");
                } else {
                    _slot_txt = tr("D-Pad Escolher");
                }
            } else {
                _slot_txt = tr("[Aperte ") + string(_i + 1) + tr(" para Equipar]");
            }
            draw_text(_cx + _col_w / 2, _btn_y + 12, _slot_txt);
            draw_set_valign(fa_top);
        }
    
        // ================= RODAPE DO BAU =================
        draw_set_color(make_colour_rgb(60, 50, 30));
        draw_line(_win_x + 30, _footer_y, _win_x + _win_w - 30, _footer_y);
    
        var _discard_hover = (_mx >= _discard_x && _mx <= _discard_x + _discard_w && _my >= _discard_y && _my <= _discard_y + _discard_h);
    
        if (_discard_hover && _m_click) {
            skip_chest_reward();
        }
    
        if (_discard_hover) {
            draw_set_alpha(0.85);
            draw_set_color(make_colour_rgb(60, 24, 28));
            draw_rectangle(_discard_x, _discard_y, _discard_x + _discard_w, _discard_y + _discard_h, false);
            draw_set_alpha(1);
            draw_set_color(make_colour_rgb(255, 90, 90));
            draw_rectangle(_discard_x, _discard_y, _discard_x + _discard_w, _discard_y + _discard_h, true);
        } else {
            draw_set_alpha(0.5);
            draw_set_color(make_colour_rgb(28, 16, 22));
            draw_rectangle(_discard_x, _discard_y, _discard_x + _discard_w, _discard_y + _discard_h, false);
            draw_set_alpha(1);
            draw_set_color(make_colour_rgb(140, 50, 50));
            draw_rectangle(_discard_x, _discard_y, _discard_x + _discard_w, _discard_y + _discard_h, true);
        }
    
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_discard_hover ? c_white : make_colour_rgb(240, 110, 110));
        var _discard_txt = input_get_btn_label("cancel") + tr(" Descartar este Talento e Continuar");
        draw_text(_discard_x + _discard_w / 2, _discard_y + _discard_h / 2, _discard_txt);
    
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
}

function hud_draw_hero_sheet(_hud, target, _gw, _gh) {
        // Fundo semitransparente escurecido permitindo vislumbre do jogo pausado
        draw_set_alpha(0.86);
        draw_set_color(make_colour_rgb(10, 14, 22));
        draw_rectangle(0, 0, _gw, _gh, false);
        draw_set_alpha(1);
    
        // Dimensoes da Janela Modal
        var _win_w = min(960, _gw - 40);
        var _win_h = min(560, _gh - 30);
        var _win_x = (_gw - _win_w) / 2;
        var _win_y = (_gh - _win_h) / 2;
    
        // Fundo da Janela
        draw_set_alpha(0.95);
        draw_set_color(make_colour_rgb(16, 20, 32));
        draw_rectangle(_win_x, _win_y, _win_x + _win_w, _win_y + _win_h, false);
        draw_set_alpha(1);
    
        // Borda dupla estilizada
        draw_set_color(make_colour_rgb(65, 85, 125));
        draw_rectangle(_win_x, _win_y, _win_x + _win_w, _win_y + _win_h, true);
        draw_set_color(make_colour_rgb(35, 45, 70));
        draw_rectangle(_win_x + 2, _win_y + 2, _win_x + _win_w - 2, _win_y + _win_h - 2, true);
    
        // ================= CABECALHO =================
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_yellow);
        var _play_str = format_playtime(variable_global_exists("run_playtime") ? global.run_playtime : 0);
        draw_text(_win_x + 24, _win_y + 16, tr("PAUSADO  -  FICHA DO HEROI   (Tempo: ") + _play_str + ")");
    
        var _is_mobile = (os_type == os_android || os_type == os_ios || (variable_global_exists("dev_touch_mode") && global.dev_touch_mode));
        var _btn_rx = _win_x + _win_w - 130;
        var _btn_ry = _win_y + 10;
        var _btn_rw = 110;
        var _btn_rh = 26;
        draw_set_color(make_colour_rgb(32, 44, 68));
        draw_rectangle(_btn_rx, _btn_ry, _btn_rx + _btn_rw, _btn_ry + _btn_rh, false);
        draw_set_color(c_yellow);
        draw_rectangle(_btn_rx, _btn_ry, _btn_rx + _btn_rw, _btn_ry + _btn_rh, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_btn_rx + _btn_rw / 2, _btn_ry + _btn_rh / 2, _is_mobile ? tr("Retomar") : (input_is_gamepad_active() ? (input_get_btn_label("cancel") + tr(" Retomar")) : tr("[ESC] Retomar")));
    
        // Linha divisoria do cabecalho
        draw_set_color(make_colour_rgb(45, 60, 90));
        draw_line(_win_x + 20, _win_y + 40, _win_x + _win_w - 20, _win_y + 40);
    
        // Dimensoes dos dois paineis
        var _panel_gap = 16;
        var _left_w = 380;
        var _right_w = _win_w - _left_w - _panel_gap - 40;
        var _col1_x = _win_x + 20;
        var _col2_x = _col1_x + _left_w + _panel_gap;
        var _content_y = _win_y + 48;
        var _footer_y = _win_y + _win_h - 42;
        var _content_h = _footer_y - _content_y - 8;
    
        // ================= PAINEL ESQUERDO: ESTATISTICAS =================
        draw_set_alpha(0.6);
        draw_set_color(make_colour_rgb(12, 16, 26));
        draw_rectangle(_col1_x, _content_y, _col1_x + _left_w, _content_y + _content_h, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(40, 52, 78));
        draw_rectangle(_col1_x, _content_y, _col1_x + _left_w, _content_y + _content_h, true);
    
        var _lx = _col1_x + 16;
        var _ly = _content_y + 12;
    
        // Identidade do Heroi
        var _c_name = string_upper(target.character_class);
        if (variable_instance_exists(target, "archetype_name") && target.archetype_name != "") {
            _c_name += " (" + string_upper(target.archetype_name) + ")";
        }
        draw_set_halign(fa_left);
        draw_set_color(c_yellow);
        draw_text(_lx, _ly, _c_name);
        _ly += 22;
    
        draw_set_color(c_white);
        draw_text(_lx, _ly, tr("Nivel ") + string(target.level) + tr("   (EXP: ") + string(round(target.xp)) + " / " + string(round(target.xp_to_next)) + ")");
        _ly += 20;
    
        // Mini barra de EXP
        var _exp_bar_w = _left_w - 32;
        var _exp_ratio = (target.xp_to_next > 0) ? min(1, target.xp / target.xp_to_next) : 0;
        draw_set_color(make_colour_rgb(25, 30, 42));
        draw_rectangle(_lx, _ly, _lx + _exp_bar_w, _ly + 6, false);
        draw_set_color(c_yellow);
        draw_rectangle(_lx, _ly, _lx + _exp_bar_w * _exp_ratio, _ly + 6, false);
        _ly += 14;
    
        // Divisor
        draw_set_color(make_colour_rgb(35, 45, 70));
        draw_line(_lx, _ly, _col1_x + _left_w - 16, _ly);
        _ly += 10;
    
        // Atributos Vitais de Combate (Nintendo Miyamoto: semiótica limpa)
        var _val_x = _lx + 165;
    
        // 1. HP
        var _hp_val = string(max(0, round(target.hp))) + " / " + string(round(target.hp_max));
        if (variable_instance_exists(target, "paladin_barrier_active") && target.paladin_barrier_active > 0) {
            _hp_val += "  (+" + string(round(target.paladin_barrier_active)) + ")";
        }
        draw_set_color(make_colour_rgb(240, 80, 80));
        draw_text(_lx, _ly, tr("[HP] Vida:"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, _hp_val);
        _ly += 22;
    
        // 2. Poder Fisico (Auto-Ataque com a arma basica)
        var _pwr_str = string(round(target.nat_power));
        if (variable_instance_exists(target, "synth_pwr_fisica") && target.synth_pwr_fisica > 0) {
            _pwr_str += " (+" + string(target.synth_pwr_fisica) + ")";
        }
        draw_set_color(make_colour_rgb(255, 170, 40));
        draw_text(_lx, _ly, tr("[PWR-F] Fisico (AA):"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, _pwr_str);
        _ly += 20;
    
        // 3. Poder Magico (Habilidades, Curas e Efeitos Elementais)
        var _mag_val = variable_instance_exists(target, "synth_pwr_magica") ? target.synth_pwr_magica : 0;
        var _mag_str = (_mag_val > 0) ? ("+" + string(_mag_val) + tr(" (Skills/Cura)")) : tr("Base (x1.0)");
        draw_set_color(make_colour_rgb(200, 130, 255));
        draw_text(_lx, _ly, tr("[PWR-M] Magico (Skill):"));
        draw_set_color((_mag_val > 0) ? c_yellow : c_gray);
        draw_text(_val_x, _ly, _mag_str);
        _ly += 20;
    
        // 4. Defesa Fisica (Melee / Contato / Espinhos)
        var _def_str = string(round(target.nat_defesa));
        if (variable_instance_exists(target, "synth_def_fisica") && target.synth_def_fisica > 0) {
            _def_str += " (+" + string(target.synth_def_fisica) + ")";
        }
        draw_set_color(make_colour_rgb(70, 160, 240));
        draw_text(_lx, _ly, tr("[DEF-F] Melee/Contato:"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, _def_str);
        _ly += 20;
    
        // 5. Defesa Magica (Projeteis Ranged / Pocas / Area)
        var _mdef_val = variable_instance_exists(target, "synth_def_magica") ? target.synth_def_magica : 0;
        var _mdef_str = string(round(target.nat_defesa));
        if (_mdef_val > 0) {
            _mdef_str += " (+" + string(_mdef_val) + ")";
        }
        draw_set_color(make_colour_rgb(100, 220, 240));
        draw_text(_lx, _ly, tr("[DEF-M] Ranged/Area:"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, _mdef_str);
        _ly += 20;
    
        // 4. Velocidade de Ataque
        draw_set_color(make_colour_rgb(230, 210, 80));
        draw_text(_lx, _ly, tr("[ATK] Cadencia:"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, string(round(target.nat_atk_spd * 100) / 100) + tr(" golpes/s"));
        _ly += 22;
    
        // 5. Velocidade de Movimento
        draw_set_color(make_colour_rgb(80, 220, 130));
        draw_text(_lx, _ly, tr("[VEL] Movimento:"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, string(round(target.nat_move_spd)));
        _ly += 22;
    
        // 6. Tempo de Partida
        draw_set_color(make_colour_rgb(180, 210, 240));
        draw_text(_lx, _ly, tr("[RUN] Tempo:"));
        draw_set_color(c_white);
        draw_text(_val_x, _ly, format_playtime(variable_global_exists("run_playtime") ? global.run_playtime : 0));
        _ly += 26;
    
        // Divisor
        draw_set_color(make_colour_rgb(35, 45, 70));
        draw_line(_lx, _ly, _col1_x + _left_w - 16, _ly);
        _ly += 10;
    
        // Sinergias Ativas (apenas o que for > 0!)
        draw_set_color(c_yellow);
        draw_text(_lx, _ly, tr("SINERGIAS ATIVAS:"));
        _ly += 22;
    
        var _has_syn = false;
        draw_set_color(c_ltgray);
    
        if (target.synth_crit_chance > 0) {
            draw_text(_lx, _ly, tr("- Chance Critica: ") + string(round(target.synth_crit_chance * 100)) + "%");
            _ly += 18;
            _has_syn = true;
        }
        if (target.synth_cdr > 0) {
            draw_text(_lx, _ly, tr("- Reducao Recarga: ") + string(round(target.synth_cdr * 100)) + "%");
            _ly += 18;
            _has_syn = true;
        }
        if (target.synth_dodge > 0) {
            draw_text(_lx, _ly, tr("- Chance de Esquiva: ") + string(round(target.synth_dodge * 100)) + "%");
            _ly += 18;
            _has_syn = true;
        }
        if (target.synth_hp_reg > 0) {
            draw_text(_lx, _ly, tr("- Regeneracao: +") + string(target.synth_hp_reg) + tr(" HP/s"));
            _ly += 18;
            _has_syn = true;
        }
        if (target.synth_lifesteal > 0) {
            draw_text(_lx, _ly, tr("- Roubo de Vida: +") + string(round(target.synth_lifesteal * 100)) + "%");
            _ly += 18;
            _has_syn = true;
        }
        if (target.synth_armor_hp > 0) {
            draw_text(_lx, _ly, tr("- Bonus Armadura HP: +") + string(target.synth_armor_hp));
            _ly += 18;
            _has_syn = true;
        }
    
        if (!_has_syn) {
            draw_set_color(make_colour_rgb(100, 115, 140));
            draw_text(_lx, _ly, tr("(Evolua talentos para ativar sinergias)"));
        }
    
        // ================= PAINEL DIREITO: TALENTOS DA RUN =================
        draw_set_alpha(0.6);
        draw_set_color(make_colour_rgb(12, 16, 26));
        draw_rectangle(_col2_x, _content_y, _col2_x + _right_w, _content_y + _content_h, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(40, 52, 78));
        draw_rectangle(_col2_x, _content_y, _col2_x + _right_w, _content_y + _content_h, true);
    
        var _rx = _col2_x + 16;
        var _ry = _content_y + 12;
    
        // Cabecalho de Pontos Disponiveis (Nintendo Sakurai: Juice / Destaque)
        var _pts = target.talent_pending_points;
        if (_pts > 0) {
            var _pulse = 0.5 + 0.5 * abs(sin(current_time * 0.008));
            var _banner_col = merge_colour(c_yellow, c_white, _pulse);
    
            draw_set_color(_banner_col);
            draw_text(_rx, _ry, "* " + string(_pts) + tr(" PONTO(S)!"));
            draw_set_halign(fa_right);
            draw_text(_col2_x + _right_w - 16, _ry, _is_mobile ? tr("Toque para Evoluir") : (input_is_gamepad_active() ? (tr("D-Pad Navegar | ") + input_get_btn_label("aux") + tr(" Evoluir")) : tr("Aperte [1, 2 ou 3]")));
            draw_set_halign(fa_left);
        } else {
            draw_set_color(c_white);
            draw_text(_rx, _ry, tr("Talentos Equipados"));
            draw_set_halign(fa_right);
            draw_set_color(c_gray);
            draw_text(_col2_x + _right_w - 16, _ry, tr("0 pts pendentes"));
            draw_set_halign(fa_left);
        }
    
        _ry += 22;
        draw_set_color(make_colour_rgb(35, 45, 70));
        draw_line(_rx, _ry, _col2_x + _right_w - 16, _ry);
        _ry += 12;
    
        // Cards de Talentos (3 Slots)
        var _card_w = _right_w - 32;
        var _card_h = 100;
        var _card_gap = 12;
    
        for (var _i = 0; _i < array_length(target.talent_slot_ids); _i++) {
            var _tid = target.talent_slot_ids[_i];
            var _rank = target.talent_slot_ranks[_i];
            var _cy = _ry + _i * (_card_h + _card_gap);
    
            // Fundo do Card
            draw_set_alpha(0.88);
            draw_set_color(make_colour_rgb(18, 24, 36));
            draw_rectangle(_rx, _cy, _rx + _card_w, _cy + _card_h, false);
            draw_set_alpha(1);
    
            var _max_rank = (_tid != "") ? talent_get_max_rank(_tid) : 1;
            var _cost = (_tid != "") ? talent_get_upgrade_cost(_tid, _rank) : 999999;
    
            // Borda do Card
            var _is_cur_card = (input_has_gamepad_connected() && _hud.hud_talent_slot_cursor == _i);
            if (_is_cur_card) {
                var _flash_cur = 0.5 + 0.5 * abs(sin(current_time * 0.009));
                draw_set_color(merge_colour(c_yellow, c_white, _flash_cur));
                draw_rectangle(_rx - 2, _cy - 2, _rx + _card_w + 2, _cy + _card_h + 2, true);
                draw_rectangle(_rx - 1, _cy - 1, _rx + _card_w + 1, _cy + _card_h + 1, true);
            } else if (_pts >= _cost && _rank < _max_rank && _tid != "") {
                var _flash = 0.5 + 0.5 * sin(current_time * 0.007 + _i * 1.5);
                draw_set_color(merge_colour(make_colour_rgb(70, 90, 130), c_yellow, _flash));
                draw_rectangle(_rx - 1, _cy - 1, _rx + _card_w + 1, _cy + _card_h + 1, true);
            } else {
                draw_set_color(make_colour_rgb(45, 60, 85));
                draw_rectangle(_rx, _cy, _rx + _card_w, _cy + _card_h, true);
            }
    
            if (_tid == "") {
                draw_set_color(c_gray);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(_rx + _card_w / 2, _cy + _card_h / 2, tr("Slot ") + string(_i + 1) + tr(": (Vazio - Obtenha novos talentos em Baus)"));
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                continue;
            }
    
            var _def = get_talent_def_by_id(_tid);
            var _tlabel = is_undefined(_def) ? _tid : talent_get_label(_def);
            var _ticon = is_undefined(_def) ? "sword" : talent_get_icon_type(_def);
            var _tdesc = is_undefined(_def) ? "" : talent_get_desc_value(_def);
    
            // Container do Icone
            var _icon_box_size = 54;
            var _ibx = _rx + 10;
            var _iby = _cy + 10;
            draw_set_color(make_colour_rgb(26, 34, 52));
            draw_rectangle(_ibx, _iby, _ibx + _icon_box_size, _iby + _icon_box_size, false);
            draw_set_color(make_colour_rgb(60, 80, 115));
            draw_rectangle(_ibx, _iby, _ibx + _icon_box_size, _iby + _icon_box_size, true);
    
            draw_talent_icon(_ticon, _ibx + _icon_box_size / 2, _iby + _icon_box_size / 2 - 2, 28, c_yellow);
    
            // Tecla de atalho [1], [2], [3]
            draw_set_color(make_colour_rgb(24, 30, 46));
            draw_rectangle(_ibx, _iby + _icon_box_size + 6, _ibx + _icon_box_size, _iby + _icon_box_size + 24, false);
            draw_set_color((_pts >= _cost && _rank < _max_rank) ? c_yellow : make_colour_rgb(80, 100, 140));
            draw_rectangle(_ibx, _iby + _icon_box_size + 6, _ibx + _icon_box_size, _iby + _icon_box_size + 24, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_ibx + _icon_box_size / 2, _iby + _icon_box_size + 15, "[" + string(_i + 1) + "]");
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
    
            // Titulo do Talento e Rank
            var _tx = _rx + 76;
            var _ty = _cy + 10;
            draw_set_color(c_yellow);
            draw_text(_tx, _ty, _tlabel);
    
            // Exibição estilizada do Rank
            draw_set_halign(fa_right);
            var _rank_str = "";
            if (_max_rank == 1) {
                _rank_str = (_rank >= 1) ? tr("[ATIVO - MAX]") : tr("[INATIVO - Custo: ") + string(_cost) + tr(" pts]");
            } else {
                _rank_str = tr("Rank ") + string(_rank) + "/" + string(_max_rank);
                if (_rank >= _max_rank) _rank_str += tr(" [MAX]");
            }
            draw_set_color((_pts >= _cost && _rank < _max_rank) ? c_yellow : c_white);
            draw_text(_rx + _card_w - 14, _ty, _rank_str);
            draw_set_halign(fa_left);
    
            // Divisor dentro do card
            draw_set_color(make_colour_rgb(35, 45, 65));
            draw_line(_tx, _ty + 22, _rx + _card_w - 14, _ty + 22);
    
            // Descricao mecânica
            draw_set_color(c_ltgray);
            var _desc_w = _card_w - 90;
            draw_text_ext(_tx, _ty + 26, _tdesc, 16, _desc_w);
    
            // Aviso de upgrade
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            if (_rank < _max_rank) {
                if (_pts >= _cost) {
                    draw_set_color(c_yellow);
                    var _upg_str = "";
                    if (input_has_gamepad_connected()) {
                        if (_hud.hud_talent_slot_cursor == _i) {
                            _upg_str = input_get_btn_label("aux") + tr(" ou ") + input_get_btn_label("confirm") + tr(" Evoluir (-") + string(_cost) + tr(" pts)");
                        } else {
                            _upg_str = tr("Custo: ") + string(_cost) + tr(" pts");
                        }
                    } else {
                        _upg_str = tr("Aperte [") + string(_i + 1) + tr("] para Evoluir (-") + string(_cost) + tr(" pts)");
                    }
                    draw_text(_rx + _card_w - 14, _cy + _card_h - 6, _upg_str);
                } else {
                    draw_set_color(make_colour_rgb(170, 180, 200));
                    draw_text(_rx + _card_w - 14, _cy + _card_h - 6, tr("Custo: ") + string(_cost) + tr(" pts (") + string(_pts) + tr(" disponíveis)"));
                }
            } else {
                draw_set_color(make_colour_rgb(100, 220, 140));
                draw_text(_rx + _card_w - 14, _cy + _card_h - 6, tr("TALENTO MAXIMIZADO"));
            }
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    
        // ================= RODAPE =================
        draw_set_color(make_colour_rgb(45, 60, 90));
        draw_line(_win_x + 20, _footer_y, _win_x + _win_w - 20, _footer_y);
    
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _f_center_y = _footer_y + 20;
    
        var _ret_str = _is_mobile ? tr("Retomar") : (input_is_gamepad_active() ? (input_get_btn_label("cancel") + " / " + input_get_btn_label("pause") + tr(" Retomar")) : tr("[ESC] Retomar"));
        var _ret_w = max(150, string_width(_ret_str) + 32);
        var _ret_h = 32;
        var _ret_x = _win_x + 30;
        var _ret_y = _footer_y + 5;
        draw_set_color(make_colour_rgb(28, 40, 62));
        draw_rectangle(_ret_x, _ret_y, _ret_x + _ret_w, _ret_y + _ret_h, false);
        draw_set_color(c_yellow);
        draw_rectangle(_ret_x, _ret_y, _ret_x + _ret_w, _ret_y + _ret_h, true);
        draw_set_color(c_white);
        var _ret_tw = max(1, string_width(_ret_str));
        var _ret_scale = min(1.0, (_ret_w - 20) / _ret_tw);
        draw_text_transformed(_ret_x + _ret_w / 2, _ret_y + _ret_h / 2, _ret_str, _ret_scale, _ret_scale, 0);
    
        var _men_str = _is_mobile ? tr("Abandonar Run") : (input_has_gamepad_connected() ? tr("[Select / M] Abandonar Run") : tr("[M] Abandonar Run (Menu)"));
        var _men_w = max(310, string_width(_men_str) + 40);
        var _men_h = 32;
        var _men_x = _win_x + _win_w / 2 - _men_w / 2;
        var _men_y = _footer_y + 5;
        draw_set_color(make_colour_rgb(28, 40, 62));
        draw_rectangle(_men_x, _men_y, _men_x + _men_w, _men_y + _men_h, false);
        draw_set_color(make_colour_rgb(70, 95, 135));
        draw_rectangle(_men_x, _men_y, _men_x + _men_w, _men_y + _men_h, true);
        draw_set_color(c_ltgray);
        var _men_tw = max(1, string_width(_men_str));
        var _men_scale = min(1.0, (_men_w - 24) / _men_tw);
        draw_text_transformed(_men_x + _men_w / 2, _men_y + _men_h / 2, _men_str, _men_scale, _men_scale, 0);
    
        if (!_is_mobile) {
            draw_set_halign(fa_right);
            draw_set_color(c_gray);
            draw_text(_win_x + _win_w - 30, _f_center_y, tr("[Q] Sair"));
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
}

