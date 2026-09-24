// ---------------------------------------------------------------------
// SLIME DE VENTO
//  - Salta em arco ate onde o jogador estava (sombra marca o pouso).
//  - No ar fica intangivel: nao adianta atacar, reposicione-se.
//  - Pouso: dano em circulo + empurrao radial. Depois fica 0.5s vulneravel.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup" || state == "hop_windup") ? c_white : make_colour_rgb(190, 245, 255);

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

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

        if (attack_cooldown_timer <= 0 && _dist <= hop_range && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            state = "hop_windup";
            attack_windup_timer = 0.35;
            var _tp = { x: _player.x, y: _player.y };
            if (!fh_place_free_of_walls(_tp.x, _tp.y, body_radius)) _tp = fh_find_free_spawn_pos(_tp.x, _tp.y, body_radius);
            hop_target_x = _tp.x;
            hop_target_y = _tp.y;
            facing_dir = point_direction(x, y, hop_target_x, hop_target_y);
        } else {
            var _dir = point_direction(x, y, _player.x, _player.y) + adaptive_ai_get_flank_offset(_player);
            ai_enemy_move(_dir, move_speed_effective, _dt);
        }
        break;

    case "hop_windup":
        attack_windup_timer -= _dt;
        scale_x = 1.4;
        scale_y = 0.6;
        if (attack_windup_timer <= 0) {
            state = "hop";
            hop_timer = 0;
            hop_start_x = x;
            hop_start_y = y;
            fh_untargetable = true;
            sfx_play("wind_gust", 0.1, 0.5);
        }
        break;

    case "hop":
        // Arqueiro: uma flecha derruba o slime no ar
        if (fh_air_shot) {
            fh_air_shot = false;
            fh_untargetable = false;
            draw_z = 0;
            state = "recover";
            recover_timer = 1.2;
            fh_vuln_timer = 1.2;
            attack_cooldown_timer = attack_cooldown + 0.6;
            fx_spawn_damage_popup(x, y - 26, "DERRUBADO!", true, c_yellow);
            fx_spawn_sparks(x, y, c_white, 12);
            break;
        }
        hop_timer += _dt;
        var _t = clamp(hop_timer / hop_time, 0, 1);
        var _nx = lerp(hop_start_x, hop_target_x, _t);
        var _ny = lerp(hop_start_y, hop_target_y, _t);
        if (fh_place_free_of_walls(_nx, _ny, body_radius)) {
            x = _nx;
            y = _ny;
        }
        draw_z = sin(_t * pi) * 44;
        scale_x = 0.85;
        scale_y = 1.2;
        if (_t >= 1) {
            fh_untargetable = false;
            draw_z = 0;
            elem_hit_player_circle(x, y, land_radius, contact_damage, "physical");
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= push_radius) {
                elem_push_player(point_direction(x, y, _player.x, _player.y), 320);
            }
            fx_spawn_sparks(x, y, c_white, 14);
            trigger_camera_shake(3);
            scale_x = 1.5;
            scale_y = 0.55;
            state = "recover";
            recover_timer = 0.5;
            fh_vuln_timer = 0.5;
            attack_cooldown_timer = attack_cooldown + 0.6;
        }
        break;

    case "recover":
        recover_timer -= _dt;
        if (recover_timer <= 0) state = "chase";
        break;
}

// Seguranca: nunca permanecer intangivel fora do salto
if (state != "hop") {
    fh_untargetable = false;
    draw_z = 0;
}
fh_air = (state == "hop");
fh_mist_cut = (state == "hop");
fh_air_shot = false;

ai_update_sprite_animation();
