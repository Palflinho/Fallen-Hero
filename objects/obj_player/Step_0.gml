if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
fx_system_update(_dt);

if (hp <= 0) {
    state = "dead";
    input_rumble_stop();
}

if (hit_flash_timer > 0) hit_flash_timer -= _dt;
if (invuln_timer > 0) invuln_timer -= _dt;
if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;
if (attack_buffer_timer > 0) attack_buffer_timer -= _dt;
if (defend_cooldown_timer > 0) defend_cooldown_timer -= _dt;
if (second_wind_cooldown_timer > 0) second_wind_cooldown_timer -= _dt;
if (parry_flash_timer > 0) parry_flash_timer -= _dt;
if (parry_haste_timer > 0) parry_haste_timer -= _dt;
if (furia_ancestral_timer > 0) furia_ancestral_timer -= _dt;
if (conflagracao_timer > 0) conflagracao_timer -= _dt;
if (cefiro_buff_timer > 0) cefiro_buff_timer -= _dt;
if (singularidade_timer > 0) singularidade_timer -= _dt;

attack_idle_timer += _dt;
if (dance_speed_timer > 0) dance_speed_timer -= _dt;
if (segundo_folego_cooldown > 0) segundo_folego_cooldown -= _dt;
if (archer_recuo_cooldown > 0) archer_recuo_cooldown -= _dt;
if (archer_hunter_reflex_timer > 0) archer_hunter_reflex_timer -= _dt;
if (archer_phantom_timer > 0) archer_phantom_timer -= _dt;
if (point_distance(0, 0, vx, vy) <= 5) {
    archer_stationary_timer += _dt;
    if (archer_stationary_timer >= 1.5 && character_class == "archer" && variable_instance_exists(id, "synth_archer_balist_balista_piromante") && synth_archer_balist_balista_piromante > 0 && random(1) < 0.15) {
        fx_spawn_sparks(x, y - 8, c_orange, 1);
    }
} else {
    archer_stationary_timer = 0;
}
if (assassin_free_evade_cooldown > 0) assassin_free_evade_cooldown -= _dt;
if (assassin_smoke_timer > 0) assassin_smoke_timer -= _dt;
if (assassin_entered_room_timer > 0) assassin_entered_room_timer -= _dt;
if (assassin_plasma_buff_timer > 0) assassin_plasma_buff_timer -= _dt;
if (frenesi_timer > 0) {
    frenesi_timer -= _dt;
    if (frenesi_timer <= 0) frenesi_stacks = 0;
}

if (poison_active) {
    poison_duration -= _dt;
    poison_tick_timer -= _dt;
    if (poison_tick_timer <= 0) {
        var _pdmg = poison_damage;
        if (variable_instance_exists(id, "paladin_barrier_active") && paladin_barrier_active > 0) {
            if (paladin_barrier_active >= _pdmg) {
                paladin_barrier_active -= _pdmg;
                _pdmg = 0;
                fx_spawn_damage_popup(x, y - 24, "SOBREVIDA!", false, c_aqua);
            } else {
                _pdmg -= paladin_barrier_active;
                paladin_barrier_active = 0;
                fx_spawn_damage_popup(x, y - 24, "ESCUDO QUEBROU!", false, c_orange);
            }
        }
        if (_pdmg > 0) {
            hp -= _pdmg;
        }
        poison_tick_timer = poison_tick_interval;
        hit_flash_timer = hit_flash_duration;
    }
    if (poison_duration <= 0) poison_active = false;
}

if (slow_active) {
    slow_duration -= _dt;
    if (slow_duration <= 0) {
        slow_active = false;
        slow_multiplier = 1;
    }
}

if (synth_hp_reg > 0 && state != "dead" && hp > 0) {
    hp = min(hp_max, hp + synth_hp_reg * _dt);
}

if (state == "dead") {
    exit;
}

var _attack_pressed = input_check_attack_pressed();
var _defend_pressed = input_check_defend_pressed();

if (_attack_pressed) attack_buffer_timer = attack_buffer_duration;

input_h = input_get_h();
input_v = input_get_v();

