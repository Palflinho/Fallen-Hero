// Shop talents per class -- cost 0 means unlocked from the start, cost > 0 must be bought
// with gold in the shop before it can be picked at the pre-run talent-selection screen.
//
// General talents (character: "general") are never sold in a shop and never offered at
// the pre-run screen -- they're only found in chests during a run (see roll_chest_talent
// / equip_chest_talent below), and are always "unlocked" the moment they're found.
//
// Each synth_field has exactly one class-specific source (stronger, chosen deliberately)
// and, where it makes sense across classes, one general/chest source (weaker, found at
// random) -- no synth_field should have two talents competing for the same role in the
// same class.
//
// Numbers here (per_rank, cost) follow Nintendo design pillars: Sakurai juice, Miyamoto intuitiveness, Iwata modularity.
function get_talent_defs() {
    return [
        // =========================================================================
        // CAVALEIRO (KNIGHT) - 50 TALENTOS
        // =========================================================================
        // 1. FUNDAMENTAIS / MESTRIA COM ESCUDO E ESPADA (10 TALENTOS)
        {id: "knight_postura_firme", character: "knight", affinity: "none", label: "Postura Firme", synth_field: "synth_postura_firme", per_rank: 0.50, cost: 0,
         desc_flavor: "Firmeza marcial com o escudo erguido, permitindo avancar contra chuvas de golpes sem perder velocidade.",
         desc_value: "+50% de velocidade de movimento enquanto defende com o escudo.", icon_type: "block"},
        {id: "knight_lamina_afiada", character: "knight", affinity: "none", label: "Lamina Afiada", synth_field: "synth_lamina_afiada", per_rank: 1, cost: 0,
         desc_flavor: "Paciencia e tecnica que acumulam poder na ponta da lamina quando o guerreiro aguarda o momento certo.",
         desc_value: "O primeiro golpe apos 2s sem atacar tem 100% de chance de acerto critico.", icon_type: "sword"},
        {id: "knight_golpe_pesado", character: "knight", affinity: "none", label: "Golpe Pesado", synth_field: "synth_golpe_pesado", per_rank: 1, cost: 0,
         desc_flavor: "Impacto demolidor que projeta monstros violentamente para tras ao atingir pontos criticos.",
         desc_value: "Acertos criticos aumentam a forca de repulsao em +80% e atordoam inimigos por 0.3s.", icon_type: "crit"},
        {id: "knight_escudo_choque", character: "knight", affinity: "none", label: "Escudo de Choque", synth_field: "synth_escudo_choque", per_rank: 1, cost: 35,
         desc_flavor: "O impacto absorvido pelo metal e canalizado em uma onda conica de ar que empurra agressores.",
         desc_value: "Bloquear um golpe direto projeta uma onda conica de ar que empurra inimigos a frente.", icon_type: "shockwave"},
        {id: "knight_segundo_folego", character: "knight", affinity: "none", label: "Segundo Folego", synth_field: "synth_segundo_folego", per_rank: 1, cost: 45,
         desc_flavor: "Resiliencia heroica extrema que impede o guerreiro de sucumbir em momentos desesperadores.",
         desc_value: "Ao cair para menos de 25% de vida, recupera instantaneamente 20% de HP (Recarga: 60s).", icon_type: "second_wind"},
        {id: "knight_muralha_movel", character: "knight", affinity: "none", label: "Muralha Movel", synth_field: "synth_muralha_movel", per_rank: 0.30, cost: 40,
         desc_flavor: "Carga decidida com o escudo a frente para fechar a distancia contra inimigos e arqueiros.",
         desc_value: "Correr em direcao a um inimigo com o escudo erguido concede +30% de velocidade de movimento.", icon_type: "boot"},
        {id: "knight_aco_temperado", character: "knight", affinity: "none", label: "Aco Temperado", synth_field: "synth_aco_temperado", per_rank: 1, cost: 50,
         desc_flavor: "Reforcos forjados com ligas preciosas que endurecem a armadura proporcionalmente as riquezas da run.",
         desc_value: "+1 de defesa fisica para cada 100 moedas de ouro acumuladas na run (maximo +8).", icon_type: "shield"},
        {id: "knight_fio_carrasco", character: "knight", affinity: "none", label: "Fio do Carrasco", synth_field: "synth_fio_carrasco", per_rank: 0.40, cost: 50,
         desc_flavor: "Cortes impiedosos desenhados para decapitar oponentes desestabilizados a beira da morte.",
         desc_value: "Causa +40% de dano contra qualquer inimigo com menos de 30% de vida.", icon_type: "execute"},
        {id: "knight_reflexo_blindado", character: "knight", affinity: "none", label: "Reflexo Blindado", synth_field: "synth_reflexo_blindado", per_rank: 0.40, cost: 55,
         desc_flavor: "Angulacao perfeita do escudo capaz de defletir flechas e projeteis de volta aos agressores.",
         desc_value: "Projeteis que atingem o escudo com bloqueio ativo tem 40% de chance de ricochetear de volta.", icon_type: "riposte"},
        {id: "knight_vontade_indomavel", character: "knight", affinity: "none", label: "Vontade Indomavel", synth_field: "synth_vontade_indomavel", per_rank: 1, cost: 60,
         desc_flavor: "Postura inabalavel que ignora terrenos escorregadios, ventanias e empurroes de chefes colossais.",
         desc_value: "Torna o Cavaleiro imune a empurroes, knockback e desaceleracoes de armadilhas ou chefes.", icon_type: "bastion"},

        // 2. PALADINO (ELEMENTO AGUA / SAGRADO - 8 TALENTOS)
        {id: "knight_paladino_bencao_mare", character: "knight", affinity: "water", label: "Bencao da Mare", synth_field: "synth_paladino_bencao_mare", per_rank: 4, cost: 50,
         desc_flavor: "As aguas sagradas circulam em pulsos acelerados, revitalizando tecidos e curando feridas profundas.",
         desc_value: "A Aura de Sobrevida pulsa 25% mais rapido e aumenta a regeneracao natural em +4 HP/s.", icon_type: "holy"},
        {id: "knight_paladino_bastiao_liquido", character: "knight", affinity: "water", label: "Bastiao Liquido", synth_field: "synth_paladino_bastiao_liquido", per_rank: 0.50, cost: 60,
         desc_flavor: "Uma pelicula aquosa translucida que dissipa disparos a distancia antes que toquem o corpo.",
         desc_value: "Barreira de sobrevida ganha capacidade maxima de +50% do HP e absorve 100% do dano de projeteis.", icon_type: "barrier"},
        {id: "knight_paladino_gota_purificadora", character: "knight", affinity: "water", label: "Gota Purificadora", synth_field: "synth_paladino_gota_purificadora", per_rank: 8, cost: 55,
         desc_flavor: "Emanacoes puras limpam toxinas corporais instantaneamente quando o mal e purgado.",
         desc_value: "Eliminar um inimigo remove instantaneamente venenos ou queimaduras e cura 8 HP.", icon_type: "regen"},
        {id: "knight_paladino_correnteza_dilacerante", character: "knight", affinity: "water", label: "Correnteza Dilacerante", synth_field: "synth_paladino_correnteza_dilacerante", per_rank: 6, cost: 65,
         desc_flavor: "A aura gira como um turbilhao tempestuoso, desacelerando passos inimigos e corroendo sua carne.",
         desc_value: "Inimigos na aura sofrem -40% de velocidade e recebem dano magico continuo a cada 0.5s.", icon_type: "wind"},
        {id: "knight_paladino_golpe_nascente", character: "knight", affinity: "water", label: "Golpe da Nascente", synth_field: "synth_paladino_golpe_nascente", per_rank: 5, cost: 70,
         desc_flavor: "A cada ciclo de esgrima, a lamina faz brotar uma onda cortante de agua pristina que nutre o heroi.",
         desc_value: "Cada 3o golpe de espada libera uma onda d'agua penetrante que cura o jogador em 5 HP.", icon_type: "heal_hit"},
        {id: "knight_paladino_escudo_espelhado", character: "knight", affinity: "water", label: "Escudo Espelhado", synth_field: "synth_paladino_escudo_espelhado", per_rank: 1, cost: 65,
         desc_flavor: "A quebra da barreira estilhaca o espelho dagua em um estrondo que atordoa agressores.",
         desc_value: "Quando a barreira de sobrevida quebra por dano, explode cegando e empurrando num raio de 120px.", icon_type: "shockwave"},
        {id: "knight_paladino_graca_abencoada", character: "knight", affinity: "water", label: "Graca Abencoada", synth_field: "synth_paladino_graca_abencoada", per_rank: 0.50, cost: 75,
         desc_flavor: "A vitalidade excedente nunca e desperdicada, condensando-se em escudo de energia sagrada.",
         desc_value: "Receber cura enquanto estiver com HP cheio converte 50% do valor em barreira de sobrevida.", icon_type: "barrier"},
        {id: "knight_paladino_julgamento_sereno", character: "knight", affinity: "water", label: "Julgamento Sereno", synth_field: "synth_paladino_julgamento_sereno", per_rank: 0.25, cost: 80,
         desc_flavor: "Sob o amparo da barreira luminosa, o cavaleiro manuseia a espada com serenidade e cadencia reluzente.",
         desc_value: "Enquanto a barreira de sobrevida estiver ativa, a velocidade de ataque da espada aumenta em +25%.", icon_type: "haste"},

        // 3. BERSERKER (ELEMENTO FOGO / FURIA - 8 TALENTOS)
        {id: "knight_berserk_arco_incendiario", character: "knight", affinity: "fire", label: "Arco Incendiario", synth_field: "synth_berserk_arco_incendiario", per_rank: 0.40, cost: 55,
         desc_flavor: "O calor abrasador alarga a silhueta da espada, deixando rastros incandescentes no chao da masmorra.",
         desc_value: "Aumenta a area do corte da espada em +40% e queima o chao por 1.5s.", icon_type: "burn"},
        {id: "knight_berserk_frenesi_ardente", character: "knight", affinity: "fire", label: "Frenesi Ardente", synth_field: "synth_berserk_frenesi_ardente", per_rank: 0.05, cost: 60,
         desc_flavor: "A adrenalina e as brasas aceleram os musculos a cada contato cortante consecutivo com o ferro.",
         desc_value: "Cada golpe consecutivo concede +5% de velocidade de ataque (acumula ate 6 vezes por 3s).", icon_type: "haste"},
        {id: "knight_berserk_combustao_espontanea", character: "knight", affinity: "fire", label: "Combustao Espontanea", synth_field: "synth_berserk_combustao_espontanea", per_rank: 0.60, cost: 65,
         desc_flavor: "Inimigos em chamas entram em ponto critico ao morrer, detonando pirotecnicamente entre aliados.",
         desc_value: "Inimigos mortos sob efeito de Queimadura explodem causando 60% do dano do ataque em area.", icon_type: "fury"},
        {id: "knight_berserk_sede_sangue", character: "knight", affinity: "fire", label: "Sede de Sangue", synth_field: "synth_berserk_sede_sangue", per_rank: 0.15, cost: 70,
         desc_flavor: "A furia cega se alimenta da dor inimiga, restaurando a fibra muscular e mantendo o frenesi aceso.",
         desc_value: "Golpes criticos recuperam 15% do dano causado como vida e prolongam a Furia Ardente em +0.5s.", icon_type: "lifesteal"},
        {id: "knight_berserk_cinzas_sacrificio", character: "knight", affinity: "fire", label: "Cinzas do Sacrificio", synth_field: "synth_berserk_cinzas_sacrificio", per_rank: 1, cost: 75,
         desc_flavor: "O berserker queima o proprio sangue em troca de um pico de destruicao piroclastica estarrecedor.",
         desc_value: "Ativar Furia Ardente consome 10% do HP atual, mas dobra o bonus de dano de fogo nos primeiros 3s.", icon_type: "fireball"},
        {id: "knight_berserk_lamina_brasa", character: "knight", affinity: "fire", label: "Lamina em Brasa", synth_field: "synth_berserk_lamina_brasa", per_rank: 0.50, cost: 70,
         desc_flavor: "Temperatura vulcanica capaz de fundir escudos pesados e rachar as couracas rochosas dos golens.",
         desc_value: "Inimigos com armadura perdem 50% da sua reducao de dano contra seus ataques de fogo.", icon_type: "sword"},
        {id: "knight_berserk_vinganca_flamejante", character: "knight", affinity: "fire", label: "Vinganca Flamejante", synth_field: "synth_berserk_vinganca_flamejante", per_rank: 18, cost: 65,
         desc_flavor: "Cada ferida sofrida rompe uma valvula de pressao, expelindo um anel de chamas ao redor do corpo.",
         desc_value: "Sofrer dano fisico descarrega uma labareda ao redor do corpo que atinge todos num raio de 70px.", icon_type: "burn"},
        {id: "knight_berserk_furia_imortal", character: "knight", affinity: "fire", label: "Furia Imortal", synth_field: "synth_berserk_furia_imortal", per_rank: 1, cost: 85,
         desc_flavor: "A recusa obstinada em morrer enquanto o fogo da furia continuar crepitando no peito.",
         desc_value: "Enquanto a habilidade Furia Ardente estiver ativa, o jogador nao pode ser derrotado (mantem 1 HP).", icon_type: "second_wind"},

        // 4. DUELISTA (ELEMENTO AR / VENTO - 8 TALENTOS)
        {id: "knight_duelista_riposte_perfeito", character: "knight", affinity: "wind", label: "Riposte Perfeito", synth_field: "synth_duelista_riposte_perfeito", per_rank: 1.00, cost: 60,
         desc_flavor: "Sincronismo milimetrico no aparo da lamina hostil abrindo brechas para um contra-golpe mortal.",
         desc_value: "Acertar um Parry com menos de 0.1s de margem causa +100% de dano critico no contra-ataque.", icon_type: "riposte"},
        {id: "knight_duelista_passo_eolico", character: "knight", affinity: "wind", label: "Passo Eolico", synth_field: "synth_duelista_passo_eolico", per_rank: 1, cost: 55,
         desc_flavor: "Deslize etereo impulsionado pelo ricochete do bloqueio para reposicionar o heroi instantaneamente.",
         desc_value: "Bloquear ou aparar um golpe permite realizar um dash instantaneo na direcao de mira sem custo.", icon_type: "wind"},
        {id: "knight_duelista_combo_vendaval", character: "knight", affinity: "wind", label: "Combo Vendaval", synth_field: "synth_duelista_combo_vendaval", per_rank: 1, cost: 65,
         desc_flavor: "O segundo floreio do combo corta o ar com tanta pressao que cria um bumerangue de vacuo voador.",
         desc_value: "O segundo golpe do combo dispara uma rajada cortante de vento que atinge inimigos distantes.", icon_type: "wind"},
        {id: "knight_duelista_danca_laminas", character: "knight", affinity: "wind", label: "Danca das Laminas", synth_field: "synth_duelista_danca_laminas", per_rank: 0.25, cost: 60,
         desc_flavor: "Fluidez acrobata inebriante que converte cada baixa em aceleracao ritmica pelos corredores.",
         desc_value: "Aumenta a velocidade de movimento base em +25% por 2s apos cada abate.", icon_type: "boot"},
        {id: "knight_duelista_aparar_cadeia", character: "knight", affinity: "wind", label: "Aparar em Cadeia", synth_field: "synth_duelista_aparar_cadeia", per_rank: 1, cost: 75,
         desc_flavor: "Dominio ritmico de esgrima que aproveita o balanco do bloqueio anterior para aparar o proximo.",
         desc_value: "Aparar um golpe reseta imediatamente o tempo de recarga da habilidade de Parry.", icon_type: "riposte"},
        {id: "knight_duelista_vacuo_cortante", character: "knight", affinity: "wind", label: "Vacuo Cortante", synth_field: "synth_duelista_vacuo_cortante", per_rank: 1, cost: 70,
         desc_flavor: "Um vortice centripeto se forma no ponto de impacto puxando monstros desavisados para o centro.",
         desc_value: "O contra-ataque do Parry puxa todos os inimigos proximos para o centro antes de explodir.", icon_type: "shockwave"},
        {id: "knight_duelista_reflexos_celere", character: "knight", affinity: "wind", label: "Reflexos Celere", synth_field: "synth_duelista_reflexos_celere", per_rank: 0.15, cost: 75,
         desc_flavor: "Instintos agucados que pressentem trajetorias de ataque, deixando apenas imagens residuais no ar.",
         desc_value: "Concede +15% de chance de esquiva passiva permanente contra qualquer golpe.", icon_type: "dodge"},
        {id: "knight_duelista_estocada_fulminante", character: "knight", affinity: "wind", label: "Estocada Fulminante", synth_field: "synth_duelista_estocada_fulminante", per_rank: 2.50, cost: 80,
         desc_flavor: "Puncionamento cirurgico na espinha ou pontos cegos de adversarios desatentos.",
         desc_value: "Se o golpe de uma sequencia atingir as costas do inimigo, causa 2.5x de dano.", icon_type: "sword"},

        // 5. GUARDIAO (ELEMENTO TERRA / FORTALEZA - 8 TALENTOS)
        {id: "knight_guardiao_muralha_sismica", character: "knight", affinity: "earth", label: "Muralha Sismica", synth_field: "synth_guardiao_muralha_sismica", per_rank: 1, cost: 60,
         desc_flavor: "O impacto firme da postura faz brotar estalagmites macicas que estrangulam corredores e hordas.",
         desc_value: "O Bastiao de Terra cria estalagmites no chao ao redor bloqueando passagens e inimigos.", icon_type: "bastion"},
        {id: "knight_guardiao_provocacao_esmagadora", character: "knight", affinity: "earth", label: "Provocacao Esmagadora", synth_field: "synth_guardiao_provocacao_esmagadora", per_rank: 0.30, cost: 65,
         desc_flavor: "Grito de desafio ensurdecedor que abala a coragem dos monstros, enfraquecendo seu poder ofensivo.",
         desc_value: "Inimigos provocados pelo Guardiao tem seu dano reduzido em 30% contra o jogador por 4s.", icon_type: "shockwave"},
        {id: "knight_guardiao_carapaca_granito", character: "knight", affinity: "earth", label: "Carapaca de Granito", synth_field: "synth_guardiao_carapaca_granito", per_rank: 12, cost: 70,
         desc_flavor: "Camada densa de minerais sobre as placas de ferro tornando o guerreiro tao inamovivel quanto uma montanha.",
         desc_value: "Concede +12 de defesa fisica e imunidade a qualquer tipo de knockback ou empurrao.", icon_type: "rock"},
        {id: "knight_guardiao_retaliacao_sismica", character: "knight", affinity: "earth", label: "Retaliacao Sismica", synth_field: "synth_guardiao_retaliacao_sismica", per_rank: 0.50, cost: 70,
         desc_flavor: "A vibracao sismica devolve o choque em fragmentos de pedra pontiagudos em todas as direcoes.",
         desc_value: "Devolve 50% do dano de qualquer golpe recebido como dano de terra para todos ao redor.", icon_type: "thorns"},
        {id: "knight_guardiao_fissura_telurica", character: "knight", affinity: "earth", label: "Fissura Telurica", synth_field: "synth_guardiao_fissura_telurica", per_rank: 1, cost: 75,
         desc_flavor: "Golpe descendente monumental que abre uma fenda no solo rochoso da masmorra.",
         desc_value: "Cada 4o golpe de espada faz rachar o chao em linha reta, atordoando o primeiro inimigo por 0.8s.", icon_type: "rock"},
        {id: "knight_guardiao_bastiao_inabalavel", character: "knight", affinity: "earth", label: "Bastiao Inabalavel", synth_field: "synth_guardiao_bastiao_inabalavel", per_rank: 0.15, cost: 70,
         desc_flavor: "A firmeza inquebravel do escudo ancora as forcas vitais na terra, cicatrizando o organismo.",
         desc_value: "Bloquear ataques converte 15% do dano bloqueado em regeneracao de vida temporaria.", icon_type: "regen"},
        {id: "knight_guardiao_peso_esmagador", character: "knight", affinity: "earth", label: "Peso Esmagador", synth_field: "synth_guardiao_peso_esmagador", per_rank: 25, cost: 75,
         desc_flavor: "A inercia do escudo e descomunal: colisoes contra rochas e paredes esmagam ossos com facilidade.",
         desc_value: "Empurrar um inimigo contra uma parede causa dano de esmagamento extra de 25 por rank.", icon_type: "shield"},
        {id: "knight_guardiao_fortaleza_viva", character: "knight", affinity: "earth", label: "Fortaleza Viva", synth_field: "synth_guardiao_fortaleza_viva", per_rank: 3, cost: 80,
         desc_flavor: "Quanto mais cercado e pressionado por hordas, mais impenetravel se torna a presenca do Guardiao.",
         desc_value: "Para cada inimigo a menos de 90px de distancia, ganha +3 de defesa e +5% de reducao de dano.", icon_type: "shield"},

        // 6. LENDARIOS / SINERGIAS ELEMENTAIS HIBRIDAS DO CAVALEIRO (8 TALENTOS)
        {id: "knight_lendario_vapor_sagrado", character: "knight", affinity: "hybrid", label: "Vapor Sagrado", synth_field: "synth_lendario_vapor_sagrado", per_rank: 1, cost: 100,
         desc_flavor: "Fusao dos misterios da agua e do fogo gerando nevoas misticas que cauterizam e saram.",
         desc_value: "Ataques aplicam vapor escaldante: queimadura continua que tambem cura o jogador a cada tick.", icon_type: "holy"},
        {id: "knight_lendario_tempestade_poeira", character: "knight", affinity: "hybrid", label: "Tempestade de Poeira", synth_field: "synth_lendario_tempestade_poeira", per_rank: 1, cost: 100,
         desc_flavor: "A sinergia entre terra e ar levanta areia em torvelinho, desviando projeteis antes de alcancarem o alvo.",
         desc_value: "O contra-ataque do Parry levanta uma tempestade de areia que cega projeteis inimigos por 3s.", icon_type: "wind"},
        {id: "knight_lendario_gelo_fendido", character: "knight", affinity: "hybrid", label: "Gelo Fendido", synth_field: "synth_lendario_gelo_fendido", per_rank: 1, cost: 110,
         desc_flavor: "A frieza da agua e a solidez da terra criam estacas cristalizadas que paralisam agressores.",
         desc_value: "O impacto do escudo cria espinhos de gelo permanentes que congelam inimigos que pisam neles.", icon_type: "barrier"},
        {id: "knight_lendario_tempestade_ignea", character: "knight", affinity: "hybrid", label: "Tempestade Ignea", synth_field: "synth_lendario_tempestade_ignea", per_rank: 1, cost: 110,
         desc_flavor: "O sopro do vento alimenta o apetite do fogo criando torvelinhos flamejantes que cacam oponentes.",
         desc_value: "O combo do Duelista dispara tornados de fogo que perseguem os alvos mais proximos.", icon_type: "fury"},
        {id: "knight_lendario_avatar_elemental", character: "knight", affinity: "legendary", label: "Avatar Elemental", synth_field: "synth_lendario_avatar_elemental", per_rank: 1, cost: 120,
         desc_flavor: "Harmonia perfeita entre os quatro elementos desencadeando ondas binarias devastadoras.",
         desc_value: "+25% de dano de ataque fisico e magico e desencadeia explosoes combinadas elementais.", icon_type: "fireball"},
        {id: "knight_lendario_cavaleiro_apocalipse", character: "knight", affinity: "legendary", label: "Cavaleiro do Apocalipse", synth_field: "synth_lendario_cavaleiro_apocalipse", per_rank: 1, cost: 130,
         desc_flavor: "A maestria imaculada atrai a furia dos ceus, despencando cometas quando a sequencia de abates e perfeita.",
         desc_value: "A cada 10 inimigos derrotados sem sofrer dano, o proximo golpe descarrega um meteoro no alvo.", icon_type: "fireball"},
        {id: "knight_lendario_escudo_titanico", character: "knight", affinity: "legendary", label: "Escudo Titanico", synth_field: "synth_lendario_escudo_titanico", per_rank: 1, cost: 125,
         desc_flavor: "O metal se expande como um portal de fortaleza capaz de criar uma trincheira intransponivel para hordas.",
         desc_value: "O tamanho do escudo dobra, cobrindo 180 frontais e bloqueando passagens inteiras.", icon_type: "shield"},
        {id: "knight_lendario_eco_ancestrais", character: "knight", affinity: "legendary", label: "Eco dos Ancestrais", synth_field: "synth_lendario_eco_ancestrais", per_rank: 1, cost: 140,
         desc_flavor: "O sangue heroico desperta memorias de reis guerreiros antigos que espelham cada golpe desferido.",
         desc_value: "Bloquear ou contra-atacar invoca o espirito translucido de um guerreiro que desfere um golpe gemeo.", icon_type: "sword"},

        // =========================================================================
        // MAGO (MAGE) - 50 TALENTOS
        // =========================================================================
        // 1. FUNDAMENTAIS / MESTRIA ARCANA (10 TALENTOS)
        {id: "mage_canalizacao_fluida", character: "mage", affinity: "none", label: "Canalizacao Fluida", synth_field: "synth_mage_canalizacao_fluida", per_rank: 1, cost: 0,
         desc_flavor: "Postura deslizante que permite disparar encantamentos em pleno deslocamento sem perder cadencia.",
         desc_value: "Mover-se nao interrompe a conjuracao do ataque magico basico.", icon_type: "boot"},
        {id: "mage_mente_cristalina", character: "mage", affinity: "none", label: "Mente Cristalina", synth_field: "synth_mage_mente_cristalina", per_rank: 0.20, cost: 0,
         desc_flavor: "Concentracao inabalavel que acumula densidade arcana nas maos enquanto o mago evita ser golpeado.",
         desc_value: "Ficar sem sofrer dano por 4s concede +20% de dano magico no proximo feitico.", icon_type: "magic_def"},
        {id: "mage_eco_magico", character: "mage", affinity: "none", label: "Eco Magico", synth_field: "synth_mage_eco_magico", per_rank: 1, cost: 0,
         desc_flavor: "Ressonancia residual do eter que gera uma segunda fagulha menor logo apos o feitico principal.",
         desc_value: "Todo 4o projetil magico dispara uma replica menor adicional com 50% de dano.", icon_type: "fireball"},
        {id: "mage_protecao_mana_reativa", character: "mage", affinity: "none", label: "Protecao Mana-Reativa", synth_field: "synth_mage_protecao_mana_reativa", per_rank: 1, cost: 35,
         desc_flavor: "O impacto sofrido rompe uma bolsa eterea comprimida, empurrando ameacas a sua volta.",
         desc_value: "Ao sofrer um golpe que tire mais de 15% de HP, repele os inimigos em 120px.", icon_type: "shockwave"},
        {id: "mage_sobrecarga_feitico", character: "mage", affinity: "none", label: "Sobrecarga de Feitico", synth_field: "synth_mage_sobrecarga_feitico", per_rank: 0.40, cost: 45,
         desc_flavor: "Explosoes criticas que superaquecem o ar ao redor do ponto de impacto magico.",
         desc_value: "Acertos criticos magicos causam mini-explosao de 50px de raio com 40% de dano.", icon_type: "crit"},
        {id: "mage_condensacao_arcana", character: "mage", affinity: "none", label: "Condensacao Arcana", synth_field: "synth_mage_condensacao_arcana", per_rank: 0.25, cost: 40,
         desc_flavor: "O projetil condensa particulas celestes durante a trajetoria, alcancando potencia maxima a distancia.",
         desc_value: "Projeteis magicos que viajam mais de 250px ganham +25% de dano e tamanho.", icon_type: "fireball"},
        {id: "mage_sifao_alma", character: "mage", affinity: "none", label: "Sifao da Alma", synth_field: "synth_mage_sifao_alma", per_rank: 3, cost: 50,
         desc_flavor: "Drenagem sutil da forca vital desgarrada das criaturas purgadas para fechar as proprias feridas.",
         desc_value: "Derrotar um inimigo restaura instantaneamente 3 pontos de HP.", icon_type: "regen"},
        {id: "mage_fluxo_conduzido", character: "mage", affinity: "none", label: "Fluxo Conduzido", synth_field: "synth_mage_fluxo_conduzido", per_rank: 0.15, cost: 50,
         desc_flavor: "Linhas ley alinhadas aceleram os disparos arcanos como relampagos pelo ar da masmorra.",
         desc_value: "+15% de velocidade de viagem para todos os projeteis magicos disparados.", icon_type: "haste"},
        {id: "mage_ressonancia_foco", character: "mage", affinity: "none", label: "Ressonancia de Foco", synth_field: "synth_mage_ressonancia_foco", per_rank: 1.2, cost: 55,
         desc_flavor: "Hexagonos arcanos reforcados que prolongam a durabilidade do escudo protetor do mago.",
         desc_value: "O Manashield dura +1.2s e reduz todo dano recebido em 25%.", icon_type: "barrier"},
        {id: "mage_conhecimento_ancestral", character: "mage", affinity: "none", label: "Conhecimento Ancestral", synth_field: "synth_mage_conhecimento_ancestral", per_rank: 2, cost: 60,
         desc_flavor: "A assimilacao de segredos antigos a cada lacaio expurgado expande o poder de conjuracao.",
         desc_value: "Ganha +2 de Poder Magico a cada 15 inimigos derrotados na run (maximo +12).", icon_type: "magic_def"},

        // 2. CRIOMANTE (MAGO / AGUA - 8 TALENTOS)
        {id: "mage_crio_geada_penetrante", character: "mage", affinity: "water", label: "Geada Penetrante", synth_field: "synth_crio_geada_penetrante", per_rank: 0.30, cost: 50,
         desc_flavor: "Cristais frios que se fixam nas juntas dos monstros, entorpecendo seus movimentos.",
         desc_value: "Projeteis basicos aplicam 30% de lentidao por 2s a cada impacto.", icon_type: "barrier"},
        {id: "mage_crio_pico_glacial", character: "mage", affinity: "water", label: "Pico Glacial", synth_field: "synth_crio_pico_glacial", per_rank: 1.5, cost: 60,
         desc_flavor: "O frio acumulado atinge o zero relativo, congelando monstros em blocos solidos de gelo.",
         desc_value: "Inimigos sob lentidao recebem 1.5s de congelamento total se atingidos por magia.", icon_type: "barrier"},
        {id: "mage_crio_armadura_gelo_negro", character: "mage", affinity: "water", label: "Armadura de Gelo Negro", synth_field: "synth_crio_armadura_gelo_negro", per_rank: 1, cost: 55,
         desc_flavor: "Pontas afiadas de gelo negro que recobrem a barreira, congelando o toque dos agressores.",
         desc_value: "Enquanto o Manashield estiver ativo, qualquer contato fisico congela o agressor.", icon_type: "shield"},
        {id: "mage_crio_onda_torrencial", character: "mage", affinity: "water", label: "Onda Torrencial", synth_field: "synth_crio_onda_torrencial", per_rank: 1, cost: 65,
         desc_flavor: "Um jato frontal de agua em alta pressao que varre hordas inteiras pelo corredor.",
         desc_value: "O 3o ataque magico dispara uma mare frontal que arrasta monstros por 150px.", icon_type: "shockwave"},
        {id: "mage_crio_prisao_criogenica", character: "mage", affinity: "water", label: "Prisao Criogenica", synth_field: "synth_crio_prisao_criogenica", per_rank: 6, cost: 70,
         desc_flavor: "A quebra da redoma de gelo descarrega estilhacos perfurantes em todas as direcoes.",
         desc_value: "A Prisao Glacial (X) estilhaca no final, disparando 6 fragmentos congelantes.", icon_type: "barrier"},
        {id: "mage_crio_orvalho_restaurador", character: "mage", affinity: "water", label: "Orvalho Restaurador", synth_field: "synth_crio_orvalho_restaurador", per_rank: 8, cost: 65,
         desc_flavor: "A quebra do gelo de inimigos derrotados condensa gotas pristinas curativas no piso.",
         desc_value: "Derrotar inimigos congelados gera uma poca dagua pura que regenera 8 HP.", icon_type: "regen"},
        {id: "mage_crio_lanca_zero_absoluto", character: "mage", affinity: "water", label: "Lanca de Zero Absoluto", synth_field: "synth_crio_lanca_zero_absoluto", per_rank: 0.35, cost: 75,
         desc_flavor: "Espetos de gelo fino desenhados para quebrar couracas enrijecidas pelo frio extremo.",
         desc_value: "Ataques contra inimigos imobilizados ou lentos tem +35% de chance de acerto critico.", icon_type: "crit"},
        {id: "mage_crio_coracao_geada", character: "mage", affinity: "water", label: "Coracao da Geada", synth_field: "synth_crio_coracao_geada", per_rank: 0.15, cost: 80,
         desc_flavor: "Simbiose completa com o elemento gelido: toxinas sao purgadas e frio vira vitalidade.",
         desc_value: "Imunidade a lentidao e venenos; converte 15% do dano de frio recebido em escudo.", icon_type: "holy"},

        // 3. PIROMANTE (MAGO / FOGO - 8 TALENTOS)
        {id: "mage_piro_centelha_incandescente", character: "mage", affinity: "fire", label: "Centelha Incandescente", synth_field: "synth_piro_centelha_incandescente", per_rank: 4, cost: 55,
         desc_flavor: "Brasas vivas impregnadas nos projeteis que devoram a carne do alvo continuamente.",
         desc_value: "Projeteis basicos deixam inimigos em chamas por 3s causando dano continuo.", icon_type: "burn"},
        {id: "mage_piro_meteoro_menor", character: "mage", affinity: "fire", label: "Meteoro Menor", synth_field: "synth_piro_meteoro_menor", per_rank: 20, cost: 60,
         desc_flavor: "Chamado sutil do cosmos trazendo pedras incandescentes que despencam sobre agressores.",
         desc_value: "A cada 5 acertos magicos, um meteoro menor despenca causando 20 de dano em area.", icon_type: "fireball"},
        {id: "mage_piro_rastro_flamejante", character: "mage", affinity: "fire", label: "Rastro Flamejante", synth_field: "synth_piro_rastro_flamejante", per_rank: 6, cost: 65,
         desc_flavor: "Passos aquecidos ao rubro que transformam o chao da masmorra em uma esteira de brasas.",
         desc_value: "Andar deixa uma esteira de brasas vivas por 1.5s que queima monstros que pisarem.", icon_type: "burn"},
        {id: "mage_piro_inferno_expansivo", character: "mage", affinity: "fire", label: "Inferno Expansivo", synth_field: "synth_piro_inferno_expansivo", per_rank: 0.50, cost: 70,
         desc_flavor: "Corpos carbonizados entram em ignicao expontanea ao sucumbir, inflamando aliados.",
         desc_value: "Abater um inimigo em chamas faz com que ele exploda, espalhando fogo aos vizinhos.", icon_type: "fury"},
        {id: "mage_piro_ponto_fusao", character: "mage", affinity: "fire", label: "Ponto de Fusao", synth_field: "synth_piro_ponto_fusao", per_rank: 0.50, cost: 75,
         desc_flavor: "Calor vulcanico extremo capaz de liquefazer couracas de ferro e escudos magicos.",
         desc_value: "O dano de fogo ignora 50% da armadura fisica e magica dos inimigos.", icon_type: "fireball"},
        {id: "mage_piro_conflagracao_furiosa", character: "mage", affinity: "fire", label: "Conflagracao Furiosa", synth_field: "synth_piro_conflagracao_furiosa", per_rank: 0.30, cost: 70,
         desc_flavor: "As cinzas incandescentes sopram furiosamente pelo cajado, acelerando novos lancamentos.",
         desc_value: "O Ponto de Ignicao (X) atrai cinzas que aumentam a cadencia de feiticos em +30% por 3s.", icon_type: "haste"},
        {id: "mage_piro_sopro_dragao", character: "mage", affinity: "fire", label: "Sopro de Dragao", synth_field: "synth_piro_sopro_dragao", per_rank: 1, cost: 65,
         desc_flavor: "A ponta do cajado cospe uma labareda torrencial conica no lugar de projeteis isolados.",
         desc_value: "O feitico basico se torna um cone continuo de chamas a curto alcance com dano em area.", icon_type: "burn"},
        {id: "mage_piro_fenix_imortal", character: "mage", affinity: "fire", label: "Fenix Imortal", synth_field: "synth_piro_fenix_imortal", per_rank: 0.35, cost: 85,
         desc_flavor: "A centelha primordial da fenix renasce das cinzas em uma supernova de cura quando o mago cai.",
         desc_value: "Ao sofrer dano fatal, liberta uma supernova curando 35% de vida (1 vez por run).", icon_type: "second_wind"},

        // 4. AEROMANTE (MAGO / VENTO E TROVAO - 8 TALENTOS)
        {id: "mage_aero_arco_eletrico", character: "mage", affinity: "wind", label: "Arco Eletrico", synth_field: "synth_aero_arco_eletrico", per_rank: 2, cost: 60,
         desc_flavor: "Fagulhas ionizadas saltam do alvo primario para eletrocutar inimigos proximos.",
         desc_value: "Projeteis magicos encadeiam um raio secundario para ate 2 alvos proximos.", icon_type: "wind"},
        {id: "mage_aero_passo_cefiro", character: "mage", affinity: "wind", label: "Passo Cefiro", synth_field: "synth_aero_passo_cefiro", per_rank: 0.20, cost: 55,
         desc_flavor: "Bisas velozes impulsionam os passos do conjurador apos canalizar o vento das alturas.",
         desc_value: "+20% de velocidade base; aumenta em mais +10% apos usar feiticos por 2s.", icon_type: "boot"},
        {id: "mage_aero_sobrecarga_estatica", character: "mage", affinity: "wind", label: "Sobrecarga Estatica", synth_field: "synth_aero_sobrecarga_estatica", per_rank: 1.0, cost: 65,
         desc_flavor: "O atrito do ar acumula voltagem estatica no cajado, pronta para paralisar o agressor.",
         desc_value: "Mover-se acumula carga eletrica; com 100% de carga, o proximo ataque atordoa por 1s.", icon_type: "shockwave"},
        {id: "mage_aero_tufao_repulsor", character: "mage", affinity: "wind", label: "Tufao Repulsor", synth_field: "synth_aero_tufao_repulsor", per_rank: 1, cost: 60,
         desc_flavor: "Uma redoma de vento comprimido capaz de desviar flechas e disparos hostis no ar.",
         desc_value: "O Manashield (X) gera uma rajada circular de vento que afasta projeteis inimigos.", icon_type: "wind"},
        {id: "mage_aero_salto_tempestuoso", character: "mage", affinity: "wind", label: "Salto Tempestuoso", synth_field: "synth_aero_salto_tempestuoso", per_rank: 0.40, cost: 75,
         desc_flavor: "O teletransporte eletrico reutiliza a energia estatica colhida no vacuo dos monstros.",
         desc_value: "A Distorcao Voltaica (X) recarrega 40% mais rapido se passar por dentro de inimigos.", icon_type: "cdr"},
        {id: "mage_aero_vortice_cortante", character: "mage", affinity: "wind", label: "Vortice Cortante", synth_field: "synth_aero_vortice_cortante", per_rank: 1, cost: 70,
         desc_flavor: "A sequencia de ataques cria um redemoinho giratorio que suga inimigos desorientados.",
         desc_value: "O 3o projetil consecutivo gera um minifuracao no impacto que puxa monstros fracos.", icon_type: "shockwave"},
        {id: "mage_aero_condutividade_letal", character: "mage", affinity: "wind", label: "Condutividade Letal", synth_field: "synth_aero_condutividade_letal", per_rank: 1.0, cost: 75,
         desc_flavor: "A agua acumulada no solo ou nos corpos amplifica a tensao do choque eletrico.",
         desc_value: "Inimigos lentos ou molhados sofrem o dobro de dano de raio e choque prolongado.", icon_type: "crit"},
        {id: "mage_aero_olho_furacao", character: "mage", affinity: "wind", label: "Olho do Furacao", synth_field: "synth_aero_olho_furacao", per_rank: 0.15, cost: 80,
         desc_flavor: "A pressao atmosferica cria um bolsao de baixa densidade onde disparos erram o alvo.",
         desc_value: "Esquiva de projeteis aumentada em +15% enquanto o mago estiver em movimento.", icon_type: "dodge"},

        // 5. GEOMANTE (MAGO / TERRA E BASALTO - 8 TALENTOS)
        {id: "mage_geo_projetil_rochoso", character: "mage", affinity: "earth", label: "Projetil Rochoso", synth_field: "synth_geo_projetil_rochoso", per_rank: 0.60, cost: 60,
         desc_flavor: "Cristais pesados de basalto no nucleo do disparo que empurram agressores para tras.",
         desc_value: "A magia basica ganha pedras pesadas com +60% de empurrao (knockback).", icon_type: "rock"},
        {id: "mage_geo_armadura_granito", character: "mage", affinity: "earth", label: "Armadura de Granito", synth_field: "synth_geo_armadura_granito", per_rank: 6, cost: 65,
         desc_flavor: "Camadas solidas de rochas flutuantes ao redor do manto conferindo protecao contra ferro afiado.",
         desc_value: "+6 de Defesa Fisica permanente e imunidade a cortes fracos.", icon_type: "shield"},
        {id: "mage_geo_tremer_terra", character: "mage", affinity: "earth", label: "Tremer da Terra", synth_field: "synth_geo_tremer_terra", per_rank: 1, cost: 70,
         desc_flavor: "O choque dos projeteis contra rochedos e paredes dissipa ondas sismicas no assoalho.",
         desc_value: "O impacto de projeteis em paredes gera uma onda sismica curta no chao causando lentidao.", icon_type: "rock"},
        {id: "mage_geo_monolito_esmagador", character: "mage", affinity: "earth", label: "Monolito Esmagador", synth_field: "synth_geo_monolito_esmagador", per_rank: 40, cost: 70,
         desc_flavor: "O pilar basÃ¡ltico implode ao se esgotar, esmagando tudo que estiver preso na gravidade.",
         desc_value: "O Monolito Basaltico (X) desaba no fim da duracao causando 40 de dano em area.", icon_type: "bastion"},
        {id: "mage_geo_espinhos_teluricos", character: "mage", affinity: "earth", label: "Espinhos Teluricos", synth_field: "synth_geo_espinhos_teluricos", per_rank: 1.0, cost: 75,
         desc_flavor: "Monstros arremessados contra obstaculos sofrem a violencia do esmagamento mineral.",
         desc_value: "Inimigos empurrados contra paredes por magias sofrem o dobro de dano de impacto.", icon_type: "thorns"},
        {id: "mage_geo_coracao_areia", character: "mage", affinity: "earth", label: "Coracao de Areia", synth_field: "synth_geo_coracao_areia", per_rank: 0.05, cost: 70,
         desc_flavor: "Areia dourada que se condensa em uma pelicula protetora a cada fragmento arremessado.",
         desc_value: "Ganha barreira temporaria igual a 5% do dano causado com magias de terra.", icon_type: "barrier"},
        {id: "mage_geo_poco_gravitacional", character: "mage", affinity: "earth", label: "Poco Gravitacional", synth_field: "synth_geo_poco_gravitacional", per_rank: 0.40, cost: 75,
         desc_flavor: "Massa telurica densa no mago que dobra o peso dos monstros que tentam cerca-lo.",
         desc_value: "Inimigos a menos de 70px do mago sofrem 40% de lentidao constante pela gravidade.", icon_type: "shockwave"},
        {id: "mage_geo_estilhaco_basalto", character: "mage", affinity: "earth", label: "Estilhaco de Basalto", synth_field: "synth_geo_estilhaco_basalto", per_rank: 4, cost: 80,
         desc_flavor: "A destruicao dos monstros libera lascas afiadas de basalto que atravessam fileiras vizinhas.",
         desc_value: "Abates com magias de terra explodem em 4 fragmentos pontiagudos que perfuram alvos.", icon_type: "rock"},

        // 6. LENDARIOS / SINERGIAS HIBRIDAS DO MAGO (8 TALENTOS)
        {id: "mage_lendario_vapor_fulminante", character: "mage", affinity: "hybrid", label: "Vapor Fulminante", synth_field: "synth_mage_vapor_fulminante", per_rank: 1, cost: 100,
         desc_flavor: "Gelo e chamas se chocam descarregando nuvens de vapor superaquecido no ambiente.",
         desc_value: "Inimigos queimados e congelados simultaneamente liberam vapor fervente com dano continuo em area.", icon_type: "burn"},
        {id: "mage_lendario_tempestade_areia", character: "mage", affinity: "hybrid", label: "Tempestade de Areia", synth_field: "synth_mage_tempestade_areia", per_rank: 0.50, cost: 100,
         desc_flavor: "Particulas de quartzo sopradas pelo vento cegam a visao de monstros atacantes.",
         desc_value: "Projeteis de terra liberam cortinas de areia que fazem inimigos errarem 50% dos ataques.", icon_type: "wind"},
        {id: "mage_lendario_gelo_fendido", character: "mage", affinity: "hybrid", label: "Gelo Fendido", synth_field: "synth_mage_gelo_fendido", per_rank: 1, cost: 110,
         desc_flavor: "Solo rochoso congelado em permafrost profundo prendendo monstros em armadilhas geladas.",
         desc_value: "Impactos de gelo petrificam o chao, congelando inimigos permanentemente ao pisarem.", icon_type: "barrier"},
        {id: "mage_lendario_tempestade_plasma", character: "mage", affinity: "hybrid", label: "Tempestade de Plasma", synth_field: "synth_mage_tempestade_plasma", per_rank: 1, cost: 110,
         desc_flavor: "A fusao de furia ignea e raio gera descargas de plasma violeta teleguiadas.",
         desc_value: "Relampagos inflamam alvos e geram arcos de plasma teleguiados em cascata.", icon_type: "fireball"},
        {id: "mage_lendario_avatar_arcano", character: "mage", affinity: "legendary", label: "Avatar Arcano", synth_field: "synth_mage_avatar_arcano", per_rank: 0.30, cost: 120,
         desc_flavor: "Dominio supremo da teia mistica transformando o corpo em um condutor de luz pura.",
         desc_value: "+30% de Poder Magico total e Manashield absorve 100% de dano por 1s ao ser ativado.", icon_type: "magic_def"},
        {id: "mage_lendario_singularidade_dimensional", character: "mage", affinity: "legendary", label: "Singularidade Dimensional", synth_field: "synth_mage_singularidade_dimensional", per_rank: 1, cost: 130,
         desc_flavor: "Colapso do espaco que distorce o ar engolindo projeteis inimigos em um buraco negro.",
         desc_value: "A cada 12s, o proximo feitico cria um buraco negro que suga e desintegra projeteis.", icon_type: "shockwave"},
        {id: "mage_lendario_chuva_cometas", character: "mage", affinity: "legendary", label: "Chuva de Cometas", synth_field: "synth_mage_chuva_cometas", per_rank: 1, cost: 125,
         desc_flavor: "Crateras caindo das estrelas que incendeiam e reduzem salas inteiras a poeira e brasas.",
         desc_value: "Acertos criticos convocam cometas gigantescos incandescentes que esmagam em area.", icon_type: "fireball"},
        {id: "mage_lendario_conjurador_supremo", character: "mage", affinity: "legendary", label: "Conjurador Supremo", synth_field: "synth_mage_conjurador_supremo", per_rank: 1, cost: 140,
         desc_flavor: "Cadencia celestial ininterrupta canalizando magias como uma torrente eterea infinita.",
         desc_value: "Elimina o intervalo entre ataques magicos caso acerte 5 feiticos consecutivos.", icon_type: "haste"},

        // =========================================================================
        // ARQUEIRO (ARCHER) - 50 TALENTOS
        // =========================================================================
        // 1. FUNDAMENTAIS / MESTRIA EM TIRO (10 TALENTOS)
        {id: "archer_tiro_em_corrida", character: "archer", affinity: "none", label: "Tiro em Corrida", synth_field: "synth_archer_tiro_em_corrida", per_rank: 0.60, cost: 0,
         desc_flavor: "Agilidade magistral que permite disparar flechas velozes sem desacelerar a corrida.",
         desc_value: "Atirar enquanto se desloca reduz a desaceleracao de movimento em 60%.", icon_type: "boot"},
        {id: "archer_ponto_cego", character: "archer", affinity: "none", label: "Ponto Cego", synth_field: "synth_archer_ponto_cego", per_rank: 0.30, cost: 0,
         desc_flavor: "Calculo balistico perfeito para acertar pontos vulneraveis no limite maximo da visao.",
         desc_value: "Flechas que atingem inimigos a mais de 300px de distancia causam +30% de dano critico.", icon_type: "crit"},
        {id: "archer_perfuracao_reta", character: "archer", affinity: "none", label: "Perfuracao Reta", synth_field: "synth_archer_perfuracao_reta", per_rank: 1, cost: 0,
         desc_flavor: "Pontas aerodinamicas que varrem fileiras de inimigos sem perder forca ou desviar do curso.",
         desc_value: "Todas as flechas atravessam 1 inimigo adicional antes de sumir.", icon_type: "pierce"},
        {id: "archer_aljava_leve", character: "archer", affinity: "none", label: "Aljava Leve", synth_field: "synth_archer_aljava_leve", per_rank: 0.20, cost: 35,
         desc_flavor: "Saque rapido das penas e encaixe imediato na corda do arco para disparos continuos.",
         desc_value: "+20% de velocidade de ataque base com o arco longo.", icon_type: "arrow_speed"},
        {id: "archer_pontas_farpadas", character: "archer", affinity: "none", label: "Pontas Farpadas", synth_field: "synth_archer_pontas_farpadas", per_rank: 0.20, cost: 45,
         desc_flavor: "Ganchos de ferro na haste das flechas que rasgam carne e deixam sangramentos continuos.",
         desc_value: "Acertos criticos aplicam sangramento causando 20% do dano ao longo de 2s.", icon_type: "execute"},
        {id: "archer_recuo_emergencia", character: "archer", affinity: "none", label: "Recuo de Emergencia", synth_field: "synth_archer_recuo_emergencia", per_rank: 1, cost: 40,
         desc_flavor: "Mola de pressao no arco que empurra atacantes violentamente se o heroi for atingido.",
         desc_value: "Ao sofrer dano fisico, repele o agressor 90px para tras (recarga: 8s).", icon_type: "shockwave"},
        {id: "archer_reflexo_cacador", character: "archer", affinity: "none", label: "Reflexo do Cacador", synth_field: "synth_archer_reflexo_cacador", per_rank: 0.25, cost: 50,
         desc_flavor: "A adrenalina do rolamento posiciona a corda do arco pronta para um disparo imediato.",
         desc_value: "Usar o Rolamento concede +25% de velocidade de ataque pelos proximos 2s.", icon_type: "haste"},
        {id: "archer_flecha_pesada", character: "archer", affinity: "none", label: "Flecha Pesada", synth_field: "synth_archer_flecha_pesada", per_rank: 0.50, cost: 50,
         desc_flavor: "Hastes reforcadas de carvalho negro que jogam monstros no chao com impacto macico.",
         desc_value: "Aumenta a forca de empurrao (knockback) das flechas em +50%.", icon_type: "bow"},
        {id: "archer_tiro_concentrado", character: "archer", affinity: "none", label: "Tiro Concentrado", synth_field: "synth_archer_tiro_concentrado", per_rank: 1, cost: 55,
         desc_flavor: "Paciencia e respiracao controlada garantindo letalidade absoluta no disparo.",
         desc_value: "Ficar parado por 1.5s garante 100% de chance de critico na proxima flecha.", icon_type: "crit"},
        {id: "archer_saque_rapido", character: "archer", affinity: "none", label: "Saque Rapido", synth_field: "synth_archer_saque_rapido", per_rank: 0.15, cost: 60,
         desc_flavor: "Ritmo muscular aprimorado que resfria esquivas conforme tiros certeiros encontram o alvo.",
         desc_value: "Rolamento recarrega 15% mais rapido a cada acerto critico desferido.", icon_type: "cdr"},

        // 2. CACADOR DAS MARES (ARQUEIRO / AGUA - 8 TALENTOS)
        {id: "archer_glacial_flecha_estalactite", character: "archer", affinity: "water", label: "Flecha de Estalactite", synth_field: "synth_archer_glacial_flecha_estalactite", per_rank: 0.25, cost: 50,
         desc_flavor: "Flechas com pontas esculpidas em pingentes gelados que congelam os passos das feras.",
         desc_value: "Flechas aplicam 25% de lentidao acumulativa a cada impacto no alvo.", icon_type: "pierce"},
        {id: "archer_glacial_pista_escorregadia", character: "archer", affinity: "water", label: "Pista Escorregadia", synth_field: "synth_archer_glacial_pista_escorregadia", per_rank: 1, cost: 60,
         desc_flavor: "O rolamento espalha agua cristalizada onde monstros derrapam e perdem o equilibrio.",
         desc_value: "O rolamento deixa um rastro de agua congelada no solo que desorienta inimigos.", icon_type: "barrier"},
        {id: "archer_glacial_chuva_torrencial", character: "archer", affinity: "water", label: "Chuva Torrencial", synth_field: "synth_archer_glacial_chuva_torrencial", per_rank: 4, cost: 55,
         desc_flavor: "Uma saraivada celestial de flechas liquefeitas que chovem sobre zonas inteiras.",
         desc_value: "Toda 5Âª flecha atirada faz chover 4 projeteis aquaticos celestes em leque.", icon_type: "bow"},
        {id: "archer_glacial_flecha_arpao", character: "archer", affinity: "water", label: "Flecha Arpao", synth_field: "synth_archer_glacial_flecha_arpao", per_rank: 3, cost: 65,
         desc_flavor: "Cordas de orvalho conectam os inimigos perfurados, dividindo os ferimentos entre todos.",
         desc_value: "Flechas perfurantes conectam alvos com agua, dividindo dano entre ate 3 monstros.", icon_type: "pierce"},
        {id: "archer_glacial_brisa_curativa", character: "archer", affinity: "water", label: "Brisa Curativa", synth_field: "synth_archer_glacial_brisa_curativa", per_rank: 4, cost: 70,
         desc_flavor: "Gotas de agua purificada evaporam das vitimas lentas, restaurando a vitalidade do arqueiro.",
         desc_value: "Abater inimigos sob lentidao libera goticulas que restauram 4 de HP.", icon_type: "regen"},
        {id: "archer_glacial_nevoa_ilusoria", character: "archer", affinity: "water", label: "Nevoa Ilusoria", synth_field: "synth_archer_glacial_nevoa_ilusoria", per_rank: 1, cost: 65,
         desc_flavor: "Uma nÃ©voa densa que cega agressores na area de rolamento, fazendo-os golpear o ar.",
         desc_value: "Inimigos dentro da nevoa do Rolamento perdem a linha de visao e erram seus ataques.", icon_type: "dodge"},
        {id: "archer_glacial_perfurador_glacial", character: "archer", affinity: "water", label: "Perfurador Glacial", synth_field: "synth_archer_glacial_perfurador_glacial", per_rank: 1.0, cost: 75,
         desc_flavor: "Tiros macicos contra carne congelada que quebram o alvo em estilhacos cortantes.",
         desc_value: "Tiros em alvos congelados causam o dobro de dano e quebram gelo em estilhacos.", icon_type: "crit"},
        {id: "archer_glacial_tiro_maelstrom", character: "archer", affinity: "water", label: "Tiro do Maelstrom", synth_field: "synth_archer_glacial_tiro_maelstrom", per_rank: 1, cost: 80,
         desc_flavor: "A flecha gira criando um turbilhao tempestuoso que arrasta tudo pelo caminho.",
         desc_value: "A flecha se transforma em um redemoinho aquatico tragando monstros em sua trajetoria.", icon_type: "shockwave"},

        // 3. BALISTICO INFERNAL (ARQUEIRO / FOGO - 8 TALENTOS)
        {id: "archer_balist_flecha_incendiaria", character: "archer", affinity: "fire", label: "Flecha Incendiaria", synth_field: "synth_archer_balist_flecha_incendiaria", per_rank: 4, cost: 55,
         desc_flavor: "Hastes ensopadas em pez ardente que cobrem agressores de labaredas continuas.",
         desc_value: "Flechas incendeiam inimigos atingidos causando dano de fogo continuo por 3s.", icon_type: "burn"},
        {id: "archer_balist_detonacao_parede", character: "archer", affinity: "fire", label: "Detonacao de Parede", synth_field: "synth_archer_balist_detonacao_parede", per_rank: 30, cost: 60,
         desc_flavor: "Polvora concentrada que explode pirotecnicamente ao colidir contra as rochas das salas.",
         desc_value: "Flechas que colidem com paredes explodem causando 30 de dano em area.", icon_type: "fireball"},
        {id: "archer_balist_tiro_fragmentacao", character: "archer", affinity: "fire", label: "Tiro de Fragmentacao", synth_field: "synth_archer_balist_tiro_fragmentacao", per_rank: 3, cost: 65,
         desc_flavor: "A ponta da flecha se estilhaca em tres estopins explosivos ao atingir a carne inimiga.",
         desc_value: "O 3o disparo solta uma flecha que se divide em 3 fagulhas explosivas no impacto.", icon_type: "fury"},
        {id: "archer_balist_marca_purgatorio", character: "archer", affinity: "fire", label: "Marca do Purgatorio", synth_field: "synth_archer_balist_marca_purgatorio", per_rank: 1, cost: 70,
         desc_flavor: "Inimigos em brasa explodem em combustao espontanea ao sofrerem perfuracoes criticas.",
         desc_value: "Inimigos em chamas atingidos por criticos explodem causando combustao em massa.", icon_type: "burn"},
        {id: "archer_balist_propulsao_ardente", character: "archer", affinity: "fire", label: "Propulsao Ardente", synth_field: "synth_archer_balist_propulsao_ardente", per_rank: 0.50, cost: 75,
         desc_flavor: "A explosao de recuo arremessa o heroi mais longe e transforma o piso em magma fervente.",
         desc_value: "O Tiro de Recuo (X) projeta o arqueiro 50% mais longe e deixa labaredas no solo.", icon_type: "haste"},
        {id: "archer_balist_polvora_concentrada", character: "archer", affinity: "fire", label: "Polvora Concentrada", synth_field: "synth_archer_balist_polvora_concentrada", per_rank: 0.25, cost: 70,
         desc_flavor: "Composicao quimica aprimorada que alarga a onda de choque das explosoes de fogo.",
         desc_value: "+25% de raio de explosao para todos os efeitos de fogo do arqueiro.", icon_type: "fireball"},
        {id: "archer_balist_balista_piromante", character: "archer", affinity: "fire", label: "Balista Piromante", synth_field: "synth_archer_balist_balista_piromante", per_rank: 1, cost: 65,
         desc_flavor: "Acumulo termico que transforma o arco longo em um canhao capaz de derreter blindagens.",
         desc_value: "Ficar imovel acumula calor; a flecha atinge velocidade extrema e perfura todos os alvos.", icon_type: "pierce"},
        {id: "archer_balist_fenix_cacadora", character: "archer", affinity: "fire", label: "Fenix Cacadora", synth_field: "synth_archer_balist_fenix_cacadora", per_rank: 1, cost: 85,
         desc_flavor: "Um projetil com asas de fogo que curva a trajetoria para devastar monstros de elite e chefes.",
         desc_value: "O disparo vira uma fenix voadora teleguiada que persegue o inimigo mais perigoso.", icon_type: "fireball"},

        // 4. MESTRE DO VENDAVAL (ARQUEIRO / VENTO - 8 TALENTOS)
        {id: "archer_venda_disparo_leque", character: "archer", affinity: "wind", label: "Disparo em Leque", synth_field: "synth_archer_venda_disparo_leque", per_rank: 3, cost: 60,
         desc_flavor: "Tres flechas disparadas simultaneamente em arco frontal para varrer corredores inteiros.",
         desc_value: "O ataque basico atira 3 flechas simultaneas em leque com 40% de dano cada.", icon_type: "bow"},
        {id: "archer_venda_flecha_teleguiada", character: "archer", affinity: "wind", label: "Flecha Teleguiada", synth_field: "synth_archer_venda_flecha_teleguiada", per_rank: 1, cost: 55,
         desc_flavor: "Correntes de vento guiam a cauda das flechas na direcao exata dos corpos hostis.",
         desc_value: "Flechas curvam levemente a trajetoria no ar para encontrar inimigos proximos.", icon_type: "arrow_speed"},
        {id: "archer_venda_tiro_supersonico", character: "archer", affinity: "wind", label: "Tiro Supersonico", synth_field: "synth_archer_venda_tiro_supersonico", per_rank: 1.0, cost: 65,
         desc_flavor: "Velocidade de saida descomunal que quebra a barreira do som e dissipa projeteis menores.",
         desc_value: "A velocidade da flecha dobra e o disparo anula projeteis menores no trajeto.", icon_type: "arrow_speed"},
        {id: "archer_venda_rolamento_furacao", character: "archer", affinity: "wind", label: "Rolamento Furacao", synth_field: "synth_archer_venda_rolamento_furacao", per_rank: 1, cost: 60,
         desc_flavor: "Vortice eolico descarregado ao rolar que abre espaco empurrando agressores para longe.",
         desc_value: "A Esquiva Ciclonica (X) empurra inimigos adjacentes para fora com rajada de vento.", icon_type: "wind"},
        {id: "archer_venda_danca_ventos", character: "archer", affinity: "wind", label: "Danca dos Ventos", synth_field: "synth_archer_venda_danca_ventos", per_rank: 1.0, cost: 75,
         desc_flavor: "Aproveitamento do vacuo pos-esquiva para desferir dois disparos instantaneos em sequencia.",
         desc_value: "Esquivar com sucesso concede +100% de velocidade de ataque para as proximas 2 flechas.", icon_type: "haste"},
        {id: "archer_venda_corte_tufao", character: "archer", affinity: "wind", label: "Corte do Tufao", synth_field: "synth_archer_venda_corte_tufao", per_rank: 0.35, cost: 70,
         desc_flavor: "Laminas de ar comprimido nas pontas das hastes que arranham monstros nas bordas do tiro.",
         desc_value: "Flechas criam ondas de vacuo laterais causando dano raspante a alvos vizinhos.", icon_type: "wind"},
        {id: "archer_venda_passo_etereo", character: "archer", affinity: "wind", label: "Passo Etereo", synth_field: "synth_archer_venda_passo_etereo", per_rank: 0.15, cost: 75,
         desc_flavor: "Imaterialidade eterea estendida enquanto o arqueiro gira e contorna garras e laminas.",
         desc_value: "Aumenta o tempo de invulnerabilidade do Rolamento em +0.15 segundos.", icon_type: "dodge"},
        {id: "archer_venda_tempestade_mil_tiros", character: "archer", affinity: "wind", label: "Tempestade de Mil Tiros", synth_field: "synth_archer_venda_tempestade_mil_tiros", per_rank: 1, cost: 80,
         desc_flavor: "Metralhadora de arcos desferindo uma torrente de flechas reluzentes pelo ar.",
         desc_value: "Dispara uma torrente de 15 flechas ultrarrapidas em cone devastador a frente.", icon_type: "bow"},

        // 5. BALISTA DA TERRA (ARQUEIRO / TERRA - 8 TALENTOS)
        {id: "archer_terra_flecha_arpao_pedra", character: "archer", affinity: "earth", label: "Flecha Arpao de Pedra", synth_field: "synth_archer_terra_flecha_arpao_pedra", per_rank: 1.0, cost: 60,
         desc_flavor: "Pontas pesadas de granito que cravam monstros contra colunas e paredes rochosas.",
         desc_value: "Flechas pesadas que empurram inimigos ate paredes causam atordoamento de 1s.", icon_type: "rock"},
        {id: "archer_terra_tremores_impacto", character: "archer", affinity: "earth", label: "Tremores de Impacto", synth_field: "synth_archer_terra_tremores_impacto", per_rank: 0.30, cost: 65,
         desc_flavor: "Vibracoes teluricas no ponto de impacto que abrem fissuras desacelerando os passos.",
         desc_value: "Cada flecha que atinge o solo solta uma mini-fissura que causa lentidao de 30%.", icon_type: "rock"},
        {id: "archer_terra_flecha_enraizadora", character: "archer", affinity: "earth", label: "Flecha Enraizadora", synth_field: "synth_archer_terra_flecha_enraizadora", per_rank: 2.0, cost: 70,
         desc_flavor: "Esporos vegetais concentrados que brotam raizes do chao prendendo o monstro no lugar.",
         desc_value: "A cada 4 acertos, raizes emergem do solo e prendem o monstro no lugar por 2s.", icon_type: "bastion"},
        {id: "archer_terra_postura_fortaleza", character: "archer", affinity: "earth", label: "Postura da Fortaleza", synth_field: "synth_archer_terra_postura_fortaleza", per_rank: 15, cost: 70,
         desc_flavor: "Estacas de aco fixadas no solo impedindo qualquer tipo de empurrao de bestas colossais.",
         desc_value: "A Fixacao de Ancora (X) concede +15 de defesa fisica e imunidade a knockback.", icon_type: "shield"},
        {id: "archer_terra_balista_obsidiana", character: "archer", affinity: "earth", label: "Balista de Obsidiana", synth_field: "synth_archer_terra_balista_obsidiana", per_rank: 0.35, cost: 75,
         desc_flavor: "Perfuracao mineral afiada capaz de partir escudos pesados e estilhacar couracas.",
         desc_value: "Flechas tem 35% de chance de despedacar armaduras e escudos inimigos.", icon_type: "sword"},
        {id: "archer_terra_raizes_sanguineas", character: "archer", affinity: "earth", label: "Raizes Sanguineas", synth_field: "synth_archer_terra_raizes_sanguineas", per_rank: 0.30, cost: 70,
         desc_flavor: "As vinhas cravadas sugam o vigor da vitima tornando-a vulneravel a novos impactos.",
         desc_value: "Inimigos enraizados sofrem +30% a mais de dano de qualquer fonte.", icon_type: "execute"},
        {id: "archer_terra_estacas_defensivas", character: "archer", affinity: "earth", label: "Estacas Defensivas", synth_field: "synth_archer_terra_estacas_defensivas", per_rank: 3, cost: 75,
         desc_flavor: "Espinhos de calcario deixados na esteira do rolamento para empalar perseguidores.",
         desc_value: "Ao rolar, deixa 3 armadilhas de espinhos de pedra no solo causando dano.", icon_type: "thorns"},
        {id: "archer_terra_tiro_cataclismico", character: "archer", affinity: "earth", label: "Tiro Cataclismico", synth_field: "synth_archer_terra_tiro_cataclismico", per_rank: 1, cost: 80,
         desc_flavor: "Uma estaca macica talhada em rocha pura que empurra fileiras inteiras pelo corredor.",
         desc_value: "Dispara uma flecha colossal que perfura a sala inteira empurrando monstros.", icon_type: "rock"},

        // 6. LENDARIOS / SINERGIAS HIBRIDAS DO ARQUEIRO (8 TALENTOS)
        {id: "archer_lendario_flecha_aurora_glacial", character: "archer", affinity: "hybrid", label: "Flecha da Aurora Glacial", synth_field: "synth_archer_aurora_glacial", per_rank: 1, cost: 100,
         desc_flavor: "Minas de gelo pontiagudo cravadas no solo que estilham quando monstros se aproximam.",
         desc_value: "Flechas cravam estacas de gelo no solo que explodem em espinhos quando inimigos pisam.", icon_type: "barrier"},
        {id: "archer_lendario_tempestade_ignea_aerea", character: "archer", affinity: "hybrid", label: "Tempestade Ignea Aerea", synth_field: "synth_archer_tempestade_ignea", per_rank: 1, cost: 100,
         desc_flavor: "Ventos rodopiantes inflamam as hastes criando tres tornados de fogo pelo salao.",
         desc_value: "Flechas em leque inflamam criando tres tornados de fogo moveis na sala.", icon_type: "fury"},
        {id: "archer_lendario_chuva_lodo_acido", character: "archer", affinity: "hybrid", label: "Chuva de Lodo Acido", synth_field: "synth_archer_lodo_acido", per_rank: 1, cost: 110,
         desc_flavor: "Vapor corrosivo que dissolve resistencias monstruosas e sara feridas do arqueiro.",
         desc_value: "Flechas de vapor toxico dissolvem resistencias e restauram vida proporcional ao dano.", icon_type: "poison"},
        {id: "archer_lendario_projetil_meteorico", character: "archer", affinity: "hybrid", label: "Projetil Meteorico", synth_field: "synth_archer_projetil_meteorico", per_rank: 1, cost: 110,
         desc_flavor: "Crateras ardentes onde as flechas atingem, detonando estilhacos incandescentes.",
         desc_value: "Flechas deixam pocas de magma fervente e estilhacos que explodem apos 1s.", icon_type: "fireball"},
        {id: "archer_lendario_olho_falcao_cosmico", character: "archer", affinity: "legendary", label: "Olho do Falcao Cosmico", synth_field: "synth_archer_falcao_cosmico", per_rank: 1, cost: 120,
         desc_flavor: "Precisao estelar que enxerga alem dos muros convocando flechas celestes reluzentes.",
         desc_value: "Alcance ilimitado; acertos criticos disparam flechas estelares celestes adicionais.", icon_type: "crit"},
        {id: "archer_lendario_atirador_fantasma", character: "archer", affinity: "legendary", label: "Atirador Fantasma", synth_field: "synth_archer_atirador_fantasma", per_rank: 1, cost: 130,
         desc_flavor: "Uma projecao espectral deixada no rolamento que espelha os disparos por alguns segundos.",
         desc_value: "O rolamento deixa um clone translucido que atira junto com o arqueiro por 3s.", icon_type: "bow"},
        {id: "archer_lendario_saraivada_eterna", character: "archer", affinity: "legendary", label: "Saraivada Eterna", synth_field: "synth_archer_saraivada_eterna", per_rank: 1, cost: 125,
         desc_flavor: "Momentum de caca inesgotavel acelerando esquivas e cadencia a cada abate conquistado.",
         desc_value: "Abater inimigos reinicia a recarga do Rolamento e dobra a velocidade de disparo temporariamente.", icon_type: "haste"},
        {id: "archer_lendario_flecha_julgamento", character: "archer", affinity: "legendary", label: "Flecha do Julgamento", synth_field: "synth_archer_flecha_julgamento", per_rank: 1, cost: 140,
         desc_flavor: "Um raio de luz divina que desintegra criaturas enfraquecidas em um estrondo celestial.",
         desc_value: "Toda 10Âª flecha dispara uma lanca divina que desintegra monstros com menos de 30% de vida.", icon_type: "holy"},

        // =========================================================================
        // ASSASSINO (ASSASSIN) - 50 TALENTOS
        // =========================================================================
        // 1. FUNDAMENTAIS / MESTRIA DE ADAGAS (10 TALENTOS)
        {id: "assassin_golpe_jugular", character: "assassin", affinity: "none", label: "Golpe na Jugular", synth_field: "synth_assassin_golpe_jugular", per_rank: 0.75, cost: 0,
         desc_flavor: "Perfeicao cirurgica na ponta da adaga atingindo pontos vitais dos alvos pelas costas.",
         desc_value: "Ataques pelas costas dos inimigos causam +75% de dano critico.", icon_type: "execute"},
        {id: "assassin_passo_silencioso", character: "assassin", affinity: "none", label: "Passo Silencioso", synth_field: "synth_assassin_passo_silencioso", per_rank: 25, cost: 0,
         desc_flavor: "Passadas incorporeas pelas penumbras permitindo flanquear sem atrair atencao.",
         desc_value: "+25 de Velocidade de Movimento base; correr nao alerta inimigos fora de visao.", icon_type: "boot"},
        {id: "assassin_laminas_gemeas", character: "assassin", affinity: "none", label: "Laminas Gemeas", synth_field: "synth_assassin_laminas_gemeas", per_rank: 1, cost: 0,
         desc_flavor: "Manejo simetrico em cruz desferindo dois talhos rapidos a cada comando de ataque.",
         desc_value: "Todo ataque basico desfere dois cortes rapidos em sucessao imediata.", icon_type: "dagger"},
        {id: "assassin_adaga_envenenada", character: "assassin", affinity: "none", label: "Adaga Envenenada", synth_field: "synth_assassin_adaga_envenenada", per_rank: 3, cost: 35,
         desc_flavor: "Extrato mortal de escorpioes da cripta que corroe o sangue das vitimas.",
         desc_value: "Acertos criticos aplicam veneno mortal causando dano continuo por 4s.", icon_type: "poison"},
        {id: "assassin_saque_rapido_letal", character: "assassin", affinity: "none", label: "Saque Rapido Letal", synth_field: "synth_assassin_saque_rapido_letal", per_rank: 2.0, cost: 45,
         desc_flavor: "O primeiro golpe na entrada de qualquer embate atinge com letalidade estarrecedora.",
         desc_value: "Entrar em uma sala concede 100% de critico pelos primeiros 2s de combate.", icon_type: "crit"},
        {id: "assassin_esquiva_reflexa", character: "assassin", affinity: "none", label: "Esquiva Reflexa", synth_field: "synth_assassin_esquiva_reflexa", per_rank: 0.15, cost: 40,
         desc_flavor: "Instintos felinos que contornam garras afiadas no ultimo milisegundo possivel.",
         desc_value: "+15% de chance de esquiva; esquivar com sucesso recarrega 1s de Invisibilidade.", icon_type: "dodge"},
        {id: "assassin_frenesi_sangue", character: "assassin", affinity: "none", label: "Frenesi de Sangue", synth_field: "synth_assassin_frenesi_sangue", per_rank: 0.10, cost: 50,
         desc_flavor: "O cheiro de sangue quente acelera os pulsos das adagas a cada monstro eliminado.",
         desc_value: "Eliminar um monstro concede +10% de velocidade de ataque por 3s (acumula ate 5x).", icon_type: "haste"},
        {id: "assassin_execucao_fria", character: "assassin", affinity: "none", label: "Execucao Fria", synth_field: "synth_assassin_execucao_fria", per_rank: 1.0, cost: 50,
         desc_flavor: "Frieza impiedosa para decepar monstros feridos antes que possam revidar.",
         desc_value: "Inimigos com menos de 25% de vida sofrem o dobro de dano de cortes normais.", icon_type: "execute"},
        {id: "assassin_emboscada_perfeita", character: "assassin", affinity: "none", label: "Emboscada Perfeita", synth_field: "synth_assassin_emboscada_perfeita", per_rank: 1.5, cost: 55,
         desc_flavor: "O golpe desferido a partir do vacuo sombrio atordoa a mente do agressor surpreso.",
         desc_value: "Golpear a partir da Invisibilidade (X) atordoa o alvo por 1.5 segundos.", icon_type: "dagger"},
        {id: "assassin_presteza_sombria", character: "assassin", affinity: "none", label: "Presteza Sombria", synth_field: "synth_assassin_presteza_sombria", per_rank: 1.5, cost: 60,
         desc_flavor: "Afinidade com as sombras reduzindo o intervalo entre momentos de ocultamento.",
         desc_value: "O tempo de recarga da habilidade de Invisibilidade e reduzido em 1.5 segundos.", icon_type: "cdr"},

        // 2. LAMINA ESPECTRAL (ASSASSINO / AGUA - 8 TALENTOS)
        {id: "assassin_espect_corte_fluido", character: "assassin", affinity: "water", label: "Corte Fluido", synth_field: "synth_assassin_espect_corte_fluido", per_rank: 1, cost: 50,
         desc_flavor: "O corpo desliza como agua escorrendo por entre as garras e armas dos monstros.",
         desc_value: "Atacar permite deslizar livremente atraves do modelo de colisao dos inimigos.", icon_type: "dodge"},
        {id: "assassin_espect_gota_hemofagica", character: "assassin", affinity: "water", label: "Gota Hemofagica", synth_field: "synth_assassin_espect_gota_hemofagica", per_rank: 4, cost: 60,
         desc_flavor: "As adagas condensam a forca vital da vitima recompondo o folego do assassino.",
         desc_value: "Cortes criticos drenam a vitalidade do alvo, curando 4 de HP por golpe.", icon_type: "lifesteal"},
        {id: "assassin_espect_nevoa_ilusoria", character: "assassin", affinity: "water", label: "Nevoa Ilusoria", synth_field: "synth_assassin_espect_nevoa_ilusoria", per_rank: 1, cost: 55,
         desc_flavor: "Dissolucao repentina em gotas de agua ao sofrer um golpe iminente, anulando o impacto.",
         desc_value: "Ao sofrer dano, dissipa em nevoa momentanea anulando o golpe (recarga: 20s).", icon_type: "barrier"},
        {id: "assassin_espect_adaga_criogenica", character: "assassin", affinity: "water", label: "Adaga Criogenica", synth_field: "synth_assassin_espect_adaga_criogenica", per_rank: 0.40, cost: 65,
         desc_flavor: "O fio gelido das laminas esfria a circulacao sanguinea da vitima a cada corte.",
         desc_value: "O 3o golpe de adaga esfria o sangue do alvo aplicando 40% de lentidao.", icon_type: "dagger"},
        {id: "assassin_espect_afogamento_sombrio", character: "assassin", affinity: "water", label: "Afogamento Sombrio", synth_field: "synth_assassin_espect_afogamento_sombrio", per_rank: 1, cost: 70,
         desc_flavor: "Uma esfera aquosa de vacuo sela a boca do monstro impedindo conjuracoes e gritos.",
         desc_value: "Ataques furtivos silenciam e desarmam a vitima momentaneamente com bolha d'agua.", icon_type: "shockwave"},
        {id: "assassin_espect_passo_mares", character: "assassin", affinity: "water", label: "Passo das Mares", synth_field: "synth_assassin_espect_passo_mares", per_rank: 1.5, cost: 65,
         desc_flavor: "A forma eterea de nevoa perdura por mais tempo conferindo aceleracao aquatica pura.",
         desc_value: "A Dissipacao em Nevoa (X) dura +1.5s e concede +40% de velocidade de deslocamento.", icon_type: "boot"},
        {id: "assassin_espect_estocada_gelo_fino", character: "assassin", affinity: "water", label: "Estocada de Gelo Fino", synth_field: "synth_assassin_espect_estocada_gelo_fino", per_rank: 1.5, cost: 75,
         desc_flavor: "Golpear as costas de alvos desestabilizados pelo frio congela suas vertebras instantaneamente.",
         desc_value: "Golpear inimigos pelas costas enquanto lentos congela o alvo imediatamente por 1.5s.", icon_type: "crit"},
        {id: "assassin_espect_mare_ceifa", character: "assassin", affinity: "water", label: "Mare da Ceifa", synth_field: "synth_assassin_espect_mare_ceifa", per_rank: 1, cost: 80,
         desc_flavor: "Turbilhao giratorio de oito cortes consecutivos com laminas de agua afiada em 360.",
         desc_value: "Desfere uma sequencia de 8 cortes circulares rapidos fatiando tudo ao redor.", icon_type: "dagger"},

        // 3. LAMINA VULCANICA (ASSASSINO / FOGO - 8 TALENTOS)
        {id: "assassin_vulcan_corte_incandescente", character: "assassin", affinity: "fire", label: "Corte Incandescente", synth_field: "synth_assassin_vulcan_corte_incandescente", per_rank: 4, cost: 55,
         desc_flavor: "Laminas em brasa viva que cauterizam feridas abertas com chamas continuas.",
         desc_value: "Adagas em chamas incendeiam alvos causando queimadura continua por 3s.", icon_type: "burn"},
        {id: "assassin_vulcan_estalo_polvora", character: "assassin", affinity: "fire", label: "Estalo de Polvora", synth_field: "synth_assassin_vulcan_estalo_polvora", per_rank: 25, cost: 60,
         desc_flavor: "Estopim quimico na ponta do metal detonando uma explosao apos tres golpes no mesmo ponto.",
         desc_value: "O 3o ataque consecutivo no mesmo alvo detona uma explosao de 25 de dano.", icon_type: "fireball"},
        {id: "assassin_vulcan_passo_explosivo", character: "assassin", affinity: "fire", label: "Passo Explosivo", synth_field: "synth_assassin_vulcan_passo_explosivo", per_rank: 35, cost: 65,
         desc_flavor: "A bomba sufocante cospe estilhacos incandescentes em cone cegando agressores.",
         desc_value: "A Bomba de Cinzas (X) causa 35 de dano de fogo e arremessa fagulhas em cone.", icon_type: "fury"},
        {id: "assassin_vulcan_marca_enxofre", character: "assassin", affinity: "fire", label: "Marca do Enxofre", synth_field: "synth_assassin_vulcan_marca_enxofre", per_rank: 0.30, cost: 70,
         desc_flavor: "A fumaca sulfurosa enfraquece a musculatura e o impacto dos golpes das feras.",
         desc_value: "Inimigos queimados pelo assassino causam 30% a menos de dano contra ele.", icon_type: "burn"},
        {id: "assassin_vulcan_combustao_fatal", character: "assassin", affinity: "fire", label: "Combustao Fatal", synth_field: "synth_assassin_vulcan_combustao_fatal", per_rank: 1, cost: 75,
         desc_flavor: "Abates pelas costas provocam detonacoes em cadeia incendiando toda a horda vizinha.",
         desc_value: "Abater inimigos com ataques furtivos os faz explodir incendiando quem estiver perto.", icon_type: "fury"},
        {id: "assassin_vulcan_lamina_magma", character: "assassin", affinity: "fire", label: "Lamina de Magma", synth_field: "synth_assassin_vulcan_lamina_magma", per_rank: 1, cost: 70,
         desc_flavor: "O calor de lava funde as couracas transformando o dano cortante em dano igneo puro.",
         desc_value: "100% do dano das adagas se torna Dano Magico de Fogo ignorando defesas fisicas.", icon_type: "fireball"},
        {id: "assassin_vulcan_adrenalina_torrida", character: "assassin", affinity: "fire", label: "Adrenalina Torrida", synth_field: "synth_assassin_vulcan_adrenalina_torrida", per_rank: 0.04, cost: 65,
         desc_flavor: "A masmorra em chamas inflama o espirito do assassino com velocidade vertiginosa.",
         desc_value: "Cada inimigo em chamas na sala concede +4% de velocidade de movimento ao heroi.", icon_type: "haste"},
        {id: "assassin_vulcan_supernova_sombria", character: "assassin", affinity: "fire", label: "Supernova Sombria", synth_field: "synth_assassin_vulcan_supernova_sombria", per_rank: 1, cost: 85,
         desc_flavor: "Detonacao simultanea de todas as queimaduras da sala em uma sinfonia ensurdecedora.",
         desc_value: "Consome todas as queimaduras ativas na sala em dano explosivo imediato.", icon_type: "fireball"},

        // 4. ALGOZ DO TUFAO (ASSASSINO / VENTO - 8 TALENTOS)
        {id: "assassin_tufao_lamina_vacuo", character: "assassin", affinity: "wind", label: "Lamina de Vacuo", synth_field: "synth_assassin_tufao_lamina_vacuo", per_rank: 1.0, cost: 60,
         desc_flavor: "O talho veloz projeta lÃ¢minas de ar que dobram o alcance dos ataques corpo a corpo.",
         desc_value: "Cortes com adagas estendem ondas cortantes que dobram o alcance dos ataques basicos.", icon_type: "wind"},
        {id: "assassin_tufao_celeridade_fantasma", character: "assassin", affinity: "wind", label: "Celeridade Fantasma", synth_field: "synth_assassin_tufao_celeridade_fantasma", per_rank: 0.35, cost: 55,
         desc_flavor: "Bracos que se transformam em borroes de vento em uma sequencia de fatiamento vertiginosa.",
         desc_value: "+35% de velocidade de ataque base permanente com as adagas duplas.", icon_type: "haste"},
        {id: "assassin_tufao_passo_sombras", character: "assassin", affinity: "wind", label: "Passo das Sombras", synth_field: "synth_assassin_tufao_passo_sombras", per_rank: 1, cost: 65,
         desc_flavor: "Execucoes furtivas reciclam o impulso eolico para novo teletransporte imediato.",
         desc_value: "O Shadowstep (X) recarrega instantaneamente se o golpe das sombras abater o alvo.", icon_type: "boot"},
        {id: "assassin_tufao_esquiva_espectral", character: "assassin", affinity: "wind", label: "Esquiva Espectral", synth_field: "synth_assassin_tufao_esquiva_espectral", per_rank: 1, cost: 60,
         desc_flavor: "O golpe inimigo corta apenas o vento enquanto o heroi reaparece atras da vitima.",
         desc_value: "Esquivar com sucesso reposiciona o assassino instantaneamente nas costas do agressor.", icon_type: "dodge"},
        {id: "assassin_tufao_tornado_adagas", character: "assassin", affinity: "wind", label: "Tornado de Adagas", synth_field: "synth_assassin_tufao_tornado_adagas", per_rank: 1, cost: 75,
         desc_flavor: "Seis golpes velozes criam uma ventania que arremessa inimigos e lhes corta a carne.",
         desc_value: "Toda sequencia de 6 ataques lancao um vendaval cortante empurrando alvos a frente.", icon_type: "wind"},
        {id: "assassin_tufao_reflexos_celere", character: "assassin", affinity: "wind", label: "Reflexos Celere", synth_field: "synth_assassin_tufao_reflexos_celere", per_rank: 1, cost: 70,
         desc_flavor: "Afiacao de esgrima para partir flechas e feiticos no ar com o corte das facas.",
         desc_value: "Projeteis proximos podem ser destruidos ao serem atingidos por golpes de adaga.", icon_type: "riposte"},
        {id: "assassin_tufao_pressao_eolica", character: "assassin", affinity: "wind", label: "Pressao Eolica", synth_field: "synth_assassin_tufao_pressao_eolica", per_rank: 0.30, cost: 75,
         desc_flavor: "Ar comprimido nos olhos das feras reduzindo drasticamente sua capacidade de acerto.",
         desc_value: "Inimigos atingidos por cortes de vento sofrem 30% de reducao de precisao.", icon_type: "wind"},
        {id: "assassin_tufao_mil_cortes_invisiveis", character: "assassin", affinity: "wind", label: "Mil Cortes Invisiveis", synth_field: "synth_assassin_tufao_mil_cortes_invisiveis", per_rank: 1, cost: 80,
         desc_flavor: "Teletransporte instantaneo entre todos os alvos fatiando cada um em cortes fulminantes.",
         desc_value: "Teletransporta entre todos os inimigos da sala fatiando cada um 3 vezes em 0.5s.", icon_type: "dagger"},

        // 5. CARRASCO DE OBSIDIANA (ASSASSINO / TERRA - 8 TALENTOS)
        {id: "assassin_obsid_corte_obsidiana", character: "assassin", affinity: "earth", label: "Corte de Obsidiana", synth_field: "synth_assassin_obsid_corte_obsidiana", per_rank: 1, cost: 60,
         desc_flavor: "Laminas negras de vidro vulcanico que estilhacam as armaduras de chefes e elites.",
         desc_value: "Ataques basicos ignoram completamente a armadura fisica de elites e chefes.", icon_type: "rock"},
        {id: "assassin_obsid_veneno_petrificante", character: "assassin", affinity: "earth", label: "Veneno Petrificante", synth_field: "synth_assassin_obsid_veneno_petrificante", per_rank: 2.0, cost: 65,
         desc_flavor: "Toxinas minerais densas que endurecem os tecidos ate petrificar a carne em pedra pura.",
         desc_value: "Inimigos envenenados acumulam toxina ate ficarem petrificados por 2s.", icon_type: "poison"},
        {id: "assassin_obsid_pele_petrea", character: "assassin", affinity: "earth", label: "Pele Petrea", synth_field: "synth_assassin_obsid_pele_petrea", per_rank: 8, cost: 70,
         desc_flavor: "Placas de ardosia sob o couro negro garantindo solidez em combate corpo a corpo.",
         desc_value: "+8 de Defesa Fisica permanente; o assassino ganha grande resistencia a dano.", icon_type: "shield"},
        {id: "assassin_obsid_armadura_sismica", character: "assassin", affinity: "earth", label: "Armadura Sismica", synth_field: "synth_assassin_obsid_armadura_sismica", per_rank: 0.50, cost: 70,
         desc_flavor: "A Carapaca de Obsidiana devolve a forca dos impactos fisicos em estilhacos cortantes.",
         desc_value: "A Carapaca de Obsidiana (X) reflete 50% do dano corpo a corpo de volta ao agressor.", icon_type: "thorns"},
        {id: "assassin_obsid_fratura_ossea", character: "assassin", affinity: "earth", label: "Fratura Ossea", synth_field: "synth_assassin_obsid_fratura_ossea", per_rank: 0.25, cost: 75,
         desc_flavor: "Impactos contundentes nas juntas que quebram ossos e diminuem a forca das feras.",
         desc_value: "Criticos nas costas reduzem o poder de ataque do inimigo em 25% por 4s.", icon_type: "execute"},
        {id: "assassin_obsid_mercurio_liquido", character: "assassin", affinity: "earth", label: "Mercurio Liquido", synth_field: "synth_assassin_obsid_mercurio_liquido", per_rank: 0.20, cost: 70,
         desc_flavor: "Metais pesados liquefeitos aplicados nas feridas que prolongam a agonia e desaceleram.",
         desc_value: "Venenos duram o dobro do tempo e causam 20% de lentidao constante.", icon_type: "poison"},
        {id: "assassin_obsid_mina_basalto", character: "assassin", affinity: "earth", label: "Mina de Basalto", synth_field: "synth_assassin_obsid_mina_basalto", per_rank: 1, cost: 75,
         desc_flavor: "Sair da invisibilidade crava uma mina espinhosa que perfura quem pisar no local.",
         desc_value: "Sair da invisibilidade deixa para tras um cristal pontiagudo que perfura quem pisar.", icon_type: "rock"},
        {id: "assassin_obsid_golpe_tectonico", character: "assassin", affinity: "earth", label: "Golpe Tectonico", synth_field: "synth_assassin_obsid_golpe_tectonico", per_rank: 1, cost: 80,
         desc_flavor: "Ambas as adagas cravadas no chao abrindo fendas que engolem monstros adjacentes.",
         desc_value: "Crava adagas no solo gerando um terremoto curto que esmaga monstros ao redor.", icon_type: "shockwave"},

        // 6. LENDARIOS / SINERGIAS HIBRIDAS DO ASSASSINO (8 TALENTOS)
        {id: "assassin_lendario_danca_vapor_letal", character: "assassin", affinity: "hybrid", label: "Danca do Vapor Letal", synth_field: "synth_assassin_vapor_letal", per_rank: 1, cost: 100,
         desc_flavor: "Queimar alvos envenenados desprende gas fervente que dissolve armaduras no salao.",
         desc_value: "Queimar alvos envenenados gera vapor fervente corrosivo derretendo defesas na sala.", icon_type: "burn"},
        {id: "assassin_lendario_tempestade_cristal", character: "assassin", affinity: "hybrid", label: "Tempestade de Cristal", synth_field: "synth_assassin_tempestade_cristal", per_rank: 1, cost: 100,
         desc_flavor: "O choque do vento despedaca rochas de obsidiana em agulhas mortais em 360.",
         desc_value: "Golpes de vento quebram pedras de obsidiana espalhando estilhacos mortais em 360.", icon_type: "wind"},
        {id: "assassin_lendario_gelo_venenoso", character: "assassin", affinity: "hybrid", label: "Gelo Venenoso", synth_field: "synth_assassin_gelo_venenoso", per_rank: 1, cost: 110,
         desc_flavor: "Cristais verdes gelados onde toxinas agem em triplo sem despertar a vitima do gelo.",
         desc_value: "Monstros congelados sofrem dano de veneno 3x mais rapido sem descongelar.", icon_type: "poison"},
        {id: "assassin_lendario_lamina_plasma_igneo", character: "assassin", affinity: "hybrid", label: "Lamina de Plasma Igneo", synth_field: "synth_assassin_plasma_igneo", per_rank: 0.50, cost: 110,
         desc_flavor: "Relampagos dourados inflamam as adagas desatando uma tempestade de fatiamento continuo.",
         desc_value: "Criticos eletricos inflamam e aceleram a taxa de ataque em +50% por 3s.", icon_type: "fury"},
        {id: "assassin_lendario_sombra_suprema", character: "assassin", affinity: "legendary", label: "Sombra Suprema", synth_field: "synth_assassin_sombra_suprema", per_rank: 1, cost: 120,
         desc_flavor: "Imersao absoluta na escuridao duplicando velocidade e garantindo tres mortes limpas.",
         desc_value: "Invisibilidade dobra velocidade de corrida e garante 3 acertos criticos seguidos.", icon_type: "dodge"},
        {id: "assassin_lendario_ceifador_cosmico", character: "assassin", affinity: "legendary", label: "Ceifador Cosmico", synth_field: "synth_assassin_ceifador_cosmico", per_rank: 1, cost: 130,
         desc_flavor: "O exterminio perfeito concede uma fracao de segundo de intangibilidade estelar e cura.",
         desc_value: "Abater qualquer monstro restaura 10% de HP maximo e concede 1s de intangibilidade pura.", icon_type: "execute"},
        {id: "assassin_lendario_lamina_guilhotina", character: "assassin", affinity: "legendary", label: "Lamina da Guilhotina", synth_field: "synth_assassin_lamina_guilhotina", per_rank: 1, cost: 125,
         desc_flavor: "Golpe sumario na nuca que decapita presas severamente feridas sem piedade.",
         desc_value: "Se o alvo tiver menos de 15% de HP, o golpe nas costas elimina instantaneamente.", icon_type: "dagger"},
        {id: "assassin_lendario_eco_assassinos", character: "assassin", affinity: "legendary", label: "Eco dos Assassinos", synth_field: "synth_assassin_eco_assassinos", per_rank: 1, cost: 140,
         desc_flavor: "Uma sombra espectral gemea replica cada corte critico desferido pelo mestre.",
         desc_value: "Cada golpe critico conjura uma sombra clone que repete o mesmo golpe instantaneamente.", icon_type: "dagger"},

        // =========================================================================
        // TALENTOS GERAIS (BAUS DA RUN)
        // =========================================================================
        {id: "general_vigor", character: "general", label: "Vigor", synth_field: "synth_hp_reg", per_rank: 2, cost: 0,
         desc_flavor: "Vitalidade organica que eleva a velocidade natural de recuperacao do corpo.",
         desc_value: "+2 de Regeneracao de Vida por segundo por rank.", icon_type: "regen"},
        {id: "general_fortuna", character: "general", label: "Fortuna", synth_field: "synth_gold_bonus", per_rank: 0.15, cost: 0,
         desc_flavor: "Afinidade com riquezas que multiplica o ouro encontrado na jornada.",
         desc_value: "+15% de Ouro recebido adicional por rank.", icon_type: "gold"},
        {id: "general_reflexos", character: "general", label: "Reflexos", synth_field: "synth_dodge", per_rank: 0.025, cost: 0,
         desc_flavor: "Instinto apurado permitindo esquivar de ataques repentinos.",
         desc_value: "+2.5% de Chance de Esquiva total por rank.", icon_type: "dodge"},
        {id: "general_folego_extra", character: "general", label: "Folego Extra", synth_field: "synth_second_wind", per_rank: 1, cost: 0,
         desc_flavor: "Ao beirar a derrota, o heroi ganha uma sobrevida emergencial com vida restaurada.",
         desc_value: "+1 Carga de Segundo Folego (ressuscita imediatamente ao cair).", icon_type: "second_wind"},
        {id: "general_impeto", character: "general", label: "Impeto", synth_field: "synth_cdr", per_rank: 0.03, cost: 0,
         desc_flavor: "Ritmo marcial intenso que resfria habilidades e especiais mais depressa.",
         desc_value: "+3% de Reducao de Tempo de Recarga (CDR) por rank.", icon_type: "cdr"},
        {id: "general_presteza", character: "general", label: "Presteza", synth_field: "synth_atk_spd_bonus", per_rank: 0.08, cost: 0,
         desc_flavor: "Manuseio mais veloz de qualquer arma empunhada.",
         desc_value: "+8% de Velocidade de Ataque por rank.", icon_type: "haste"},
        {id: "general_precisao", character: "general", label: "Precisao", synth_field: "synth_crit_chance", per_rank: 0.05, cost: 0,
         desc_flavor: "Olhar clinico para encontrar falhas na postura inimiga e acertar pontos vitais.",
         desc_value: "+5% de Chance de Golpe Critico por rank.", icon_type: "crit"},
        {id: "general_essencia", character: "general", label: "Essencia Arcana", synth_field: "synth_pwr_magica", per_rank: 3, cost: 0,
         desc_flavor: "Canalizacao pura de forca arcana primordial ampliando magias.",
         desc_value: "+3 de Poder Magico por rank.", icon_type: "fireball"},
        {id: "general_aura", character: "general", label: "Aura Protetora", synth_field: "synth_def_magica", per_rank: 3, cost: 0,
         desc_flavor: "Campo protetor etereo contra feiticos e elementos hostis.",
         desc_value: "+3 de Defesa Magica por rank.", icon_type: "magic_def"},
        {id: "general_forca", character: "general", label: "Forca Bruta", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0,
         desc_flavor: "Aumento de musculatura e peso do impacto em combate direto.",
         desc_value: "+3 de Poder Fisico por rank.", icon_type: "sword"}
    ];
}

