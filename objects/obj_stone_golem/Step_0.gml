// ---------------------------------------------------------------------
// GOLEM DE PEDRA
//  - Inempurravel. Enquanto tem ARMADURA recebe so 35% do dano;
//    cada golpe racha a armadura (6 golpes -> quebra: atordoado 2.5s e +50% de dano).
//    A armadura se refaz 8s depois.
//  - PISAO: anel de choque que se expande pelo chao (esquive/atravesse com esquiva).
//  - ARREMESSO: pedregulho em arco; onde cai vira um obstaculo por 7s.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused()) exit;
if (hp <= 0) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();
knockback_resistance = 1.0; // inempurravel (o escalonamento do bioma limita a 0.9)

// --- Armadura (postura) detectada pela perda de vida ---
if (hp < last_hp && armor_hp > 0 && state != "broken") {
    armor_hp -= 1;
    fx_spawn_sparks(x, y, make_colour_rgb(180, 150, 110), 4);
    if (armor_hp <= 0) {
        state = "broken";
        broken_timer = 2.5;
        fh_vuln_timer = 2.5;
        damage_reduction = 1.0;
        armor_regen_timer = 8.0;
        ring_active = false;
        fx_spawn_damage_popup(x, y - 44, "ARMADURA QUEBRADA!", true, c_yellow);
        fx_spawn_death_burst(x, y, make_colour_rgb(150, 120, 90), 14);
        trigger_hitstop(0.08);
        trigger_camera_shake(6);
        sfx_play("stagger", 0.04);
    }
}
last_hp = hp;

if (armor_hp <= 0 && state != "broken") {
    armor_regen_timer -= _dt;
    if (armor_regen_timer <= 0) {
        armor_hp = armor_max;
        damage_reduction = armored_reduction;
        fx_spawn_damage_popup(x, y - 44, "ARMADURA REFEITA", false, make_colour_rgb(200, 170, 120));
        fx_spawn_sparks(x, y, make_colour_rgb(200, 170, 120), 12);
    }
}

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

// --- Anel de choque ---
if (ring_active) {
    ring_r += ring_speed * _dt;
    if (!ring_hit && _player != noone) {
        var _pd = point_distance(x, y, _player.x, _player.y);
        if (abs(_pd - ring_r) <= 10 + _player.body_radius) {
            ring_hit = true;
            player_take_damage(elem_dmg(18), "physical");
            elem_push_player(point_direction(x, y, _player.x, _player.y), 240);
        }
    }
    if (ring_r >= ring_max) ring_active = false;
}

if (state == "patrol" || state == "chase") state = "walk";

switch (state) {
    case "walk":
        body_colour = make_colour_rgb(125, 100, 75);
        if (_player == noone) break;
        facing_dir = point_direction(x, y, _player.x, _player.y);
        var _dist = point_distance(x, y, _player.x, _player.y);
        if (_dist > 90) ai_enemy_move(facing_dir, move_speed_effective, _dt);
        if (attack_cooldown_timer <= 0) {
            if (_dist <= 140 || next_attack == "stomp") {
                state = "slam_windup";
                windup_timer = 0.9;
                next_attack = "boulder";
            } else {
                state = "windup";
                windup_timer = 0.7;
                next_attack = "stomp";
            }
        }
        break;

    case "slam_windup":
        windup_timer -= _dt;
        scale_x = 0.85;
        scale_y = 1.3;
        body_colour = make_colour_rgb(190, 150, 100);
        if (windup_timer <= 0) {
            ring_active = true;
            ring_r = body_radius;
            ring_hit = false;
            elem_hit_player_circle(x, y, body_radius + 26, elem_dmg(22), "physical");
            fx_spawn_sparks(x, y, make_colour_rgb(160, 120, 80), 20);
            trigger_camera_shake(7);
            trigger_hitstop(0.06);
            sfx_play("slam", 0.05, 1.0);
            scale_x = 1.4;
            scale_y = 0.7;
            state = "recover";
            recover_timer = 1.2;
            fh_vuln_timer = max(fh_vuln_timer, 1.2);
            attack_cooldown_timer = attack_cooldown;
        }
        break;

    case "windup":
        windup_timer -= _dt;
        scale_x = 1.2;
        scale_y = 1.1;
        if (windup_timer <= 0) {
            if (_player != noone) {
                var _b = elem_spawn_missile(x, y - body_radius, "boulder", 0, 0, elem_dmg(16), make_colour_rgb(170, 125, 70));
                _b.target_x = _player.x;
                _b.target_y = _player.y;
                _b.flight_time = 0.85;
            }
            sfx_play("slam", 0.1, 0.4);
            state = "recover";
            recover_timer = 0.6;
            attack_cooldown_timer = attack_cooldown;
        }
        break;

    case "recover":
        recover_timer -= _dt;
        if (recover_timer <= 0) state = "walk";
        break;

    case "broken":
        broken_timer -= _dt;
        body_colour = make_colour_rgb(95, 75, 55);
        scale_x = 1.15;
        scale_y = 0.85;
        if (broken_timer <= 0) state = "walk";
        break;
}
