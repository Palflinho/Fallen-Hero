// =========================================================================
// OPCOES DO JOGO (settings.ini, valem para todos os slots de save)
// Idioma, tela cheia, volumes (geral / efeitos / musica, 0 a 10),
// tremor de tela e vibracao do controle.
// =========================================================================

function settings_defaults() {
    global.opt_fullscreen = false;
    global.opt_vol_master = 10;
    global.opt_vol_sfx = 8;
    global.opt_vol_music = 7;   // usado quando a musica entrar no jogo
    global.opt_screen_shake = true;
    global.opt_rumble = true;
}

function settings_load() {
    if (variable_global_exists("settings_loaded") && global.settings_loaded) return;
    global.settings_loaded = true;
    settings_defaults();
    var _lang = variable_global_exists("game_language") ? global.game_language : "pt";
    if (file_exists("settings.ini")) {
        ini_open("settings.ini");
        _lang = ini_read_string("settings", "language", _lang);
        global.opt_fullscreen = ini_read_real("settings", "fullscreen", 0) > 0;
        global.opt_vol_master = clamp(ini_read_real("settings", "vol_master", 10), 0, 10);
        global.opt_vol_sfx = clamp(ini_read_real("settings", "vol_sfx", 8), 0, 10);
        global.opt_vol_music = clamp(ini_read_real("settings", "vol_music", 7), 0, 10);
        global.opt_screen_shake = ini_read_real("settings", "screen_shake", 1) > 0;
        global.opt_rumble = ini_read_real("settings", "rumble", 1) > 0;
        ini_close();
    }
    global.game_language = (_lang == "en") ? "en" : "pt";
    settings_apply();
}

function settings_save() {
    if (!variable_global_exists("opt_vol_master")) settings_defaults();
    ini_open("settings.ini");
    ini_write_string("settings", "language", loc_get_language());
    ini_write_real("settings", "fullscreen", global.opt_fullscreen ? 1 : 0);
    ini_write_real("settings", "vol_master", global.opt_vol_master);
    ini_write_real("settings", "vol_sfx", global.opt_vol_sfx);
    ini_write_real("settings", "vol_music", global.opt_vol_music);
    ini_write_real("settings", "screen_shake", global.opt_screen_shake ? 1 : 0);
    ini_write_real("settings", "rumble", global.opt_rumble ? 1 : 0);
    ini_close();
}

function settings_apply() {
    if (!variable_global_exists("opt_vol_master")) settings_defaults();
    if (os_type == os_windows || os_type == os_macosx || os_type == os_linux) {
        if (window_get_fullscreen() != global.opt_fullscreen) window_set_fullscreen(global.opt_fullscreen);
    }
    audio_master_gain(global.opt_vol_master / 10);
}

// Multiplicadores usados pelo audio (0..1)
function settings_sfx_gain() {
    if (!variable_global_exists("opt_vol_sfx")) return 1;
    return global.opt_vol_sfx / 8; // 8 = volume padrao original dos efeitos
}

function settings_music_gain() {
    if (!variable_global_exists("opt_vol_music")) return 0.7;
    return global.opt_vol_music / 10;
}

function settings_shake_enabled() {
    return !variable_global_exists("opt_screen_shake") || global.opt_screen_shake;
}

function settings_rumble_enabled() {
    return !variable_global_exists("opt_rumble") || global.opt_rumble;
}

// -------------------------------------------------------------------------
// TELA DE OPCOES (obj_char_select, estado "options") - roda no escopo do obj_char_select
// -------------------------------------------------------------------------
function char_select_refresh_texts() {
    main_menu_options = [tr("Novo Jogo"), tr("Continuar"), tr("Opcoes"), tr("Sair")];
    labels = [tr("Cavaleiro"), tr("Mago"), tr("Arqueiro"), tr("Assassino")];
}

function options_row_rect(_i) {
    var _w = 660;
    var _x = (room_width - _w) / 2;
    var _y = 140 + _i * 58;
    return [_x, _y, _x + _w, _y + 50];
}