function element_get_name(_elem) {
    switch (_elem) {
        case "water": return "Agua";
        case "fire": return "Fogo";
        case "wind": return "Ar";
        case "earth": return "Terra";
        default: return "Neutro";
    }
}

function element_get_boss_name(_elem) {
    switch (_elem) {
        case "water": return "General Glacial (Sala 2)";
        case "fire":  return "General Magma (Sala 4)";
        case "wind":  return "General Zephyrus (Sala 6)";
        case "earth": return "Tita Monolito (Sala 8)";
        default:      return "";
    }
}

function element_get_unlock_requirement(_elem) {
    switch (_elem) {
        case "water": return "Derrote o General Glacial (Chefe da Sala 2)";
        case "fire":  return "Derrote o General Magma (Chefe da Sala 4)";
        case "wind":  return "Derrote o General Zephyrus (Chefe da Sala 6)";
        case "earth": return "Derrote o Tita Monolito (Chefe Supremo da Sala 8)";
        default:      return "";
    }
}

function class_get_archetype_name(_class, _elem) {
    switch (_class) {
        case "knight":
            switch (_elem) {
                case "water": return "Paladino";
                case "fire": return "Berserker";
                case "wind": return "Duelista";
                case "earth": return "Guardiao";
                default: return "Cavaleiro";
            }
        case "mage":
            switch (_elem) {
                case "water": return "Criomante";
                case "fire": return "Piromante";
                case "wind": return "Aeromante";
                case "earth": return "Geomante";
                default: return "Arcano";
            }
        case "archer":
            switch (_elem) {
                case "water": return "Cacador das Mares";
                case "fire": return "Balistico Infernal";
                case "wind": return "Mestre do Vendaval";
                case "earth": return "Balista da Terra";
                default: return "Arqueiro";
            }
        case "assassin":
            switch (_elem) {
                case "water": return "Lamina Espectral";
                case "fire": return "Lamina Vulcanica";
                case "wind": return "Algoz do Tufao";
                case "earth": return "Carrasco de Obsidiana";
                default: return "Assassino";
            }
        default:
            return "Heroi";
    }
}

