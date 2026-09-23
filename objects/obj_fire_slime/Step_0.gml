// ---------------------------------------------------------------------
// SLIME DE FOGO
//  - Ataque normal: pulo curto em area.
//  - Abaixo de 30% de vida: incha piscando por 1.2s e EXPLODE (circulo),
//    ferindo o jogador E os outros inimigos, deixando brasas no chao.
//    Mate-o rapido durante o inchaco para evitar a explosao - ou use-o como bomba.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup") ? c_yellow : c_orange;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

var _player = instance_find(obj_player, 0);
var _seen = ai_can_see_player(vision_range, vision_angle);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

if (!swell_triggered && hp <= hp_max * 0.30) {
    swell_triggered = true;
    state = "swell";
    swell_timer = swell_time;
    fx_spawn_damage_popup(x, y - 26, "VAI EXPLODIR!", true, c_orange);
    sfx_play("magic", 0.05, 0.7);
}

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

        if (_dist <= attack_range && attack_cooldown_timer <= 0) {
            state = "windup";
            attack_windup_timer = attack_windup;
            facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            var _dir = point_direction(x, y, _player.x, _player.y) + adaptive_ai_get_flank_offset(_player);
            ai_enemy_move(_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.35;
        scale_y = 0.65;
        if (attack_windup_timer <= 0) {
            var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
            _hit.owner = id;
            _hit.damage = contact_damage;
            _hit.damage_type = "physical";
            _hit.body_radius = attack_range + 6;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            scale_x = 0.8;
            scale_y = 1.3;
        }
        break;

    case "swell":
        swell_timer -= _dt;
        var _k = 1 - clamp(swell_timer / swell_time, 0, 1);
        scale_x = 1 + _k * 0.7;
        scale_y = 1 + _k * 0.7;
        // pisca cada vez mais rapido
        var _blink_rate = 0.01 + _k * 0.04;
        body_colour = (sin(current_time * _blink_rate) > 0) ? c_white : c_red;
        // rasteja devagar em direcao ao jogador
        if (_player != noone) ai_enemy_move(point_direction(x, y, _player.x, _player.y), move_speed * 0.45, _dt);

        if (swell_timer <= 0) {
            if (!swell_safe) elem_hit_player_circle(x, y, explode_radius, elem_dmg(18), "magical");
            elem_hit_enemies_circle(x, y, explode_radius, 20, id);
            for (var _e = 0; _e < 5; _e++) {
                var _ea = _e * 72 + random(30);
                var _ember = elem_spawn_ground(x + lengthdir_x(random_range(14, 40), _ea), y + lengthdir_y(random_range(14, 40), _ea), "fire", 14, 3.0);
                _ember.damage = elem_dmg(3);
            }
            fx_spawn_death_burst(x, y, c_orange, 24);
            trigger_camera_shake(6);
            trigger_hitstop(0.05);
            sfx_play("slam", 0.05, 0.9);
            hp = 0; // o inimigo base finaliza a morte no proximo frame
            state = "dead";
        }
        break;
}

ai_update_sprite_animation();
