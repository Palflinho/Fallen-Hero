var _dt = delta_time / 1000000;
if (toast_timer > 0) toast_timer -= _dt;

// Nada de sair da sala nem de final/vitoria no sandbox
with (obj_stage_gate) instance_destroy();
if (instance_exists(obj_ending_controller)) {
    with (obj_ending_controller) instance_destroy();
    global.ending_active = false;
}
global.run_victory = false;

// Barra de vida de chefe no HUD quando houver um chefe colocado
var _any_boss = false;
with (obj_enemy_parent) if (enemy_is_boss(id)) _any_boss = true;
with (obj_hud) boss_room = _any_boss;

var _p = instance_find(obj_player, 0);
if (!player_applied && _p != noone) {
    player_applied = true;
    sandbox_apply_player(_p);
}
if (god_mode && _p != noone && _p.hp > 0) _p.hp = _p.hp_max;

if (keyboard_check_pressed(vk_f6)) panel_visible = !panel_visible;
if (keyboard_check_pressed(vk_f7)) show_collisions = !show_collisions;

// Monta as linhas do painel (as mesmas que o Draw GUI desenha)
sandbox_build_panel();

if (global.paused || global.attr_window_open || global.chest_reward_open || dialogue_is_active()) exit;

var _gw = display_get_gui_width();
var _gx = device_mouse_x_to_gui(0);
var _gy = device_mouse_y_to_gui(0);
var _over_panel = panel_visible && _gx >= _gw - panel_w;

if (_over_panel) {
    if (mouse_wheel_up()) scroll = max(0, scroll - 60);
    if (mouse_wheel_down()) scroll = min(scroll_max, scroll + 60);
    if (mouse_check_button_pressed(mb_left)) {
        for (var _i = 0; _i < array_length(panel_rows); _i++) {
            var _r = panel_rows[_i];
            if (_r.action == "" || !_r.visible) continue;
            if (_gx >= _r.x1 && _gx <= _r.x2 && _gy >= _r.y1 && _gy <= _r.y2) {
                sandbox_panel_action(_r, _gx);
                sfx_play("menu_select", 0.05, 1.1);
                break;
            }
        }
    }
} else {
    // Colocar o item escolhido
    if (mouse_check_button_pressed(mb_left) && !is_undefined(tool)) {
        var _inst = sandbox_place(tool, mouse_x, mouse_y, variant);
        if (_inst != noone) fx_spawn_sparks(mouse_x, mouse_y, c_aqua, 10);
    }
    // Apagar o que estiver embaixo do cursor
    if (mouse_check_button_pressed(mb_right)) {
        var _best = noone;
        var _best_d = 48;
        var _mx = mouse_x;
        var _my = mouse_y;
        with (all) {
            if (!sandbox_is_removable(id)) continue;
            var _d = point_distance(x, y, _mx, _my);
            if (object_index == obj_wall && _mx >= bbox_left && _mx <= bbox_right && _my >= bbox_top && _my <= bbox_bottom) _d = 0;
            if (_d < _best_d) { _best_d = _d; _best = id; }
        }
        if (_best != noone) {
            fx_spawn_sparks(_best.x, _best.y, c_red, 8);
            instance_destroy(_best);
        }
    }
}
