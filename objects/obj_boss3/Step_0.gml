event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
rot_angle += 220 * _dt;

var _player = instance_find(obj_player, 0);

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

switch (state) {
    case "chase":
        if (_player != noone) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed * _dt, _dir), lengthdir_y(move_speed * _dt, _dir));
            facing_dir = _dir;

            if (attack_cooldown_timer <= 0 && point_distance(x, y, _player.x, _player.y) <= 320) {
                state = "windup";
                dash_windup_timer = dash_windup;
                var _pdir = point_direction(x, y, _player.x, _player.y);
                dash_vx = lengthdir_x(460, _pdir);
                dash_vy = lengthdir_y(460, _pdir);
                fx_spawn_sparks(x, y, c_white, 8);
            }
        }
        break;

    case "windup":
        dash_windup_timer -= _dt;
        // Telegrafia clara de ataque iminente
        scale_x = 1.3 + 0.1 * sin(current_time * 0.04);
        scale_y = 1.3 + 0.1 * sin(current_time * 0.04);
        body_colour = c_white;

        if (dash_windup_timer <= 0) {
            state = "dash";
            dash_timer = 0.35;
            body_colour = make_colour_rgb(180, 245, 255);

            // Dispara leque de 5 penas de vento
            if (_player != noone) {
                var _base_ang = point_direction(x, y, _player.x, _player.y);
                for (var _a = -2; _a <= 2; _a++) {
                    var _ang = _base_ang + _a * 15;
                    var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                    _proj.owner = id;
                    _proj.damage = 10;
                    _proj.dir_x = lengthdir_x(1, _ang);
                    _proj.dir_y = lengthdir_y(1, _ang);
                    _proj.speed_px = 300;
                    _proj.colour = c_white;
                    _proj.damage_type = "magical";
                }
            }
        }
        break;

    case "dash":
        dash_timer -= _dt;
        fh_move_and_collide(dash_vx * _dt, dash_vy * _dt);

        if (random(1) < 0.4) {
            fx_spawn_sparks(x, y, make_colour_rgb(200, 245, 255), 2);
        }

        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
            player_take_damage(contact_damage, "physical");
        }

        if (dash_timer <= 0) {
            state = "chase";
            attack_cooldown_timer = (hp <= hp_max * 0.5) ? 1.3 : 2.0;
            scale_x = 0.9;
            scale_y = 0.9;
        }
        break;
}