function class_get_archetype_desc(_class, _elem) {
    switch (_class) {
        case "knight":
            switch (_elem) {
                case "water": return "Paladino: Especial gera Aura de Sobrevida em area que cura/protege.";
                case "fire": return "Berserker: Ataque amplo devastador. Especial entra em Furia Ardente (+50% dano/+regen).";
                case "wind": return "Duelista: Ataque duplo veloz em combo. Especial e Aparar (Parry com contra-ataque de 360).";
                case "earth": return "Guardiao: Ataque concentrado. Especial Bastiao bloqueia 100% dano fisico e magico + Taunt.";
                default: return "Cavaleiro: Espada de medio alcance e escudo com bloqueio fisico tradicional.";
            }
        case "mage":
            switch (_elem) {
                case "water": return "Criomante: Magias de gelo que desaceleram e congelam. Especial Prisao Glacial cria redoma defensiva.";
                case "fire": return "Piromante: Conjuracoes igneas devastadoras. Especial Ponto de Ignicao detona calor em 360 e incendeia o chao.";
                case "wind": return "Aeromante: Projeteis velozes e eletricos. Especial Distorcao Voltaica (Blink) teletransporta com arco eletrico.";
                case "earth": return "Geomante: Dano basaltico com alto impacto. Especial Monolito Basaltico ergue pilar que atrai inimigos.";
                default: return "Arcano: Projeteis de energia arcana e Manashield para absorcao de dano magico.";
            }
        case "archer":
            switch (_elem) {
                case "water": return "Cacador das Mares: Flechas de gelo e orvalho. Especial Cambalhota de Nevoa cega e confunde agressores.";
                case "fire": return "Balistico Infernal: Tiros de polvora e fogo. Especial Tiro de Recuo Igneo salta para tras incendiando a area.";
                case "wind": return "Mestre do Vendaval: Flechas supersonicas em leque. Especial Esquiva Ciclonica rola atirando 3 flechas guiadas.";
                case "earth": return "Balista da Terra: Tiros pesados de impacto. Especial Fixacao de Ancora enraiza no chao para +60% dano e perfuracao.";
                default: return "Arqueiro: Disparos de flechas fisicas velozes a longa distancia e rolamento evasivo.";
            }
        case "assassin":
            switch (_elem) {
                case "water": return "Lamina Espectral: Furtividade fluida e roubo de vida. Especial Dissipacao em Nevoa atravessa corpos e regenera vida.";
                case "fire": return "Lamina Vulcanica: Adagas igneas e explosoes a cada golpe. Especial Bomba de Cinzas cega e queima em area.";
                case "wind": return "Algoz do Tufao: Cortes de ar em hipervelocidade. Especial Salto das Sombras teletransporta atras do alvo com estocada.";
                case "earth": return "Carrasco de Obsidiana: Veneno petrificante e alta resistencia. Especial Carapaca de Obsidiana reduz 80% do dano.";
                default: return "Assassino: Adagas duplas velozes com alto dano critico e furtividade temporaria.";
            }
        default:
            return "";
    }
}

