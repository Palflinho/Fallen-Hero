event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

switch (state) {
    case "patrol":
        ai_patrol(_dt);
        if (_player != noone && !_player.invisible && point_distance(x, y, _player.x, _player.y) <= vision_range) {
            state = "chase";
            attack_cooldown_timer = max(attack_cooldown_timer, 0.70);
            consecutive_shots = 0;
        }
        break;

    case "chase":
        if (_player != noone && _player.invisible) {
            state = "patrol";
            break;
        }
        if (_player != noone) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            ai_enemy_move(_dir, move_speed_effective, _dt);

            if (attack_cooldown_timer <= 0 && point_distance(x, y, _player.x, _player.y) <= attack_range && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
                state = "windup";
                attack_windup_timer = attack_windup;
                locked_aim_dir = -1;
            }
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.35;
        scale_y = 1.35;

        // Fase 1: segue o jogador enquanto carrega
        if (attack_windup_timer > attack_windup * 0.35) {
            if (_player != noone && !_player.invisible) {
                facing_dir = point_direction(x, y, _player.x, _player.y);
            }
        }
        // Fase 2: trava a mira nos ultimos 35% do windup
        else {
            if (locked_aim_dir == -1 && _player != noone && !_player.invisible) {
                var _base_acc = 0.45;
                var _eff_acc = 0.0;
                if (consecutive_shots == 0) {
                    _eff_acc = 0.0; // Primeiro tiro e direto
                } else if (consecutive_shots == 1) {
                    _eff_acc = _base_acc * 0.40; // Segundo tiro calibra
                } else {
                    _eff_acc = _base_acc; // A partir do 3o tiro
                }

                locked_aim_dir = adaptive_ai_get_lead_aim_dir(x, y, _player, 220, _eff_acc, 16.0);
                facing_dir = locked_aim_dir;
                fx_spawn_sparks(x + lengthdir_x(16, facing_dir), y + lengthdir_y(16, facing_dir), make_colour_rgb(180, 140, 90), 2);
            }
        }

        if (attack_windup_timer <= 0) {
            var _pdir = (locked_aim_dir != -1) ? locked_aim_dir : point_direction(x, y, _player.x, _player.y);
            if (_player != noone && !_player.invisible) {
                var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _proj.owner = id;
                _proj.damage = 14;
                _proj.dir_x = lengthdir_x(1, _pdir);
                _proj.dir_y = lengthdir_y(1, _pdir);
                _proj.speed_px = 220;
                _proj.colour = make_colour_rgb(180, 140, 90);
                _proj.damage_type = "physical";
                consecutive_shots += 1;
                fx_spawn_sparks(x, y, make_colour_rgb(140, 105, 65), 10);
            }
            locked_aim_dir = -1;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            scale_x = 0.85;
            scale_y = 0.85;
        }
        break;
}
