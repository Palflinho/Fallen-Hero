if (is_world_paused()) exit;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
    player_apply_poison(tick_damage, tick_interval, poison_duration);
}

// Reação Sistêmica (Dead Cells & Iwata): Fogo detona a nuvem de gás!
var _ignited = false;
var _ex = x;
var _ey = y;

with (obj_atk_fireball) {
    if (point_distance(x, y, other.x, other.y) <= other.radius + 16) {
        _ignited = true;
    }
}

with (obj_enemy_projectile) {
    if (colour == c_red || damage_type == "magical") {
        if (point_distance(x, y, other.x, other.y) <= other.radius + 12) {
            _ignited = true;
        }
    }
}

if (_ignited) {
    trigger_hitstop(0.08);
    fx_spawn_death_burst(_ex, _ey, c_orange, 22);
    fx_spawn_sparks(_ex, _ey, c_yellow, 15);

    with (obj_enemy_parent) {
        if (point_distance(x, y, _ex, _ey) <= other.radius * 1.5) {
            enemy_take_damage(id, 35, _ex, _ey, 220);
            enemy_apply_poison(id, 4, 0.4, 2.5);
        }
    }

    if (_player != noone && point_distance(_player.x, _player.y, _ex, _ey) <= radius * 1.2) {
        player_take_damage(16, "magical");
    }

    instance_destroy();
}
