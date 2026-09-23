// ---------------------------------------------------------------------
// SLIME DE TERRA
//  - Carapaca de pedra na frente: golpes frontais ricocheteiam (0 de dano).
//    3 golpes na carapaca a quebram (janela vulneravel de 2.5s).
//  - Ataque: linha de aviso -> rola em linha reta -> fica tonto 0.9s
//    (gira e expoe as costas).
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup" || state == "roll_windup") ? make_colour_rgb(180, 140, 80) : make_colour_rgb(135, 100, 60);

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

        if (_dist <= attack_range && attack_cooldown_timer <= 0) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (attack_cooldown_timer <= 0 && _dist >= roll_min && _dist <= roll_range) {
            state = "roll_windup";
            attack_windup_timer = 0.55;
            roll_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            ai_enemy_move(point_direction(x, y, _player.x, _player.y), move_speed_effective, _dt);
        }
        // A carapaca sempre encara o jogador
        facing_dir = point_direction(x, y, _player.x, _player.y);
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.40;
        scale_y = 0.60;
        if (attack_windup_timer <= 0) {
            var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
            _hit.owner = id;
            _hit.damage = contact_damage;
            _hit.damage_type = "physical";
            _hit.body_radius = attack_range + 8;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            scale_x = 0.85;
            scale_y = 1.25;
            fx_spawn_sparks(x, y, make_colour_rgb(160, 120, 70), 8);
        }
        break;

    case "roll_windup":
        attack_windup_timer -= _dt;
        facing_dir = roll_dir;
        scale_x = 1.3;
        scale_y = 0.7;
        if (attack_windup_timer <= 0) {
            state = "roll";
            roll_timer = 0.6;
            roll_hit = false;
            sfx_play("slam", 0.1, 0.4);
        }
        break;

    case "roll":
        roll_timer -= _dt;
        facing_dir = roll_dir;
        var _ox = x;
        var _oy = y;
        fh_move_and_collide(lengthdir_x(320 * _dt, roll_dir), lengthdir_y(320 * _dt, roll_dir));
        if (random(1) < 0.4) fx_spawn_sparks(x, y + body_radius, make_colour_rgb(160, 120, 70), 1);
        if (!roll_hit && _player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius + 2) {
            roll_hit = true;
            player_take_damage(elem_dmg(12), "physical");
            elem_push_player(roll_dir, 280);
        }
        var _blocked = (point_distance(_ox, _oy, x, y) < 320 * _dt * 0.3);
        if (roll_timer <= 0 || _blocked) {
            if (_blocked) {
                trigger_camera_shake(3);
                fx_spawn_sparks(x, y, c_ltgray, 10);
            }
            state = "dizzy";
            dizzy_timer = _blocked ? 1.3 : 0.9;
            fh_vuln_timer = dizzy_timer;
            attack_cooldown_timer = attack_cooldown + 0.8;
        }
        break;

    case "dizzy":
        dizzy_timer -= _dt;
        facing_dir = (facing_dir + 540 * _dt) mod 360; // gira tonto: a carapaca deixa as costas expostas
        scale_x = 1.1;
        scale_y = 0.9;
        if (dizzy_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