// _dir: -1 (esquerda), +1 (direita), 0 (confirmar)
function options_change(_row, _dir) {
    var _step = (_dir == 0) ? 1 : _dir;
    switch (_row) {
        case 0:
            loc_next_language();
            char_select_refresh_texts();
            break;
        case 1: global.opt_fullscreen = !global.opt_fullscreen; break;
        case 2: global.opt_vol_master = (_dir == 0) ? ((global.opt_vol_master + 1) mod 11) : clamp(global.opt_vol_master + _step, 0, 10); break;
        case 3: global.opt_vol_sfx = (_dir == 0) ? ((global.opt_vol_sfx + 1) mod 11) : clamp(global.opt_vol_sfx + _step, 0, 10); break;
        case 4: global.opt_vol_music = (_dir == 0) ? ((global.opt_vol_music + 1) mod 11) : clamp(global.opt_vol_music + _step, 0, 10); break;
        case 5: global.opt_screen_shake = !global.opt_screen_shake; break;
        case 6:
            global.opt_rumble = !global.opt_rumble;
            if (global.opt_rumble) input_rumble(0.4, 0.4, 0.2);
            break;
        case 7:
            if (_dir == 0) state = "controls";
            return;
        case 8:
            if (_dir == 0) { settings_save(); state = "main_menu"; }
            return;
    }
    settings_apply();
    settings_save();
    sfx_play("menu_select", 0.05, 1.2);
}

function char_select_options_step() {
    if (!variable_global_exists("opt_vol_master")) settings_load();
    if (input_check_ui_up_pressed()) options_cursor = (options_cursor - 1 + options_count) mod options_count;
    if (input_check_ui_down_pressed()) options_cursor = (options_cursor + 1) mod options_count;
    if (input_check_ui_left_pressed()) options_change(options_cursor, -1);
    else if (input_check_ui_right_pressed()) options_change(options_cursor, 1);
    else if (input_check_ui_confirm()) options_change(options_cursor, 0);
    else if (input_check_ui_cancel()) {
        settings_save();
        state = "main_menu";
        return;
    }

    for (var _i = 0; _i < options_count; _i++) {
        var _r = options_row_rect(_i);
        if (touch_room_clicked(_r[0], _r[1], _r[2], _r[3])) {
            options_cursor = _i;
            var _mx = mouse_x;
            if (_i >= 7) options_change(_i, 0);
            else options_change(_i, (_mx < (_r[0] + _r[2]) / 2 + 60) ? -1 : 1);
            break;
        }
    }
}

function options_value_text(_row) {
    switch (_row) {
        case 0: return loc_get_language_label();
        case 1: return global.opt_fullscreen ? tr("Ligada") : tr("Desligada");
        case 2: return string(global.opt_vol_master * 10) + "%";
        case 3: return string(global.opt_vol_sfx * 10) + "%";
        case 4: return string(global.opt_vol_music * 10) + "%";
        case 5: return global.opt_screen_shake ? tr("Ligado") : tr("Desligado");
        case 6: return global.opt_rumble ? tr("Ligada") : tr("Desligada");
    }
    return "";
}