function knight_get_archetype_name(_elem) {
    return class_get_archetype_name("knight", _elem);
}

function knight_get_archetype_desc(_elem) {
    return class_get_archetype_desc("knight", _elem);
}

function get_talents_for_character(_character) {
    var _all = get_talent_defs();
    var _out = [];
    for (var i = 0; i < array_length(_all); i++) {
        if (_all[i].character == _character) array_push(_out, _all[i]);
    }
    return _out;
}

function get_talents_for_character_and_affinity(_character, _affinity) {
    var _all = get_talents_for_character(_character);
    var _out = [];
    for (var i = 0; i < array_length(_all); i++) {
        var _t = _all[i];
        var _aff = variable_struct_exists(_t, "affinity") ? _t.affinity : "none";
        if (_aff == "none" || _aff == "legendary" || _aff == "hybrid" || _aff == _affinity) {
            array_push(_out, _t);
        }
    }
    return _out;
}

function knight_get_talents_for_affinity(_affinity) {
    return get_talents_for_character_and_affinity("knight", _affinity);
}

function player_has_talent(_p, _id) {
    if (_p == noone || !instance_exists(_p)) return false;
    for (var i = 0; i < array_length(_p.talent_slot_ids); i++) {
        if (_p.talent_slot_ids[i] == _id && _p.talent_slot_ranks[i] > 0) return true;
    }
    return false;
}

