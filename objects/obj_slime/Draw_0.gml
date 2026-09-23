// Aviso de investida (linha = investida)
if (state == "lunge_windup") {
    elem_draw_warning_line(x, y, lunge_dir, 110, 14, c_aqua);
}
// Fio de agua entre os minis: mate um antes que se reunam
if (is_mini && instance_exists(partner) && id < partner.id) {
    var _urg = (merge_timer <= 0) ? 1 : clamp(1 - merge_timer / 3, 0, 1);
    draw_set_alpha(0.25 + 0.5 * _urg);
    draw_set_color(c_aqua);
    draw_line_width(x, y, partner.x, partner.y, 1 + 2 * _urg);
    draw_set_alpha(1);
}
event_inherited();
