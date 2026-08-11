var _dt = delta_time / 1000000;

if (hp <= 0) {
    state = "dead";
}

if (hit_flash_timer > 0) hit_flash_timer -= _dt;
if (invuln_timer > 0) invuln_timer -= _dt;
if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;
if (defend_cooldown_timer > 0) defend_cooldown_timer -= _dt;

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

if (state == "dead") {
    exit;
}

var _left  = keyboard_check(vk_left);
var _right = keyboard_check(vk_right);
var _up    = keyboard_check(vk_up);
var _down  = keyboard_check(vk_down);
var _attack_pressed = keyboard_check_pressed(ord("Z"));
var _defend_down = keyboard_check(ord("X"));
var _defend_pressed = keyboard_check_pressed(ord("X"));

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

        if (_attack_pressed && attack_cooldown_timer <= 0) {
            state = "attack";
            attack_timer = attack_duration;
            attack_has_fired = false;
        } else if (defend_mode == "roll") {
            if (_defend_pressed && defend_cooldown_timer <= 0 && stamina >= defend_block_cost) {
                state = "defend";
                defend_active = true;
                stamina -= defend_block_cost;
                stamina_regen_timer = stamina_regen_delay;
                roll_timer = defend_roll_duration;
                invuln_timer = defend_roll_duration;
            }
        } else if (_defend_down) {
            if (defend_mode == "block" || mana > 0) {
                state = "defend";
                defend_active = true;
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
            state = "idle";
            attack_cooldown_timer = attack_cooldown;
        }
        break;

    case "defend":
        switch (defend_mode) {
            case "block":
                defend_active = true;
                if (!_defend_down) {
                    defend_active = false;
                    state = "idle";
                }
                break;

            case "manashield":
                defend_active = true;
                if (!_defend_down || mana <= 0) {
                    defend_active = false;
                    state = "idle";
                } else {
                    mana = max(0, mana - defend_mana_drain * _dt);
                }
                break;

            case "invisible":
                defend_active = true;
                invisible = true;
                if (!_defend_down || mana <= 0) {
                    defend_active = false;
                    invisible = false;
                    state = "idle";
                } else {
                    mana = max(0, mana - defend_mana_drain * _dt);
                }
                break;

            case "roll":
                roll_timer -= _dt;
                fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
                if (roll_timer <= 0) {
                    defend_active = false;
                    state = "idle";
                    defend_cooldown_timer = defend_cooldown;
                }
                break;
        }
        break;

    case "hurt":
        if (hit_flash_timer <= 0) state = "idle";
        break;
}

if (defend_mode == "invisible" && state != "defend") invisible = false;

var _draining_mana = defend_active && (defend_mode == "manashield" || defend_mode == "invisible");

if (stamina_regen_timer > 0) {
    stamina_regen_timer -= _dt;
} else if (stamina < stamina_max) {
    stamina = min(stamina_max, stamina + stamina_regen * _dt);
}

if (!_draining_mana) {
    if (mana_regen_timer > 0) {
        mana_regen_timer -= _dt;
    } else if (mana < mana_max) {
        mana = min(mana_max, mana + mana_regen * _dt);
    }
}

hp = clamp(hp, 0, hp_max);
stamina = clamp(stamina, 0, stamina_max);
mana = clamp(mana, 0, mana_max);

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
