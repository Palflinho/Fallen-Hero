event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}
state = "orbit";
orbit_angle += 70 * _dt;
x = owner.x + lengthdir_x(orbit_radius, orbit_angle);
y = owner.y + lengthdir_y(orbit_radius, orbit_angle);
knockback_vx = 0;
knockback_vy = 0;

shot_timer -= _dt;
if (shot_timer <= 0) {
    shot_timer = (owner.boss_phase >= 3) ? 1.4 : 2.0;
    var _p = elem_player();
    if (_p != noone && !_p.invisible) {
        elem_spawn_projectile(x, y, point_direction(x, y, _p.x, _p.y), 260, 14, make_colour_rgb(40, 220, 255), "magical");
        sfx_play("laser_beam", 0.05, 0.4);
    }
}
