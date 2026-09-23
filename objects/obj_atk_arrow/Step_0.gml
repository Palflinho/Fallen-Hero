if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;

// 20 Flecha Teleguiada (curva suavemente para encontrar inimigos próximos)
if (instance_exists(owner) && variable_instance_exists(owner, "synth_archer_venda_flecha_teleguiada") && owner.synth_archer_venda_flecha_teleguiada > 0) {
    var _nearest = instance_nearest(x, y, obj_enemy_parent);
    if (_nearest != noone && point_distance(x, y, _nearest.x, _nearest.y) <= 180) {
        var _target_dir = point_direction(x, y, _nearest.x, _nearest.y);
        var _curr_dir = point_direction(0, 0, dir_x, dir_y);
        var _new_dir = _curr_dir + clamp(angle_difference(_target_dir, _curr_dir), -120 * _dt, 120 * _dt);
        dir_x = lengthdir_x(1, _new_dir);
        dir_y = lengthdir_y(1, _new_dir);
    }
}

// 21 Fênix Caçadora (persegue o inimigo com maior vida)
if (instance_exists(owner) && variable_instance_exists(owner, "synth_archer_balist_fenix_cacadora") && owner.synth_archer_balist_fenix_cacadora > 0) {
    var _boss_or_strong = noone;
    var _max_hp = 0;
    with (obj_enemy_parent) {
        if (hp_max > _max_hp && point_distance(x, y, other.x, other.y) <= 220) {
            _max_hp = hp_max;
            _boss_or_strong = id;
        }
    }
    if (_boss_or_strong != noone) {
        var _target_dir = point_direction(x, y, _boss_or_strong.x, _boss_or_strong.y);
        var _curr_dir = point_direction(0, 0, dir_x, dir_y);
        var _new_dir = _curr_dir + clamp(angle_difference(_target_dir, _curr_dir), -180 * _dt, 180 * _dt);
        dir_x = lengthdir_x(1, _new_dir);
        dir_y = lengthdir_y(1, _new_dir);
        if (random(1) < 0.3) fx_spawn_sparks(x, y, c_orange, 1);
    }
}

x += dir_x * speed_px * _dt;
y += dir_y * speed_px * _dt;
dist_traveled += speed_px * _dt;

// 15 Tiro do Maelstrom (traga monstros na trajetória da flecha)
if (instance_exists(owner) && variable_instance_exists(owner, "synth_archer_glacial_tiro_maelstrom") && owner.synth_archer_glacial_tiro_maelstrom > 0) {
    with (obj_enemy_parent) {
        if (point_distance(x, y, other.x, other.y) <= 65) {
            var _pdir = point_direction(x, y, other.x, other.y);
            x += lengthdir_x(25 * _dt * 60, _pdir);
            y += lengthdir_y(25 * _dt * 60, _pdir);
            enemy_apply_slow(id, 0.4, 0.5);
        }
    }
    if (random(1) < 0.25) fx_spawn_sparks(x, y, c_aqua, 2);
}

// 23 Corte do Tufão (ondas de vácuo laterais causando dano raspante)
if (instance_exists(owner) && variable_instance_exists(owner, "synth_archer_venda_corte_tufao") && owner.synth_archer_venda_corte_tufao > 0) {
    with (obj_enemy_parent) {
        if (point_distance(x, y, other.x, other.y) <= 35) {
            enemy_take_damage(id, 4, other.x, other.y, 40);
        }
    }
}

with (obj_enemy_parent) {
    var _already_hit = false;
    for (var _i = 0; _i < array_length(other.hit_list); _i++) {
        if (other.hit_list[_i] == id) {
            _already_hit = true;
            break;
        }
    }
    if (!_already_hit && (!fh_untargetable || fh_air) && point_distance(x, y, other.x, other.y) <= body_radius + other.body_radius) {
        array_push(other.hit_list, id);

        var _hit_dmg = other.damage;
        // 02 Ponto Cego: flechas a >300px causam +30% de dano
        if (other.dist_traveled >= 300 && instance_exists(other.owner) && variable_instance_exists(other.owner, "synth_archer_ponto_cego") && other.owner.synth_archer_ponto_cego > 0) {
            _hit_dmg *= 1.30;
            fx_spawn_damage_popup(x, y - 18, "PONTO CEGO!", true, c_yellow);
        }

        player_on_hit_enemy(other.owner, id, _hit_dmg);

        // 43 Aurora Glacial (estacas de gelo explosivas ao contato)
        if (instance_exists(other.owner) && variable_instance_exists(other.owner, "synth_archer_aurora_glacial") && other.owner.synth_archer_aurora_glacial > 0) {
            fx_spawn_sparks(x, y, c_aqua, 12);
            fx_spawn_damage_popup(x, y - 20, "AURORA GLACIAL!", true, c_aqua);
            with (obj_enemy_parent) {
                if (id != other.id && point_distance(x, y, other.x, other.y) <= 65) {
                    enemy_take_damage(id, 16, other.x, other.y, 90);
                    enemy_apply_slow(id, 0.2, 1.5);
                }
            }
        }

        // 46 Projétil Meteórico (poças de magma e estilhaços que explodem)
        if (instance_exists(other.owner) && variable_instance_exists(other.owner, "synth_archer_projetil_meteorico") && other.owner.synth_archer_projetil_meteorico > 0) {
            fx_spawn_death_burst(x, y, c_orange, 12);
            fx_spawn_damage_popup(x, y - 20, "MAGMA!", true, c_orange);
            with (obj_enemy_parent) {
                if (id != other.id && point_distance(x, y, other.x, other.y) <= 70) {
                    enemy_take_damage(id, 18, other.x, other.y, 110);
                    enemy_apply_poison(id, 4, 0.5, 2.0);
                }
            }
        }

        // 03 Perfuração Reta (garante perfuração adicional)
        var _extra_pierce = (instance_exists(other.owner) && variable_instance_exists(other.owner, "synth_archer_perfuracao_reta") && other.owner.synth_archer_perfuracao_reta > 0) ? other.owner.synth_archer_perfuracao_reta : 0;
        if (other.pierce_remaining + _extra_pierce > 0) {
            other.pierce_remaining -= 1;
        } else {
            other.should_destroy = true;
        }
    }
}

if (!fh_place_free_of_walls(x, y, body_radius)) {
    // 13 Detonação de Parede: colisão com paredes causa 30 de dano em área
    if (instance_exists(owner) && variable_instance_exists(owner, "synth_archer_balist_detonacao_parede") && owner.synth_archer_balist_detonacao_parede > 0) {
        var _ex_r = 50;
        if (variable_instance_exists(owner, "synth_archer_balist_polvora_concentrada") && owner.synth_archer_balist_polvora_concentrada > 0) {
            _ex_r *= 1.25;
        }
        fx_spawn_death_burst(x, y, c_orange, 14);
        fx_spawn_damage_popup(x, y - 16, "DETONACAO!", true, c_orange);
        trigger_hitstop(0.06);
        with (obj_enemy_parent) {
            if (point_distance(x, y, other.x, other.y) <= _ex_r) {
                enemy_take_damage(id, 30, other.x, other.y, 160);
                enemy_apply_poison(id, 3, 0.5, 2.0);
            }
        }
    }
    instance_destroy();
    exit;
}

if (should_destroy || life <= 0) {
    instance_destroy();
}

