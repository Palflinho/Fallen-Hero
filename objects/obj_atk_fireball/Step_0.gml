if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;

x += dir_x * speed_px * _dt;
y += dir_y * speed_px * _dt;
dist_traveled += speed_px * _dt;

// 04 Condensacao Arcana: >250px ganha +25% de dano e tamanho
if (!is_condensed && dist_traveled >= 250 && instance_exists(owner) && variable_instance_exists(owner, "synth_mage_condensacao_arcana") && owner.synth_mage_condensacao_arcana > 0) {
    is_condensed = true;
    damage *= 1.25;
    body_radius *= 1.25;
    fx_spawn_sparks(x, y, c_fuchsia, 6);
}

// 44 Tempestade de Areia: Projeteis soltam areia que desorienta atacantes
if (instance_exists(owner) && variable_instance_exists(owner, "synth_mage_tempestade_areia") && owner.synth_mage_tempestade_areia > 0 && random(1) < 0.20) {
    fx_spawn_sparks(x, y, make_colour_rgb(220, 190, 130), 2);
}

with (obj_enemy_parent) {
    var _already_hit = false;
    for (var _i = 0; _i < array_length(other.hit_list); _i++) {
        if (other.hit_list[_i] == id) {
            _already_hit = true;
            break;
        }
    }
    if (!_already_hit && !fh_untargetable && point_distance(x, y, other.x, other.y) <= body_radius + other.body_radius) {
        array_push(other.hit_list, id);
        player_on_hit_enemy(other.owner, id, other.damage);
        if (other.pierce_remaining > 0) {
            other.pierce_remaining -= 1;
        } else {
            other.should_destroy = true;
        }
    }
}

if (!fh_place_free_of_walls(x, y, body_radius)) {
    // 33 Tremer da Terra: impacto em parede gera onda sismica que desacelera inimigos
    if (instance_exists(owner) && variable_instance_exists(owner, "synth_geo_tremer_terra") && owner.synth_geo_tremer_terra > 0) {
        fx_spawn_sparks(x, y, make_colour_rgb(160, 100, 50), 10);
        with (obj_enemy_parent) {
            if (point_distance(x, y, other.x, other.y) <= 65) {
                enemy_apply_slow(id, 0.35, 1.5);
                enemy_take_damage(id, 8, other.x, other.y, 60);
            }
        }
    }
    instance_destroy();
    exit;
}

if (should_destroy || life <= 0) {
    instance_destroy();
}
