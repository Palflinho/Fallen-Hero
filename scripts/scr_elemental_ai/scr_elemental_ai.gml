// =========================================================================
// KIT DE MECANICAS ELEMENTAIS (Slimes, Elementais, Conjuradores, Golens,
// Fogo-fatuo, Totens e Espiritos das Arenas)
// =========================================================================
// Principios de leitura (Miyamoto/Sakurai):
//   - FORMA = tipo de ataque: circulo = area, linha = investida, seta = projetil.
//   - COR = elemento: azul-agua, laranja-fogo, branco/ciano-vento, marrom-terra.
//   - Todo golpe forte deixa uma janela de vulnerabilidade (fh_vuln_timer).
// =========================================================================

function elem_colour(_elem) {
    if (_elem == "fire") return make_colour_rgb(255, 130, 40);
    if (_elem == "wind") return make_colour_rgb(200, 250, 255);
    if (_elem == "earth") return make_colour_rgb(170, 125, 70);
    return make_colour_rgb(70, 170, 255);
}

// Dano base escalado pelo bioma (enemy_ensure_scaling preenche atk_scale)
function elem_dmg(_base) {
    var _s = variable_instance_exists(id, "atk_scale") ? atk_scale : 1;
    return max(1, round(_base * _s));
}

function elem_player() {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return noone;
    if (_p.hp <= 0) return noone;
    return _p;
}

// Empurrao suave aplicado ao jogador ao longo de alguns frames (obj_player consome fh_push_vx/vy)
function elem_push_player(_dir, _force) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;
    if (player_is_anchored(_p)) {
        fx_spawn_sparks(_p.x, _p.y + _p.body_radius, make_colour_rgb(160, 130, 80), 4);
        return;
    }
    _p.fh_push_vx = lengthdir_x(_force, _dir);
    _p.fh_push_vy = lengthdir_y(_force, _dir);
}

// Dano circular ao jogador. Retorna true se acertou.
function elem_hit_player_circle(_x, _y, _radius, _damage, _type) {
    var _p = elem_player();
    if (_p == noone) return false;
    if (point_distance(_x, _y, _p.x, _p.y) > _radius + _p.body_radius) return false;
    player_take_damage(_damage, _type);
    return true;
}

// Dano circular aos proprios inimigos (explosoes do Slime de Fogo, etc.)
function elem_hit_enemies_circle(_x, _y, _radius, _damage, _ignore) {
    with (obj_enemy_parent) {
        if (id != _ignore && hp > 0 && point_distance(x, y, _x, _y) <= _radius + body_radius) {
            enemy_take_damage(id, _damage, _x, _y, 200);
        }
    }
}

function elem_spawn_ground(_x, _y, _kind, _radius, _life) {
    var _g = instance_create_layer(_x, _y, layer, obj_elem_ground);
    _g.kind = _kind;
    _g.owner_obj = object_index;
    _g.radius = _radius;
    _g.life = _life;
    _g.life_max = _life;
    if (_kind == "fire") _g.colour = elem_colour("fire");
    else if (_kind == "slick") _g.colour = make_colour_rgb(190, 240, 255);
    else if (_kind == "mist") _g.colour = elem_colour("wind");
    else _g.colour = c_white;
    return _g;
}

function elem_spawn_missile(_x, _y, _kind, _dir, _speed, _damage, _colour) {
    var _m = instance_create_layer(_x, _y, layer, obj_elem_missile);
    _m.kind = _kind;
    _m.owner = id;
    _m.owner_obj = object_index;
    _m.dir = _dir;
    _m.spd = _speed;
    _m.damage = _damage;
    _m.colour = _colour;
    _m.origin_x = _x;
    _m.origin_y = _y;
    return _m;
}

function elem_spawn_projectile(_x, _y, _dir, _speed, _damage, _colour, _type) {
    var _p = instance_create_layer(_x, _y, layer, obj_enemy_projectile);
    _p.owner = id;
    _p.owner_obj = object_index;
    _p.damage = _damage;
    _p.dir_x = lengthdir_x(1, _dir);
    _p.dir_y = lengthdir_y(1, _dir);
    _p.speed_px = _speed;
    _p.colour = _colour;
    _p.damage_type = _type;
    return _p;
}

