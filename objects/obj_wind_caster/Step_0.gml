// ---------------------------------------------------------------------
// CONJURADOR DE VENTO
//  - BARREIRA DE VENTO (3s): reflete flechas e bolas de fogo de volta e cria
//    um VORTICE que puxa o jogador para o centro (o olho machuca).
//    Golpes corpo a corpo atravessam a barreira normalmente.
//  - Depois da barreira fica EXAUSTO 1s (+50% de dano).
//  - Com a barreira recarregando, lanca uma rajada em area que empurra.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "cast" || state == "windup") ? c_white : make_colour_rgb(130, 220, 240);
if (state == "exhausted") body_colour = make_colour_rgb(90, 140, 150);

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;
if (barrier_cooldown > 0) barrier_cooldown -= _dt;

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
        if (_player != noone && _player.invisible) {
            state = "patrol";
            break;
        }
        if (_seen != noone) {
            lost_sight_timer = 0;
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }
        if (_player == noone) break;
        facing_dir = point_direction(x, y, _player.x, _player.y);

        if (barrier_cooldown <= 0 && _dist <= 240) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (attack_cooldown_timer <= 0 && _dist <= 300) {
            state = "cast";
            cast_target_x = _player.x;
            cast_target_y = _player.y;
            cast_timer = telegraph_time;
        } else if (_dist < preferred_range - 30) {
            ai_enemy_move(facing_dir + 180, move_speed_effective, _dt);
        } else if (_dist > preferred_range + 30) {
            ai_enemy_move(facing_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_y = 1.25;
        scale_x = 0.85;
        if (attack_windup_timer <= 0) {
            state = "barrier";
            barrier_timer = barrier_time;
            vortex_tick = 0;
            sfx_play("wind_gust", 0.1, 0.8);
        }
        break;

    case "barrier":
        barrier_timer -= _dt;
        elem_reflect_player_projectiles(x, y, barrier_radius, make_colour_rgb(210, 250, 255));
        if (_player != noone && !_player.invisible) {
            var _pd = point_distance(x, y, _player.x, _player.y);
            if (_pd <= vortex_radius && _pd > 20) {
                var _pull_dir = point_direction(_player.x, _player.y, x, y);
                var _pull = vortex_pull * (1 - _pd / vortex_radius * 0.5) * _dt;
                with (_player) fh_move_and_collide(lengthdir_x(_pull, _pull_dir), lengthdir_y(_pull, _pull_dir));
            }
            if (vortex_tick > 0) vortex_tick -= _dt;
            if (_pd <= body_radius + 26 && vortex_tick <= 0) {
                player_take_damage(elem_dmg(6), "magical");
                vortex_tick = 0.5;
            }
        }
        if (barrier_timer <= 0) {
            state = "exhausted";
            exhausted_timer = 1.0;
            fh_vuln_timer = 1.0;
            barrier_cooldown = barrier_cooldown_max;
            fx_spawn_sparks(x, y, c_white, 12);
        }
        break;

    case "exhausted":
        exhausted_timer -= _dt;
        scale_y = 0.8;
        scale_x = 1.2;
        if (exhausted_timer <= 0) state = "chase";
        break;

    case "cast":
        cast_timer -= _dt;
        scale_y = 1.25;
        scale_x = 0.85;
        if (cast_timer <= 0) {
            if (_player != noone && !_player.invisible && point_distance(cast_target_x, cast_target_y, _player.x, _player.y) <= aoe_radius) {
                player_take_damage(elem_dmg(aoe_damage), "magical");
                elem_push_player(point_direction(cast_target_x, cast_target_y, _player.x, _player.y), 300);
                player_apply_slow(0.5, 1.2);
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            scale_y = 0.85;
            scale_x = 1.15;
            fx_spawn_sparks(cast_target_x, cast_target_y, c_white, 14);
        }
        break;
}

ai_update_sprite_animation();