function player_get_talent_rank(_p, _id) {
    if (_p == noone || !instance_exists(_p)) return 0;
    for (var i = 0; i < array_length(_p.talent_slot_ids); i++) {
        if (_p.talent_slot_ids[i] == _id) return _p.talent_slot_ranks[i];
    }
    return 0;
}

function get_general_talent_defs() {
    return get_talents_for_character("general");
}

function get_talent_def_by_id(_id) {
    // Compatibilidade com saves e IDs legados anteriores
    if (_id == "knight_paladino_golpe_sagrado") _id = "knight_paladino_golpe_nascente";
    if (_id == "knight_berserk_furia") _id = "knight_berserk_frenesi_ardente";
    if (_id == "knight_paladino_aura") _id = "knight_paladino_bencao_mare";
    if (_id == "knight_guardian_provocacao") _id = "knight_guardiao_provocacao_esmagadora";
    if (_id == "knight_duelist_riposte") _id = "knight_duelista_riposte_perfeito";
    if (_id == "knight_fundamental_postura") _id = "knight_postura_firme";
    if (_id == "knight_duelist_speed") _id = "knight_duelista_passo_eolico";
    if (_id == "knight_guardian_fortaleza") _id = "knight_guardiao_fortaleza_viva";

    if (_id == "archer_pwr_fisica") _id = "archer_ponto_cego";
    if (_id == "archer_mira_precisa") _id = "archer_tiro_concentrado";
    if (_id == "archer_fluxo_flechas") _id = "archer_aljava_leve";
    if (_id == "archer_passo_leve") _id = "archer_tiro_em_corrida";
    if (_id == "archer_flechas_perfurantes") _id = "archer_perfuracao_reta";
    if (_id == "archer_instinto_cacador") _id = "archer_pontas_farpadas";

    if (_id == "mage_couraca_magica") _id = "mage_protecao_mana_reativa";
    if (_id == "mage_fluxo_arcano") _id = "mage_canalizacao_fluida";
    if (_id == "mage_vigor_arcano") _id = "mage_sifao_alma";
    if (_id == "mage_sobrecarga") _id = "mage_sobrecarga_feitico";
    if (_id == "mage_explosao_perfurante") _id = "mage_condensacao_arcana";

    if (_id == "assassin_move_spd") _id = "assassin_passo_silencioso";
    if (_id == "assassin_instinto_assassino") _id = "assassin_execucao_fria";
    if (_id == "assassin_reflexos_sombrios") _id = "assassin_esquiva_reflexa";
    if (_id == "assassin_laminas_envenenadas") _id = "assassin_adaga_envenenada";
    if (_id == "assassin_vampirismo_sombrio") _id = "assassin_frenesi_sangue";
    if (_id == "assassin_sombra_mortal") _id = "assassin_golpe_jugular";

    var _all = get_talent_defs();
    for (var i = 0; i < array_length(_all); i++) {
        if (_all[i].id == _id) return _all[i];
    }
    return undefined;
}