// Algum ataque do jogador esta tocando este ponto? (estourar bolhas, etc.)
function elem_player_attack_near(_x, _y, _radius) {
    var _objs = [obj_atk_knight, obj_atk_dagger, obj_atk_arrow, obj_atk_fireball];
    for (var _i = 0; _i < array_length(_objs); _i++) {
        var _a = instance_nearest(_x, _y, _objs[_i]);
        if (_a != noone && point_distance(_x, _y, _a.x, _a.y) <= _radius + _a.body_radius) return true;
    }
    return false;
}

// Barreira de vento: devolve flechas/bolas de fogo do jogador que entrarem no raio
function elem_reflect_player_projectiles(_x, _y, _radius, _colour) {
    var _count = 0;
    var _p = elem_player();
    var _objs = [obj_atk_arrow, obj_atk_fireball];
    for (var _i = 0; _i < array_length(_objs); _i++) {
        with (_objs[_i]) {
            // Ilusionista e Cacador Furtivo: vento nao reflete vento
            var _wind_user = (instance_exists(owner) && owner.element_affinity == "wind" && (owner.character_class == "mage" || owner.character_class == "archer"));
            if (!_wind_user && point_distance(x, y, _x, _y) <= _radius) {
                var _back = (_p != noone) ? point_direction(x, y, _p.x, _p.y) : point_direction(0, 0, -dir_x, -dir_y);
                var _r = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _r.owner = noone;
                _r.damage = max(4, round(damage * 0.6));
                _r.dir_x = lengthdir_x(1, _back);
                _r.dir_y = lengthdir_y(1, _back);
                _r.speed_px = 300;
                _r.colour = _colour;
                _r.damage_type = "projectile";
                fx_spawn_sparks(x, y, _colour, 6);
                _count++;
                instance_destroy();
            }
        }
    }
    if (_count > 0) {
        fx_spawn_damage_popup(_x, _y - 30, "REFLETIDO!", false, _colour);
        sfx_play("wind_gust", 0.1, 0.6);
    }
    return _count;
}

// Levanta uma parede de pedra temporaria (filha de obj_wall => bloqueia tudo).
// Recusa se for prender o jogador ou um inimigo dentro dela.
function elem_raise_wall(_cx, _cy, _cells_w, _cells_h, _life) {
    var _size = 32;
    var _w = _cells_w * _size;
    var _h = _cells_h * _size;
    var _x1 = _cx - _w * 0.5;
    var _y1 = _cy - _h * 0.5;
    if (_x1 < 40 || _y1 < 40 || _x1 + _w > room_width - 40 || _y1 + _h > room_height - 40) return noone;

    var _blocked = false;
    var _p = instance_find(obj_player, 0);
    if (_p != noone) {
        var _px = clamp(_p.x, _x1, _x1 + _w);
        var _py = clamp(_p.y, _y1, _y1 + _h);
        if (point_distance(_p.x, _p.y, _px, _py) < _p.body_radius + 4) _blocked = true;
    }
    with (obj_enemy_parent) {
        var _ex = clamp(x, _x1, _x1 + _w);
        var _ey = clamp(y, _y1, _y1 + _h);
        if (point_distance(x, y, _ex, _ey) < body_radius + 2) _blocked = true;
    }
    if (_blocked) return noone;

    var _wall = instance_create_layer(_x1, _y1, layer, obj_elem_wall);
    _wall.base_size = _size;
    _wall.image_xscale = _cells_w;
    _wall.image_yscale = _cells_h;
    _wall.life = _life;
    _wall.life_max = _life;
    fx_spawn_sparks(_cx, _cy, elem_colour("earth"), 10);
    return _wall;
}

// Ponto livre aleatorio a uma distancia do alvo (teleportes, clones, emergir)
function elem_find_point_around(_tx, _ty, _dmin, _dmax, _radius) {
    for (var _i = 0; _i < 16; _i++) {
        var _a = random(360);
        var _d = random_range(_dmin, _dmax);
        var _nx = clamp(_tx + lengthdir_x(_d, _a), 64, room_width - 64);
        var _ny = clamp(_ty + lengthdir_y(_d, _a), 64, room_height - 64);
        if (fh_place_free_of_walls(_nx, _ny, _radius)) return { x: _nx, y: _ny };
    }
    return fh_find_free_spawn_pos(_tx, _ty, _radius);
}

// Limpa sorteios de elite/raro/alfa (usado por minis, clones e espiritos)
function elem_strip_elite() {
    is_rare_mob = false;
    rare_chest_drop_chance = 0;
    elite_affix = "none";
    bulwark_hits = 0;
    is_greater_variant = false;
    scale_x = 1;
    scale_y = 1;
}

