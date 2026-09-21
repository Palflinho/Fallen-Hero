// Dispara Diálogo Narrativo de Confronto do Chefe ao entrar na arena dos ventos
if (!variable_global_exists("dialogue_boss3_shown") || !global.dialogue_boss3_shown) {
    global.dialogue_boss3_shown = true;
    dialogue_play_id("temple3_wind_boss");
}

event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (state == "vulnerable") {
    rot_angle += 40 * _dt; // Giro lento atordoado
    vulnerable_timer -= _dt;
    damage_reduction = 1.0;
    vulnerable = true;
    body_colour = c_lime;
    
    // Estrelas e faíscas de desorientação/vulnerabilidade
    if (random(1) < 0.35) {
        var _sa = random(360);
        fx_spawn_sparks(x + lengthdir_x(32, _sa), y - body_radius - 10 + lengthdir_y(8, _sa), c_yellow, 2);
    }
    
    if (vulnerable_timer <= 0) {
        vulnerable = false;
        damage_reduction = 0;
        state = "chase";
        dash_count = 0;
        attack_cooldown_timer = 1.5;
        body_colour = make_colour_rgb(180, 245, 255);
        scale_x = 1.0;
        scale_y = 1.0;
        
        // Pulso expansivo de ar na recuperação
        trigger_hitstop(0.06);
        fx_spawn_sparks(x, y, c_white, 16);
        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 120) {
            player_take_damage(20, "magical");
        }
    }
    exit;
}

rot_angle += 240 * _dt;
if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

switch (state) {
    case "chase":
        body_colour = make_colour_rgb(180, 245, 255);
        damage_reduction = 0;
        if (_player != noone && !_player.invisible) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed * _dt, _dir), lengthdir_y(move_speed * _dt, _dir));
            facing_dir = _dir;

            if (attack_cooldown_timer <= 0 && point_distance(x, y, _player.x, _player.y) <= 360) {
                state = "windup";
                dash_windup_timer = dash_windup;
                var _pdir = point_direction(x, y, _player.x, _player.y);
                dash_vx = lengthdir_x(480, _pdir);
                dash_vy = lengthdir_y(480, _pdir);
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
            dash_count++;

            // Dispara leque de 5 penas de vento
            if (_player != noone) {
                var _base_ang = point_direction(x, y, _player.x, _player.y);
                for (var _a = -2; _a <= 2; _a++) {
                    var _ang = _base_ang + _a * 15;
                    var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                    _proj.owner = id;
                    _proj.damage = 22;
                    _proj.dir_x = lengthdir_x(1, _ang);
                    _proj.dir_y = lengthdir_y(1, _ang);
                    _proj.speed_px = 310;
                    _proj.colour = c_white;
                    _proj.damage_type = "magical";
                }
            }
        }
        break;

    case "dash":
        dash_timer -= _dt;
        fh_move_and_collide(dash_vx * _dt, dash_vy * _dt);

        if (random(1) < 0.45) {
            fx_spawn_sparks(x, y, make_colour_rgb(200, 245, 255), 2);
        }

        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
            player_take_damage(contact_damage, "physical");
        }

        if (dash_timer <= 0) {
            scale_x = 0.9;
            scale_y = 0.9;
            if (dash_count >= dash_max) {
                // Após o 3º dash consecutivo: Descompressão Atmosférica e Janela de Vulnerabilidade!
                state = "vulnerable";
                vulnerable = true;
                vulnerable_timer = vulnerable_duration;
                damage_reduction = 1.0;
                scale_x = 1.15;
                scale_y = 0.80;
                fx_spawn_sparks(x, y, c_lime, 14);
                trigger_hitstop(0.08);
            } else {
                // Intervalo tático breve antes da próxima investida
                state = "chase";
                attack_cooldown_timer = 0.40;
            }
        }
        break;
}
