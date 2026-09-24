if (state == "delay" || state == "revelation") exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
draw_set_font(ui_font());

// Cor de fundo de cada final
var _bg = make_colour_rgb(8, 8, 14);
if (chosen == "vinganca") _bg = make_colour_rgb(40, 16, 10);
else if (chosen == "conquistador") _bg = make_colour_rgb(26, 10, 36);
else if (chosen == "sintese") _bg = make_colour_rgb(8, 32, 36);

draw_set_alpha((state == "choice") ? 0.9 : 1);
draw_set_color(_bg);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (state) {
    case "choice":
        draw_set_color(c_yellow);
        draw_text_transformed(_gw / 2, _gh / 2 - 170, tr("QUAL DE NOS E O HEROI?"), 1.8, 1.8, 0);
        draw_set_color(c_ltgray);
        draw_text(_gw / 2, _gh / 2 - 120, tr("As quatro Essencias pulsam em suas maos. O que voce vai fazer?"));

        var _cw = min(720, _gw - 60);
        var _ch = 74;
        var _cx = (_gw - _cw) / 2;
        var _cy0 = _gh / 2 - 60;
        for (var _i = 0; _i < array_length(options); _i++) {
            var _opt = options[_i];
            var _yy = _cy0 + _i * (_ch + 14);
            var _locked = (_opt.id == "sintese" && !ending_synthesis_available());
            var _sel = (_i == cursor);

            draw_set_alpha(0.92);
            draw_set_color(_sel ? make_colour_rgb(40, 50, 76) : make_colour_rgb(18, 20, 30));
            draw_rectangle(_cx, _yy, _cx + _cw, _yy + _ch, false);
            draw_set_alpha(1);
            draw_set_color(_sel ? c_yellow : make_colour_rgb(70, 80, 110));
            draw_rectangle(_cx, _yy, _cx + _cw, _yy + _ch, true);
            if (_sel) draw_rectangle(_cx - 2, _yy - 2, _cx + _cw + 2, _yy + _ch + 2, true);

            if (_locked) {
                draw_set_color(c_gray);
                draw_text_transformed(_gw / 2, _yy + 24, "? ? ?", 1.2, 1.2, 0);
                var _req = ending_synthesis_on_mastery() ? tr("Requer: ja ter visto outro final") : tr("Requer: jogar com a Maestria da classe e ja ter visto outro final");
                draw_set_color((deny_timer > 0 && _sel) ? c_red : make_colour_rgb(140, 140, 160));
                draw_text(_gw / 2, _yy + 52, _req);
            } else {
                draw_set_color(_sel ? c_yellow : c_white);
                draw_text_transformed(_gw / 2, _yy + 24, ending_txt(_opt.title), 1.2, 1.2, 0);
                draw_set_color(make_colour_rgb(180, 190, 210));
                draw_text(_gw / 2, _yy + 52, ending_txt(_opt.desc));
            }
        }

        draw_set_color(make_colour_rgb(150, 160, 180));
        draw_text(_gw / 2, _gh - 36, input_get_btn_label("confirm") + tr(" Escolher"));
        break;

    case "epilogue":
        if (page_index < array_length(pages)) {
            var _txt = ending_txt(pages[page_index]);
            var _last = (page_index == array_length(pages) - 1);
            draw_set_alpha(page_alpha);
            if (_last) {
                // Titulo do final + frase
                var _nl = string_pos("\n", _txt);
                var _title = (_nl > 0) ? string_copy(_txt, 1, _nl - 1) : _txt;
                var _sub = (_nl > 0) ? string_delete(_txt, 1, _nl) : "";
                draw_set_color(c_yellow);
                draw_text_transformed(_gw / 2, _gh / 2 - 30, _title, 2, 2, 0);
                draw_set_color(c_white);
                draw_text_ext(_gw / 2, _gh / 2 + 30, _sub, 24, min(820, _gw - 80));
            } else {
                draw_set_color(c_white);
                draw_text_ext_transformed(_gw / 2, _gh / 2, _txt, 26, min(760, _gw - 80) / 1.2, 1.2, 1.2, 0);
            }
            draw_set_alpha(1);
            if (page_alpha >= 1) {
                draw_set_color(make_colour_rgb(150, 160, 180));
                draw_text(_gw / 2, _gh - 36, input_get_btn_label("confirm") + tr(" Continuar"));
            }
        }
        break;

    case "credits":
    case "finish":
        for (var _l = 0; _l < array_length(credits); _l++) {
            var _ly = credits_y + _l * 34;
            if (_ly < -40 || _ly > _gh + 40) continue;
            var _line = credits[_l];
            var _is_head = (_l == 0);
            var _is_role = (_line != "" && string_upper(_line) == _line && !_is_head);
            draw_set_color(_is_head ? c_yellow : (_is_role ? make_colour_rgb(150, 190, 230) : c_white));
            var _sc = _is_head ? 2.2 : 1.1;
            draw_text_transformed(_gw / 2, _ly, _line, _sc, _sc, 0);
        }
        if (state == "finish") {
            draw_set_alpha(fade);
            draw_set_color(c_black);
            draw_rectangle(0, 0, _gw, _gh, false);
            draw_set_alpha(1);
        }
        break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