// Guarda comum para o inicio do Step dos inimigos redesenhados.
// Retorna true quando a IA NAO deve agir neste frame (pausa ou atordoamento).
function elem_ai_blocked() {
    if (is_world_paused()) return true;
    if (variable_instance_exists(id, "stagger_timer") && stagger_timer > 0) return true;
    if (hp <= 0) return true;
    return false;
}

// Desenha um anel de aviso no chao (circulo = area). _t de 0 a 1 = carga.
function elem_draw_warning_circle(_x, _y, _radius, _t, _colour) {
    draw_set_alpha(0.22);
    draw_set_color(_colour);
    draw_circle(_x, _y, _radius * clamp(_t, 0, 1), false);
    draw_set_alpha(0.8);
    draw_circle(_x, _y, _radius, true);
    draw_set_alpha(1);
}

// Linha de aviso (linha = investida)
function elem_draw_warning_line(_x, _y, _dir, _length, _width, _colour) {
    var _x2 = _x + lengthdir_x(_length, _dir);
    var _y2 = _y + lengthdir_y(_length, _dir);
    draw_set_alpha(0.25 + 0.15 * sin(current_time * 0.03));
    draw_set_color(_colour);
    draw_line_width(_x, _y, _x2, _y2, _width);
    draw_set_alpha(0.9);
    draw_line_width(_x, _y, _x2, _y2, 2);
    draw_set_alpha(1);
}

// =========================================================================
// ESPIRITOS ELEMENTAIS - chefes finais das Arenas de cada Templo
// =========================================================================
function spirit_init(_name, _element, _hp) {
    elem_strip_elite();
    is_spirit_boss = true;
    spirit_name = _name;
    element = _element;
    body_colour = elem_colour(_element);
    hp_max = _hp;
    hp = hp_max;
    hp_lag = hp;
    has_poise = false;
    can_enrage = false;
    knockback_resistance = 0.9;
    vision_range = 9999;
    vision_angle = 360;
    patrol_radius = 0;
    has_spotted_player = true;
    exp_reward = 160;
    gold_reward = 15;
    phase2 = false;
    state = "intro";
    state_timer = 1.4;
    action_timer = 1.0;
    fh_untargetable = true;
    draw_alpha = 0;
}

// Transicao para a 2a fase aos 50% de vida. Retorna true no frame da transicao.
function spirit_check_phase2() {
    if (phase2 || hp > hp_max * 0.5) return false;
    phase2 = true;
    fx_spawn_damage_popup(x, y - body_radius - 30, "O ESPIRITO SE ENFURECE!", true, c_red);
    fx_spawn_sparks(x, y, elem_colour(element), 24);
    trigger_camera_shake(6);
    trigger_hitstop(0.08);
    sfx_play("thunder", 0.05, 0.7);
    return true;
}

// Aparicao do espirito (intangivel, surge aos poucos). Retorna true enquanto dura.
function spirit_update_intro(_dt) {
    if (state != "intro") return false;
    state_timer -= _dt;
    draw_alpha = clamp(1 - state_timer / 1.4, 0, 1);
    draw_z = 20 * (state_timer / 1.4);
    fh_untargetable = true;
    if (random(1) < 0.4) fx_spawn_sparks(x + random_range(-20, 20), y + random_range(-20, 20), elem_colour(element), 1);
    if (state_timer <= 0) {
        state = "idle";
        fh_untargetable = false;
        draw_alpha = 1;
        draw_z = 0;
        action_timer = 0.8;
    }
    return true;
}

// Estrelas de "exposto" sobre a cabeca (janela de vulnerabilidade dos espiritos)
function spirit_draw_exposed() {
    var _sy = y - draw_z - body_radius - 22;
    draw_set_color(c_yellow);
    for (var _s = 0; _s < 3; _s++) {
        var _sa = current_time * 0.01 + _s * 2.09;
        draw_circle(x + cos(_sa) * 16, _sy + sin(_sa) * 5, 3, false);
    }
    draw_set_color(c_white);
}

// =========================================================================
// CHEFES PRINCIPAIS (Generais e O Salvador)
// Cada chefe tem UMA mecanica central que abre a janela de dano. Fora da janela
// recebe so dano leve (boss_chip); na janela recebe 100% +50% (anel amarelo).
// Fases: 1 (100-66%), 2 (66-33%), 3 (abaixo de 33%) - cada fase adiciona um golpe.
// =========================================================================
function boss_init_common(_chip) {
    boss_chip = _chip;
    damage_reduction = _chip;
    boss_phase = 1;
    boss_phase_shield = 0;
    boss_phase_shield_popup = 0;
    boss_level_scaled = false;
    vulnerable = false;
    vulnerable_timer = 0;
    has_poise = false;
    can_enrage = false;
}

