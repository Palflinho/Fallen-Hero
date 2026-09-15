event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (_player != noone && !_player.invisible && state != "slam_windup" && state != "dash") {
    facing_dir = point_direction(x, y, _player.x, _player.y);
}

// ----------------------------------------------------
// JANELA DE VULNERABILIDADE (3.0s)
// ----------------------------------------------------
if (state == "vulnerable") {
    vulnerable_timer -= _dt;
    vulnerable = true;
    damage_reduction = 1.0; // 100% de dano sofrido!
    body_colour = c_lime;
    scale_y = 0.80;
    scale_x = 1.20;

    if (random(1) < 0.35) {
        fx_spawn_sparks(x + random_range(-15, 15), y - body_radius - 8, c_yellow, 1);
    }

    if (vulnerable_timer <= 0) {
        vulnerable = false;
        damage_reduction = 0.35;
        state = "chase";
        combo_count = 0;
        attack_cooldown_timer = 1.5;
        if (element_type == "wind") body_colour = make_colour_rgb(180, 240, 255);
        else if (element_type == "earth") body_colour = make_colour_rgb(140, 100, 60);
        else body_colour = make_colour_rgb(200, 235, 255);
        scale_x = 1.0;
        scale_y = 1.0;

        trigger_hitstop(0.05);
        var _rcol = (element_type == "wind") ? c_white : ((element_type == "earth") ? make_colour_rgb(160, 120, 80) : c_aqua);
        fx_spawn_sparks(x, y, _rcol, 14);
    }
    exit;
}

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

switch (state) {
    case "chase":
        if (element_type == "wind") body_colour = make_colour_rgb(180, 240, 255);
        else if (element_type == "earth") body_colour = make_colour_rgb(140, 100, 60);
        else body_colour = make_colour_rgb(200, 235, 255);
        damage_reduction = 0.35;

        if (_player != noone && !_player.invisible) {
            var _dist = point_distance(x, y, _player.x, _player.y);
            var _dir = point_direction(x, y, _player.x, _player.y);

            if (_dist > 100) {
                ai_enemy_move(_dir, move_speed * _dt * 60, _dt);
            }

            if (attack_cooldown_timer <= 0) {
                if (combo_count == 0) {
                    // 1. Ataque Ranged Assinatura do Bioma
                    state = "fan_windup";
                    attack_cooldown_timer = 0.50;
                    scale_x = 1.25;
                    scale_y = 1.25;
                    body_colour = c_white;
                } else {
                    // 2. Ataque Pesado Assinatura do Bioma (Slam ou Dash de Chefe)
                    if (element_type == "wind") {
                        state = "dash_windup";
                        attack_cooldown_timer = 0.40;
                        scale_x = 1.30;
                        scale_y = 1.30;
                        body_colour = c_white;
                    } else {
                        state = "slam_windup";
                        slam_windup_timer = slam_windup;
                        scale_y = 1.40;
                        scale_x = 0.80;
                        body_colour = c_yellow;
                    }
                }
            }
        }
        break;

    case "fan_windup":
        attack_cooldown_timer -= _dt;
        if (attack_cooldown_timer <= 0) {
            if (_player != noone) {
                var _bdir = point_direction(x, y, _player.x, _player.y);
                var _pcol = (element_type == "wind") ? c_white : ((element_type == "earth") ? make_colour_rgb(170, 130, 80) : c_aqua);
                var _shots = (element_type == "wind") ? 4 : 3;
                for (var _f = -1; _f <= 1; _f++) {
                    var _fang = _bdir + _f * 20;
                    var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                    _p.owner = id;
                    _p.damage = 11;
                    _p.dir_x = lengthdir_x(1, _fang);
                    _p.dir_y = lengthdir_y(1, _fang);
                    _p.speed_px = 290;
                    _p.colour = _pcol;
                    _p.damage_type = (element_type == "earth") ? "physical" : "magical";
                }
            }
            combo_count = 1;
            state = "chase";
            attack_cooldown_timer = 0.8;
            fx_spawn_sparks(x, y, (element_type == "wind") ? c_white : c_aqua, 8);
        }
        break;

    case "dash_windup":
        attack_cooldown_timer -= _dt;
        if (attack_cooldown_timer <= 0) {
            state = "dash";
            dash_timer = 0.40;
            var _cdir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
            dash_vx = lengthdir_x(480, _cdir);
            dash_vy = lengthdir_y(480, _cdir);
            fx_spawn_sparks(x, y, c_white, 8);
        }
        break;

    case "dash":
        dash_timer -= _dt;
        fh_move_and_collide(dash_vx * _dt, dash_vy * _dt);
        if (random(1) < 0.45) fx_spawn_sparks(x, y, make_colour_rgb(180, 240, 255), 2);

        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
            player_take_damage(contact_damage, "physical");
        }

        if (dash_timer <= 0) {
            // Fim do dash de vento: Descompressão e Janela de Vulnerabilidade!
            state = "vulnerable";
            vulnerable = true;
            vulnerable_timer = vulnerable_duration;
            damage_reduction = 1.0;
            scale_y = 0.75;
            scale_x = 1.30;
            fx_spawn_sparks(x, y, c_lime, 14);
            trigger_hitstop(0.08);
        }
        break;

    case "slam_windup":
        slam_windup_timer -= _dt;
        scale_y = 1.40;
        scale_x = 0.80;
        if (slam_windup_timer <= 0) {
            var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
            _hit.owner = id;
            _hit.damage = slam_damage;
            _hit.damage_type = "physical";
            _hit.body_radius = slam_radius;

            // Transiciona diretamente para a Janela de Vulnerabilidade!
            state = "vulnerable";
            vulnerable = true;
            vulnerable_timer = vulnerable_duration;
            damage_reduction = 1.0;

            scale_y = 0.65;
            scale_x = 1.40;
            var _scol = (element_type == "earth") ? make_colour_rgb(160, 120, 80) : c_aqua;
            fx_spawn_sparks(x, y, _scol, 18);
            trigger_hitstop(0.08);
        }
        break;
}
