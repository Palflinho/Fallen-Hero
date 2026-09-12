if (target == noone || !instance_exists(target)) {
    target = instance_find(obj_player, 0);
    if (target == noone) exit;
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = pad;
var _y = pad + 16;

// Archetype Name
var _hero_title = string_upper(target.character_class);
if (variable_instance_exists(target, "archetype_name") && target.archetype_name != "") {
    _hero_title = string_upper(target.archetype_name);
}
draw_set_color(c_yellow);
draw_text(_x, _y - 18, _hero_title);
draw_set_color(c_white);

// HP
draw_set_color(c_black);
draw_rectangle(_x - 2, _y - 2, _x + bar_w + 2, _y + bar_h + 2, false);
draw_set_color(c_red);
draw_rectangle(_x, _y, _x + bar_w * (target.hp / target.hp_max), _y + bar_h, false);

// Paladin Overlife Barrier overlay
if (variable_instance_exists(target, "paladin_barrier_active") && target.paladin_barrier_active > 0) {
    draw_set_alpha(0.5);
    draw_set_color(c_aqua);
    var _bar_ratio = min(1, target.paladin_barrier_active / target.hp_max);
    draw_rectangle(_x, _y, _x + bar_w * _bar_ratio, _y + bar_h, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
var _hp_str = "HP " + string(max(0, round(target.hp))) + "/" + string(round(target.hp_max));
if (variable_instance_exists(target, "paladin_barrier_active") && target.paladin_barrier_active > 0) {
    _hp_str += " (+" + string(round(target.paladin_barrier_active)) + ")";
}
draw_text(_x + 4, _y + 1, _hp_str);

_y += bar_h + bar_gap;

// Level / EXP
draw_set_color(c_black);
draw_rectangle(_x - 2, _y - 2, _x + bar_w + 2, _y + bar_h + 2, false);
draw_set_color(c_yellow);
draw_rectangle(_x, _y, _x + bar_w * (target.xp / target.xp_to_next), _y + bar_h, false);
draw_set_color(c_white);
draw_text(_x + 4, _y + 1, "Nv " + string(target.level) + "  " + string(round(target.xp)) + "/" + string(round(target.xp_to_next)) + " EXP");

_y += bar_h + bar_gap;

// Special ability cooldown / active
var _skill_name = "Habilidade";
if (target.defend_mode == "paladin_aura") _skill_name = "Aura Sobrevida";
else if (target.defend_mode == "berserk_fury") _skill_name = "Furia Ardente";
else if (target.defend_mode == "parry") _skill_name = "Aparar (Parry)";
else if (target.defend_mode == "guardian_aegis") _skill_name = "Bastiao";
else if (target.defend_mode == "block") _skill_name = "Bloqueio";
else if (target.defend_mode == "manashield") _skill_name = "Escudo Magico";
else if (target.defend_mode == "roll") _skill_name = "Rolamento";
else if (target.defend_mode == "invisible") _skill_name = "Invisibilidade";

if (target.state == "defend" && target.defend_active) {
    draw_set_color(c_lime);
    draw_text(_x, _y, _skill_name + ": ATIVA (" + string(round(target.defend_timer * 10) / 10) + "s)");
    draw_set_color(c_white);
} else if (target.defend_cooldown_timer > 0) {
    draw_set_color(c_ltgray);
    draw_text(_x, _y, _skill_name + ": " + string(round(target.defend_cooldown_timer * 10) / 10) + "s");
    draw_set_color(c_white);
} else {
    draw_set_color(c_yellow);
    draw_text(_x, _y, _skill_name + ": pronta [X]");
    draw_set_color(c_white);
}

_y += 20;

if (target.talent_pending_points > 0) {
    var _pulse = 0.65 + 0.35 * abs(sin(current_time * 0.006));
    draw_set_color(merge_colour(c_yellow, c_white, _pulse));
    draw_text(_x, _y, "★ PONTOS DISPONIVEIS: " + string(target.talent_pending_points) + " [ESC / T]");
    draw_set_color(c_white);
    _y += 20;
} else {
    draw_set_color(c_ltgray);
    draw_text(_x, _y, "Ficha / Pausa: [ESC / T]");
    draw_set_color(c_white);
    _y += 20;
}

// Low HP red vignette
if (target.hp / target.hp_max <= 0.3) {
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
if (!boss_room) {
    draw_text(_x, _y + bar_gap, "Botoes: " + string(global.boss_buttons_pressed) + "/4");
}

if (boss_room) {
    var _boss = instance_find(obj_boss, 0);
    if (_boss == noone) _boss = instance_find(obj_boss2, 0);
    if (_boss != noone) {
        var _bw = 500;
        var _bh = 26;
        var _bx = display_get_gui_width() / 2 - _bw / 2;
        var _by = 24;
        var _boss_name = (_boss.object_index == obj_boss2) ? "GENERAL MAGMA" : "GUARDIAO DAS AGUAS";

        draw_set_color(c_black);
        draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + _bh + 2, false);
        draw_set_color(_boss.vulnerable ? c_lime : c_maroon);
        draw_rectangle(_bx, _by, _bx + _bw * (_boss.hp / _boss.hp_max), _by + _bh, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bx + _bw / 2, _by + _bh / 2, _boss.vulnerable ? (_boss_name + " - VULNERAVEL!") : _boss_name);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

if (game_over) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

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
    draw_text(_bx + _box_w / 2, _by + 24, "VOCE FOI DERROTADO");

    draw_set_color(c_ltgray);
    draw_text(_bx + _box_w / 2, _by + 52, "Sua jornada nesta masmorra chegou ao fim.");

    // Divisor
    draw_set_color(make_colour_rgb(70, 30, 40));
    draw_line(_bx + 30, _by + 80, _bx + _box_w - 30, _by + 80);

    // Extrato de Ouro da Partida (60% retido)
    var _ry = _by + 98;
    draw_set_halign(fa_left);

    draw_set_color(c_white);
    draw_text(_bx + 50, _ry, "Ouro obtido nesta partida:");
    draw_set_halign(fa_right);
    draw_set_color(c_yellow);
    draw_text(_bx + _box_w - 50, _ry, "+" + string(death_gold_earned) + " Ouro");
    _ry += 30;

    draw_set_halign(fa_left);
    draw_set_color(make_colour_rgb(240, 95, 95));
    draw_text(_bx + 50, _ry, "Penalidade por Morte (40%):");
    draw_set_halign(fa_right);
    draw_text(_bx + _box_w - 50, _ry, "-" + string(death_gold_lost) + " Ouro");
    _ry += 30;

    draw_set_halign(fa_left);
    draw_set_color(make_colour_rgb(80, 220, 120));
    draw_text(_bx + 50, _ry, "Ouro resgatado ao cofre (60%):");
    draw_set_halign(fa_right);
    draw_text(_bx + _box_w - 50, _ry, "+" + string(death_gold_kept) + " Ouro");
    _ry += 34;

    // Divisor
    draw_set_color(make_colour_rgb(70, 30, 40));
    draw_line(_bx + 30, _ry, _bx + _box_w - 30, _ry);
    _ry += 16;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_bx + 50, _ry, "Saldo Atual no Cofre:");
    draw_set_halign(fa_right);
    draw_set_color(c_yellow);
    draw_text(_bx + _box_w - 50, _ry, string(global.gold) + " Ouro");
    _ry += 40;

    // Botoes de Acao
    draw_set_halign(fa_center);
    var _pulse = 0.6 + 0.4 * abs(sin(current_time * 0.006));
    draw_set_color(merge_colour(c_yellow, c_white, _pulse));
    draw_text(_bx + _box_w / 2, _ry, "[ESPACO / ENTER / Z] Voltar para Selecao de Personagem");
    _ry += 26;

    draw_set_color(c_ltgray);
    draw_text(_bx + _box_w / 2, _ry, "[R] Tentar Novamente (Teste)   -   [M] Menu Principal");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
} else if (level_complete || (variable_global_exists("run_victory") && global.run_victory)) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

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
    draw_text_transformed(_bx + _box_w / 2, _by + 36, "EXPEDICAO CONCLUIDA COM SUCESSO!", 1.35, 1.35, 0);

    draw_set_color(make_colour_rgb(140, 210, 255));
    draw_text(_bx + _box_w / 2, _by + 68, "As Forcas da Agua e do Fogo foram Dominadas!");

    draw_set_color(make_colour_rgb(60, 85, 125));
    draw_line(_bx + 30, _by + 92, _bx + _box_w - 30, _by + 92);

    // Dados da Partida
    var _sy = _by + 118;
    draw_set_halign(fa_left);

    var _p_class = (target != noone) ? target.character_class : "Heroi";
    var _p_arch = (target != noone && variable_instance_exists(target, "archetype_name")) ? target.archetype_name : "Guerreiro";
    var _p_lvl = (target != noone) ? target.level : 1;

    draw_set_color(c_white);
    draw_text(_bx + 50, _sy, "Heroi:");
    draw_set_halign(fa_right);
    draw_set_color(c_yellow);
    draw_text(_bx + _box_w - 50, _sy, string_upper(_p_class) + " (" + _p_arch + ")");
    _sy += 28;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_bx + 50, _sy, "Nivel Final:");
    draw_set_halign(fa_right);
    draw_set_color(c_aqua);
    draw_text(_bx + _box_w - 50, _sy, "Nivel " + string(_p_lvl));
    _sy += 28;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_bx + 50, _sy, "Ouro Resgatado:");
    draw_set_halign(fa_right);
    draw_set_color(c_yellow);
    draw_text(_bx + _box_w - 50, _sy, "+" + string(global.gold) + " Ouro");
    _sy += 28;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_bx + 50, _sy, "Afinidades Desbloqueadas:");
    draw_set_halign(fa_right);
    draw_set_color(make_colour_rgb(100, 240, 160));
    draw_text(_bx + _box_w - 50, _sy, "Agua e Fogo Desbloqueados!");
    _sy += 38;

    // Linha divisoria
    draw_set_color(make_colour_rgb(60, 85, 125));
    draw_line(_bx + 30, _sy, _bx + _box_w - 30, _sy);
    _sy += 24;

    // Botao de Retorno
    draw_set_halign(fa_center);
    var _b_pulse = 0.6 + 0.4 * abs(sin(current_time * 0.007));
    draw_set_color(merge_colour(c_yellow, c_white, _b_pulse));
    draw_text(_bx + _box_w / 2, _sy, "[ESPACO / ENTER / Z] Retornar a Selecao de Personagens");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
} else if (global.chest_reward_open) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Fundo escurecido semitransparente permitindo ver o jogo congelado
    draw_set_alpha(0.86);
    draw_set_color(make_colour_rgb(10, 14, 22));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // Janela Modal do Bau
    var _win_w = min(880, _gw - 40);
    var _win_h = min(530, _gh - 30);
    var _win_x = (_gw - _win_w) / 2;
    var _win_y = (_gh - _win_h) / 2;

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
    draw_text(_win_x + _win_w / 2, _win_y + 16, "*  BAU DE TESOURO ABERTO!  *");

    draw_set_color(c_ltgray);
    draw_text(_win_x + _win_w / 2, _win_y + 38, "Voce encontrou um novo talento! Escolha um slot para equipar ou descarte-o.");

    draw_set_color(make_colour_rgb(60, 50, 30));
    draw_line(_win_x + 30, _win_y + 60, _win_x + _win_w - 30, _win_y + 60);

    // ================= CARD DO NOVO TALENTO ENCONTRADO =================
    var _found_def = get_talent_def_by_id(global.chest_reward_talent_id);
    var _found_label = is_undefined(_found_def) ? global.chest_reward_talent_id : _found_def.label;
    var _found_icon = is_undefined(_found_def) ? "sword" : talent_get_icon_type(_found_def);
    var _found_desc_val = is_undefined(_found_def) ? "" : talent_get_desc_value(_found_def);
    var _found_desc_flv = is_undefined(_found_def) ? "" : talent_get_desc_flavor(_found_def);

    var _card_top_x = _win_x + 30;
    var _card_top_y = _win_y + 72;
    var _card_top_w = _win_w - 60;
    var _card_top_h = 104;

    // Fundo do card de destaque
    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(22, 30, 46));
    draw_rectangle(_card_top_x, _card_top_y, _card_top_x + _card_top_w, _card_top_y + _card_top_h, false);
    draw_set_alpha(1);
    draw_set_color(make_colour_rgb(215, 170, 50));
    draw_rectangle(_card_top_x, _card_top_y, _card_top_x + _card_top_w, _card_top_y + _card_top_h, true);

    // Icone do talento encontrado
    var _icon_box_x = _card_top_x + 16;
    var _icon_box_y = _card_top_y + 18;
    var _icon_box_s = 68;
    draw_set_color(make_colour_rgb(14, 18, 28));
    draw_rectangle(_icon_box_x, _icon_box_y, _icon_box_x + _icon_box_s, _icon_box_y + _icon_box_s, false);
    draw_set_color(make_colour_rgb(215, 170, 50));
    draw_rectangle(_icon_box_x, _icon_box_y, _icon_box_x + _icon_box_s, _icon_box_y + _icon_box_s, true);
    draw_talent_icon(_found_icon, _icon_box_x + _icon_box_s / 2, _icon_box_y + _icon_box_s / 2, 38, c_yellow);

    // Textos do novo talento
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    draw_text(_card_top_x + 100, _card_top_y + 14, "NOVO TALENTO ENCONTRADO:");

    draw_set_color(c_white);
    draw_text(_card_top_x + 100, _card_top_y + 34, _found_label);

    draw_set_color(make_colour_rgb(160, 220, 255));
    draw_text_ext(_card_top_x + 100, _card_top_y + 56, "Efeito: " + _found_desc_val, 16, _card_top_w - 120);

    if (_found_desc_flv != "") {
        draw_set_color(c_ltgray);
        draw_text_ext(_card_top_x + 100, _card_top_y + 78, _found_desc_flv, 14, _card_top_w - 120);
    }

    // ================= SLOTS COMPARATIVOS =================
    var _slots_y = _card_top_y + _card_top_h + 16;
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(_win_x + _win_w / 2, _slots_y, "SELECIONE O SLOT PARA SUBSTITUIR  (O NOVO TALENTO HERDARA O RANK DO SLOT):");

    var _col_w = (_win_w - 60 - 2 * 16) / 3;
    var _col_h = 195;
    var _cols_start_y = _slots_y + 24;

    for (var _i = 0; _i < array_length(target.talent_slot_ids); _i++) {
        var _cur_id = target.talent_slot_ids[_i];
        var _cur_rank = target.talent_slot_ranks[_i];
        var _cx = _win_x + 30 + _i * (_col_w + 16);

        // Fundo do card de slot
        draw_set_alpha(0.85);
        draw_set_color(make_colour_rgb(18, 22, 34));
        draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + _col_h, false);
        draw_set_alpha(1);
        draw_set_color(make_colour_rgb(50, 70, 100));
        draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + _col_h, true);

        // Cabecalho do Slot
        draw_set_color(make_colour_rgb(26, 34, 52));
        draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + 26, false);
        draw_set_color(c_yellow);
        draw_rectangle(_cx, _cols_start_y, _cx + _col_w, _cols_start_y + 26, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_cx + _col_w / 2, _cols_start_y + 13, "SLOT " + string(_i + 1));
        draw_set_valign(fa_top);

        // Detalhes do Talento Atual do Slot
        if (_cur_id == "") {
            draw_set_color(c_gray);
            draw_text(_cx + _col_w / 2, _cols_start_y + 55, "(Slot Vazio)");
            draw_set_color(make_colour_rgb(80, 220, 120));
            draw_text_ext(_cx + _col_w / 2, _cols_start_y + 85, "Instale diretamente com Rank " + string(_cur_rank) + "!", 16, _col_w - 24);
        } else {
            var _cur_def = get_talent_def_by_id(_cur_id);
            var _cur_label = is_undefined(_cur_def) ? _cur_id : _cur_def.label;
            var _cur_icon = is_undefined(_cur_def) ? "sword" : talent_get_icon_type(_cur_def);

            draw_talent_icon(_cur_icon, _cx + _col_w / 2, _cols_start_y + 50, 26, c_yellow);

            draw_set_color(c_white);
            draw_text(_cx + _col_w / 2, _cols_start_y + 70, _cur_label);

            draw_set_color(c_yellow);
            var _r_str = "Rank " + string(_cur_rank) + "  ";
            for (var _s = 1; _s <= 3; _s++) _r_str += (_s <= _cur_rank) ? "[X] " : "[ ] ";
            draw_text(_cx + _col_w / 2, _cols_start_y + 92, _r_str);

            draw_set_color(make_colour_rgb(240, 110, 110));
            draw_text_ext(_cx + _col_w / 2, _cols_start_y + 114, "Substituira " + _cur_label, 14, _col_w - 18);
        }

        // Botao de Acao
        var _btn_y = _cols_start_y + _col_h - 38;
        draw_set_color(make_colour_rgb(30, 45, 70));
        draw_rectangle(_cx + 10, _btn_y, _cx + _col_w - 10, _btn_y + 28, false);
        draw_set_color(c_yellow);
        draw_rectangle(_cx + 10, _btn_y, _cx + _col_w - 10, _btn_y + 28, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_cx + _col_w / 2, _btn_y + 14, "[Aperte " + string(_i + 1) + " para Equipar]");
        draw_set_valign(fa_top);
    }

    // ================= RODAPE DO BAU =================
    var _footer_y = _win_y + _win_h - 40;
    draw_set_color(make_colour_rgb(60, 50, 30));
    draw_line(_win_x + 30, _footer_y, _win_x + _win_w - 30, _footer_y);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_colour_rgb(240, 95, 95));
    draw_text(_win_x + _win_w / 2, _footer_y + 18, "[X ou ESC] Descartar este Talento e Continuar a Partida");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
} else if (global.paused || global.attr_window_open) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Fundo semitransparente escurecido permitindo vislumbre do jogo pausado
    draw_set_alpha(0.86);
    draw_set_color(make_colour_rgb(10, 14, 22));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // Dimensoes da Janela Modal
    var _win_w = min(960, _gw - 40);
    var _win_h = min(540, _gh - 30);
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
    draw_text(_win_x + 24, _win_y + 16, "PAUSADO  -  FICHA DO HEROI");

    draw_set_halign(fa_right);
    draw_set_color(c_ltgray);
    draw_text(_win_x + _win_w - 24, _win_y + 16, "Pressione [ESC] ou [T] para Retomar");

    // Linha divisoria do cabecalho
    draw_set_color(make_colour_rgb(45, 60, 90));
    draw_line(_win_x + 20, _win_y + 40, _win_x + _win_w - 20, _win_y + 40);

    // Dimensoes dos dois paineis
    var _panel_gap = 16;
    var _left_w = 360;
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
    draw_text(_lx, _ly, "Nivel " + string(target.level) + "   (EXP: " + string(round(target.xp)) + " / " + string(round(target.xp_to_next)) + ")");
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
    // 1. HP
    var _hp_val = string(max(0, round(target.hp))) + " / " + string(round(target.hp_max));
    if (variable_instance_exists(target, "paladin_barrier_active") && target.paladin_barrier_active > 0) {
        _hp_val += "  (+" + string(round(target.paladin_barrier_active)) + ")";
    }
    draw_set_color(make_colour_rgb(240, 80, 80));
    draw_text(_lx, _ly, "[HP] Vida:");
    draw_set_color(c_white);
    draw_text(_lx + 130, _ly, _hp_val);
    _ly += 22;

    // 2. Poder
    var _pwr_str = string(round(target.nat_power));
    if (variable_instance_exists(target, "synth_pwr_fisica") && target.synth_pwr_fisica > 0) {
        _pwr_str += " (+" + string(target.synth_pwr_fisica) + ")";
    }
    draw_set_color(make_colour_rgb(255, 170, 40));
    draw_text(_lx, _ly, "[PWR] Poder:");
    draw_set_color(c_white);
    draw_text(_lx + 130, _ly, _pwr_str);
    _ly += 22;

    // 3. Defesa
    var _def_str = string(round(target.nat_defesa));
    if (variable_instance_exists(target, "synth_def_fisica") && target.synth_def_fisica > 0) {
        _def_str += " (+" + string(target.synth_def_fisica) + ")";
    }
    draw_set_color(make_colour_rgb(70, 160, 240));
    draw_text(_lx, _ly, "[DEF] Defesa:");
    draw_set_color(c_white);
    draw_text(_lx + 130, _ly, _def_str);
    _ly += 22;

    // 4. Velocidade de Ataque
    draw_set_color(make_colour_rgb(230, 210, 80));
    draw_text(_lx, _ly, "[ATK] Cadencia:");
    draw_set_color(c_white);
    draw_text(_lx + 130, _ly, string(round(target.nat_atk_spd * 100) / 100) + " golpes/s");
    _ly += 22;

    // 5. Velocidade de Movimento
    draw_set_color(make_colour_rgb(80, 220, 130));
    draw_text(_lx, _ly, "[VEL] Movimento:");
    draw_set_color(c_white);
    draw_text(_lx + 130, _ly, string(round(target.nat_move_spd)));
    _ly += 26;

    // Divisor
    draw_set_color(make_colour_rgb(35, 45, 70));
    draw_line(_lx, _ly, _col1_x + _left_w - 16, _ly);
    _ly += 10;

    // Sinergias Ativas (apenas o que for > 0!)
    draw_set_color(c_yellow);
    draw_text(_lx, _ly, "SINERGIAS ATIVAS:");
    _ly += 22;

    var _has_syn = false;
    draw_set_color(c_ltgray);

    if (target.synth_crit_chance > 0) {
        draw_text(_lx, _ly, "- Chance Critica: " + string(round(target.synth_crit_chance * 100)) + "%");
        _ly += 18;
        _has_syn = true;
    }
    if (target.synth_cdr > 0) {
        draw_text(_lx, _ly, "- Reducao Recarga: " + string(round(target.synth_cdr * 100)) + "%");
        _ly += 18;
        _has_syn = true;
    }
    if (target.synth_dodge > 0) {
        draw_text(_lx, _ly, "- Chance de Esquiva: " + string(round(target.synth_dodge * 100)) + "%");
        _ly += 18;
        _has_syn = true;
    }
    if (target.synth_hp_reg > 0) {
        draw_text(_lx, _ly, "- Regeneracao: +" + string(target.synth_hp_reg) + " HP/s");
        _ly += 18;
        _has_syn = true;
    }
    if (target.synth_lifesteal > 0) {
        draw_text(_lx, _ly, "- Roubo de Vida: +" + string(round(target.synth_lifesteal * 100)) + "%");
        _ly += 18;
        _has_syn = true;
    }
    if (target.synth_armor_hp > 0) {
        draw_text(_lx, _ly, "- Bonus Armadura HP: +" + string(target.synth_armor_hp));
        _ly += 18;
        _has_syn = true;
    }

    if (!_has_syn) {
        draw_set_color(make_colour_rgb(100, 115, 140));
        draw_text(_lx, _ly, "(Evolua talentos para ativar sinergias)");
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
        draw_text(_rx, _ry, "* " + string(_pts) + " PONTO(S) DISPONIVEL(EIS)!");
        draw_set_halign(fa_right);
        draw_text(_col2_x + _right_w - 16, _ry, "Pressione [1, 2 ou 3] para Evoluir");
        draw_set_halign(fa_left);
    } else {
        draw_set_color(c_white);
        draw_text(_rx, _ry, "Talentos Equipados nesta Run (3 Slots)");
        draw_set_halign(fa_right);
        draw_set_color(c_gray);
        draw_text(_col2_x + _right_w - 16, _ry, "Nenhum ponto pendente");
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

        // Borda do Card
        if (_pts > 0 && _tid != "") {
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
            draw_text(_rx + _card_w / 2, _cy + _card_h / 2, "Slot " + string(_i + 1) + ": (Vazio - Obtenha novos talentos em Baus)");
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            continue;
        }

        var _def = get_talent_def_by_id(_tid);
        var _tlabel = is_undefined(_def) ? _tid : _def.label;
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
        draw_set_color((_pts > 0) ? c_yellow : make_colour_rgb(80, 100, 140));
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

        // Pips de Rank (ex: Rank 2/3   * * -)
        draw_set_halign(fa_right);
        var _rank_str = "Rank " + string(_rank) + "  ";
        for (var _s = 1; _s <= 3; _s++) {
            _rank_str += (_s <= _rank) ? "[X] " : "[ ] ";
        }
        draw_set_color((_pts > 0) ? c_yellow : c_white);
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
        if (_pts > 0) {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(c_yellow);
            draw_text(_rx + _card_w - 14, _cy + _card_h - 6, "Aperte [" + string(_i + 1) + "] para Evoluir (+1)");
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }

    // ================= RODAPE =================
    draw_set_color(make_colour_rgb(45, 60, 90));
    draw_line(_win_x + 20, _footer_y, _win_x + _win_w - 20, _footer_y);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _f_center_y = _footer_y + 20;

    draw_set_color(c_white);
    draw_text(_win_x + _win_w / 2, _f_center_y, "[ESC / T] Retomar   -   [C] Selecao de Heroi (Teste)   -   [M] Menu Principal   -   [Q] Sair");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