// Nivel esperado do heroi ao chegar em cada chefe (curva de XP quadratica)
function boss_expected_level(_obj) {
    if (_obj == obj_boss) return 10;
    if (_obj == obj_boss2) return 14;
    if (_obj == obj_boss3) return 17;
    if (_obj == obj_boss4) return 20;
    if (_obj == obj_boss_human) return 22;
    return 1;
}

// Chefe escala com o heroi: +4% de vida por nivel acima do esperado (maximo +80%).
// Quem chega no nivel normal (ou abaixo) enfrenta o chefe com a vida base.
function boss_apply_level_scaling() {
    boss_level_scaled = true;
    var _pl = instance_find(obj_player, 0);
    if (_pl == noone) { boss_level_scaled = false; return; }
    var _over = max(0, _pl.level - boss_expected_level(object_index));
    if (_over <= 0) return;
    var _mult = min(1.8, 1 + 0.04 * _over);
    var _ratio = (hp_max > 0) ? (hp / hp_max) : 1;
    hp_max = round(hp_max * _mult);
    hp = round(hp_max * _ratio);
    if (variable_instance_exists(id, "hp_lag")) hp_lag = hp;
}

// Vida minima da fase atual: o dano nunca atravessa o limite da fase (66% / 33%),
// entao nenhum golpe forte pula uma fase inteira.
function boss_phase_floor(_inst) {
    if (!variable_instance_exists(_inst, "boss_phase")) return 0;
    if (_inst.boss_phase == 1) return ceil(_inst.hp_max * 0.66);
    if (_inst.boss_phase == 2) return ceil(_inst.hp_max * 0.33);
    return 0;
}

// Retorna true no frame em que o chefe muda de fase.
// Na troca de fase o chefe PERCEBE: fecha qualquer janela de dano, solta um rugido que
// empurra o jogador para longe e fica imune por 1.5s enquanto muda de postura.
function boss_update_phase() {
    if (!boss_level_scaled) boss_apply_level_scaling();
    if (boss_phase_shield > 0) {
        boss_phase_shield -= delta_time / 1000000;
        if (boss_phase_shield_popup > 0) boss_phase_shield_popup -= delta_time / 1000000;
        if (random(1) < 0.5) fx_spawn_sparks(x + random_range(-body_radius, body_radius), y + random_range(-body_radius, body_radius), c_white, 1);
    }

    var _target = (hp <= hp_max * 0.33) ? 3 : ((hp <= hp_max * 0.66) ? 2 : 1);
    if (_target <= boss_phase) return false;
    boss_phase = _target;

    // Encerra a janela de dano em andamento (o proprio chefe volta ao estado de recuperacao
    // no mesmo frame, pelo seu bloco "if (vulnerable)")
    if (vulnerable) vulnerable_timer = min(vulnerable_timer, 0.001);
    fh_vuln_timer = 0;
    boss_phase_shield = 1.5;
    boss_phase_shield_popup = 0;

    // Rugido: afasta o jogador
    var _pl = instance_find(obj_player, 0);
    if (_pl != noone && point_distance(x, y, _pl.x, _pl.y) <= 220) {
        elem_push_player(point_direction(x, y, _pl.x, _pl.y), 320);
    }

    fx_spawn_damage_popup(x, y - body_radius - 44, "FASE " + string(boss_phase) + "!", true, c_red);
    fx_spawn_death_burst(x, y, c_white, 28);
    fx_spawn_sparks(x, y, c_red, 24);
    trigger_camera_shake(10);
    trigger_hitstop(0.15);
    sfx_play("thunder", 0.05, 0.9);
    return true;
}

function boss_open_window(_dur) {
    vulnerable = true;
    vulnerable_timer = _dur;
    damage_reduction = 1.0;
    fh_vuln_timer = _dur;
}

function boss_close_window() {
    vulnerable = false;
    vulnerable_timer = 0;
    damage_reduction = boss_chip;
    fh_vuln_timer = 0;
}