function ensure_meta_loaded() {
    if (!variable_global_exists("gold")) load_meta_from_disk();
}

function talent_is_unlocked(_id) {
    if (variable_global_exists("dev_mode") && global.dev_mode) return true;
    ensure_meta_loaded();
    var _def = get_talent_def_by_id(_id);
    if (is_undefined(_def)) return false;
    if (_def.cost <= 0) return true;
    return variable_struct_exists(global.meta_unlocked, _id);
}

function element_is_unlocked(_elem) {
    if (_elem == "none") return true;
    if (variable_global_exists("dev_mode") && global.dev_mode) return true;
    ensure_meta_loaded();
    if (variable_global_exists("meta_elements") && is_struct(global.meta_elements) && variable_struct_exists(global.meta_elements, _elem)) {
        return global.meta_elements[$ _elem] == true;
    }
    return false; // Bloqueado por padrão até derrotar o chefe correspondente
}

function element_unlock(_elem) {
    ensure_meta_loaded();
    if (!variable_global_exists("meta_elements") || !is_struct(global.meta_elements)) {
        global.meta_elements = {water: false, fire: false, wind: false, earth: false};
    }
    global.meta_elements[$ _elem] = true;
    save_meta();
}

function load_meta_from_disk() {
    global.meta_unlocked = {};
    global.gold = 0;
    global.meta_elements = {water: false, fire: false, wind: false, earth: false};
    global.meta_mastery = {};
    if (!variable_global_exists("dev_mode")) global.dev_mode = false;

    if (!file_exists("meta.json")) return;

    var _buf = buffer_load("meta.json");
    if (_buf == -1) return;
    var _str = buffer_read(_buf, buffer_string);
    buffer_delete(_buf);

    if (_str == "") return;
    var _data = json_parse(_str);
    if (is_struct(_data)) {
        if (variable_struct_exists(_data, "gold")) global.gold = _data.gold;
        if (variable_struct_exists(_data, "unlocked") && is_struct(_data.unlocked)) {
            global.meta_unlocked = _data.unlocked;
        }
        if (variable_struct_exists(_data, "elements") && is_struct(_data.elements)) {
            global.meta_elements = _data.elements;
            if (!variable_struct_exists(global.meta_elements, "water")) global.meta_elements.water = false;
            if (!variable_struct_exists(global.meta_elements, "fire")) global.meta_elements.fire = false;
            if (!variable_struct_exists(global.meta_elements, "wind")) global.meta_elements.wind = false;
            if (!variable_struct_exists(global.meta_elements, "earth")) global.meta_elements.earth = false;
        }
        if (variable_struct_exists(_data, "mastery") && is_struct(_data.mastery)) {
            global.meta_mastery = _data.mastery;
        }
        if (variable_struct_exists(_data, "dev_mode")) {
            global.dev_mode = _data.dev_mode;
        }
    }
}

