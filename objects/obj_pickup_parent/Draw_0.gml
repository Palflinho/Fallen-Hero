var _bob = sin(bob_timer / 20) * 4;

draw_set_color(c_black);
draw_circle(x, y + _bob + 2, radius + 2, false);
draw_set_color(colour);
draw_circle(x, y + _bob, radius, false);
draw_set_color(c_white);
draw_circle(x, y + _bob, radius, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y + _bob, label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
