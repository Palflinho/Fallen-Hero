// Balcao de madeira rustica
draw_set_color(make_colour_rgb(85, 55, 35));
draw_rectangle(x - 36, y - 16, x + 36, y + 16, false);
draw_set_color(make_colour_rgb(140, 95, 60));
draw_rectangle(x - 36, y - 16, x + 36, y + 16, true);

// Toldo mistico do mercador
draw_set_color(make_colour_rgb(60, 20, 90));
draw_rectangle(x - 40, y - 38, x + 40, y - 16, false);
draw_set_color(c_yellow);
draw_rectangle(x - 40, y - 18, x + 40, y - 15, false);

// Lanternas laterais
var _pulse = 0.5 + 0.5 * sin(lantern_timer * 5);
draw_set_alpha(0.3 + 0.2 * _pulse);
draw_set_color(c_orange);
draw_circle(x - 36, y - 10, 14, false);
draw_circle(x + 36, y - 10, 14, false);
draw_set_alpha(1);
draw_set_color(c_yellow);
draw_circle(x - 36, y - 10, 4, false);
draw_circle(x + 36, y - 10, 4, false);

// Figura do Mercador
draw_set_color(make_colour_rgb(25, 35, 60));
draw_circle(x, y - 2, 13, false);
draw_set_color(c_yellow);
draw_circle(x - 3, y - 5, 2, false);
draw_circle(x + 3, y - 5, 2, false);

// Prompt flutuante
if (prompt_active && !global.midrun_shop_open) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var _py = y - 48 + 3 * sin(current_time / 100);

    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(15, 20, 32));
    draw_rectangle(x - 120, _py - 22, x + 120, _py + 4, false);
    draw_set_alpha(1);

    draw_set_color(c_yellow);
    draw_rectangle(x - 120, _py - 22, x + 120, _py + 4, true);
    var _interact_str = input_get_btn_label("confirm") + tr(" Falar com o Mercador");
    draw_text(x, _py, _interact_str);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
