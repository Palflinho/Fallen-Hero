// ---------------------------------------------------------------------
// GOLEM DE TEMPESTADE
//  - So pode ser ferido quando SOLIDO. Na NEVOA fica intangivel e translucido.
//  - Tornado: gira perseguindo o jogador e empurra quem encosta.
//  - Depois do tornado fica TONTO 2s: janela de dano (+50%).
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();
if (tornado_hit_cd > 0) tornado_hit_cd -= _dt;
phase_timer -= _dt;

// O inimigo base devolve a "patrol" quando o jogador fica invisivel
if (state == "patrol" || state == "chase") {
    state = "solid";
    phase_timer = 1.6;
    fan_fired = false;
}

fh_untargetable = (state == "mist");
draw_alpha = (state == "mist") ? 0.3 : 1;

switch (state) {
    case "solid":
        body_colour = make_colour_rgb(170, 225, 245);
        spin = lerp(spin, 0, 0.1);
        if (_player != noone) {
            facing_dir = point_direction(x, y, _player.x, _player.y);
            if (point_distance(x, y, _player.x, _player.y) > 110) ai_enemy_move(facing_dir, move_speed_effective, _dt);
            // Rajada em leque na metade da fase solida
            if (!fan_fired && phase_timer <= 0.8) {
                fan_fired = true;
                for (var _f = -2; _f <= 2; _f++) {
                    elem_spawn_projectile(x, y, facing_dir + _f * 16, 280, elem_dmg(10), c_white, "projectile");
                }
                fx_spawn_sparks(x, y, c_white, 8);
                sfx_play("wind_gust", 0.1, 0.6);
            }
        }
        if (phase_timer <= 0) {
            state = "windup";
            phase_timer = 0.8;
            sfx_play("wind_gust", 0.05, 0.9);
        }
        break;

    case "windup":
        // "!" + anel de aviso: vai virar tornado
        spin += 900 * _dt;
        scale_x = 1.15;
        scale_y = 1.15;
        body_colour = c_white;
        if (phase_timer <= 0) {
            state = "tornado";
            phase_timer = 2.2;
        }
        break;

    case "tornado":
        spin += 1440 * _dt;
        body_colour = make_colour_rgb(220, 250, 255);
        if (_player != noone) {
            ai_enemy_move(point_direction(x, y, _player.x, _player.y), tornado_speed, _dt);
            if (tornado_hit_cd <= 0 && point_distance(x, y, _player.x, _player.y) <= tornado_radius + _player.body_radius) {
                player_take_damage(elem_dmg(14), "physical");
                elem_push_player(point_direction(x, y, _player.x, _player.y), 380);
                tornado_hit_cd = 0.6;
            }
        }
        if (random(1) < 0.6) fx_spawn_sparks(x + random_range(-tornado_radius, tornado_radius), y + random_range(-tornado_radius, tornado_radius), c_white, 1);
        if (phase_timer <= 0) {
            state = "dizzy";
            phase_timer = 2.0;
            fh_vuln_timer = 2.0;
            fx_spawn_damage_popup(x, y - 40, "TONTO!", true, c_yellow);
            trigger_hitstop(0.05);
        }
        break;

    case "dizzy":
        spin = lerp(spin, 0, 0.05);
        body_colour = make_colour_rgb(140, 190, 210);
        scale_x = 1.2;
        scale_y = 0.85;
        if (phase_timer <= 0) {
            state = "mist";
            phase_timer = 2.2;
            fx_spawn_sparks(x, y, c_white, 16);
        }
        break;

    case "mist":
        // Desliza intangivel para o outro lado do jogador
        if (_player != noone) {
            var _side = point_direction(_player.x, _player.y, x, y) + 90;
            ai_enemy_move(point_direction(x, y, _player.x + lengthdir_x(140, _side), _player.y + lengthdir_y(140, _side)), move_speed * 2.2, _dt);
        }
        if (phase_timer <= 0) {
            state = "solid";
            phase_timer = 2.4;
            fan_fired = false;
            fx_spawn_sparks(x, y, c_white, 16);
        }
        break;
}

if (state != "mist") {
    fh_untargetable = false;
    draw_alpha = 1;
}
