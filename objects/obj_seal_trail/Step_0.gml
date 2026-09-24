var _dt = delta_time / 1000000;
life -= _dt;
var _d = point_distance(x, y, target_x, target_y);
if (_d <= spd * _dt || life <= 0) {
    fx_spawn_sparks(target_x, target_y, c_aqua, 20);
    sfx_play_at("magic", target_x, target_y, 900, 0.05, 0.8);
    instance_destroy();
    exit;
}
var _dir = point_direction(x, y, target_x, target_y);
x += lengthdir_x(spd * _dt, _dir);
y += lengthdir_y(spd * _dt, _dir);
if (random(1) < 0.7) fx_spawn_sparks(x, y, c_aqua, 1);
