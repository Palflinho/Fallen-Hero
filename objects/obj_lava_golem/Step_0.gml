event_inherited();
var _dt = delta_time / 1000000;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

if (shield_active_timer > 0) {
    shield_active_timer -= _dt;
    damage_reduction = 0.25;
    if (shield_active_timer <= 0) {
        damage_reduction = 1;
        shield_timer = shield_interval;
    }
} else {
    shield_timer -= _dt;
    if (shield_timer <= 0) {
        shield_active_timer = shield_duration;
    }
}

if ((state == "chase" || state == "windup") && magia_timer > 0) {
    magia_timer -= _dt;
}

if (shield_active_timer > 0) {
    body_colour = c_white;
} else if (state == "windup") {
    body_colour = c_yellow;
} else if (state == "magia_windup") {
    body_colour = c_purple;
} else {
    body_colour = c_maroon;
}

var _player = instance_find(obj_player, 0);
var _seen = ai_can_see_player(vision_range, vision_angle);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

switch (state) {
    case "patrol":
        ai_patrol(_dt);
        if (_seen != noone) {
            state = "chase";
            lost_sight_timer = 0;
        }
        break;

    case "chase":
        if (_seen != noone) {
            lost_sight_timer = 0;
            facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }

        if (magia_timer <= 0) {
            state = "magia_windup";
            magia_windup_timer = magia_telegraph;
            break;
        }

        if (_dist <= attack_range && attack_cooldown_timer <= 0) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_player != noone && _dist < preferred_range - 20) {
            var _dir = point_direction(x, y, _player.x, _player.y) + 180;
            fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
        } else if (_player != noone && _dist > preferred_range + 20) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        // Sakurai Polish: Energy coiling
        scale_x = 1.2;
        scale_y = 1.2;
        if (attack_windup_timer <= 0) {
            if (_player != noone && !_player.invisible) {
                var _pdir = point_direction(x, y, _player.x, _player.y);
                var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _p.owner = id;
                _p.damage = projectile_damage;
                _p.dir_x = lengthdir_x(1, _pdir);
                _p.dir_y = lengthdir_y(1, _pdir);
                _p.speed_px = projectile_speed;
                _p.colour = c_maroon;
                _p.body_radius = 10;
                _p.damage_type = "magical";
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            // Recoil
            scale_x = 0.85;
            scale_y = 0.85;
            fx_spawn_sparks(x, y, c_orange, 6);
        }
        break;

    case "magia_windup":
        magia_windup_timer -= _dt;
        // Sakurai Polish: Pulsating dangerous molten core
        scale_x = 1.2 + 0.1 * sin(current_time * 0.03);
        scale_y = 1.2 + 0.1 * sin(current_time * 0.03);
        if (magia_windup_timer <= 0) {
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= magia_radius + _player.body_radius) {
                player_take_damage(magia_damage, "magical");
            }
            magia_timer = magia_interval;
            state = "chase";
            // Volcanic eruption shockwave
            scale_x = 1.4;
            scale_y = 0.6;
            fx_spawn_sparks(x, y, c_red, 16);
        }
        break;
}