// Distancia de um ponto ao segmento (lasers, ondas)
function elem_point_segment_dist(_px, _py, _x1, _y1, _x2, _y2) {
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    var _len2 = _dx * _dx + _dy * _dy;
    var _t = (_len2 > 0) ? clamp(((_px - _x1) * _dx + (_py - _y1) * _dy) / _len2, 0, 1) : 0;
    return point_distance(_px, _py, _x1 + _t * _dx, _y1 + _t * _dy);
}

// Rotulo padrao sobre a cabeca dos chefes
function boss_draw_label(_name, _hint) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(vulnerable ? c_yellow : c_white);
    draw_text(x, y - draw_z - body_radius - 24, vulnerable ? _hint : _name);
    // Mutacao da IA adaptativa (resistencias/fraquezas aprendidas)
    if (variable_instance_exists(id, "adaptation") && is_struct(adaptation) && adaptation.active) {
        draw_set_color(adaptation.aura_colour);
        draw_text(x, y - draw_z - body_radius - 42, "* " + adaptation.title + " *");
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// =========================================================================
// INTERACOES DE CLASSE (Iwata/Sakurai: "cada heroi le o mesmo inimigo de um jeito")
// Cada CLASSE tem um verbo base e cada ESPECIALIZACAO uma interacao propria.
//   Cavaleiro  - SEGURAR: escudo erguido para investidas.
//   Maga       - INTERROMPER: magia cancela canalizacoes (curas, barreiras, chuvas).
//   Arqueiro   - DERRUBAR: flechas derrubam o que voa.
//   Assassino  - SOMBRA: invisivel, o que persegue perde o alvo; nucleos pelas costas.
// Tabela completa em docs/INTERACOES_DE_CLASSE.md
// =========================================================================

function player_is_archetype(_p, _class, _elem) {
    return (_p != noone && instance_exists(_p) && _p.character_class == _class && _p.element_affinity == _elem);
}

// Escudo do Cavaleiro contra investidas: 0 = nenhum, 1 = parcial (escudo comum, aura), 2 = total (Guardiao, Duelista)
function player_shield_tier(_p) {
    if (_p == noone || !instance_exists(_p) || _p.character_class != "knight") return 0;
    if (_p.state != "defend" || !_p.defend_active) return 0;
    if (_p.defend_mode == "guardian_aegis" || _p.defend_mode == "parry") return 2;
    if (_p.defend_mode == "block" || _p.defend_mode == "paladin_aura") return 1;
    return 0;
}

// Ancorado: Sentinela (ancora) e Cavaleiro Runico em Furia ignoram empurroes e puxoes
function player_is_anchored(_p) {
    if (_p == noone || !instance_exists(_p)) return false;
    if (variable_instance_exists(_p, "earth_anchored") && _p.earth_anchored) return true;
    if (_p.state == "defend" && _p.defend_active && _p.defend_mode == "berserk_fury") return true;
    return false;
}

// Jogador que pode ser RASTREADO (invisivel = o ataque perde o alvo)
function elem_player_tracking() {
    var _p = elem_player();
    if (_p == noone || _p.invisible) return noone;
    return _p;
}

// Puxao continuo (vortices, vendavais) respeitando a ancora
function elem_pull_player(_dx, _dy) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone || player_is_anchored(_p)) return;
    with (_p) fh_move_and_collide(_dx, _dy);
}

