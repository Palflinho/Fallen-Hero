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
        } else if (_defend_pressed && defend_cooldown_timer <= 0) {
            // Special ability: press to activate a fixed window, then it's on cooldown.
            // No resource cost anymore -- just the cooldown gate.
            state = "defend";
            defend_active = true;
            defend_timer = defend_duration;
            if (defend_mode == "invisible") invisible = true;
            if (defend_mode == "roll") invuln_timer = defend_duration;
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
        defend_timer -= _dt;

        if (defend_mode == "roll") {
            fh_move_and_collide(facing_x * defend_roll_speed * _dt, facing_y * defend_roll_speed * _dt);
        }

        if (defend_timer <= 0) {
            defend_active = false;
            invisible = false;
            state = "idle";
            defend_cooldown_timer = defend_cooldown;
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
