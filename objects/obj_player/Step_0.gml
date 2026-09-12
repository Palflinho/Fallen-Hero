if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
fx_system_update(_dt);

if (hp <= 0) {
    state = "dead";
}

if (hit_flash_timer > 0) hit_flash_timer -= _dt;
if (invuln_timer > 0) invuln_timer -= _dt;
if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;
if (attack_buffer_timer > 0) attack_buffer_timer -= _dt;
if (defend_cooldown_timer > 0) defend_cooldown_timer -= _dt;
if (second_wind_cooldown_timer > 0) second_wind_cooldown_timer -= _dt;
if (parry_flash_timer > 0) parry_flash_timer -= _dt;

attack_idle_timer += _dt;
if (dance_speed_timer > 0) dance_speed_timer -= _dt;
if (segundo_folego_cooldown > 0) segundo_folego_cooldown -= _dt;
if (archer_recuo_cooldown > 0) archer_recuo_cooldown -= _dt;
if (assassin_free_evade_cooldown > 0) assassin_free_evade_cooldown -= _dt;
if (assassin_smoke_timer > 0) assassin_smoke_timer -= _dt;
if (assassin_entered_room_timer > 0) assassin_entered_room_timer -= _dt;
if (frenesi_timer > 0) {
    frenesi_timer -= _dt;
    if (frenesi_timer <= 0) frenesi_stacks = 0;
}

if (poison_active) {
    poison_duration -= _dt;
    poison_tick_timer -= _dt;
    if (poison_tick_timer <= 0) {
        hp -= poison_damage;
        poison_tick_timer = poison_tick_interval;
        hit_flash_timer = hit_flash_duration;
    }
    if (poison_duration <= 0) poison_active = false;
}

if (synth_hp_reg > 0 && state != "dead" && hp > 0) {
    hp = min(hp_max, hp + synth_hp_reg * _dt);
}

if (state == "dead") {
    exit;
}

var _left  = keyboard_check(vk_left);
var _right = keyboard_check(vk_right);
var _up    = keyboard_check(vk_up);
var _down  = keyboard_check(vk_down);
var _attack_pressed = keyboard_check_pressed(ord("Z"));
var _defend_pressed = keyboard_check_pressed(ord("X"));

if (_attack_pressed) attack_buffer_timer = attack_buffer_duration;

input_h = _right - _left;
input_v = _down - _up;