function save_meta() {
    var _data = {
        gold: global.gold,
        unlocked: global.meta_unlocked,
        elements: variable_global_exists("meta_elements") ? global.meta_elements : {water: false, fire: false, wind: false, earth: false},
        mastery: variable_global_exists("meta_mastery") ? global.meta_mastery : {},
        dev_mode: variable_global_exists("dev_mode") ? global.dev_mode : false
    };
    var _str = json_stringify(_data);
    var _buf = buffer_create(string_byte_length(_str) + 1, buffer_fixed, 1);
    buffer_write(_buf, buffer_string, _str);
    buffer_save(_buf, "meta.json");
    buffer_delete(_buf);
}

function mastery_unlock(_class, _element) {
    ensure_meta_loaded();
    if (!variable_global_exists("meta_mastery") || !is_struct(global.meta_mastery)) global.meta_mastery = {};
    if (!variable_struct_exists(global.meta_mastery, _class)) global.meta_mastery[$ _class] = {};
    global.meta_mastery[$ _class][$ _element] = true;
    save_meta();
}

function get_mastery_gold_multiplier() {
    ensure_meta_loaded();
    if (!variable_global_exists("meta_mastery") || !is_struct(global.meta_mastery)) return 1.0;
    var _count = 0;
    var _classes = variable_struct_get_names(global.meta_mastery);
    for (var _c = 0; _c < array_length(_classes); _c++) {
        var _cname = _classes[_c];
        var _elems = global.meta_mastery[$ _cname];
        if (is_struct(_elems)) {
            var _enames = variable_struct_get_names(_elems);
            for (var _e = 0; _e < array_length(_enames); _e++) {
                if (_elems[$ _enames[_e]]) _count++;
            }
        }
    }
    return 1.0 + (_count * 0.05);
}

function talent_purchase(_id) {
    ensure_meta_loaded();
    var _def = get_talent_def_by_id(_id);
    if (is_undefined(_def)) return false;
    if (_def.cost <= 0) return true;
    if (talent_is_unlocked(_id)) return true;

    // Se o elemento estiver bloqueado na campanha normal, impede a compra
    if (_def.affinity != "none" && !element_is_unlocked(_def.affinity)) return false;

    if (global.gold < _def.cost) return false;

    global.gold -= _def.cost;
    global.meta_unlocked[$ _id] = true;
    save_meta();
    return true;
}

function meta_earn_gold(_amount) {
    ensure_meta_loaded();
    var _gained = round(_amount);
    if (_gained <= 0) return;
    global.gold += _gained;
    save_meta();
}

// Rebuilds every synth_* field from scratch based on the chosen talent slots and their
// current in-run rank. Call after any rank change, before player_recompute_attributes.
function player_recompute_synthetics(_p) {
    // ---- Bases universais ----
    _p.synth_hp_reg = 0;
    _p.synth_crit_chance = 0;
    _p.synth_cdr = 0;
    _p.synth_dodge = 0;
    _p.synth_armor_hp = 0;
    _p.synth_pwr_fisica = 0;
    _p.synth_pwr_magica = 0;
    _p.synth_def_fisica = 0;
    _p.synth_def_magica = 0;
    _p.synth_atk_spd_bonus = 0;
    _p.synth_move_spd_bonus = 0;
    _p.synth_lifesteal = 0;
    _p.synth_thorns_dmg = 0;
    _p.synth_block_reduction = 0;
    _p.synth_pierce_count = 0;
    _p.synth_execute_bonus = 0;
    _p.synth_poison_on_hit = 0;
    _p.synth_gold_bonus = 0;
    _p.synth_second_wind = 0;

    // ---- Cavaleiro (Knight) ----
    _p.synth_postura_firme = 0;
    _p.synth_lamina_afiada = 0;
    _p.synth_golpe_pesado = 0;
    _p.synth_escudo_choque = 0;
    _p.synth_segundo_folego = 0;
    _p.synth_muralha_movel = 0;
    _p.synth_aco_temperado = 0;
    _p.synth_fio_carrasco = 0;
    _p.synth_reflexo_blindado = 0;
    _p.synth_vontade_indomavel = 0;

    _p.synth_paladino_bencao_mare = 0;
    _p.synth_paladino_bastiao_liquido = 0;
    _p.synth_paladino_gota_purificadora = 0;
    _p.synth_paladino_correnteza_dilacerante = 0;
    _p.synth_paladino_golpe_nascente = 0;
    _p.synth_paladino_escudo_espelhado = 0;
    _p.synth_paladino_graca_abencoada = 0;
    _p.synth_paladino_julgamento_sereno = 0;

    _p.synth_berserk_arco_incendiario = 0;
    _p.synth_berserk_frenesi_ardente = 0;
    _p.synth_berserk_combustao_espontanea = 0;
    _p.synth_berserk_sede_sangue = 0;
    _p.synth_berserk_cinzas_sacrificio = 0;
    _p.synth_berserk_lamina_brasa = 0;
    _p.synth_berserk_vinganca_flamejante = 0;
    _p.synth_berserk_furia_imortal = 0;

    _p.synth_duelista_riposte_perfeito = 0;
    _p.synth_duelista_passo_eolico = 0;
    _p.synth_duelista_combo_vendaval = 0;
    _p.synth_duelista_danca_laminas = 0;
    _p.synth_duelista_aparar_cadeia = 0;
    _p.synth_duelista_vacuo_cortante = 0;
    _p.synth_duelista_reflexos_celere = 0;
    _p.synth_duelista_estocada_fulminante = 0;

    _p.synth_guardiao_muralha_sismica = 0;
    _p.synth_guardiao_provocacao_esmagadora = 0;
    _p.synth_guardiao_carapaca_granito = 0;
    _p.synth_guardiao_retaliacao_sismica = 0;
    _p.synth_guardiao_fissura_telurica = 0;
    _p.synth_guardiao_bastiao_inabalavel = 0;
    _p.synth_guardiao_peso_esmagador = 0;
    _p.synth_guardiao_fortaleza_viva = 0;

    _p.synth_lendario_vapor_sagrado = 0;
    _p.synth_lendario_tempestade_poeira = 0;
    _p.synth_lendario_gelo_fendido = 0;
    _p.synth_lendario_tempestade_ignea = 0;
    _p.synth_lendario_avatar_elemental = 0;
    _p.synth_lendario_cavaleiro_apocalipse = 0;
    _p.synth_lendario_escudo_titanico = 0;
    _p.synth_lendario_eco_ancestrais = 0;

    // ---- Mago (Mage) ----
    _p.synth_mage_canalizacao_fluida = 0;
    _p.synth_mage_mente_cristalina = 0;
    _p.synth_mage_eco_magico = 0;
    _p.synth_mage_protecao_mana_reativa = 0;
    _p.synth_mage_sobrecarga_feitico = 0;
    _p.synth_mage_condensacao_arcana = 0;
    _p.synth_mage_sifao_alma = 0;
    _p.synth_mage_fluxo_conduzido = 0;
    _p.synth_mage_ressonancia_foco = 0;
    _p.synth_mage_conhecimento_ancestral = 0;

    _p.synth_crio_geada_penetrante = 0;
    _p.synth_crio_pico_glacial = 0;
    _p.synth_crio_armadura_gelo_negro = 0;
    _p.synth_crio_onda_torrencial = 0;
    _p.synth_crio_prisao_criogenica = 0;
    _p.synth_crio_orvalho_restaurador = 0;
    _p.synth_crio_lanca_zero_absoluto = 0;
    _p.synth_crio_coracao_geada = 0;

    _p.synth_piro_centelha_incandescente = 0;
    _p.synth_piro_meteoro_menor = 0;
    _p.synth_piro_rastro_flamejante = 0;
    _p.synth_piro_inferno_expansivo = 0;
    _p.synth_piro_ponto_fusao = 0;
    _p.synth_piro_conflagracao_furiosa = 0;
    _p.synth_piro_sopro_dragao = 0;
    _p.synth_piro_fenix_imortal = 0;

    _p.synth_aero_arco_eletrico = 0;
    _p.synth_aero_passo_cefiro = 0;
    _p.synth_aero_sobrecarga_estatica = 0;
    _p.synth_aero_tufao_repulsor = 0;
    _p.synth_aero_salto_tempestuoso = 0;
    _p.synth_aero_vortice_cortante = 0;
    _p.synth_aero_condutividade_letal = 0;
    _p.synth_aero_olho_furacao = 0;

    _p.synth_geo_projetil_rochoso = 0;
    _p.synth_geo_armadura_granito = 0;
    _p.synth_geo_tremer_terra = 0;
    _p.synth_geo_monolito_esmagador = 0;
    _p.synth_geo_espinhos_teluricos = 0;
    _p.synth_geo_coracao_areia = 0;
    _p.synth_geo_poco_gravitacional = 0;
    _p.synth_geo_estilhaco_basalto = 0;

    _p.synth_mage_vapor_fulminante = 0;
    _p.synth_mage_tempestade_areia = 0;
    _p.synth_mage_gelo_fendido = 0;
    _p.synth_mage_tempestade_plasma = 0;
    _p.synth_mage_avatar_arcano = 0;
    _p.synth_mage_singularidade_dimensional = 0;
    _p.synth_mage_chuva_cometas = 0;
    _p.synth_mage_conjurador_supremo = 0;

    // ---- Arqueiro (Archer) ----
    _p.synth_archer_tiro_em_corrida = 0;
    _p.synth_archer_ponto_cego = 0;
    _p.synth_archer_perfuracao_reta = 0;
    _p.synth_archer_aljava_leve = 0;
    _p.synth_archer_pontas_farpadas = 0;
    _p.synth_archer_recuo_emergencia = 0;
    _p.synth_archer_reflexo_cacador = 0;
    _p.synth_archer_flecha_pesada = 0;
    _p.synth_archer_tiro_concentrado = 0;
    _p.synth_archer_saque_rapido = 0;

    _p.synth_archer_glacial_flecha_estalactite = 0;
    _p.synth_archer_glacial_pista_escorregadia = 0;
    _p.synth_archer_glacial_chuva_torrencial = 0;
    _p.synth_archer_glacial_flecha_arpao = 0;
    _p.synth_archer_glacial_brisa_curativa = 0;
    _p.synth_archer_glacial_nevoa_ilusoria = 0;
    _p.synth_archer_glacial_perfurador_glacial = 0;
    _p.synth_archer_glacial_tiro_maelstrom = 0;

    _p.synth_archer_balist_flecha_incendiaria = 0;
    _p.synth_archer_balist_detonacao_parede = 0;
    _p.synth_archer_balist_tiro_fragmentacao = 0;
    _p.synth_archer_balist_marca_purgatorio = 0;
    _p.synth_archer_balist_propulsao_ardente = 0;
    _p.synth_archer_balist_polvora_concentrada = 0;
    _p.synth_archer_balist_balista_piromante = 0;
    _p.synth_archer_balist_fenix_cacadora = 0;

    _p.synth_archer_venda_disparo_leque = 0;
    _p.synth_archer_venda_flecha_teleguiada = 0;
    _p.synth_archer_venda_tiro_supersonico = 0;
    _p.synth_archer_venda_rolamento_furacao = 0;
    _p.synth_archer_venda_danca_ventos = 0;
    _p.synth_archer_venda_corte_tufao = 0;
    _p.synth_archer_venda_passo_etereo = 0;
    _p.synth_archer_venda_tempestade_mil_tiros = 0;

    _p.synth_archer_terra_flecha_arpao_pedra = 0;
    _p.synth_archer_terra_tremores_impacto = 0;
    _p.synth_archer_terra_flecha_enraizadora = 0;
    _p.synth_archer_terra_postura_fortaleza = 0;
    _p.synth_archer_terra_balista_obsidiana = 0;
    _p.synth_archer_terra_raizes_sanguineas = 0;
    _p.synth_archer_terra_estacas_defensivas = 0;
    _p.synth_archer_terra_tiro_cataclismico = 0;

    _p.synth_archer_aurora_glacial = 0;
    _p.synth_archer_tempestade_ignea = 0;
    _p.synth_archer_lodo_acido = 0;
    _p.synth_archer_projetil_meteorico = 0;
    _p.synth_archer_falcao_cosmico = 0;
    _p.synth_archer_atirador_fantasma = 0;
    _p.synth_archer_saraivada_eterna = 0;
    _p.synth_archer_flecha_julgamento = 0;

    // ---- Assassino (Assassin) ----
    _p.synth_assassin_golpe_jugular = 0;
    _p.synth_assassin_passo_silencioso = 0;
    _p.synth_assassin_laminas_gemeas = 0;
    _p.synth_assassin_adaga_envenenada = 0;
    _p.synth_assassin_saque_rapido_letal = 0;
    _p.synth_assassin_esquiva_reflexa = 0;
    _p.synth_assassin_frenesi_sangue = 0;
    _p.synth_assassin_execucao_fria = 0;
    _p.synth_assassin_emboscada_perfeita = 0;
    _p.synth_assassin_presteza_sombria = 0;

    _p.synth_assassin_espect_corte_fluido = 0;
    _p.synth_assassin_espect_gota_hemofagica = 0;
    _p.synth_assassin_espect_nevoa_ilusoria = 0;
    _p.synth_assassin_espect_adaga_criogenica = 0;
    _p.synth_assassin_espect_afogamento_sombrio = 0;
    _p.synth_assassin_espect_passo_mares = 0;
    _p.synth_assassin_espect_estocada_gelo_fino = 0;
    _p.synth_assassin_espect_mare_ceifa = 0;

    _p.synth_assassin_vulcan_corte_incandescente = 0;
    _p.synth_assassin_vulcan_estalo_polvora = 0;
    _p.synth_assassin_vulcan_passo_explosivo = 0;
    _p.synth_assassin_vulcan_marca_enxofre = 0;
    _p.synth_assassin_vulcan_combustao_fatal = 0;
    _p.synth_assassin_vulcan_lamina_magma = 0;
    _p.synth_assassin_vulcan_adrenalina_torrida = 0;
    _p.synth_assassin_vulcan_supernova_sombria = 0;

    _p.synth_assassin_tufao_lamina_vacuo = 0;
    _p.synth_assassin_tufao_celeridade_fantasma = 0;
    _p.synth_assassin_tufao_passo_sombras = 0;
    _p.synth_assassin_tufao_esquiva_espectral = 0;
    _p.synth_assassin_tufao_tornado_adagas = 0;
    _p.synth_assassin_tufao_reflexos_celere = 0;
    _p.synth_assassin_tufao_pressao_eolica = 0;
    _p.synth_assassin_tufao_mil_cortes_invisiveis = 0;

    _p.synth_assassin_obsid_corte_obsidiana = 0;
    _p.synth_assassin_obsid_veneno_petrificante = 0;
    _p.synth_assassin_obsid_pele_petrea = 0;
    _p.synth_assassin_obsid_armadura_sismica = 0;
    _p.synth_assassin_obsid_fratura_ossea = 0;
    _p.synth_assassin_obsid_mercurio_liquido = 0;
    _p.synth_assassin_obsid_mina_basalto = 0;
    _p.synth_assassin_obsid_golpe_tectonico = 0;

    _p.synth_assassin_vapor_letal = 0;
    _p.synth_assassin_tempestade_cristal = 0;
    _p.synth_assassin_gelo_venenoso = 0;
    _p.synth_assassin_plasma_igneo = 0;
    _p.synth_assassin_sombra_suprema = 0;
    _p.synth_assassin_ceifador_cosmico = 0;
    _p.synth_assassin_lamina_guilhotina = 0;
    _p.synth_assassin_eco_assassinos = 0;

    for (var i = 0; i < array_length(_p.talent_slot_ids); i++) {
        var _id = _p.talent_slot_ids[i];
        if (_id == "") continue;
        var _rank = _p.talent_slot_ranks[i];
        if (_rank <= 0) continue;

        var _def = get_talent_def_by_id(_id);
        if (is_undefined(_def)) continue;

        var _field = _def.synth_field;
        var _curr = variable_instance_exists(_p, _field) ? variable_instance_get(_p, _field) : 0;
        variable_instance_set(_p, _field, _curr + _def.per_rank * _rank);
    }

    // Atributos derivados diretos do Cavaleiro
    if (_p.synth_fio_carrasco > 0) _p.synth_execute_bonus += _p.synth_fio_carrasco;
    if (_p.synth_duelista_reflexos_celere > 0) _p.synth_dodge += _p.synth_duelista_reflexos_celere;
    if (_p.synth_guardiao_carapaca_granito > 0) _p.synth_def_fisica += _p.synth_guardiao_carapaca_granito;
    if (_p.synth_paladino_bencao_mare > 0) _p.synth_hp_reg += _p.synth_paladino_bencao_mare;
    if (_p.synth_aco_temperado > 0) {
        var _gold = variable_global_exists("gold") ? global.gold : 0;
        _p.synth_def_fisica += min(8, floor(_gold / 100) * _p.synth_aco_temperado);
    }

    // Atributos derivados diretos do Mago
    if (_p.synth_mage_conhecimento_ancestral > 0) _p.synth_pwr_magica += _p.synth_mage_conhecimento_ancestral;
    if (_p.synth_geo_armadura_granito > 0) _p.synth_def_fisica += _p.synth_geo_armadura_granito;
    if (_p.synth_aero_passo_cefiro > 0) _p.synth_move_spd_bonus += _p.move_speed * _p.synth_aero_passo_cefiro;
    if (_p.synth_aero_olho_furacao > 0) _p.synth_dodge += _p.synth_aero_olho_furacao;
    if (_p.synth_mage_avatar_arcano > 0) _p.synth_pwr_magica += _p.nat_power * _p.synth_mage_avatar_arcano;

    // Atributos derivados diretos do Arqueiro
    if (_p.synth_archer_aljava_leve > 0) _p.synth_atk_spd_bonus += _p.synth_archer_aljava_leve;
    if (_p.synth_archer_perfuracao_reta > 0) _p.synth_pierce_count += _p.synth_archer_perfuracao_reta;
    if (_p.synth_archer_terra_postura_fortaleza > 0) _p.synth_def_fisica += _p.synth_archer_terra_postura_fortaleza;
    if (_p.synth_archer_venda_passo_etereo > 0) _p.synth_dodge += _p.synth_archer_venda_passo_etereo;

    // Atributos derivados diretos do Assassino
    if (_p.synth_assassin_passo_silencioso > 0) _p.synth_move_spd_bonus += _p.synth_assassin_passo_silencioso;
    if (_p.synth_assassin_esquiva_reflexa > 0) _p.synth_dodge += _p.synth_assassin_esquiva_reflexa;
    if (_p.synth_assassin_execucao_fria > 0) _p.synth_execute_bonus += _p.synth_assassin_execucao_fria;
    if (_p.synth_assassin_obsid_pele_petrea > 0) _p.synth_def_fisica += _p.synth_assassin_obsid_pele_petrea;
    if (_p.synth_assassin_tufao_celeridade_fantasma > 0) _p.synth_atk_spd_bonus += _p.synth_assassin_tufao_celeridade_fantasma;
}

