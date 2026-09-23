// ---------------------------------------------------------------------
// FOGO-FATUO
//  - Voa ate o aliado mais proximo ainda nao infundido e o INFUNDE por 1s:
//    o aliado vira elite (afixo aleatorio, cura 30%, mais forte).
//  - Durante a infusao fica parado e exposto. Foge se o jogador chegar perto.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();
bob += _dt;
draw_z = 10 + 3 * sin(bob * 5);
body_colour = merge_colour(elem_colour(element), c_white, 0.3 + 0.3 * sin(bob * 8));

if (state == "patrol" || state == "chase") state = "seek";

// Procura aliado valido
if (state == "seek" && (!instance_exists(target) || target.fh_infused)) {
    target = noone;
    var _best = 99999;
    with (obj_enemy_parent) {
        if (id != other.id && !fh_infused && !is_spirit_boss && hp > 0 && object_index != obj_wisp && object_index != obj_elem_totem) {
            var _d = point_distance(x, y, other.x, other.y);
            if (_d < _best && _d <= 500) {
                _best = _d;
                other.target = id;
            }
        }
    }
}

switch (state) {
    case "seek":
        // Foge do jogador quando ele chega perto
        if (_player != noone && point_distance(x, y, _player.x, _player.y) < 70) {
            ai_enemy_move(point_direction(_player.x, _player.y, x, y) + random_range(-40, 40), move_speed * 1.3, _dt);
            break;
        }
        if (instance_exists(target)) {
            ai_enemy_move(point_direction(x, y, target.x, target.y), move_speed_effective, _dt);
            if (point_distance(x, y, target.x, target.y) <= target.body_radius + body_radius + 6) {
                state = "infuse";
                infuse_timer = infuse_time;
                sfx_play("magic", 0.1, 0.5);
            }
        } else {
            wander_timer -= _dt;
            if (wander_timer <= 0) {
                wander_timer = 0.8;
                wander_dir = random(360);
            }
            ai_enemy_move(wander_dir, move_speed * 0.6, _dt);
        }
        break;

    case "infuse":
        if (!instance_exists(target) || target.hp <= 0) {
            state = "seek";
            target = noone;
            break;
        }
        x = lerp(x, target.x, 0.15);
        y = lerp(y, target.y - target.body_radius, 0.15);
        infuse_timer -= _dt;
        if (random(1) < 0.5) fx_spawn_sparks(target.x, target.y, elem_colour(element), 1);
        if (infuse_timer <= 0) {
            with (target) {
                fh_infused = true;
                hp = min(hp_max, hp + round(hp_max * 0.30));
                contact_damage = round(contact_damage * 1.3);
                atk_scale *= 1.3;
                if (elite_affix == "none") {
                    var _affixes = ["frenzied", "bulwark", "spore"];
                    elite_affix = _affixes[irandom(2)];
                    if (elite_affix == "frenzied") {
                        move_speed *= 1.25;
                        affix_colour = make_colour_rgb(255, 70, 70);
                    } else if (elite_affix == "bulwark") {
                        bulwark_hits = 3;
                        affix_colour = make_colour_rgb(60, 190, 255);
                    } else {
                        affix_colour = make_colour_rgb(255, 170, 40);
                    }
                    exp_reward = round(exp_reward * 1.5);
                    gold_reward = round(gold_reward * 2);
                } else {
                    move_speed *= 1.15;
                }
                fx_spawn_damage_popup(x, y - body_radius - 18, "INFUNDIDO!", true, c_yellow);
                fx_spawn_sparks(x, y, c_yellow, 16);
            }
            sfx_play("pedestal_light", 0.1, 0.6);
            instance_destroy(); // consumido na infusao (sem recompensa)
        }
        break;
}
