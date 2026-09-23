// Aviso da explosao (circulo = area)
if (state == "swell") {
    elem_draw_warning_circle(x, y, explode_radius, 1 - swell_timer / swell_time, c_orange);
}
event_inherited();