function char_select_options_draw() {
    if (!variable_global_exists("opt_vol_master")) settings_load();
    var _names = [tr("Idioma"), tr("Tela cheia"), tr("Volume geral"), tr("Volume dos efeitos"), tr("Volume da musica"),
                  tr("Tremor de tela"), tr("Vibracao do controle"), tr("Controles"), tr("Voltar")];

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text_transformed(room_width / 2, 80, tr("OPCOES"), 2, 2, 0);

    for (var _i = 0; _i < options_count; _i++) {
        var _r = options_row_rect(_i);
        var _sel = (_i == options_cursor);
        var _cy = (_r[1] + _r[3]) / 2;

        draw_set_alpha(0.9);
        draw_set_color(_sel ? make_colour_rgb(34, 48, 76) : make_colour_rgb(16, 20, 30));
        draw_rectangle(_r[0], _r[1], _r[2], _r[3], false);
        draw_set_alpha(1);
        draw_set_color(_sel ? c_yellow : make_colour_rgb(55, 70, 95));
        draw_rectangle(_r[0], _r[1], _r[2], _r[3], true);

        if (_i >= 7) {
            draw_set_halign(fa_center);
            draw_set_color(_sel ? c_yellow : c_white);
            draw_text_transformed((_r[0] + _r[2]) / 2, _cy, _names[_i], 1.15, 1.15, 0);
            continue;
        }

        draw_set_halign(fa_left);
        draw_set_color(_sel ? c_yellow : c_white);
        draw_text_transformed(_r[0] + 22, _cy, _names[_i], 1.1, 1.1, 0);

        var _vx = _r[2] - 150;
        if (_i >= 2 && _i <= 4) {
            // Barra de volume com 10 segmentos
            var _v = (_i == 2) ? global.opt_vol_master : ((_i == 3) ? global.opt_vol_sfx : global.opt_vol_music);
            var _bx = _r[2] - 290;
            for (var _s = 0; _s < 10; _s++) {
                draw_set_color((_s < _v) ? make_colour_rgb(110, 200, 255) : make_colour_rgb(40, 50, 70));
                draw_rectangle(_bx + _s * 13, _cy - 8, _bx + _s * 13 + 10, _cy + 8, false);
            }
        }
        draw_set_halign(fa_center);
        draw_set_color(_sel ? c_yellow : make_colour_rgb(190, 210, 235));
        draw_text(_vx + 70, _cy, "<  " + options_value_text(_i) + "  >");
    }

    draw_set_halign(fa_center);
    draw_set_color(make_colour_rgb(160, 170, 185));
    draw_text(room_width / 2, room_height - 40, tr("Setas: Navegar e Ajustar   |   Enter: Confirmar   |   ESC: Voltar"));
}

function char_select_controls_draw() {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text_transformed(room_width / 2, 80, tr("CONTROLES"), 2, 2, 0);

    var _rows = [
        [tr("Mover"), "W A S D / " + tr("Setas"), tr("Analogico / D-Pad")],
        [tr("Atacar"), "Z / J", "A / " + tr("Cruz")],
        [tr("Defesa / Especial"), "X / K / " + tr("Espaco"), "X / " + tr("Quadrado")],
        [tr("Ficha e Talentos / Pausa"), "T / ESC", "Start"],
        [tr("Confirmar"), "Enter / Z / " + tr("Espaco"), "A / " + tr("Cruz")],
        [tr("Voltar / Cancelar"), "ESC / X", "B / " + tr("Circulo")],
        [tr("Evoluir talento"), "1 - 5", "Y / " + tr("Triangulo")],
        [tr("Interagir"), "Enter / Z", "A / " + tr("Cruz")]
    ];

    var _x0 = room_width / 2 - 360;
    var _y = 150;
    draw_set_color(make_colour_rgb(150, 190, 230));
    draw_set_halign(fa_left);
    draw_text(_x0, _y, tr("ACAO"));
    draw_text(_x0 + 300, _y, tr("TECLADO"));
    draw_text(_x0 + 540, _y, tr("CONTROLE"));
    _y += 36;
    for (var _i = 0; _i < array_length(_rows); _i++) {
        draw_set_color(make_colour_rgb(40, 52, 76));
        draw_line(_x0, _y - 18, _x0 + 720, _y - 18);
        draw_set_color(c_white);
        draw_text(_x0, _y, _rows[_i][0]);
        draw_set_color(c_yellow);
        draw_text(_x0 + 300, _y, _rows[_i][1]);
        draw_set_color(make_colour_rgb(160, 230, 170));
        draw_text(_x0 + 540, _y, _rows[_i][2]);
        _y += 48;
    }

    draw_set_halign(fa_center);
    draw_set_color(make_colour_rgb(160, 170, 185));
    draw_text(room_width / 2, room_height - 40, tr("ESC / Enter: Voltar"));
}
