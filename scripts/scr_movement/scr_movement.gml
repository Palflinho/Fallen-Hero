function fh_place_free_of_walls(_x, _y, _radius) {
    var _free = true;
    with (obj_wall) {
        var _w = base_size * image_xscale;
        var _h = base_size * image_yscale;
        var _cx = clamp(_x, x, x + _w);
        var _cy = clamp(_y, y, y + _h);
        if (point_distance(_x, _y, _cx, _cy) < _radius) {
            _free = false;
        }
    }
    return _free;
}

function fh_move_and_collide(_amount_x, _amount_y) {
    if (_amount_x != 0) {
        var _nx = x + _amount_x;
        if (fh_place_free_of_walls(_nx, y, body_radius)) {
            x = _nx;
        }
    }
    if (_amount_y != 0) {
        var _ny = y + _amount_y;
        if (fh_place_free_of_walls(x, _ny, body_radius)) {
            y = _ny;
        }
    }
}

function fh_place_on_ice(_x, _y) {
    var _on = false;
    with (obj_ice_patch) {
        if (active) {
            var _w = base_size * image_xscale;
            var _h = base_size * image_yscale;
            if (_x >= x && _x <= x + _w && _y >= y && _y <= y + _h) {
                _on = true;
            }
        }
    }
    return _on;
}
