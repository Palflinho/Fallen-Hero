// =========================================================================
// ESTATISTICAS DA PARTIDA (mostradas na tela de derrota)
// Dano causado (fisico / magico), dano recebido (fisico / magico), cura,
// abates e o que matou o heroi. Zeradas no inicio de cada expedicao.
// =========================================================================

function run_stats_reset() {
    global.run_stats = {
        dealt_phys: 0,
        dealt_mag: 0,
        taken_phys: 0,
        taken_mag: 0,
        healed: 0,
        kills: 0,
        biggest_hit: 0,
        biggest_hit_obj: -1,
        last_hit_obj: -1,
        poison_obj: -1,
        killer_obj: -1
    };
    global.dmg_ctx_physical = false;
}

function run_stats_ensure() {
    if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) run_stats_reset();
    if (!variable_global_exists("dmg_ctx_physical")) global.dmg_ctx_physical = false;
}

// Objeto que causou o dano: projeteis, golpes e areas creditam quem os criou
function run_stats_source_obj(_inst) {
    if (!instance_exists(_inst)) return -1;
    if (_inst.object_index == obj_player) return -1;
    if (variable_instance_exists(_inst, "owner_obj") && _inst.owner_obj != -1) return _inst.owner_obj;
    if (variable_instance_exists(_inst, "owner") && instance_exists(_inst.owner) && _inst.owner != _inst.id) {
        return _inst.owner.object_index;
    }
    return _inst.object_index;
}

// Chamado quando o heroi perde vida de verdade (depois de bloqueios e mitigacao)
function run_stats_on_player_hit(_final, _damage_type, _src_obj) {
    run_stats_ensure();
    if (_final <= 0) return;
    if (_damage_type == "physical") global.run_stats.taken_phys += _final;
    else global.run_stats.taken_mag += _final;
    if (_src_obj != -1) global.run_stats.last_hit_obj = _src_obj;
    if (_final > global.run_stats.biggest_hit) {
        global.run_stats.biggest_hit = _final;
        global.run_stats.biggest_hit_obj = _src_obj;
    }
}

function run_stats_on_damage_dealt(_amount, _physical) {
    run_stats_ensure();
    if (_amount <= 0) return;
    if (_physical) global.run_stats.dealt_phys += _amount;
    else global.run_stats.dealt_mag += _amount;
}

function run_stats_add_heal(_amount) {
    run_stats_ensure();
    if (_amount > 0) global.run_stats.healed += _amount;
}

function run_stats_on_death() {
    run_stats_ensure();
    global.run_stats.killer_obj = global.run_stats.last_hit_obj;
}

// Nome legivel de quem causou o dano
function run_stats_obj_name(_obj) {
    if (_obj == -1 || !object_exists(_obj)) return tr("Desconhecido");
    var _n = object_get_name(_obj);
    switch (_n) {
        case "obj_slime": return tr("Slime da Agua");
        case "obj_fire_slime": return tr("Slime de Fogo");
        case "obj_wind_slime": return tr("Slime de Vento");
        case "obj_earth_slime": return tr("Slime de Terra");
        case "obj_elemental": return tr("Elemental da Agua");
        case "obj_fire_elemental": return tr("Elemental de Fogo");
        case "obj_wind_elemental": return tr("Elemental de Vento");
        case "obj_earth_elemental": return tr("Elemental de Terra");
        case "obj_frost_caster": return tr("Conjuradora de Gelo");
        case "obj_magma_caster": return tr("Conjuradora de Magma");
        case "obj_wind_caster": return tr("Conjuradora dos Ventos");
        case "obj_earth_caster": return tr("Conjuradora da Terra");
        case "obj_ice_golem": return tr("Golem de Gelo");
        case "obj_lava_golem": return tr("Golem de Lava");
        case "obj_storm_golem": return tr("Golem da Tempestade");
        case "obj_stone_golem": return tr("Golem de Pedra");
        case "obj_elem_totem": return tr("Totem Elemental");
        case "obj_wisp": return tr("Fogo-Fatuo");
        case "obj_spirit_ondina": return tr("Ondina");
        case "obj_spirit_salamandra": return tr("Salamandra");
        case "obj_spirit_silfide": return tr("Silfide");
        case "obj_spirit_gnomo": return tr("Gnomo");
        case "obj_boss": return tr("General da Água");
        case "obj_boss2": return tr("General Magma");
        case "obj_boss3": return tr("General Zephyrus");
        case "obj_boss4": return tr("Tita Monolito");
        case "obj_boss_human": return tr("O Salvador");
        case "obj_boss_drone": return tr("Drone do Salvador");
        case "obj_trap_spike": return tr("Armadilha de Espinhos");
        case "obj_trap_gas": return tr("Armadilha de Gas");
        case "obj_trap_crusher": return tr("Esmagador");
        case "obj_trap_dart": return tr("Armadilha de Dardos");
        case "obj_lava_pool":
        case "obj_lava_pool_cycle": return tr("Poca de Lava");
        case "obj_wind_cyclone": return tr("Ciclone");
        case "obj_earth_fissure": return tr("Fissura da Terra");
        case "obj_elem_ground": return tr("Area Elemental");
        case "obj_elem_missile":
        case "obj_enemy_projectile": return tr("Projetil Elemental");
    }
    return tr("Desconhecido");
}
