// =========================================================================
// SISTEMA DE IA ADAPTATIVA & NEMESIS DINAMICO (Fallen Hero)
// =========================================================================
// Pilares aplicados (Miyamoto, Sakurai, Iwata):
// 1. O jogo aprende com os habitos e vicios de classe do jogador.
// 2. Mira Preditiva (Lead Aim) intercepta trajetorias em vez de atirar estaticamente.
// 3. I-Frame Baiting: chefes atrasam o slam se o jogador abusa de rolamentos.
// 4. Mutações de Revanche: chefes criam contramedidas contra a classe que os
//    derrotou na run anterior, enquanto abrem uma vulnerabilidade critica
//    contra outra classe, estimulando organicamente a rotacao de personagens.
// =========================================================================

function adaptive_ai_get_default_data() {
    return {
        runs_total: 0,
        class_wins: { knight: 0, mage: 0, archer: 0, assassin: 0 },
        boss_adaptations: {
            water: { counter_class: "none", streak: 0 },
            fire: { counter_class: "none", streak: 0 },
            wind: { counter_class: "none", streak: 0 },
            earth: { counter_class: "none", streak: 0 }
        },
        habits: {
            kiting_score: 0.5,
            dodge_reliance: 0.2,
            block_reliance: 0.2
        }
    };
}

function adaptive_ai_ensure_loaded() {
    ensure_meta_loaded();
    if (!variable_global_exists("meta_adaptive_ai") || !is_struct(global.meta_adaptive_ai)) {
        global.meta_adaptive_ai = adaptive_ai_get_default_data();
    }
}

// -------------------------------------------------------------------------
// 1. MIRA PREDITIVA (Lead Aim Interception)
// -------------------------------------------------------------------------
// Calcula o angulo interceptando o vetor de velocidade (vx, vy) do jogador.
// _accuracy varia de 0.0 (tiro direto burro) a 1.0 (predição matemática exata).
function adaptive_ai_get_lead_aim_dir(_sx, _sy, _player, _proj_speed, _accuracy = 0.70) {
    if (_player == noone || !instance_exists(_player) || _player.invisible || _player.hp <= 0) {
        return point_direction(_sx, _sy, _player.x, _player.y);
    }

    var _direct_dir = point_direction(_sx, _sy, _player.x, _player.y);
    if (_accuracy <= 0 || _proj_speed <= 0) return _direct_dir;

    var _dist = point_distance(_sx, _sy, _player.x, _player.y);
    var _travel_time = _dist / max(10, _proj_speed);

    // Recupera a velocidade atual do jogador (vx e vy de obj_player)
    var _pvx = variable_instance_exists(_player, "vx") ? _player.vx : 0;
    var _pvy = variable_instance_exists(_player, "vy") ? _player.vy : 0;

    // Se o jogador estiver parado ou quase parado, atira direto
    if (point_distance(0, 0, _pvx, _pvy) < 15) {
        return _direct_dir;
    }

    // Calcula a posição futura estimada aplicando a acurácia
    var _predicted_x = _player.x + (_pvx * _travel_time * _accuracy);
    var _predicted_y = _player.y + (_pvy * _travel_time * _accuracy);

    // Impede predição absurda fora dos limites da sala
    _predicted_x = clamp(_predicted_x, 40, room_width - 40);
    _predicted_y = clamp(_predicted_y, 40, room_height - 40);

    return point_direction(_sx, _sy, _predicted_x, _predicted_y);
}

// -------------------------------------------------------------------------
// 2. TATICAS DE FLANKING CONTRA BLOQUEIO FRONTAL
// -------------------------------------------------------------------------
// Se o jogador for um Cavaleiro mantendo o escudo frontal erguido,
// os inimigos ganham um desvio angular para contornar e atacar a lateral/costas.
function adaptive_ai_get_flank_offset(_player) {
    if (_player == noone || !instance_exists(_player)) return 0;
    if (variable_instance_exists(_player, "is_defending") && _player.is_defending) {
        if (_player.defend_mode == "block" || _player.defend_mode == "parry") {
            // Sorteia flanquear pela esquerda ou pela direita (60 a 90 graus)
            return (random(1) < 0.5) ? 75 : -75;
        }
    }
    return 0;
}

// -------------------------------------------------------------------------
// 3. REGISTRO DE VITORIAS & MUTACAO DO CHEFE ENTRE RUNS
// -------------------------------------------------------------------------
function adaptive_ai_record_boss_defeat(_biome, _killer_class) {
    adaptive_ai_ensure_loaded();
    
    // Incrementa vitorias com essa classe
    if (!variable_struct_exists(global.meta_adaptive_ai.class_wins, _killer_class)) {
        global.meta_adaptive_ai.class_wins[$ _killer_class] = 0;
    }
    global.meta_adaptive_ai.class_wins[$ _killer_class] += 1;
    
    // Atualiza a adaptacao de contra-ataque do chefe deste bioma
    if (!variable_struct_exists(global.meta_adaptive_ai.boss_adaptations, _biome)) {
        global.meta_adaptive_ai.boss_adaptations[$ _biome] = { counter_class: "none", streak: 0 };
    }
    
    var _adapt = global.meta_adaptive_ai.boss_adaptations[$ _biome];
    if (_adapt.counter_class == _killer_class) {
        _adapt.streak += 1;
    } else {
        _adapt.counter_class = _killer_class;
        _adapt.streak = 1;
    }
    
    save_meta();
}