// Chamado por player_on_hit_enemy ANTES do calculo de dano.
// Retorna o dano (possivelmente modificado) ou -1 quando a interacao consome o golpe.
function class_interaction_on_hit(_o, _e, _dmg) {
    var _cls = _o.character_class;
    var _el = _o.element_affinity;
    var _obj = _e.object_index;

    // ---------------- ARQUEIRO: derrubar voadores ----------------
    // Regra do elemento: Agua empresta o estilo do Arqueiro - as laminas do Lanceiro e as facas do
    // Rastreador e as lancas da Atiradora Arcana tambem derrubam voadores.
    if ((_cls == "archer" || _el == "water") && _e.fh_untargetable && _e.fh_air) {
        _e.fh_air_hits += 1;
        _e.fh_air_shot = true;
        fx_spawn_sparks(_e.x, _e.y - _e.draw_z, c_white, 8);
        return -1;
    }
    if (_cls == "archer") {
        if (_obj == obj_wisp) {
            fx_spawn_damage_popup(_e.x, _e.y - 24, "ABATIDO!", true, c_yellow);
            return _e.hp + 999;
        }
        // Artilheiro Arcano: flecha incendiaria detona o Slime de Fogo inchado (explosao so fere inimigos)
        if (_el == "fire" && _obj == obj_fire_slime && _e.state == "swell") {
            _e.swell_timer = 0;
            _e.swell_safe = true;
            fx_spawn_damage_popup(_e.x, _e.y - 30, "DETONADO!", true, c_orange);
        }
    }

    // ---------------- CAVALEIRO ----------------
    // Talento Estocada Distante (Lanceiro): laminas d'agua em alvos a mais de 120px causam +50%
    if (_cls == "knight" && variable_instance_exists(_o, "synth_paladino_gota_purificadora") && _o.synth_paladino_gota_purificadora > 0
        && point_distance(_o.x, _o.y, _e.x, _e.y) > 120) {
        _dmg *= 1.5;
        if (random(1) < 0.25) fx_spawn_damage_popup(_e.x, _e.y - _e.body_radius - 20, "ESTOCADA DISTANTE!", false, c_aqua);
    }

    // ---------------- MAGA: interromper canalizacoes ----------------
    if (_cls == "mage") {
        if (_e.fh_channeling && !_e.fh_interrupt) {
            _e.fh_interrupt = true;
            fx_spawn_damage_popup(_e.x, _e.y - _e.body_radius - 26, "INTERROMPIDO!", true, c_fuchsia);
            trigger_hitstop(0.06);
        }
        // Atiradora Arcana: precisao contra alvos lentos ou congelados
        if (_el == "water" && _e.slow_active) {
            _dmg *= 1.3;
            if (random(1) < 0.2) fx_spawn_damage_popup(_e.x, _e.y - _e.body_radius - 20, "PRECISAO!", false, c_aqua);
        }
        // Atiradora Arcana (antiga Criomante): gelo apaga o Slime de Fogo inchado
        if (_el == "water" && _obj == obj_fire_slime && _e.state == "swell") {
            _e.state = "chase";
            _e.scale_x = 1;
            _e.scale_y = 1;
            fx_spawn_damage_popup(_e.x, _e.y - 30, "APAGADO!", true, c_aqua);
            fx_spawn_sparks(_e.x, _e.y, c_white, 12);
        }
        // Piromante: fogo derrete o General da Agua congelado
        if (_el == "fire" && _obj == obj_boss && _e.state == "frozen") {
            _dmg *= 1.3;
            if (random(1) < 0.35) fx_spawn_damage_popup(_e.x, _e.y - _e.body_radius - 20, "DERRETENDO!", false, c_orange);
        }
        // Templaria: terra atravessa terra (carapacas e a frente do Tita)
        if (_el == "earth" && _e.fh_shell_hits > 0) _e.fh_pierce_next = 0.5;
    }

    // ---------------- ASSASSINO: sombra e pontos fracos ----------------
    if (_cls == "assassin") {
        // Algoz do Tufao: corta o vento (acerta quem esta na nevoa ou saltando)
        if (_el == "wind" && _e.fh_untargetable && _e.fh_mist_cut) {
            _e.fh_bypass_untargetable = true;
            if (random(1) < 0.3) fx_spawn_damage_popup(_e.x, _e.y - 26, "CORTA O VENTO!", false, c_white);
        }
        // Talento Presa Marcada (Rastreador): corpo a corpo em alvo marcado = +60% (critico)
        if (variable_instance_exists(_o, "synth_assassin_espect_adaga_criogenica") && _o.synth_assassin_espect_adaga_criogenica > 0
            && variable_instance_exists(_e, "spectral_mark") && _e.spectral_mark > 0 && point_distance(_o.x, _o.y, _e.x, _e.y) <= 70) {
            _dmg *= 1.6;
            if (random(1) < 0.3) fx_spawn_damage_popup(_e.x, _e.y - _e.body_radius - 20, "PRESA MARCADA!", true, c_teal);
        }
        // Cavaleiro Sombrio: obsidiana corta pedra
        if (_el == "earth" && _e.fh_shell_hits > 0) _e.fh_pierce_next = 0.5;
        // Nucleo do Tita pelas costas: dano dobrado
        if (_obj == obj_boss4 && !_e.vulnerable) {
            var _from = point_direction(_e.x, _e.y, _o.x, _o.y);
            if (abs(angle_difference(_e.facing_dir, _from)) > _e.fh_shell_arc) {
                _dmg *= 2;
                if (random(1) < 0.3) fx_spawn_damage_popup(_e.x, _e.y - _e.body_radius - 20, "NUCLEO PERFURADO!", true, c_yellow);
            }
        }
    }
    return _dmg;
}
