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

            if (attack_cooldown_timer <= 0 && point_distance(x, y, _player.x, _player.y) <= attack_range) {
                state = "windup";
                attack_windup_timer = attack_windup;
            }
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.35;
        scale_y = 1.35;

        if (attack_windup_timer <= 0) {
            if (_player != noone) {
                var _pdir = point_direction(x, y, _player.x, _player.y);
                var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _proj.owner = id;
                _proj.damage = 14;
                _proj.dir_x = lengthdir_x(1, _pdir);
                _proj.dir_y = lengthdir_y(1, _pdir);
                _proj.speed_px = 220;
                _proj.colour = make_colour_rgb(180, 140, 90);
                _proj.damage_type = "physical";
                fx_spawn_sparks(x, y, make_colour_rgb(140, 105, 65), 10);
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            scale_x = 0.85;
            scale_y = 0.85;
        }
        break;
}
