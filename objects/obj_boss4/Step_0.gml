event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (stomp_cooldown_timer > 0) stomp_cooldown_timer -= _dt;

switch (state) {
    case "chase":
        if (_player != noone) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed * _dt, _dir), lengthdir_y(move_speed * _dt, _dir));

            if (stomp_cooldown_timer <= 0 && point_distance(x, y, _player.x, _player.y) <= 240) {
                state = "windup";
                stomp_windup_timer = stomp_windup;
            }
        }
        break;

    case "windup":
        stomp_windup_timer -= _dt;
        // Telegrafia: O monólito ergue os braços de pedra e vibra o chão
        scale_x = 1.35;
        scale_y = 1.35;
        if (random(1) < 0.4) {
            fx_spawn_sparks(x + random_range(-30, 30), y + body_radius, make_colour_rgb(140, 100, 60), 2);
        }

        if (stomp_windup_timer <= 0) {
            // Esmagamento Sísmico!
            trigger_hitstop(0.12);
            fx_spawn_death_burst(x, y + body_radius, make_colour_rgb(160, 120, 80), 20);

            // Dispara 8 pedregulhos radiais
            for (var _a = 0; _a < 8; _a++) {
                var _ang = _a * 45;
                var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _proj.owner = id;
                _proj.damage = 16;
                _proj.dir_x = lengthdir_x(1, _ang);
                _proj.dir_y = lengthdir_y(1, _ang);
                _proj.speed_px = 250;
                _proj.colour = make_colour_rgb(190, 150, 100);
                _proj.damage_type = "physical";
            }

            // Dano de impacto direto se o jogador estiver muito próximo
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 140) {
                player_take_damage(24, "physical");
            }

            state = "chase";
            stomp_cooldown_timer = (hp <= hp_max * 0.5) ? 1.6 : stomp_cooldown;
            scale_x = 0.85;
            scale_y = 0.85;
        }
        break;
}
