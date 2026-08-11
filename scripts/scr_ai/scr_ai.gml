function ai_can_see_player(_vision_range, _vision_angle) {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || _player.invisible) return noone;

    var _dist = point_distance(x, y, _player.x, _player.y);
    if (_dist > _vision_range) return noone;

    var _dir_to_player = point_direction(x, y, _player.x, _player.y);
    if (abs(angle_difference(facing_dir, _dir_to_player)) > _vision_angle * 0.5) return noone;

    return _player;
}

function ai_patrol(_dt) {
    if (point_distance(x, y, patrol_target_x, patrol_target_y) < 8) {
        if (patrol_wait_timer > 0) {
            patrol_wait_timer -= _dt;
        } else {
            var _ang = random(360);
            var _r = random(patrol_radius);
            patrol_target_x = clamp(home_x + lengthdir_x(_r, _ang), 40, room_width - 40);
            patrol_target_y = clamp(home_y + lengthdir_y(_r, _ang), 40, room_height - 40);
            patrol_wait_timer = random_range(1, 2.5);
        }
    } else {
        var _dir = point_direction(x, y, patrol_target_x, patrol_target_y);
        facing_dir = _dir;
        fh_move_and_collide(lengthdir_x(move_speed_effective * 0.5 * _dt, _dir), lengthdir_y(move_speed_effective * 0.5 * _dt, _dir));
    }
}

function ai_update_sprite_animation() {
    if (sprite_index != -1) {
        var _moving = (x != xprevious || y != yprevious);
        image_speed = _moving ? 1 : 0;
        if (!_moving) image_index = 0;
    }
}
