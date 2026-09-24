// Visualizacao de colisoes [F7]
if (show_collisions) {
    draw_set_alpha(0.8);
    draw_set_color(c_lime);
    with (obj_player) draw_circle(x, y, body_radius, true);
    draw_set_color(c_red);
    with (obj_enemy_parent) {
        draw_circle(x, y, body_radius, true);
        if (variable_instance_exists(id, "vision_range") && vision_range < 2000) {
            draw_set_alpha(0.15);
            draw_circle(x, y, vision_range, true);
            draw_set_alpha(0.8);
        }
    }
    draw_set_color(c_yellow);
    with (obj_wall) draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_aqua);
    with (all) {
        if (object_index == obj_player || object_is_ancestor(object_index, obj_enemy_parent) || object_index == obj_enemy_parent || object_index == obj_wall) continue;
        if (variable_instance_exists(id, "radius") && is_real(radius)) draw_circle(x, y, radius, true);
    }
    draw_set_alpha(1);
}

// Fantasma do item escolhido no cursor
var _gw = display_get_gui_width();
var _over_panel = panel_visible && device_mouse_x_to_gui(0) >= _gw - panel_w;
if (!is_undefined(tool) && !_over_panel) {
    draw_set_alpha(0.45);
    draw_set_color(c_aqua);
    if (tool.obj == "wall") {
        draw_rectangle(mouse_x - tool.w / 2, mouse_y - tool.h / 2, mouse_x + tool.w / 2, mouse_y + tool.h / 2, false);
    } else {
        draw_circle(mouse_x, mouse_y, 16, false);
    }
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text(mouse_x, mouse_y - 22, tool.label);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
