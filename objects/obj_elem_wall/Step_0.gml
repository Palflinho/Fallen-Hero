if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
rise = min(1, rise + _dt * 6);
life -= _dt;
if (life <= 0) {
    var _w = base_size * image_xscale;
    var _h = base_size * image_yscale;
    fx_spawn_sparks(x + _w * 0.5, y + _h * 0.5, elem_colour("earth"), 10);
    instance_destroy();
}
