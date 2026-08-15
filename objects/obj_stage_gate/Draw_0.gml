var _ready = (trigger_mode == "boss_dead")
    ? (instance_number(obj_enemy_parent) == 0)
    : (global.boss_buttons_pressed >= 4);

draw_set_alpha(_ready ? (0.5 + 0.3 * sin(current_time / 80)) : 0.15);
draw_set_color(_ready ? c_yellow : c_dkgray);
draw_circle(x, y, radius, false);
draw_set_alpha(1);

draw_set_color(c_white);
draw_circle(x, y, radius, true);

if (!_ready) {
    draw_set_halign(fa_center);
    draw_text(x, y - radius - 20, (trigger_mode == "boss_dead") ? "Derrote o chefao" : "Ative os 4 botoes");
    draw_set_halign(fa_left);
}
draw_set_color(c_white);
