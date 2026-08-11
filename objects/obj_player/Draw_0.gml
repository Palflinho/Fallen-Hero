var _blend = c_white;
if (hit_flash_timer > 0) {
    _blend = merge_colour(c_white, c_red, 0.5);
} else if (poison_active) {
    _blend = c_lime;
} else if (state == "defend" && defend_active && defend_mode == "block") {
    _blend = c_yellow;
} else if (state == "defend" && defend_active && defend_mode == "manashield") {
    _blend = c_blue;
}

var _alpha = invisible ? 0.35 : 1;

if (sprite_walk != -1) {
    var _xscale = (facing_x < 0) ? -1 : 1;
    draw_sprite_ext(sprite_index, image_index, x, y, _xscale, 1, 0, _blend, _alpha);
} else {
    var _col = (_blend == c_white) ? body_colour : _blend;
    draw_set_alpha(_alpha);
    draw_set_color(_col);
    draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, false);
    draw_set_color(c_black);
    draw_rectangle(x - body_radius, y - body_radius, x + body_radius, y + body_radius, true);
    draw_set_alpha(1);

    draw_line_width(x, y, x + facing_x * body_radius * 1.6, y + facing_y * body_radius * 1.6, 3);

    if (state == "attack") {
        draw_set_color(c_white);
        draw_circle(x + facing_x * 10, y + facing_y * 10, 5, true);
    }
}

draw_set_color(c_white);
