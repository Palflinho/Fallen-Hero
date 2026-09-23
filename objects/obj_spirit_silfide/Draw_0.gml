if (state == "dash_windup") {
    elem_draw_warning_line(x, y, dash_dir, 680 * 0.38, body_radius * 2, c_white);
}
if (state == "vortex" || state == "vortex_windup") {
    var _spin = current_time * 0.6;
    draw_set_alpha(0.3);
    draw_set_color(c_white);
    for (var _v = 0; _v < 8; _v++) {
        var _va = _spin + _v * 45;
        draw_line(x + lengthdir_x(40, _va), y + lengthdir_y(40, _va), x + lengthdir_x(150, _va + 50), y + lengthdir_y(150, _va + 50));
    }
    draw_set_alpha(0.12);
    draw_circle(x, y, 320, true);
    draw_set_alpha(1);
}
// Lamina Espectral enxerga o invisivel
var _saved_alpha = draw_alpha;
if (player_is_archetype(instance_find(obj_player, 0), "assassin", "water")) draw_alpha = max(draw_alpha, 0.6);
event_inherited();
draw_alpha = _saved_alpha;
if (state == "exposed") spirit_draw_exposed();
