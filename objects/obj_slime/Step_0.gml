// ---------------------------------------------------------------------
// SLIME DE AGUA
//  - Golpe fatal: divide-se em 2 mini-slimes (a menos que ja seja mini).
//  - Minis vivos por 3s correm um para o outro e se reunem (60% de vida).
//  - Investida: linha de aviso -> desliza deixando rastro de gelo.
// ---------------------------------------------------------------------
if (!is_world_paused() && hp <= 0 && !is_mini && !split_done) {
    split_done = true;
    var _minis = [noone, noone];
    for (var _i = 0; _i < 2; _i++) {
        var _pos = elem_find_point_around(x, y, 12, 28, 10);
        var _m = instance_create_layer(_pos.x, _pos.y, layer, obj_slime);
        with (_m) elem_strip_elite();
        _m.is_mini = true;
        _m.split_done = true;
        _m.stats_scaled = true;
        _m.atk_scale = atk_scale;
        _m.defense = defense;
        _m.orig_hp_max = hp_max;
        _m.orig_contact = contact_damage;
        _m.orig_speed = move_speed;
        _m.orig_exp = exp_reward;
        _m.orig_gold = gold_reward;
        _m.hp_max = max(4, round(hp_max * 0.30));
        _m.hp = _m.hp_max;
        _m.hp_lag = _m.hp_max;
        _m.contact_damage = max(2, round(contact_damage * 0.6));
        _m.body_radius = 9;
        _m.attack_range = 24;
        _m.move_speed = move_speed * 1.3;
        _m.move_speed_effective = _m.move_speed;
        _m.exp_reward = max(1, round(exp_reward * 0.2));
        _m.gold_reward = 0;
        _m.state = "chase";
        _m.has_spotted_player = true;
        _m.merge_timer = 3.0;
        var _kick = (_i == 0) ? 90 : 270;
        _m.knockback_vx = lengthdir_x(200, facing_dir + _kick);
        _m.knockback_vy = lengthdir_y(200, facing_dir + _kick);
        _minis[_i] = _m;
    }
    _minis[0].partner = _minis[1];
    _minis[1].partner = _minis[0];
    fx_spawn_damage_popup(x, y - 24, "DIVIDIU-SE!", false, c_aqua);
    fx_spawn_sparks(x, y, c_aqua, 14);
}

event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
var _base_col = is_mini ? make_colour_rgb(120, 200, 255) : make_colour_rgb(60, 160, 255);
body_colour = (state == "windup" || state == "lunge_windup") ? c_white : _base_col;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

var _player = instance_find(obj_player, 0);
var _seen = ai_can_see_player(vision_range, vision_angle);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

// Minis: apos 3s, se o par ainda existir, correm para se reunir
if (is_mini && state != "merge") {
    merge_timer -= _dt;
    if (merge_timer <= 0 && instance_exists(partner)) state = "merge";
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

        if (!is_mini && attack_cooldown_timer <= 0 && _dist <= lunge_range && _dist > 30) {
            state = "lunge_windup";
            attack_windup_timer = 0.35;
            lunge_dir = point_direction(x, y, _player.x, _player.y);
            facing_dir = lunge_dir;
        } else if (_dist <= attack_range && attack_cooldown_timer <= 0) {
            state = "windup";
            attack_windup_timer = attack_windup;
            facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            var _dir = point_direction(x, y, _player.x, _player.y) + adaptive_ai_get_flank_offset(_player);
            // Taticas de Bando: Guarda-Costas interpondo-se na frente de Casters
            var _caster = instance_nearest(x, y, obj_frost_caster);
            if (_caster != noone && point_distance(x, y, _caster.x, _caster.y) < 220) {
                var _mid_x = (_caster.x + _player.x) * 0.5;
                var _mid_y = (_caster.y + _player.y) * 0.5;
                if (point_distance(x, y, _mid_x, _mid_y) > 30) _dir = point_direction(x, y, _mid_x, _mid_y);
            }
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

    case "lunge_windup":
        attack_windup_timer -= _dt;
        scale_x = 1.4;
        scale_y = 0.6;
        if (attack_windup_timer <= 0) {
            state = "lunge";
            lunge_timer = 0.32;
            lunge_hit = false;
            trail_timer = 0;
            sfx_play("slash", 0.1, 0.5);
        }
        break;

    case "lunge":
        lunge_timer -= _dt;
        scale_x = 0.75;
        scale_y = 1.25;
        fh_move_and_collide(lengthdir_x(330 * _dt, lunge_dir), lengthdir_y(330 * _dt, lunge_dir));
        trail_timer -= _dt;
        if (trail_timer <= 0) {
            trail_timer = 0.06;
            elem_spawn_ground(x, y, "slick", 15, 3.0);
        }
        if (!lunge_hit && _player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius + 2) {
            lunge_hit = true;
            player_take_damage(contact_damage, "physical");
        }
        if (lunge_timer <= 0) {
            state = "recover";
            recover_timer = 0.45;
            attack_cooldown_timer = attack_cooldown + 0.8;
        }
        break;

    case "recover":
        recover_timer -= _dt;
        scale_x = 1.2;
        scale_y = 0.8;
        if (recover_timer <= 0) state = "chase";
        break;

    case "merge":
        if (!instance_exists(partner)) {
            state = "chase";
            merge_timer = 9999;
            break;
        }
        var _to = point_direction(x, y, partner.x, partner.y);
        ai_enemy_move(_to, move_speed * 1.4, _dt);
        if (point_distance(x, y, partner.x, partner.y) <= body_radius + partner.body_radius + 4 && id < partner.id) {
            is_mini = false;
            hp_max = orig_hp_max;
            hp = max(1, round(hp_max * 0.6));
            hp_lag = hp;
            contact_damage = orig_contact;
            move_speed = orig_speed;
            body_radius = 14;
            attack_range = 34;
            exp_reward = orig_exp;
            gold_reward = orig_gold;
            scale_x = 1.5;
            scale_y = 0.6;
            with (partner) instance_destroy();
            partner = noone;
            state = "chase";
            fx_spawn_damage_popup(x, y - 24, "REUNIDO!", true, c_aqua);
            fx_spawn_sparks(x, y, c_aqua, 16);
        }
        break;
}

ai_update_sprite_animation();
