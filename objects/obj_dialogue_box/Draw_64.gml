var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _bw = min(880, _gw - 64);
var _bh = 150;
var _bx = floor((_gw - _bw) * 0.5);
var _by = floor(_gh - _bh - 32);

draw_set_font(-1);
draw_set_alpha(box_alpha);

// 1. Sombra da caixa
draw_set_colour(c_black);
draw_set_alpha(box_alpha * 0.75);
draw_rectangle(_bx + 6, _by + 6, _bx + _bw + 6, _by + _bh + 6, false);

// 2. Fundo da caixa com gradiente sutil
draw_set_alpha(box_alpha * 0.94);
var _bg_col = make_colour_rgb(12, 16, 26);
draw_set_colour(_bg_col);
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

// 3. Moldura elegante
var _border_col = (current_speaker == "general") ? make_colour_rgb(220, 60, 60) : make_colour_rgb(45, 140, 220);
draw_set_colour(_border_col);
draw_set_alpha(box_alpha);
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
draw_rectangle(_bx + 2, _by + 2, _bx + _bw - 2, _by + _bh - 2, true);

// 4. Portrait do Personagem
var _port_size = 96;
var _port_x = _bx + 18;
var _port_y = _by + 18;

// Fundo do Portrait
draw_set_colour(make_colour_rgb(20, 26, 40));
draw_rectangle(_port_x, _port_y, _port_x + _port_size, _port_y + _port_size, false);
draw_set_colour(_border_col);
draw_rectangle(_port_x, _port_y, _port_x + _port_size, _port_y + _port_size, true);

if (current_portrait != -1 && sprite_exists(current_portrait)) {
    draw_sprite_stretched(current_portrait, 0, _port_x + 4, _port_y + 4, _port_size - 8, _port_size - 8);
} else {
    // Ícone placeholder temático para General ou Mercador
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (current_speaker == "general") {
        draw_set_colour(c_red);
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, loc("boss", "CHEFE"));
    } else if (current_speaker == "merchant") {
        draw_set_colour(c_yellow);
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, loc("shop", "LOJA"));
    } else if (current_speaker == "elder") {
        draw_set_colour(c_orange);
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, loc("elder", "ANCIAO"));
    } else if (current_speaker == "human") {
        draw_set_colour(c_aqua);
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, loc("human", "HUMANO"));
    } else if (current_speaker == "blacksmith") {
        draw_set_colour(make_colour_rgb(255, 140, 50));
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, "FORJA");
    } else if (current_speaker == "alchemist") {
        draw_set_colour(make_colour_rgb(110, 230, 160));
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, "HERVAS");
    } else if (current_speaker == "scout") {
        draw_set_colour(make_colour_rgb(160, 240, 90));
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, "VIGIA");
    } else if (current_speaker == "oracle") {
        draw_set_colour(make_colour_rgb(200, 130, 255));
        draw_text(_port_x + _port_size * 0.5, _port_y + _port_size * 0.5, "ORACULO");
    }
}

// 5. Textos de Diálogo
var _text_x = _port_x + _port_size + 20;
var _text_y = _by + 16;
var _text_w = _bw - (_port_size + 50);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Nome do Falante
draw_set_colour(make_colour_rgb(255, 215, 80));
draw_text(_text_x, _text_y, current_name);

// Fala na "Língua dos Bichinhos"
if (current_alien != "") {
    draw_set_colour(make_colour_rgb(130, 220, 255));
    draw_text(_text_x, _text_y + 20, current_alien);
}

// Legenda / Tradução com Efeito Máquina de Escrever
var _visible_text = string_copy(current_text, 1, floor(typewriter_pos));
draw_set_colour(c_white);
var _body_y = (current_alien != "") ? (_text_y + 42) : (_text_y + 24);
draw_text_ext(_text_x, _body_y, _visible_text, 18, _text_w);

// 6. Indicador de Avanço / Continuar
if (typewriter_done) {
    if (sin(current_time * 0.008) > -0.3) {
        draw_set_colour(make_colour_rgb(255, 230, 100));
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_text(_bx + _bw - 18, _by + _bh - 12, loc("continue", "[Espaço / A] Continuar »"));
    }
} else {
    draw_set_colour(c_gray);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_text(_bx + _bw - 18, _by + _bh - 12, loc("accelerate", "[Acelerar]"));
}

draw_set_alpha(1.0);
