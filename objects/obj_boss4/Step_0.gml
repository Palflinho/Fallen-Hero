event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (stomp_cooldown_timer > 0) stomp_cooldown_timer -= _dt;
if (boulder_timer > 0) boulder_timer -= _dt;

switch (state) {
    case "chase":
        damage_reduction = 0;
        vulnerable = false;
        if (_player != noone) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed * _dt, _dir), lengthdir_y(move_speed * _dt, _dir));

            // Disparo periódico de pedregulhos teleguiados leves para manter pressão
            if (boulder_timer <= 0) {
                boulder_timer = (hp <= hp_max * 0.5) ? 1.4 : 2.0;
                for (var _b = -1; _b <= 1; _b++) {
                    var _bang = _dir + _b * 22;
                    var _bp = instance_create_layer(x, y, layer, obj_enemy_projectile);
                    _bp.owner = id;
                    _bp.damage = 14;
                    _bp.dir_x = lengthdir_x(1, _bang);
                    _bp.dir_y = lengthdir_y(1, _bang);
                    _bp.speed_px = 220;
                    _bp.colour = make_colour_rgb(180, 140, 90);
                    _bp.damage_type = "physical";
                }
            }

            if (stomp_cooldown_timer <= 0 && point_distance(x, y, _player.x, _player.y) <= 260) {
                state = "windup";
                stomp_windup_timer = stomp_windup;
            }
        }
        break;

    case "windup":
        damage_reduction = 0;
        vulnerable = false;
        stomp_windup_timer -= _dt;
        // Telegrafia Miyamoto: O monólito ergue os braços maciços e estremece a terra
        scale_x = 1.35;
        scale_y = 1.35;
        if (random(1) < 0.5) {
            fx_spawn_sparks(x + random_range(-35, 35), y + body_radius, make_colour_rgb(160, 110, 60), 3);
        }

        if (stomp_windup_timer <= 0) {
            // Grande Esmagamento Sísmico!
            trigger_hitstop(0.12);
            fx_spawn_death_burst(x, y + body_radius, make_colour_rgb(180, 130, 70), 24);

            // Dispara 8 pedregulhos radiais
            for (var _a = 0; _a < 8; _a++) {
                var _ang = _a * 45;
                var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _proj.owner = id;
                _proj.damage = 18;
                _proj.dir_x = lengthdir_x(1, _ang);
                _proj.dir_y = lengthdir_y(1, _ang);
                _proj.speed_px = 260;
                _proj.colour = make_colour_rgb(200, 160, 100);
                _proj.damage_type = "physical";
            }

            // Dano de impacto direto no solo
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= stomp_hit_radius) {
                player_take_damage(stomp_damage, "physical");
            }

            stomp_count++;
            if (stomp_count < max_stomps) {
                // Segundo pisão rápido
                state = "windup";
                stomp_windup_timer = stomp_windup * 0.6;
            } else {
                // Esmagamento quebra a couraça de granito -> Janela de Vulnerabilidade Sakurai!
                stomp_count = 0;
                state = "vulnerable";
                vulnerable = true;
                vulnerable_timer = vulnerable_duration;
                damage_reduction = 1.0;
                fx_spawn_death_burst(x, y, make_colour_rgb(220, 180, 90), 20);
                trigger_hitstop(0.15);
            }
            scale_x = 0.85;
            scale_y = 0.85;
        }
        break;

    case "vulnerable":
        damage_reduction = 1.0;
        vulnerable = true;
        vulnerable_timer -= _dt;
        scale_x = 0.92;
        scale_y = 0.92;

        if (random(1) < 0.3) {
            fx_spawn_sparks(x + random_range(-25, 25), y + random_range(-25, 25), c_yellow, 2);
        }

        if (vulnerable_timer <= 0) {
            vulnerable = false;
            damage_reduction = 0;
            state = "chase";
            stomp_cooldown_timer = (hp <= hp_max * 0.5) ? 1.8 : 2.5;
            boulder_timer = 1.2;
            fx_spawn_death_burst(x, y, make_colour_rgb(140, 100, 60), 16);
            trigger_hitstop(0.08);
        }
        break;
}
