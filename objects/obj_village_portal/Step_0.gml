var _dt = delta_time / 1000000;
vortex_timer += _dt;
hum_sound_timer -= _dt;

var _player = instance_find(obj_player, 0);

if (_player != noone) {
    if (hum_sound_timer <= 0) {
        hum_sound_timer = 3.2;
        sfx_play_at("portal_hum", x, y, 300, 0.05, 0.6);
    }

    if (point_distance(x, y, _player.x, _player.y) <= portal_radius + _player.body_radius) {
        var _touch_portal = touch_room_clicked(x - portal_radius, y - portal_radius, x + portal_radius, y + portal_radius);
        if (input_check_ui_confirm() || _touch_portal) {
            sfx_play("magic", 0.05, 0.8);
            trigger_camera_shake(5);

            if (all_elements_reclaimed()) {
                // Todas as essencias recuperadas! Abre passagem ao Templo 5 (O Humano)
                global.run_biome = "human";
                global.run_room_step = 1;
                room_goto(asset_get_index("room_temple5_shop"));
            } else {
                // Inicia Expedicao pelos Templos Elementais (começando pelo Templo da Agua)
                global.run_biome = "water";
                global.run_room_step = 1;
                global.temple_arena_layout = irandom(3);
                global.temple_arena_biome = "water";
                room_goto(Room1);
            }
        }
    }
}
