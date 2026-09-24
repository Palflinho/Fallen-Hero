// Sem event_inherited(): o boneco nao usa IA, morte nem recompensas de inimigo.
if (is_world_paused()) exit;
var _dt = delta_time / 1000000;

// Levou golpe? (a vida volta sempre ao maximo)
if (hp < hp_max) {
    hits_taken += 1;
    hp = hp_max;
}
if (hit_flash_timer > 0) hit_flash_timer -= _dt;
if (result_timer > 0) result_timer -= _dt;
knockback_vx = 0;
knockback_vy = 0;
scale_x = lerp(scale_x, 1, min(1, _dt * 10));
scale_y = lerp(scale_y, 1, min(1, _dt * 10));

if (mode != "attacker") exit;

var _pl = instance_find(obj_player, 0);
var _near = (_pl != noone && point_distance(x, y, _pl.x, _pl.y) <= 150);

switch (swing_state) {
    case "idle":
        swing_angle = lerp(swing_angle, 0, min(1, _dt * 6));
        swing_timer -= _dt;
        if (swing_timer <= 0 && _near) {
            swing_state = "windup";
            swing_timer = swing_windup;
            sfx_play("menu_select", 0.05, 0.6);
        }
        break;

    case "windup":
        swing_timer -= _dt;
        swing_angle = lerp(swing_angle, -70, min(1, _dt * 3));
        if (swing_timer <= 0) {
            swing_state = "recover";
            swing_timer = 0.5;
            swing_angle = 80;
            trigger_camera_shake(2);
            if (_pl != noone && point_distance(x, y, _pl.x, _pl.y) <= swing_radius + _pl.body_radius) {
                var _safe = (_pl.state == "defend") || (_pl.invuln_timer > 0);
                result_timer = 1.2;
                result_ok = _safe;
                if (_safe) {
                    sfx_play("parry", 0.05, 1.1);
                    fx_spawn_sparks(_pl.x, _pl.y, c_aqua, 12);
                    fx_spawn_damage_popup(_pl.x, _pl.y - 24, "BOA!", true, c_aqua);
                } else {
                    // Nao machuca: so empurra, para o jogador perceber o golpe
                    sfx_play("hit", 0.05, 0.8);
                    elem_push_player(point_direction(x, y, _pl.x, _pl.y), 240);
                    fx_spawn_sparks(_pl.x, _pl.y, c_white, 6);
                }
            } else {
                fx_spawn_sparks(x + lengthdir_x(swing_radius * 0.7, 0), y, make_colour_rgb(200, 170, 110), 4);
            }
        }
        break;

    case "recover":
        swing_timer -= _dt;
        swing_angle = lerp(swing_angle, 0, min(1, _dt * 5));
        if (swing_timer <= 0) {
            swing_state = "idle";
            swing_timer = 1.6;
        }
        break;
}
