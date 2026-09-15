event_inherited();
var _dt = delta_time / 1000000;

var _player = instance_find(obj_player, 0);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

if (_player != noone && !_player.invisible && state != "slam_windup") {
    facing_dir = point_direction(x, y, _player.x, _player.y);
}

if (vulnerable) {
    // Cooldown -- the boss stands still and can be freely damaged. When it ends it does
    // NOT resume attacking immediately: it drops into "recover" first.
    vulnerable_timer -= _dt;
    damage_reduction = 1;
    if (vulnerable_timer <= 0) {
        vulnerable = false;
        damage_reduction = 0;
        state = "recover";
        recover_timer = post_slam_recover;
    }
} else {
    switch (state) {
        case "recover":
            // Guaranteed pause between one melee action and the next -- no attacks,
            // no melee re-trigger, regardless of how close the player is standing.
            recover_timer -= _dt;
            if (recover_timer <= 0) {
                state = "barrage";
                barrage_shots_fired = 0;
                barrage_shot_timer = barrage_volley_pause;
            }
            break;

        case "barrage":
            if (_player != noone && _player.invisible) {
                break;
            }

            // Back to normal: check distance, and only go for melee if the player
            // pushed in deep. Otherwise keep the ranged barrage constant.
            if (_dist <= melee_trigger_dist) {
                state = "slam_windup";
                slam_windup_timer = slam_windup;
                break;
            }

            if (_dist > 320) {
                var _dir = point_direction(x, y, _player.x, _player.y);
                fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
            }

            barrage_shot_timer -= _dt;
            if (barrage_shot_timer <= 0) {
                if (barrage_shots_fired < barrage_shots_total) {
                    var _t = (barrage_shots_total > 1) ? (barrage_shots_fired / (barrage_shots_total - 1)) : 0.5;
                    var _ang = facing_dir + barrage_spread * (_t - 0.5);
                    var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                    _p.owner = id;
                    _p.damage = projectile_damage;
                    _p.dir_x = lengthdir_x(1, _ang);
                    _p.dir_y = lengthdir_y(1, _ang);
                    _p.speed_px = projectile_speed;
                    _p.colour = c_maroon;
                    _p.body_radius = 10;
                    _p.damage_type = "magical";
                    barrage_shots_fired += 1;
                    barrage_shot_timer = barrage_shot_interval;
                } else {
                    barrage_shots_fired = 0;
                    barrage_shot_timer = barrage_volley_pause;
                }
            }
            break;

        case "slam_windup":
            slam_windup_timer -= _dt;
            // Sakurai Polish: Grand overhead windup coiling
            scale_y = 1.35;
            scale_x = 0.85;
            if (slam_windup_timer <= 0) {
                var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
                _hit.owner = id;
                _hit.damage = slam_damage;
                _hit.damage_type = "physical";
                _hit.body_radius = slam_hit_radius;

                vulnerable = true;
                vulnerable_timer = vulnerable_duration;

                // Earth-shattering slam squash and water spark burst
                scale_y = 0.65;
                scale_x = 1.45;
                fx_spawn_sparks(x, y, c_aqua, 24);
                trigger_hitstop(0.08);
            }
            break;
    }
}

if (vulnerable) {
    body_colour = c_lime;
} else if (state == "slam_windup") {
    body_colour = c_yellow;
} else if (state == "recover") {
    body_colour = c_silver;
} else {
    body_colour = c_maroon;
}