switch (state) {
    case "idle":
    case "walk":
        var _cur_speed = move_speed;
        if (dance_speed_timer > 0) _cur_speed *= 1.25;

        // 42 Fortaleza Viva: ganha defesa conforme proximidade de inimigos
        if (character_class == "knight" && variable_instance_exists(id, "synth_guardiao_fortaleza_viva") && synth_guardiao_fortaleza_viva > 0) {
            var _near = 0;
            with (obj_enemy_parent) {
                if (point_distance(x, y, other.x, other.y) <= 90) _near++;
            }
            synth_guardian_def = _near * 3;
        }

        var _desired_vx = 0;
        var _desired_vy = 0;
        if (input_h != 0 || input_v != 0) {
            var _len = point_distance(0, 0, input_h, input_v);
            _desired_vx = (input_h / _len) * _cur_speed;
            _desired_vy = (input_v / _len) * _cur_speed;
            facing_x = input_h / _len;
            facing_y = input_v / _len;
        }

        on_ice = fh_place_on_ice(x, y);

        if (on_ice) {
            // Física de Gelo: +20% velocidade máxima, inércia fluida de patinação
            _desired_vx *= 1.20;
            _desired_vy *= 1.20;
            vx = lerp(vx, _desired_vx, 0.04);
            vy = lerp(vy, _desired_vy, 0.04);
            if (point_distance(0, 0, vx, vy) > 20 && random(1) < 0.28) {
                fx_spawn_sparks(x, y + body_radius - 2, make_colour_rgb(190, 240, 255), 1);
            }
        } else {
            vx = _desired_vx;
            vy = _desired_vy;
        }

        fh_move_and_collide(vx * _dt, vy * _dt);

        state = (point_distance(0, 0, vx, vy) > 5) ? "walk" : "idle";

        if (attack_buffer_timer > 0 && attack_cooldown_timer <= 0) {
            attack_buffer_timer = 0;
            state = "attack";

            var _eff_atk_dur = attack_duration;
            if (paladin_barrier_active > 0 && variable_instance_exists(id, "synth_paladino_julgamento_sereno") && synth_paladino_julgamento_sereno > 0) {
                _eff_atk_dur *= 0.80; // +25% velocidade de ataque com barreira
            }
            if (frenesi_stacks > 0) {
                _eff_atk_dur *= (1 / (1 + frenesi_stacks * 0.05));
            }
            attack_timer = _eff_atk_dur;
            attack_has_fired = false;
        } else if (_defend_pressed && defend_cooldown_timer <= 0) {
            state = "defend";
            defend_active = true;
            defend_timer = defend_duration;
            if (defend_mode == "invisible") invisible = true;
            if (defend_mode == "roll") invuln_timer = defend_duration;

            if (defend_mode == "paladin_aura") {
                paladin_aura_tick_timer = 0;
                var _bar_cap = hp_max * 0.5;
                if (variable_instance_exists(id, "synth_paladino_bastiao_liquido") && synth_paladino_bastiao_liquido > 0) {
                    _bar_cap = hp_max * 0.75;
                }
                paladin_barrier_active = min(_bar_cap, paladin_barrier_active + 25 + synth_paladin_barrier);
            } else if (defend_mode == "berserk_fury") {
                trigger_hitstop(0.04);
                if (variable_instance_exists(id, "synth_berserk_cinzas_sacrificio") && synth_berserk_cinzas_sacrificio > 0) {
                    hp = max(1, hp - hp * 0.10);
                }
            } else if (defend_mode == "parry") {
                parry_flash_timer = 0.15;
            } else if (defend_mode == "guardian_aegis") {
                trigger_hitstop(0.05);
                with (obj_enemy_parent) {
                    agro = true;
                    if (variable_instance_exists(other, "synth_guardiao_provocacao_esmagadora") && other.synth_guardiao_provocacao_esmagadora > 0) {
                        enemy_apply_slow(id, 0.7, 4.0);
                    }
                }
                if (variable_instance_exists(id, "synth_guardiao_muralha_sismica") && synth_guardiao_muralha_sismica > 0) {
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, other.x, other.y) <= 120) {
                            enemy_take_damage(id, 14, other.x, other.y, 200);
                            enemy_apply_slow(id, 0.2, 1.0);
                        }
                    }
                }
                if (synth_guardian_taunt_shock > 0) {
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, other.x, other.y) <= 180) {
                            enemy_take_damage(id, other.synth_guardian_taunt_shock, other.x, other.y, 160);
                            enemy_apply_slow(id, 0.5, 2.0);
                        }
                    }
                }
            } else if (defend_mode == "cryo_prison") {
                invuln_timer = defend_duration;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 110) {
                        enemy_apply_slow(id, 0.2, 2.0);
                    }
                }
                fx_spawn_sparks(x, y, c_aqua, 12);
            } else if (defend_mode == "pyro_blast") {
                trigger_hitstop(0.05);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 130) {
                        enemy_take_damage(id, other.attack_damage * 1.5, other.x, other.y, 220);
                        enemy_apply_poison(id, 4, 0.5, 3.0);
                    }
                }
                fx_spawn_death_burst(x, y, c_orange, 15);
            } else if (defend_mode == "voltaic_blink") {
                var _ox = x;
                var _oy = y;
                var _bx = x + facing_x * 110;
                var _by = y + facing_y * 110;
                if (fh_place_free_of_walls(_bx, _by, body_radius)) {
                    x = _bx;
                    y = _by;
                } else {
                    fh_move_and_collide(facing_x * 60, facing_y * 60);
                }
                fx_spawn_sparks(_ox, _oy, c_yellow, 10);
                fx_spawn_sparks(x, y, c_yellow, 10);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _ox, _oy) <= 80 || point_distance(x, y, other.x, other.y) <= 80) {
                        enemy_take_damage(id, other.attack_damage * 0.8, other.x, other.y, 100);
                        enemy_apply_slow(id, 0.4, 1.0);
                    }
                }
            } else if (defend_mode == "basalt_pillar") {
                trigger_hitstop(0.06);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 120) {
                        var _ang = point_direction(x, y, other.x, other.y);
                        x += lengthdir_x(25, _ang);
                        y += lengthdir_y(25, _ang);
                        enemy_take_damage(id, other.attack_damage * 0.6, other.x, other.y, 0);
                        enemy_apply_slow(id, 0.5, 2.0);
                    }
                }
                fx_spawn_sparks(x, y, make_colour_rgb(180, 140, 80), 12);
            } else if (defend_mode == "mist_roll") {
                invuln_timer = defend_duration;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 90) {
                        enemy_apply_slow(id, 0.4, 2.0);
                    }
                }
                fx_spawn_sparks(x, y, c_teal, 8);
            } else if (defend_mode == "fire_recoil") {
                invuln_timer = defend_duration;
                var _ex_x = x + facing_x * 40;
                var _ex_y = y + facing_y * 40;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _ex_x, _ex_y) <= 80) {
                        enemy_take_damage(id, other.attack_damage * 1.2, _ex_x, _ex_y, 180);
                        enemy_apply_poison(id, 3, 0.5, 2.0);
                    }
                }
                fx_spawn_death_burst(_ex_x, _ex_y, c_orange, 10);
            } else if (defend_mode == "cyclone_roll") {
                invuln_timer = defend_duration;
                for (var _a = -1; _a <= 1; _a++) {
                    var _ang = point_direction(0, 0, facing_x, facing_y) + _a * 25;
                    var _arr = instance_create_layer(x, y, layer, obj_atk_arrow);
                    _arr.owner = id;
                    _arr.damage = attack_damage * 0.55;
                    _arr.dir_x = lengthdir_x(1, _ang);
                    _arr.dir_y = lengthdir_y(1, _ang);
                    _arr.speed_px = projectile_speed * 1.1;
                    _arr.pierce_remaining = 1;
                }
                fx_spawn_sparks(x, y, c_lime, 6);
            } else if (defend_mode == "earth_anchor") {
                earth_anchored = true;
                fx_spawn_sparks(x, y, make_colour_rgb(140, 160, 60), 8);
            } else if (defend_mode == "spectral_mist") {
                invisible = true;
                invuln_timer = defend_duration;
                fx_spawn_sparks(x, y, c_aqua, 8);
            } else if (defend_mode == "ash_bomb") {
                invisible = true;
                invuln_timer = 0.5;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 100) {
                        enemy_take_damage(id, other.attack_damage * 0.9, other.x, other.y, 120);
                        enemy_apply_poison(id, 4, 0.5, 2.5);
                        enemy_apply_slow(id, 0.3, 1.5);
                    }
                }
                fx_spawn_death_burst(x, y, c_dkgray, 12);
            } else if (defend_mode == "shadowstep") {
                var _target = noone;
                var _min_dist = 9999;
                with (obj_enemy_parent) {
                    var _d = point_distance(other.x, other.y, x, y);
                    if (_d < _min_dist && _d <= 220) {
                        var _dot = (x - other.x) * other.facing_x + (y - other.y) * other.facing_y;
                        if (_dot > 0) {
                            _min_dist = _d;
                            _target = id;
                        }
                    }
                }
                if (_target != noone) {
                    var _bx = _target.x - facing_x * 24;
                    var _by = _target.y - facing_y * 24;
                    if (fh_place_free_of_walls(_bx, _by, body_radius)) {
                        x = _bx;
                        y = _by;
                    }
                    trigger_hitstop(0.04);
                } else {
                    fh_move_and_collide(facing_x * 90, facing_y * 90);
                }
                invisible = true;
                fx_spawn_sparks(x, y, c_purple, 8);
            } else if (defend_mode == "obsidian_skin") {
                invuln_timer = 0.2;
                fx_spawn_sparks(x, y, c_black, 10);
            }
        }
        break;

    case "attack":
        attack_timer -= _dt;
        if (!attack_has_fired && attack_timer <= attack_duration * 0.5) {
            attack_has_fired = true;
            player_perform_attack();
        }
        if (attack_timer <= 0) {
            // Combo duplo para o Duelista
            if (character_class == "knight" && element_affinity == "wind" && duelist_combo_count == 0) {
                duelist_combo_count = 1;
                state = "attack";
                attack_timer = attack_duration * 0.8;
                attack_has_fired = false;
            } else {
                duelist_combo_count = 0;
                state = "idle";
                attack_cooldown_timer = attack_cooldown;
            }
        }
        break;

    case "defend":
        defend_timer -= _dt;

        if (defend_mode == "roll" || defend_mode == "mist_roll" || defend_mode == "cyclone_roll") {
            fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
        } else if (defend_mode == "fire_recoil") {
            fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
        } else if (defend_mode == "spectral_mist") {
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                fh_move_and_collide((input_h / _len) * move_speed * 1.25 * _dt, (input_v / _len) * move_speed * 1.25 * _dt);
            }
        }

        // Paladino: Aura de Sobrevida cura em pulsos e reduz velocidade de movimento
        if (defend_mode == "paladin_aura") {
            paladin_aura_tick_timer -= _dt;
            if (paladin_aura_tick_timer <= 0) {
                paladin_aura_tick_timer = (variable_instance_exists(id, "synth_paladino_bencao_mare") && synth_paladino_bencao_mare > 0) ? 0.45 : paladin_aura_tick_interval;
                var _heal = 3 + synth_paladin_aura_heal + synth_paladino_bencao_mare;
                if (hp >= hp_max && variable_instance_exists(id, "synth_paladino_graca_abencoada") && synth_paladino_graca_abencoada > 0) {
                    paladin_barrier_active = min(hp_max * 0.75, paladin_barrier_active + _heal * 0.5);
                } else {
                    hp = min(hp_max, hp + _heal);
                }
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= other.paladin_aura_radius) {
                        enemy_apply_slow(id, 0.6, 0.6);
                        // 14 Correnteza Dilacerante
                        if (variable_instance_exists(other, "synth_paladino_correnteza_dilacerante") && other.synth_paladino_correnteza_dilacerante > 0) {
                            enemy_take_damage(id, other.synth_paladino_correnteza_dilacerante, other.x, other.y, 10);
                        }
                    }
                }
            }
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                fh_move_and_collide((input_h / _len) * move_speed * 0.6 * _dt, (input_v / _len) * move_speed * 0.6 * _dt);
            }
        }

        // Cavaleiro Padrao: Postura Firme & Muralha Movel
        if (defend_mode == "block") {
            var _block_spd_mult = 0.40;
            if (variable_instance_exists(id, "synth_postura_firme") && synth_postura_firme > 0) {
                _block_spd_mult = 0.70; // 50% menos desaceleracao!
            }
            if (variable_instance_exists(id, "synth_muralha_movel") && synth_muralha_movel > 0) {
                _block_spd_mult *= 1.30;
            }
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                fh_move_and_collide((input_h / _len) * move_speed * _block_spd_mult * _dt, (input_v / _len) * move_speed * _block_spd_mult * _dt);
            }
        }

        // Berserker: Furia permite movimento livre e ataque continuo
        if (defend_mode == "berserk_fury") {
            hp = min(hp_max, hp + (8 + synth_hp_reg * 2) * _dt);
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                facing_x = input_h / _len;
                facing_y = input_v / _len;
                fh_move_and_collide((input_h / _len) * move_speed * 1.15 * _dt, (input_v / _len) * move_speed * 1.15 * _dt);
            }
            if (attack_buffer_timer > 0 && attack_cooldown_timer <= 0) {
                attack_buffer_timer = 0;
                player_perform_attack();
                attack_cooldown_timer = attack_cooldown;
            }
        }

        // Guardiao: Bloqueio pesado com movimento reduzido
        if (defend_mode == "guardian_aegis") {
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                fh_move_and_collide((input_h / _len) * move_speed * 0.35 * _dt, (input_v / _len) * move_speed * 0.35 * _dt);
            }
        }

        if (defend_timer <= 0) {
            if (defend_mode == "spectral_mist") {
                hp = min(hp_max, hp + hp_max * 0.15);
            } else if (defend_mode == "cryo_prison") {
                if (variable_instance_exists(id, "synth_crio_prisao_criogenica") && synth_crio_prisao_criogenica > 0) {
                    for (var _f = 0; _f < 6; _f++) {
                        var _ang = _f * 60;
                        var _sh = instance_create_layer(x, y, layer, obj_atk_fireball);
                        _sh.owner = id;
                        _sh.damage = attack_damage * 0.6;
                        _sh.dir_x = lengthdir_x(1, _ang);
                        _sh.dir_y = lengthdir_y(1, _ang);
                        _sh.speed_px = 240;
                        _sh.pierce_remaining = 1;
                    }
                }
            } else if (defend_mode == "basalt_pillar") {
                if (variable_instance_exists(id, "synth_geo_monolito_esmagador") && synth_geo_monolito_esmagador > 0) {
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, other.x, other.y) <= 120) {
                            enemy_take_damage(id, 40, other.x, other.y, 160);
                        }
                    }
                    fx_spawn_death_burst(x, y, c_dkgray, 12);
                }
            }

            defend_active = false;
            invisible = false;
            earth_anchored = false;
            state = "idle";
            var _cd = defend_cooldown;
            if (defend_mode == "parry" && synth_duelist_parry_bonus > 0) {
                _cd = max(1.2, _cd - synth_duelist_parry_bonus * 0.35);
            }
            defend_cooldown_timer = _cd;
        }
        break;

    case "hurt":
        if (hit_flash_timer <= 0) state = "idle";
        break;
}

if ((defend_mode == "invisible" || defend_mode == "spectral_mist" || defend_mode == "ash_bomb" || defend_mode == "shadowstep") && state != "defend") invisible = false;

hp = clamp(hp, 0, hp_max);

if (sprite_walk != -1) {
    var _wanted_sprite = (state == "attack") ? sprite_attack : sprite_walk;
    if (sprite_index != _wanted_sprite) {
        sprite_index = _wanted_sprite;
        image_index = 0;
    }

    if (state == "attack") {
        image_speed = 1;
    } else {
        var _moving = (x != xprevious || y != yprevious);
        image_speed = _moving ? 1 : 0;
        if (!_moving) image_index = 0;
    }
} else {
    sprite_index = -1;
}
