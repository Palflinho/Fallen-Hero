if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;

x += dir_x * speed_px * _dt;
y += dir_y * speed_px * _dt;

if (!fh_place_free_of_walls(x, y, body_radius)) {
    instance_destroy();
    exit;
}

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
    if (!fh_line_intersects_wall(x, y, _player.x, _player.y)) {
        var _defending = (_player.state == "defend" && _player.defend_active);
        if (_defending && variable_instance_exists(_player, "synth_reflexo_blindado") && _player.synth_reflexo_blindado > 0 && random(1) < 0.40) {
            fx_spawn_sparks(x, y, c_aqua, 12);
            fx_spawn_damage_popup(x, y - 16, "REFLETIDO!", false, c_aqua);
            trigger_hitstop(0.04);
            var _ref = instance_create_layer(x, y, layer, obj_atk_knight);
            _ref.owner = _player;
            _ref.damage = damage * 1.5;
            _ref.body_radius = 28;
            _ref.life = 0.15;
            instance_destroy();
            exit;
        }
        // Mage: 29 Olho do Furacao (+15% esquiva de projeteis em movimento)
        if (_player.character_class == "mage" && variable_instance_exists(_player, "synth_aero_olho_furacao") && _player.synth_aero_olho_furacao > 0 && point_distance(0, 0, _player.vx, _player.vy) > 20) {
            if (random(1) < 0.15) {
                _player.invuln_timer = max(_player.invuln_timer, 0.45);
                fx_spawn_damage_popup(_player.x, _player.y - 20, "ESQUIVA VENTO!", true, make_colour_rgb(180, 240, 255));
                fx_spawn_sparks(x, y, make_colour_rgb(180, 240, 255), 8);
                instance_destroy();
                exit;
            }
        }
        player_take_damage(damage, damage_type);
        instance_destroy();
        exit;
    }
}

if (life <= 0) instance_destroy();