switch (state) {
    case "idle":
    case "walk":
        var _cur_speed = move_speed;
        if (dance_speed_timer > 0) _cur_speed *= 1.25;
        if (cefiro_buff_timer > 0) _cur_speed *= 1.10;
        if (slow_active) _cur_speed *= slow_multiplier;
        if (character_class == "assassin" && variable_instance_exists(id, "synth_assassin_vulcan_adrenalina_torrida") && synth_assassin_vulcan_adrenalina_torrida > 0) {
            var _burn_cnt = 0;
            with (obj_enemy_parent) {
                if (poison_active) _burn_cnt++;
            }
            assassin_adrenalina_spd = min(0.40, _burn_cnt * 0.04);
            _cur_speed *= (1.0 + assassin_adrenalina_spd);
        }

        // 42 Fortaleza Viva: ganha defesa conforme proximidade de inimigos
        if (character_class == "knight" && variable_instance_exists(id, "synth_guardiao_fortaleza_viva") && synth_guardiao_fortaleza_viva > 0) {
            var _near = 0;
            with (obj_enemy_parent) {
                if (point_distance(x, y, other.x, other.y) <= 90) _near++;
            }
            synth_guardian_def = _near * 3;
        }

        // Mage: 19 Rastro Flamejante (esteira de brasas ao andar)
        if (character_class == "mage" && variable_instance_exists(id, "synth_piro_rastro_flamejante") && synth_piro_rastro_flamejante > 0 && point_distance(0, 0, vx, vy) > 20) {
            if (random(1) < 0.25) {
                fx_spawn_sparks(x, y + 8, c_orange, 3);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y + 8) <= 35) {
                        enemy_take_damage(id, 2, other.x, other.y, 40);
                        enemy_apply_poison(id, 2, 0.5, 1.5);
                    }
                }
            }
        }

        // Mage: 25 Sobrecarga Estática (mover-se acumula carga até 100%)
        if (character_class == "mage" && variable_instance_exists(id, "synth_aero_sobrecarga_estatica") && synth_aero_sobrecarga_estatica > 0 && point_distance(0, 0, vx, vy) > 20) {
            estatica_charge = min(100, estatica_charge + _dt * 20);
            if (estatica_charge >= 100 && random(1) < 0.15) {
                fx_spawn_sparks(x, y - 8, c_yellow, 2);
            }
        }

        // Mage: 38 Poço Gravitacional (lentidão de 40% em 70px)
        if (character_class == "mage" && variable_instance_exists(id, "synth_geo_poco_gravitacional") && synth_geo_poco_gravitacional > 0) {
            with (obj_enemy_parent) {
                if (point_distance(x, y, other.x, other.y) <= 70) {
                    enemy_apply_slow(id, 0.40, 0.4);
                }
            }
        }

        var _desired_vx = 0;
        var _desired_vy = 0;
        if (input_h != 0 || input_v != 0) {
            var _len = point_distance(0, 0, input_h, input_v);
            var _ratio = min(1.0, _len);
            _desired_vx = (input_h / _len) * _cur_speed * _ratio;
            _desired_vy = (input_v / _len) * _cur_speed * _ratio;
            facing_x = input_h / _len;
            facing_y = input_v / _len;
            move_dir = point_direction(0, 0, facing_x, facing_y);
        }

        on_ice = fh_place_on_ice(x, y);
        var _on_puddle = fh_place_on_water_puddle(x, y);
        var _on_mud = fh_place_on_mud(x, y);

        if (on_ice) {
            // Física de Gelo: +20% velocidade máxima, inércia fluida de patinação
            _desired_vx *= 1.20;
            _desired_vy *= 1.20;
            vx = lerp(vx, _desired_vx, 0.04);
            vy = lerp(vy, _desired_vy, 0.04);
            if (point_distance(0, 0, vx, vy) > 20 && random(1) < 0.28) {
                fx_spawn_sparks(x, y + body_radius - 2, make_colour_rgb(190, 240, 255), 1);
            }
        } else if (_on_puddle) {
            // Poça de Água: Lentidão de 40%
            _desired_vx *= 0.60;
            _desired_vy *= 0.60;
            vx = _desired_vx;
            vy = _desired_vy;
            if (point_distance(0, 0, vx, vy) > 10 && random(1) < 0.20) {
                fx_spawn_sparks(x, y + body_radius, make_colour_rgb(70, 160, 240), 1);
            }
        } else if (_on_mud) {
            // Lama Movediça: Lentidão de 55%
            _desired_vx *= 0.45;
            _desired_vy *= 0.45;
            vx = _desired_vx;
            vy = _desired_vy;
            if (point_distance(0, 0, vx, vy) > 10 && random(1) < 0.20) {
                fx_spawn_sparks(x, y + body_radius, make_colour_rgb(80, 50, 25), 1);
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

            var _atk_spd_mult = 1 + synth_atk_spd_bonus;
            var _eff_atk_dur = attack_duration / max(0.2, _atk_spd_mult);
            if (paladin_barrier_active > 0 && variable_instance_exists(id, "synth_paladino_julgamento_sereno") && synth_paladino_julgamento_sereno > 0) {
                _eff_atk_dur *= 0.80; // +25% velocidade de ataque com barreira
            }
            if (frenesi_stacks > 0) {
                _eff_atk_dur *= (1 / (1 + frenesi_stacks * 0.05));
            }
            if (parry_haste_timer > 0) {
                _eff_atk_dur *= 0.80; // +25% velocidade de ataque (Reflexos Célere)
            }
            if (conflagracao_timer > 0) {
                _eff_atk_dur *= 0.77; // +30% velocidade de ataque (Conflagração Furiosa)
            }
            if (cefiro_buff_timer > 0) {
                _eff_atk_dur *= 0.90; // +10% velocidade de ataque pós-feitiço (Passo Céfiro)
            }
            if (character_class == "mage" && variable_instance_exists(id, "synth_mage_conjurador_supremo") && synth_mage_conjurador_supremo > 0 && mage_consecutive_hits >= 5) {
                _eff_atk_dur *= 0.50; // Gatling mágica instantânea (Conjurador Supremo)
            }
            if (character_class == "archer") {
                // 04 Aljava Leve (+20% velocidade de ataque base)
                if (variable_instance_exists(id, "synth_archer_aljava_leve") && synth_archer_aljava_leve > 0) {
                    _eff_atk_dur *= 0.83;
                }
                // 07 Reflexo do Caçador: +25% velocidade de ataque após rolamento por 2s
                if (variable_instance_exists(id, "archer_hunter_reflex_timer") && archer_hunter_reflex_timer > 0) {
                    _eff_atk_dur *= 0.80;
                }
                // 23 Dança dos Ventos: +100% velocidade para as próximas 2 flechas
                if (variable_instance_exists(id, "archer_wind_dance_shots") && archer_wind_dance_shots > 0) {
                    archer_wind_dance_shots--;
                    _eff_atk_dur *= 0.50;
                }
            }
            if (character_class == "assassin") {
                // 30 Celeridade Fantasma (+35% velocidade de ataque permanente com adagas)
                if (variable_instance_exists(id, "synth_assassin_tufao_celeridade_fantasma") && synth_assassin_tufao_celeridade_fantasma > 0) {
                    _eff_atk_dur *= 0.74;
                }
                // 48 Lâmina de Plasma Ígneo (+50% taxa de ataque por 3s após crítico)
                if (variable_instance_exists(id, "assassin_plasma_buff_timer") && assassin_plasma_buff_timer > 0) {
                    _eff_atk_dur *= 0.66;
                }
            }
            attack_duration_current = _eff_atk_dur;
            attack_timer = _eff_atk_dur;
            attack_has_fired = false;
        } else if (_defend_pressed && defend_cooldown_timer <= 0) {
            state = "defend";
            defend_active = true;
            defend_timer = defend_duration;
            if (defend_mode == "invisible") player_enter_stealth();
            if (defend_mode == "roll" || defend_mode == "mist_roll" || defend_mode == "cyclone_roll" || defend_mode == "fire_recoil") {
                invuln_timer = defend_duration;
                if (character_class == "archer") {
                    // 07 Reflexo do Caçador: +25% velocidade de ataque por 2s
                    if (variable_instance_exists(id, "synth_archer_reflexo_cacador") && synth_archer_reflexo_cacador > 0) {
                        archer_hunter_reflex_timer = 2.0;
                        fx_spawn_damage_popup(x, y - 18, "REFLEXO!", false, c_yellow);
                    }
                    // 24 Passo Etéreo: +0.15s invulnerabilidade no rolamento
                    if (variable_instance_exists(id, "synth_archer_venda_passo_etereo") && synth_archer_venda_passo_etereo > 0) {
                        invuln_timer += 0.15;
                    }
                    // 16 Névoa Ilusória: inimigos perdem a linha de visão
                    if (variable_instance_exists(id, "synth_archer_glacial_nevoa_ilusoria") && synth_archer_glacial_nevoa_ilusoria > 0) {
                        with (obj_enemy_parent) {
                            if (point_distance(x, y, other.x, other.y) <= 85) {
                                has_spotted_player = false;
                                lost_sight_timer = 2.0;
                                state = "patrol";
                            }
                        }
                    }
                    // 12 Pista Escorregadia: rastro de gelo desacelera inimigos
                    if (variable_instance_exists(id, "synth_archer_glacial_pista_escorregadia") && synth_archer_glacial_pista_escorregadia > 0) {
                        with (obj_enemy_parent) {
                            if (point_distance(x, y, other.x, other.y) <= 75) {
                                enemy_apply_slow(id, 0.40, 2.0);
                            }
                        }
                        fx_spawn_sparks(x, y, c_aqua, 6);
                    }
                    // 22 Rolamento Furacão: empurra inimigos adjacentes para fora
                    if (variable_instance_exists(id, "synth_archer_venda_rolamento_furacao") && synth_archer_venda_rolamento_furacao > 0) {
                        with (obj_enemy_parent) {
                            if (point_distance(x, y, other.x, other.y) <= 90) {
                                var _kdir = point_direction(other.x, other.y, x, y);
                                knockback_vx += lengthdir_x(180, _kdir);
                                knockback_vy += lengthdir_y(180, _kdir);
                            }
                        }
                        fx_spawn_sparks(x, y, make_colour_rgb(180, 240, 255), 8);
                    }
                    // 37 Estacas Defensivas: deixa armadilha de espinhos de pedra
                    if (variable_instance_exists(id, "synth_archer_terra_estacas_defensivas") && synth_archer_terra_estacas_defensivas > 0) {
                        with (obj_enemy_parent) {
                            if (point_distance(x, y, other.x, other.y) <= 75) {
                                enemy_take_damage(id, 14, other.x, other.y, 100);
                            }
                        }
                        fx_spawn_sparks(x, y, make_colour_rgb(140, 100, 50), 8);
                    }
                    // 47 Atirador Fantasma: clone translúcido que atira por 3s
                    if (variable_instance_exists(id, "synth_archer_atirador_fantasma") && synth_archer_atirador_fantasma > 0) {
                        archer_phantom_timer = 3.0;
                        archer_phantom_x = x;
                        archer_phantom_y = y;
                        fx_spawn_damage_popup(x, y - 20, "FANTASMA!", true, c_teal);
                    }
                }
            }

            var _mag_bonus = variable_instance_exists(id, "synth_pwr_magica") ? synth_pwr_magica : 0;
            if (defend_mode == "paladin_aura") {
                paladin_aura_tick_timer = 0;
                var _bar_cap = hp_max * 0.5 + round(_mag_bonus * 2);
                if (variable_instance_exists(id, "synth_paladino_bastiao_liquido") && synth_paladino_bastiao_liquido > 0) {
                    _bar_cap = hp_max * 0.75 + round(_mag_bonus * 3);
                }
                paladin_barrier_active = min(_bar_cap, paladin_barrier_active + 25 + synth_paladin_barrier + round(_mag_bonus * 2));
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
                            enemy_take_damage(id, 14 + round(_mag_bonus * 1.5), other.x, other.y, 200);
                            enemy_apply_slow(id, 0.2, 1.0);
                        }
                    }
                }
                if (synth_guardian_taunt_shock > 0) {
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, other.x, other.y) <= 180) {
                            enemy_take_damage(id, other.synth_guardian_taunt_shock + round(_mag_bonus * 1.5), other.x, other.y, 160);
                            enemy_apply_slow(id, 0.5, 2.0);
                        }
                    }
                }
            } else if (defend_mode == "cryo_prison") {
                invuln_timer = defend_duration;
                hp = min(hp_max, hp + round(hp_max * 0.15 + _mag_bonus * 1.5));
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 110) {
                        enemy_apply_slow(id, 0.0, 2.0);
                    }
                }
                fx_spawn_sparks(x, y, c_aqua, 16);
            } else if (defend_mode == "pyro_blast") {
                trigger_hitstop(0.05);
                if (variable_instance_exists(id, "synth_piro_conflagracao_furiosa") && synth_piro_conflagracao_furiosa > 0) {
                    conflagracao_timer = 3.0;
                    fx_spawn_damage_popup(x, y - 20, "CONFLAGRACAO!", false, c_orange);
                }
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 130) {
                        enemy_take_damage(id, other.attack_damage * 1.5 + _mag_bonus * 2.5, other.x, other.y, 220);
                        enemy_apply_poison(id, 4 + round(_mag_bonus * 0.4), 0.5, 3.0);
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
                var _hit_any = false;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _ox, _oy) <= 80 || point_distance(x, y, other.x, other.y) <= 80) {
                        enemy_take_damage(id, other.attack_damage * 0.8 + _mag_bonus * 1.5, other.x, other.y, 100);
                        enemy_apply_slow(id, 0.4, 1.0);
                        _hit_any = true;
                    }
                }
                // 27 Salto Tempestuoso: Recarrega 40% mais rápido se passar por inimigos
                if (_hit_any && variable_instance_exists(id, "synth_aero_salto_tempestuoso") && synth_aero_salto_tempestuoso > 0) {
                    defend_cooldown_timer *= 0.60;
                }
                // 26 Tufão Repulsor: Afasta projéteis em 110px
                if (variable_instance_exists(id, "synth_aero_tufao_repulsor") && synth_aero_tufao_repulsor > 0) {
                    with (obj_enemy_projectile) {
                        if (point_distance(x, y, other.x, other.y) <= 110) instance_destroy();
                    }
                }
            } else if (defend_mode == "basalt_pillar") {
                trigger_hitstop(0.06);
                invuln_timer = 1.0;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 120) {
                        var _ang = point_direction(other.x, other.y, x, y);
                        x += lengthdir_x(45, _ang);
                        y += lengthdir_y(45, _ang);
                        enemy_take_damage(id, other.attack_damage * 0.8 + _mag_bonus * 1.5, other.x, other.y, 0);
                        enemy_apply_slow(id, 0.5, 2.0);
                    }
                }
                fx_spawn_sparks(x, y, make_colour_rgb(180, 140, 80), 14);
            } else if (defend_mode == "mist_roll") {
                invuln_timer = defend_duration;
                player_enter_stealth();
                poison_active = false;
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 90) {
                        enemy_apply_slow(id, 0.4, 2.0);
                    }
                }
                fx_spawn_sparks(x, y, c_teal, 10);
            } else if (defend_mode == "fire_recoil") {
                invuln_timer = defend_duration;
                var _recoil_mult = (variable_instance_exists(id, "synth_archer_balist_propulsao_ardente") && synth_archer_balist_propulsao_ardente > 0) ? 1.50 : 1.0;
                var _ex_x = x + facing_x * (40 * _recoil_mult);
                var _ex_y = y + facing_y * (40 * _recoil_mult);
                // Propulsão Ardente: projeta o arqueiro 50% mais longe e deixa labaredas no solo
                if (variable_instance_exists(id, "synth_archer_balist_propulsao_ardente") && synth_archer_balist_propulsao_ardente > 0) {
                    vx -= facing_x * move_speed * 1.8;
                    vy -= facing_y * move_speed * 1.8;
                    fx_spawn_sparks(x, y, c_orange, 12);
                }
                var _blast_r = 80;
                if (variable_instance_exists(id, "synth_archer_balist_polvora_concentrada") && synth_archer_balist_polvora_concentrada > 0) {
                    _blast_r *= 1.25;
                }
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _ex_x, _ex_y) <= _blast_r) {
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
                if (variable_instance_exists(id, "synth_archer_terra_postura_fortaleza") && synth_archer_terra_postura_fortaleza > 0) {
                    fx_spawn_damage_popup(x, y - 20, "FORTALEZA!", false, make_colour_rgb(180, 140, 70));
                }
                fx_spawn_sparks(x, y, make_colour_rgb(140, 160, 60), 8);
            } else if (defend_mode == "spectral_mist") {
                player_enter_stealth();
                var _mist_dur = defend_duration;
                // 14 Passo das Mares (+1.5s duracao e +40% vel deslocamento)
                if (variable_instance_exists(id, "synth_assassin_espect_passo_mares") && synth_assassin_espect_passo_mares > 0) {
                    _mist_dur += 1.5;
                    defend_timer = _mist_dur;
                }
                invuln_timer = _mist_dur;
                fx_spawn_sparks(x, y, c_aqua, 8);
            } else if (defend_mode == "ash_bomb") {
                player_enter_stealth();
                invuln_timer = 0.5;
                var _ash_dmg = attack_damage * 0.9;
                // 20 Passo Explosivo (+35 dano de fogo e arremessa fagulhas em cone)
                if (variable_instance_exists(id, "synth_assassin_vulcan_passo_explosivo") && synth_assassin_vulcan_passo_explosivo > 0) {
                    _ash_dmg += 35;
                    for (var _fi = -2; _fi <= 2; _fi++) {
                        var _fang = point_direction(0, 0, facing_x, facing_y) + _fi * 18;
                        var _fspk = instance_create_layer(x, y, layer, obj_atk_fireball);
                        _fspk.owner = id;
                        _fspk.damage = 20;
                        _fspk.dir_x = lengthdir_x(1, _fang);
                        _fspk.dir_y = lengthdir_y(1, _fang);
                        _fspk.speed_px = 360;
                        _fspk.pierce_remaining = 1;
                    }
                    fx_spawn_damage_popup(x, y - 24, "PASSO EXPLOSIVO!", true, c_orange);
                }
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 110) {
                        enemy_take_damage(id, _ash_dmg, other.x, other.y, 120);
                        enemy_apply_poison(id, 4, 0.5, 2.5);
                        enemy_apply_slow(id, 0.3, 1.5);
                    }
                }
                // 25 Supernova Sombria (consome queimaduras ativas na sala em dano explosivo imediato)
                if (variable_instance_exists(id, "synth_assassin_vulcan_supernova_sombria") && synth_assassin_vulcan_supernova_sombria > 0) {
                    var _supernova_count = 0;
                    with (obj_enemy_parent) {
                        if (poison_active) {
                            var _rem_dmg = max(35, poison_duration * (poison_damage / max(0.1, poison_tick_interval)));
                            poison_active = false;
                            poison_duration = 0;
                            enemy_take_damage(id, _rem_dmg, x, y, 160);
                            fx_spawn_death_burst(x, y, c_orange, 12);
                            _supernova_count++;
                        }
                    }
                    if (_supernova_count > 0) {
                        fx_spawn_damage_popup(x, y - 32, "SUPERNOVA SOMBRIA!", true, c_orange);
                        trigger_hitstop(0.10);
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
                player_enter_stealth();
                last_attack_was_crit = true;
                fx_spawn_sparks(x, y, c_purple, 8);
            } else if (defend_mode == "obsidian_skin") {
                invuln_timer = 1.2;
                for (var _si = 0; _si < 6; _si++) {
                    var _sang = _si * 60;
                    var _spk = instance_create_layer(x, y, layer, obj_atk_dagger);
                    _spk.owner = id;
                    _spk.damage = attack_damage * 1.2;
                    _spk.dir_x = lengthdir_x(1, _sang);
                    _spk.dir_y = lengthdir_y(1, _sang);
                    _spk.body_radius = 28;
                    _spk.life = 0.3;
                }
                fx_spawn_sparks(x, y, make_colour_rgb(60, 60, 75), 14);
            }
        }
        break;

    case "attack":
        attack_timer -= _dt;
        if (character_class == "mage" && variable_instance_exists(id, "synth_mage_canalizacao_fluida") && synth_mage_canalizacao_fluida > 0) {
            if (input_h != 0 || input_v != 0) {
                var _alen = point_distance(0, 0, input_h, input_v);
                var _aspeed = move_speed * 0.70;
                fh_move_and_collide((input_h / _alen) * _aspeed * _dt, (input_v / _alen) * _aspeed * _dt);
            }
        }
        if (character_class == "archer") {
            if (input_h != 0 || input_v != 0) {
                var _alen = point_distance(0, 0, input_h, input_v);
                var _aspeed = move_speed * 0.35;
                // 01 Tiro em Corrida: reduz desaceleracao em 60%
                if (variable_instance_exists(id, "synth_archer_tiro_em_corrida") && synth_archer_tiro_em_corrida > 0) {
                    _aspeed = move_speed * 0.75;
                }
                fh_move_and_collide((input_h / _alen) * _aspeed * _dt, (input_v / _alen) * _aspeed * _dt);
            }
        }
        if (character_class == "assassin" && variable_instance_exists(id, "synth_assassin_espect_corte_fluido") && synth_assassin_espect_corte_fluido > 0) {
            // 11 Corte Fluido: desliza suavemente através de modelos de colisão
            fh_move_and_collide(facing_x * move_speed * 1.15 * _dt, facing_y * move_speed * 1.15 * _dt);
            if (random(1) < 0.20) fx_spawn_sparks(x, y, c_teal, 1);
        }
        var _curr_dur = variable_instance_exists(id, "attack_duration_current") ? attack_duration_current : attack_duration;
        if (!attack_has_fired && attack_timer <= _curr_dur * 0.5) {
            attack_has_fired = true;
            player_perform_attack();
        }
        if (attack_timer <= 0) {
            // Combo duplo para o Duelista
            if (character_class == "knight" && element_affinity == "wind" && duelist_combo_count == 0) {
                duelist_combo_count = 1;
                state = "attack";
                attack_duration_current = _curr_dur * 0.8;
                attack_timer = attack_duration_current;
                attack_has_fired = false;
            } else {
                duelist_combo_count = 0;
                var _was_invis = invisible;
                invisible = false;
                if (_was_invis && character_class == "assassin" && variable_instance_exists(id, "synth_assassin_obsid_mina_basalto") && synth_assassin_obsid_mina_basalto > 0) {
                    var _btrap = instance_create_layer(x, y, layer, obj_atk_dagger);
                    _btrap.owner = id;
                    _btrap.damage = attack_damage * 1.5;
                    _btrap.body_radius = 28;
                    _btrap.life = 6.0;
                    fx_spawn_damage_popup(x, y - 20, "MINA BASALTO!", false, c_gray);
                    fx_spawn_sparks(x, y, c_dkgray, 8);
                }
                state = "idle";
                attack_cooldown_timer = attack_cooldown;
            }
        }
        break;

    case "defend":
        // Cancelamento antecipado ao apertar o botão de defesa novamente (Cavaleiro e Mago)
        if ((character_class == "knight" || character_class == "mage") && _defend_pressed && defend_timer < (defend_duration - 0.08)) {
            defend_timer = 0;
            if (defend_mode == "cryo_prison") {
                invuln_timer = min(invuln_timer, 0.15);
            }
            fx_spawn_sparks(x, y, c_white, 6);
        }

        // Assassino: Movimentacao durante a habilidade com 20% de reducao de velocidade (80% da velocidade)
        if (character_class == "assassin" && (defend_mode == "invisible" || defend_mode == "ash_bomb" || defend_mode == "obsidian_skin")) {
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                facing_x = input_h / _len;
                facing_y = input_v / _len;
                move_dir = point_direction(0, 0, facing_x, facing_y);
                fh_move_and_collide((input_h / _len) * move_speed * 0.80 * _dt, (input_v / _len) * move_speed * 0.80 * _dt);
            }
        }

        // Assassino: quebra a furtividade ao atacar, desferindo golpe surpresa emboscado
        if (character_class == "assassin" && (attack_buffer_timer > 0 || _attack_pressed) && attack_cooldown_timer <= 0) {
            var _was_invis = invisible;
            defend_active = false;
            defend_timer = 0;
            state = "attack";
            attack_buffer_timer = 0;
            if (_was_invis && variable_instance_exists(id, "synth_assassin_obsid_mina_basalto") && synth_assassin_obsid_mina_basalto > 0) {
                var _btrap = instance_create_layer(x, y, layer, obj_atk_dagger);
                _btrap.owner = id;
                _btrap.damage = attack_damage * 1.5;
                _btrap.body_radius = 28;
                _btrap.life = 6.0;
                fx_spawn_damage_popup(x, y - 20, "MINA BASALTO!", false, c_gray);
                fx_spawn_sparks(x, y, c_dkgray, 8);
            }
            var _atk_spd_mult = 1 + synth_atk_spd_bonus;
            var _eff_atk_dur = attack_duration / max(0.2, _atk_spd_mult);
            if (frenesi_stacks > 0) {
                _eff_atk_dur *= (1 / (1 + frenesi_stacks * 0.05));
            }
            if (variable_instance_exists(id, "synth_assassin_tufao_celeridade_fantasma") && synth_assassin_tufao_celeridade_fantasma > 0) {
                _eff_atk_dur *= 0.74;
            }
            if (variable_instance_exists(id, "assassin_plasma_buff_timer") && assassin_plasma_buff_timer > 0) {
                _eff_atk_dur *= 0.66;
            }
            attack_duration_current = _eff_atk_dur;
            attack_timer = _eff_atk_dur;
            attack_has_fired = false;
            var _cd = defend_cooldown;
            if (variable_instance_exists(id, "synth_assassin_presteza_sombria") && synth_assassin_presteza_sombria > 0) {
                _cd = max(1.2, _cd - synth_assassin_presteza_sombria);
            }
            defend_cooldown_timer = _cd;
        }
        defend_timer -= _dt;

        if (defend_mode == "roll" || defend_mode == "mist_roll" || defend_mode == "cyclone_roll") {
            fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
        } else if (defend_mode == "fire_recoil") {
            fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
        } else if (defend_mode == "spectral_mist") {
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                var _mist_spd = 1.25;
                if (variable_instance_exists(id, "synth_assassin_espect_passo_mares") && synth_assassin_espect_passo_mares > 0) {
                    _mist_spd *= 1.40;
                }
                fh_move_and_collide((input_h / _len) * move_speed * _mist_spd * _dt, (input_v / _len) * move_speed * _mist_spd * _dt);
            }
        }

        // Paladino: Aura de Sobrevida cura em pulsos e reduz velocidade de movimento
        if (defend_mode == "paladin_aura") {
            paladin_aura_tick_timer -= _dt;
            if (paladin_aura_tick_timer <= 0) {
                paladin_aura_tick_timer = (variable_instance_exists(id, "synth_paladino_bencao_mare") && synth_paladino_bencao_mare > 0) ? 0.45 : paladin_aura_tick_interval;
                var _mag_bonus = variable_instance_exists(id, "synth_pwr_magica") ? synth_pwr_magica : 0;
                var _heal = 3 + synth_paladin_aura_heal + synth_paladino_bencao_mare + round(_mag_bonus * 0.4);
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
                            enemy_take_damage(id, other.synth_paladino_correnteza_dilacerante + round(_mag_bonus * 0.8), other.x, other.y, 10);
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
                move_dir = point_direction(0, 0, facing_x, facing_y);
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

            var _was_invis = invisible;
            defend_active = false;
            invisible = false;
            earth_anchored = false;
            state = "idle";
            if (_was_invis && character_class == "assassin" && variable_instance_exists(id, "synth_assassin_obsid_mina_basalto") && synth_assassin_obsid_mina_basalto > 0) {
                var _btrap = instance_create_layer(x, y, layer, obj_atk_dagger);
                _btrap.owner = id;
                _btrap.damage = attack_damage * 1.5;
                _btrap.body_radius = 28;
                _btrap.life = 6.0;
                fx_spawn_damage_popup(x, y - 20, "MINA BASALTO!", false, c_gray);
                fx_spawn_sparks(x, y, c_dkgray, 8);
            }
            var _cd = defend_cooldown;
            if (defend_mode == "parry" && synth_duelist_parry_bonus > 0) {
                _cd = max(1.2, _cd - synth_duelist_parry_bonus * 0.35);
            }
            if (character_class == "assassin" && variable_instance_exists(id, "synth_assassin_presteza_sombria") && synth_assassin_presteza_sombria > 0) {
                _cd = max(1.2, _cd - synth_assassin_presteza_sombria);
            }
            defend_cooldown_timer = _cd;
        }
        break;

    case "hurt":
        if (hit_flash_timer <= 0) state = "idle";
        break;
}

if ((defend_mode == "invisible" || defend_mode == "spectral_mist" || defend_mode == "ash_bomb" || defend_mode == "shadowstep") && state != "defend" && state != "attack") invisible = false;

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
