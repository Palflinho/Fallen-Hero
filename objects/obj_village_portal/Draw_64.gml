if (transitioning && transition_alpha > 0) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    draw_set_alpha(transition_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    draw_set_alpha(transition_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_title);
    draw_set_colour(make_colour_rgb(180, 230, 255));
    draw_text(_gui_w / 2, _gui_h / 2, "Cruzando o Portal Dimensional...");
}