// -------------------------------------------------------------------------
// 4. CONSULTA DE ADAPTACAO DO CHEFE (MUTACOES)
// -------------------------------------------------------------------------
function adaptive_ai_get_boss_adaptation(_biome) {
    adaptive_ai_ensure_loaded();
    
    var _counter = "none";
    var _streak = 0;
    if (variable_struct_exists(global.meta_adaptive_ai.boss_adaptations, _biome)) {
        var _info = global.meta_adaptive_ai.boss_adaptations[$ _biome];
        _counter = _info.counter_class;
        _streak = _info.streak;
    }
    
    // Parametros padrão (sem mutação)
    var _res = {
        active: (_counter != "none"),
        counter_class: _counter,
        streak: _streak,
        title: "Padrão",
        description: "Comportamento original do General sem adaptações prévias.",
        recommended_class: "Qualquer",
        phys_damage_reduction: 0.0, // Redução percentual contra dano fisico
        magic_damage_reduction: 0.0,// Redução percentual contra dano magico
        phys_damage_vulnerability: 1.0, // Multiplicador de fraqueza fisica
        magic_damage_vulnerability: 1.0,// Multiplicador de fraqueza magica
        thorns_reflect_damage: 0,   // Dano refletido a ataques corpo a corpo
        barrage_lead_accuracy: 0.40,// Precisao preditiva dos tiros
        slam_bait_chance: 0.0,      // Chance de delay para punir roll
        extra_projectile_speed: 0,  // Velocidade extra de tiros
        aura_colour: c_white
    };
    
    switch (_counter) {
        case "knight":
            // Venceu de Cavaleiro: O Chefe endurece carapaça contra cortes e ganha espinhos,
            // mas sua couraça pesada o torna LENTO e SUPER VULNERÁVEL A MAGIA!
            _res.title = "Carapaça Espinhosa";
            _res.description = "Resistência Física +40% e reflete dano colado. Fraqueza Crítica à Magia (+50% de dano da Maga).";
            _res.recommended_class = "mage";
            _res.phys_damage_reduction = 0.40;
            _res.magic_damage_vulnerability = 1.50;
            _res.thorns_reflect_damage = 5;
            _res.barrage_lead_accuracy = 0.50;
            _res.slam_bait_chance = 0.20;
            _res.aura_colour = make_colour_rgb(255, 120, 60);
            break;
            
        case "mage":
            // Venceu de Maga: O Chefe invoca uma Barreira Arcana anti-magia e atira mais rápido,
            // mas perde blindagem física, tornando-se muito frágil à espada do Cavaleiro ou flechas do Arqueiro!
            _res.title = "Vórtice Refletor de Mana";
            _res.description = "Resistência Mágica +50% e projéteis +25% mais velozes. Vulnerável a Cortes Físicos (+40% de dano do Cavaleiro).";
            _res.recommended_class = "knight";
            _res.magic_damage_reduction = 0.50;
            _res.phys_damage_vulnerability = 1.40;
            _res.extra_projectile_speed = 65;
            _res.barrage_lead_accuracy = 0.85;
            _res.aura_colour = make_colour_rgb(180, 80, 255);
            break;
            
        case "archer":
            // Venceu de Arqueiro: O Chefe aprendeu a caçar alvos à distância, atirando com alta
            // predição e atrasando o slam para punir o rolamento (I-Frame bait),
            // mas fica totalmente vulnerável a ataques surpresa pelas costas do Assassino!
            _res.title = "Instinto Predador de Alcance";
            _res.description = "Mira Preditiva Avançada (85%) e Atraso Tático de Slam (pune rolamentos). Vulnerável a Furtividade do Assassino.";
            _res.recommended_class = "assassin";
            _res.barrage_lead_accuracy = 0.90;
            _res.slam_bait_chance = 0.65;
            _res.phys_damage_reduction = 0.20;
            _res.aura_colour = make_colour_rgb(80, 220, 240);
            break;
            
        case "assassin":
            // Venceu de Assassino: O Chefe desenvolve um Pulso de Percepção Sísmica e tiros em leque amplos,
            // mas seu campo de visão focado o deixa exposto a ataques de longa distância do Arqueiro!
            _res.title = "Sentido Sísmico de Alerta";
            _res.description = "Dificulta aproximações furtivas com pulsos de alerta contínuos. Vulnerável a ataques à distância do Arqueiro (+40% de dano).";
            _res.recommended_class = "archer";
            _res.phys_damage_vulnerability = 1.30;
            _res.barrage_lead_accuracy = 0.70;
            _res.slam_bait_chance = 0.35;
            _res.aura_colour = make_colour_rgb(140, 255, 120);
            break;
    }
    
    return _res;
}
