// =========================================================================
// ENSINO SEM TUTORIAL (estilo World 1-1)
//  - Bonecos de treino na vila: um parado (ataque) e um que ataca (defesa/esquiva).
//  - Selos: rastro de luz ate o portal, que ganha 4 luzes (uma por selo).
//  - Dicas de "primeira vez" (ex.: ficha de talentos), salvas no meta do slot.
// =========================================================================

function tutorial_ensure() {
    if (!variable_global_exists("meta_tutorial") || !is_struct(global.meta_tutorial)) global.meta_tutorial = {};
}

function tutorial_done(_key) {
    tutorial_ensure();
    return variable_struct_exists(global.meta_tutorial, _key) && global.meta_tutorial[$ _key];
}

function tutorial_mark(_key) {
    if (tutorial_done(_key)) return;
    ensure_meta_loaded();
    tutorial_ensure();
    global.meta_tutorial[$ _key] = true;
    save_meta();
}

// Balao com o botao (que muda conforme teclado / Xbox / PlayStation / toque) e a acao.
// Desenhado no mundo, centralizado em (_x, _y).
function tutorial_draw_key_hint(_x, _y, _action, _text, _alpha) {
    if (_alpha <= 0.01) return;
    var _key = input_get_btn_label(_action);
    var _bob = sin(current_time * 0.006) * 2;
    var _y2 = _y + _bob;

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var _kw = string_width(_key) + 12;
    var _tw = string_width(_text);
    var _w = _kw + 8 + _tw + 12;
    var _x0 = _x - _w / 2;

    draw_set_alpha(0.85 * _alpha);
    draw_set_color(make_colour_rgb(14, 18, 28));
    draw_rectangle(_x0, _y2 - 13, _x0 + _w, _y2 + 13, false);
    draw_set_alpha(_alpha);
    draw_set_color(make_colour_rgb(70, 90, 130));
    draw_rectangle(_x0, _y2 - 13, _x0 + _w, _y2 + 13, true);

    // Tecla
    draw_set_color(make_colour_rgb(250, 220, 90));
    draw_rectangle(_x0 + 4, _y2 - 10, _x0 + 4 + _kw, _y2 + 10, false);
    draw_set_color(make_colour_rgb(30, 24, 8));
    draw_text(_x0 + 10, _y2, _key);

    // Acao
    draw_set_color(c_white);
    draw_text(_x0 + _kw + 12, _y2, _text);

    // Setinha apontando para baixo
    draw_set_color(make_colour_rgb(250, 220, 90));
    draw_triangle(_x - 5, _y2 + 14, _x + 5, _y2 + 14, _x, _y2 + 20, false);

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