function player_apply_talent_point(_p, _slot_index) {
    if (_p.talent_pending_points <= 0) return;
    if (_slot_index < 0 || _slot_index >= array_length(_p.talent_slot_ids)) return;
    if (_p.talent_slot_ids[_slot_index] == "") return;

    _p.talent_slot_ranks[_slot_index] += 1;
    _p.talent_pending_points -= 1;

    player_recompute_synthetics(_p);
    player_recompute_attributes(_p);
}

// ---- Chests: found during a run, grant one random general talent. The player picks
// which of their 3 slots to put it in (discarding that slot's current rank), or skips.
function roll_chest_talent() {
    var _pool = [];
    var _gens = get_general_talent_defs();
    for (var _i = 0; _i < array_length(_gens); _i++) {
        array_push(_pool, _gens[_i].id);
    }

    ensure_meta_loaded();
    var _p_class = variable_global_exists("selected_character") ? global.selected_character : "knight";
    var _class_defs = get_class_talent_defs(_p_class);

    for (var _j = 0; _j < array_length(_class_defs); _j++) {
        var _t = _class_defs[_j];
        if (talent_is_unlocked(_t.id)) {
            array_push(_pool, _t.id);
        }
    }

    if (array_length(_pool) == 0) return "";
    var _idx = irandom(array_length(_pool) - 1);
    return _pool[_idx];
}

function open_chest_reward(_talent_id) {
    global.chest_reward_talent_id = _talent_id;
    global.chest_reward_open = true;
}

function equip_chest_talent(_p, _slot_index) {
    if (!global.chest_reward_open) return;
    if (_slot_index < 0 || _slot_index >= array_length(_p.talent_slot_ids)) return;

    // Rank belongs to the slot, not to whichever talent currently occupies it -- swapping
    // in a new talent keeps the rank already earned in that slot.
    _p.talent_slot_ids[_slot_index] = global.chest_reward_talent_id;

    player_recompute_synthetics(_p);
    player_recompute_attributes(_p);

    global.chest_reward_open = false;
}

function skip_chest_reward() {
    global.chest_reward_open = false;
}

// Single source of truth for "is the world frozen right now" -- covers full-screen UI
// (pause/attribute window/chest reward) AND the brief hit-stop freeze on impactful hits.
// Every Step event that matters checks this instead of the individual flags directly.
function is_world_paused() {
    return global.paused || global.attr_window_open || global.chest_reward_open || (variable_global_exists("midrun_shop_open") && global.midrun_shop_open) || (variable_global_exists("run_victory") && global.run_victory) || global.hitstop_timer > 0;
}

function talent_get_desc_flavor(_t) {
    if (is_struct(_t) && variable_struct_exists(_t, "desc_flavor")) return _t.desc_flavor;
    return "";
}

function talent_get_desc_value(_t) {
    if (is_struct(_t) && variable_struct_exists(_t, "desc_value")) return _t.desc_value;
    return "";
}

function talent_get_icon_type(_t) {
    if (is_struct(_t) && variable_struct_exists(_t, "icon_type")) return _t.icon_type;
    return "sword";
}

function draw_talent_icon(_icon_type, _x, _y, _size, _colour) {
    var _half = _size * 0.5;
    var _prev_col = draw_get_color();
    draw_set_color(_colour);

    switch (_icon_type) {
        case "shield":
        case "block":
        case "magic_def":
            var _top = _y - _half * 0.85;
            var _bot = _y + _half * 0.85;
            draw_line_width(_x - _half * 0.7, _top, _x + _half * 0.7, _top, 2);
            draw_line_width(_x - _half * 0.7, _top, _x - _half * 0.7, _y, 2);
            draw_line_width(_x + _half * 0.7, _top, _x + _half * 0.7, _y, 2);
            draw_line_width(_x - _half * 0.7, _y, _x, _bot, 2);
            draw_line_width(_x + _half * 0.7, _y, _x, _bot, 2);
            if (_icon_type == "block") {
                draw_circle(_x, _y - 2, _half * 0.3, false);
            } else if (_icon_type == "magic_def") {
                draw_circle(_x, _y - 2, _half * 0.35, true);
            } else {
                draw_line_width(_x, _top + 3, _x, _bot - 4, 2);
            }
            break;

        case "sword":
        case "riposte":
            draw_line_width(_x, _y - _half * 0.85, _x, _y + _half * 0.45, 3);
            draw_line_width(_x - _half * 0.5, _y + _half * 0.1, _x + _half * 0.5, _y + _half * 0.1, 2);
            draw_line_width(_x, _y + _half * 0.1, _x, _y + _half * 0.75, 2);
            draw_circle(_x, _y + _half * 0.8, 2, false);
            if (_icon_type == "riposte") {
                draw_line_width(_x - _half * 0.45, _y - _half * 0.45, _x + _half * 0.45, _y + _half * 0.45, 2);
            }
            break;

        case "dagger":
            draw_line_width(_x - _half * 0.5, _y + _half * 0.5, _x + _half * 0.5, _y - _half * 0.5, 3);
            draw_line_width(_x - _half * 0.2, _y + _half * 0.4, _x - _half * 0.4, _y + _half * 0.2, 2);
            draw_circle(_x - _half * 0.55, _y + _half * 0.55, 2, false);
            break;

        case "heart":
        case "regen":
        case "second_wind":
            draw_line_width(_x, _y - _half * 0.65, _x, _y + _half * 0.65, 4);
            draw_line_width(_x - _half * 0.65, _y, _x + _half * 0.65, _y, 4);
            if (_icon_type == "regen") {
                draw_circle(_x, _y, _half * 0.85, true);
            } else if (_icon_type == "second_wind") {
                draw_circle(_x, _y, _half * 0.9, true);
                draw_circle(_x, _y, _half * 0.7, true);
            }
            break;

        case "bow":
        case "arrow_speed":
        case "pierce":
            draw_line_width(_x - _half * 0.6, _y + _half * 0.6, _x + _half * 0.6, _y - _half * 0.6, 2);
            draw_line_width(_x + _half * 0.6, _y - _half * 0.6, _x + _half * 0.15, _y - _half * 0.6, 2);
            draw_line_width(_x + _half * 0.6, _y - _half * 0.6, _x + _half * 0.6, _y - _half * 0.15, 2);
            if (_icon_type == "bow") {
                draw_line_width(_x - _half * 0.4, _y - _half * 0.4, _x - _half * 0.1, _y + _half * 0.5, 2);
            } else if (_icon_type == "pierce") {
                draw_line_width(_x, _y - _half * 0.5, _x, _y + _half * 0.5, 2);
            }
            break;

        case "fury":
        case "burn":
        case "fireball":
            draw_triangle(_x, _y - _half * 0.85, _x - _half * 0.55, _y + _half * 0.65, _x + _half * 0.55, _y + _half * 0.65, false);
            draw_set_color(c_white);
            draw_circle(_x, _y + _half * 0.25, _half * 0.25, false);
            draw_set_color(_colour);
            break;

        case "holy":
        case "heal_hit":
        case "barrier":
            draw_line_width(_x, _y - _half * 0.75, _x, _y + _half * 0.75, 3);
            draw_line_width(_x - _half * 0.75, _y, _x + _half * 0.75, _y, 3);
            draw_circle(_x, _y, _half * 0.45, true);
            if (_icon_type == "barrier") {
                draw_circle(_x, _y, _half * 0.85, true);
            }
            break;

        case "wind":
        case "haste":
        case "boot":
            draw_line_width(_x - _half * 0.7, _y - _half * 0.35, _x + _half * 0.5, _y - _half * 0.35, 2);
            draw_line_width(_x - _half * 0.4, _y, _x + _half * 0.7, _y, 3);
            draw_line_width(_x - _half * 0.6, _y + _half * 0.35, _x + _half * 0.35, _y + _half * 0.35, 2);
            break;

        case "bastion":
        case "rock":
        case "shockwave":
            draw_rectangle(_x - _half * 0.6, _y - _half * 0.3, _x + _half * 0.6, _y + _half * 0.6, false);
            draw_rectangle(_x - _half * 0.6, _y - _half * 0.7, _x - _half * 0.25, _y - _half * 0.3, false);
            draw_rectangle(_x + _half * 0.25, _y - _half * 0.7, _x + _half * 0.6, _y - _half * 0.3, false);
            if (_icon_type == "shockwave") {
                draw_circle(_x, _y + _half * 0.6, _half * 0.85, true);
            }
            break;

        case "crit":
            draw_circle(_x, _y, _half * 0.45, true);
            draw_line_width(_x, _y - _half * 0.8, _x, _y + _half * 0.8, 2);
            draw_line_width(_x - _half * 0.8, _y, _x + _half * 0.8, _y, 2);
            draw_circle(_x, _y, 2, false);
            break;

        case "execute":
            draw_circle(_x, _y - 2, _half * 0.5, false);
            draw_rectangle(_x - _half * 0.3, _y, _x + _half * 0.3, _y + _half * 0.55, false);
            draw_set_color(c_black);
            draw_circle(_x - 3, _y - 2, 2, false);
            draw_circle(_x + 3, _y - 2, 2, false);
            draw_set_color(_colour);
            break;

        case "dodge":
            draw_line_width(_x - _half * 0.7, _y + _half * 0.45, _x, _y - _half * 0.65, 2);
            draw_line_width(_x - _half * 0.35, _y + _half * 0.65, _x + _half * 0.35, _y - _half * 0.45, 2);
            draw_line_width(_x, _y + _half * 0.75, _x + _half * 0.7, _y - _half * 0.25, 2);
            break;

        case "poison":
            draw_circle(_x, _y + 2, _half * 0.5, false);
            draw_triangle(_x, _y - _half * 0.75, _x - _half * 0.4, _y, _x + _half * 0.4, _y, false);
            draw_set_color(c_black);
            draw_circle(_x, _y + 2, 2, false);
            draw_set_color(_colour);
            break;

        case "lifesteal":
            draw_circle(_x, _y + 3, _half * 0.5, false);
            draw_triangle(_x, _y - _half * 0.75, _x - _half * 0.45, _y + 2, _x + _half * 0.45, _y + 2, false);
            break;

        case "cdr":
            draw_circle(_x, _y, _half * 0.65, true);
            draw_line_width(_x, _y, _x, _y - _half * 0.45, 2);
            draw_line_width(_x, _y, _x + _half * 0.35, _y, 2);
            break;

        case "gold":
            draw_circle(_x, _y, _half * 0.75, false);
            draw_set_color(c_black);
            draw_circle(_x, _y, _half * 0.75, true);
            draw_circle(_x, _y, _half * 0.5, true);
            draw_set_color(_colour);
            break;

        case "thorns":
            draw_circle(_x, _y, _half * 0.35, true);
            draw_line_width(_x, _y - _half * 0.75, _x, _y - _half * 0.25, 2);
            draw_line_width(_x, _y + _half * 0.25, _x, _y + _half * 0.75, 2);
            draw_line_width(_x - _half * 0.75, _y, _x - _half * 0.25, _y, 2);
            draw_line_width(_x + _half * 0.25, _y, _x + _half * 0.75, _y, 2);
            break;

        default:
            draw_triangle(_x, _y - _half * 0.65, _x - _half * 0.65, _y + _half * 0.45, _x + _half * 0.65, _y + _half * 0.45, true);
            break;
    }

    draw_set_color(_prev_col);
}
