// ---------------------------------------------------------------------
// TOTEM ELEMENTAL - prioridade de alvo! Enquanto estiver de pe, fortalece
// todos os aliados dentro da aura (o circulo no chao mostra o alcance).
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
knockback_resistance = 1.0;
knockback_vx = 0;
knockback_vy = 0;
state = "idle";
if (pulse_fx > 0) pulse_fx -= _dt;

pulse_timer -= _dt;
if (pulse_timer <= 0) {
    pulse_timer = pulse_interval;
    pulse_fx = 0.4;
    var _el = element;
    var _r = aura_radius;
    with (obj_enemy_parent) {
        if (id == other.id || object_index == obj_elem_totem || hp <= 0) continue;
        if (point_distance(x, y, other.x, other.y) > _r) continue;
        if (_el == "water") {
            if (hp < hp_max) {
                var _heal = max(1, round(hp_max * 0.04));
                hp = min(hp_max, hp + _heal);
                fx_spawn_damage_popup(x, y - body_radius - 10, "+" + string(_heal), false, c_aqua);
            }
        } else if (_el == "fire") {
            fh_haste_timer = max(fh_haste_timer, pulse_interval + 0.3);
        }
    }
}

if (element == "earth") {
    shield_timer -= _dt;
    if (shield_timer <= 0) {
        shield_timer = shield_interval;
        pulse_fx = 0.4;
        var _r2 = aura_radius;
        with (obj_enemy_parent) {
            if (id == other.id || object_index == obj_elem_totem || hp <= 0) continue;
            if (point_distance(x, y, other.x, other.y) <= _r2 && fh_totem_shield < 1) fh_totem_shield = 1;
        }
    }
} else if (element == "wind") {
    elem_reflect_player_projectiles(x, y, aura_radius * 0.8, elem_colour("wind"));
}
