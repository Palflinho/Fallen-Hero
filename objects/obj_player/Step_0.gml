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
        var _desired_vx = 0;
        var _desired_vy = 0;
        if (input_h != 0 || input_v != 0) {
            var _len = point_distance(0, 0, input_h, input_v);
            _desired_vx = (input_h / _len) * move_speed;
            _desired_vy = (input_v / _len) * move_speed;
            facing_x = input_h / _len;
            facing_y = input_v / _len;
        }

        on_ice = fh_place_on_ice(x, y);

        if (on_ice) {
            vx = lerp(vx, _desired_vx, 0.04);
            vy = lerp(vy, _desired_vy, 0.04);
        } else {
            vx = _desired_vx;
            vy = _desired_vy;
        }

        fh_move_and_collide(vx * _dt, vy * _dt);

        state = (point_distance(0, 0, vx, vy) > 5) ? "walk" : "idle";

        if (attack_buffer_timer > 0 && attack_cooldown_timer <= 0) {
            attack_buffer_timer = 0;
            state = "attack";
            attack_timer = attack_duration;
            attack_has_fired = false;
        } else if (_defend_pressed && defend_cooldown_timer <= 0) {
            state = "defend";
            defend_active = true;
            defend_timer = defend_duration;
            if (defend_mode == "invisible") invisible = true;
            if (defend_mode == "roll") invuln_timer = defend_duration;

            if (defend_mode == "paladin_aura") {
                paladin_aura_tick_timer = 0;
                if (synth_paladin_barrier > 0) {
                    paladin_barrier_active = synth_paladin_barrier;
                }
            } else if (defend_mode == "berserk_fury") {
                trigger_hitstop(0.04);
            } else if (defend_mode == "parry") {
                parry_flash_timer = 0.15;
            } else if (defend_mode == "guardian_aegis") {
                trigger_hitstop(0.05);
                // Provocar (Taunt) todos os inimigos da sala
                with (obj_enemy_parent) {
                    agro = true;
                }
                if (synth_guardian_taunt_shock > 0) {
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, other.x, other.y) <= 180) {
                            enemy_take_damage(id, other.synth_guardian_taunt_shock, other.x, other.y, 160);
                            enemy_apply_slow(id, 0.5, 2.0);
                        }
                    }
                }
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

        if (defend_mode == "roll") {
            fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
        }

        // Paladino: Aura de Sobrevida cura em pulsos e reduz velocidade de movimento
        if (defend_mode == "paladin_aura") {
            paladin_aura_tick_timer -= _dt;
            if (paladin_aura_tick_timer <= 0) {
                paladin_aura_tick_timer = paladin_aura_tick_interval;
                var _heal = 3 + synth_paladin_aura_heal;
                hp = min(hp_max, hp + _heal);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= other.paladin_aura_radius) {
                        enemy_apply_slow(id, 0.7, 0.6);
                    }
                }
            }
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                fh_move_and_collide((input_h / _len) * move_speed * 0.6 * _dt, (input_v / _len) * move_speed * 0.6 * _dt);
            }
        }

        // Berserker: Fúria permite movimento livre e ataque contínuo
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

        // Guardião: Bloqueio pesado com movimento reduzido
        if (defend_mode == "guardian_aegis") {
            if (input_h != 0 || input_v != 0) {
                var _len = point_distance(0, 0, input_h, input_v);
                fh_move_and_collide((input_h / _len) * move_speed * 0.35 * _dt, (input_v / _len) * move_speed * 0.35 * _dt);
            }
        }

        if (defend_timer <= 0) {
            defend_active = false;
            invisible = false;
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

if (defend_mode == "invisible" && state != "defend") invisible = false;

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
}
