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
// Numbers here (per_rank, cost) are placeholders, easy to retune.
function get_talent_defs() {
    return [
        // =========================================================================
        // 1. FUNDAMENTAIS / MESTRIA COM ESCUDO E ESPADA (10 TALENTOS)
        // =========================================================================
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

        // =========================================================================
        // 2. PALADINO (ELEMENTO AGUA / SAGRADO - 8 TALENTOS)
        // =========================================================================
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
         desc_value: "Cada 3º golpe de espada libera uma onda d'agua penetrante que cura o jogador em 5 HP.", icon_type: "heal_hit"},
        {id: "knight_paladino_escudo_espelhado", character: "knight", affinity: "water", label: "Escudo Espelhado", synth_field: "synth_paladino_escudo_espelhado", per_rank: 1, cost: 65,
         desc_flavor: "A quebra da barreira estilhaca o espelho dagua em um estrondo que atordoa agressores.",
         desc_value: "Quando a barreira de sobrevida quebra por dano, explode cegando e empurrando num raio de 120px.", icon_type: "shockwave"},
        {id: "knight_paladino_graca_abencoada", character: "knight", affinity: "water", label: "Graca Abencoada", synth_field: "synth_paladino_graca_abencoada", per_rank: 0.50, cost: 75,
         desc_flavor: "A vitalidade excedente nunca e desperdicada, condensando-se em escudo de energia sagrada.",
         desc_value: "Receber cura enquanto estiver com HP cheio converte 50% do valor em barreira de sobrevida.", icon_type: "barrier"},
        {id: "knight_paladino_julgamento_sereno", character: "knight", affinity: "water", label: "Julgamento Sereno", synth_field: "synth_paladino_julgamento_sereno", per_rank: 0.25, cost: 80,
         desc_flavor: "Sob o amparo da barreira luminosa, o cavaleiro manuseia a espada com serenidade e cadencia reluzente.",
         desc_value: "Enquanto a barreira de sobrevida estiver ativa, a velocidade de ataque da espada aumenta em +25%.", icon_type: "haste"},

        // =========================================================================
        // 3. BERSERKER (ELEMENTO FOGO / FURIA - 8 TALENTOS)
        // =========================================================================
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

        // =========================================================================
        // 4. DUELISTA (ELEMENTO AR / VENTO - 8 TALENTOS)
        // =========================================================================
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

        // =========================================================================
        // 5. GUARDIAO (ELEMENTO TERRA / FORTALEZA - 8 TALENTOS)
        // =========================================================================
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
         desc_value: "Cada 4º golpe de espada faz rachar o chao em linha reta, atordoando o primeiro inimigo por 0.8s.", icon_type: "rock"},
        {id: "knight_guardiao_bastiao_inabalavel", character: "knight", affinity: "earth", label: "Bastiao Inabalavel", synth_field: "synth_guardiao_bastiao_inabalavel", per_rank: 0.15, cost: 70,
         desc_flavor: "A firmeza inquebravel do escudo ancora as forcas vitais na terra, cicatrizando o organismo.",
         desc_value: "Bloquear ataques converte 15% do dano bloqueado em regeneracao de vida temporaria.", icon_type: "regen"},
        {id: "knight_guardiao_peso_esmagador", character: "knight", affinity: "earth", label: "Peso Esmagador", synth_field: "synth_guardiao_peso_esmagador", per_rank: 25, cost: 75,
         desc_flavor: "A inercia do escudo e descomunal: colisoes contra rochas e paredes esmagam ossos com facilidade.",
         desc_value: "Empurrar um inimigo contra uma parede causa dano de esmagamento extra de 25 por rank.", icon_type: "shield"},
        {id: "knight_guardiao_fortaleza_viva", character: "knight", affinity: "earth", label: "Fortaleza Viva", synth_field: "synth_guardiao_fortaleza_viva", per_rank: 3, cost: 80,
         desc_flavor: "Quanto mais cercado e pressionado por hordas, mais impenetravel se torna a presenca do Guardiao.",
         desc_value: "Para cada inimigo a menos de 90px de distancia, ganha +3 de defesa e +5% de reducao de dano.", icon_type: "shield"},

        // =========================================================================
        // 6. LENDARIOS / SINERGIAS ELEMENTAIS HIBRIDAS (8 TALENTOS)
        // =========================================================================
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
         desc_value: "O tamanho do escudo dobra, cobrindo 180° frontais e bloqueando passagens inteiras.", icon_type: "shield"},
        {id: "knight_lendario_eco_ancestrais", character: "knight", affinity: "legendary", label: "Eco dos Ancestrais", synth_field: "synth_lendario_eco_ancestrais", per_rank: 1, cost: 140,
         desc_flavor: "O sangue heroico desperta memorias de reis guerreiros antigos que espelham cada golpe desferido.",
         desc_value: "Bloquear ou contra-atacar invoca o espirito translucido de um guerreiro que desfere um golpe gemeo.", icon_type: "sword"},

        // ---- Arqueiro (Archer) ----
        {id: "archer_pwr_fisica", character: "archer", label: "Power Fisico", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0,
         desc_flavor: "Fortalece a tensao do arco longo disparando projeteis de maior impacto.",
         desc_value: "+3 de Poder Fisico (Dano das Flechas) por nivel.", icon_type: "bow"},
        {id: "archer_mira_precisa", character: "archer", label: "Mira Precisa", synth_field: "synth_crit_chance", per_rank: 0.03, cost: 0,
         desc_flavor: "Foco absoluto em pontos fracos aumentando a probabilidade de disparos criticos.",
         desc_value: "+3% de Chance de Acerto Critico por nivel.", icon_type: "crit"},
        {id: "archer_fluxo_flechas", character: "archer", label: "Fluxo de Flechas", synth_field: "synth_atk_spd_bonus", per_rank: 0.05, cost: 0,
         desc_flavor: "Agilidade magistral ao sacar flechas da aljava acelerando a frequencia de disparo.",
         desc_value: "+5% de Velocidade de Ataque por nivel.", icon_type: "arrow_speed"},
        {id: "archer_passo_leve", character: "archer", label: "Passo Leve", synth_field: "synth_move_spd_bonus", per_rank: 3, cost: 0,
         desc_flavor: "Passos ageis e silenciosos que concedem maior mobilidade para manter a distancia.",
         desc_value: "+3 de Velocidade de Movimento permanente por nivel.", icon_type: "boot"},
        {id: "archer_flechas_perfurantes", character: "archer", label: "Flechas Perfurantes", synth_field: "synth_pierce_count", per_rank: 1, cost: 70,
         desc_flavor: "Pontas aerodinamicas especiais que atravessam inimigos atingindo fileiras traseiras.",
         desc_value: "+1 Alvo perfurado por flecha disparada por nivel.", icon_type: "pierce"},
        {id: "archer_instinto_cacador", character: "archer", label: "Instinto Cacador", synth_field: "synth_execute_bonus", per_rank: 0.08, cost: 70,
         desc_flavor: "Instinto implacavel que multiplica o dano ao atingir adversarios severamente feridos.",
         desc_value: "+8% de Dano de Execucao contra inimigos com pouca vida.", icon_type: "execute"},

        // ---- Mago (Mage) ----
        {id: "mage_couraca_magica", character: "mage", label: "Couraca Magica", synth_field: "synth_def_magica", per_rank: 2, cost: 0,
         desc_flavor: "Aura de protecao mistica que dissipa feiticos hostis e ameniza impactos magicos.",
         desc_value: "+2 de Defesa Magica por nivel de talento.", icon_type: "magic_def"},
        {id: "mage_fluxo_arcano", character: "mage", label: "Fluxo Arcano", synth_field: "synth_cdr", per_rank: 0.03, cost: 0,
         desc_flavor: "Circulacao de mana otimizada reduzindo os tempos de espera das magias.",
         desc_value: "+3% de Reducao de Tempo de Recarga (CDR) por nivel.", icon_type: "cdr"},
        {id: "mage_vigor_arcano", character: "mage", label: "Vigor Arcano", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0,
         desc_flavor: "Energia elemental que sela feridas restaurando a saude do conjurador continuamente.",
         desc_value: "+1.5 de Regeneracao de Vida por segundo por nivel.", icon_type: "regen"},
        {id: "mage_sobrecarga", character: "mage", label: "Sobrecarga", synth_field: "synth_pwr_magica", per_rank: 3, cost: 70,
         desc_flavor: "Densidade eterea ampliada em cada bola de fogo gerando explosoes devastadoras.",
         desc_value: "+3 de Poder Magico (Dano) por nivel de talento.", icon_type: "fireball"},
        {id: "mage_explosao_perfurante", character: "mage", label: "Explosao Perfurante", synth_field: "synth_pierce_count", per_rank: 1, cost: 70,
         desc_flavor: "As labaredas atravessam os primeiros corpos atingindo grupos inteiros de monstros.",
         desc_value: "+1 Inimigo perfurado por projetil magico por nivel.", icon_type: "pierce"},

        // ---- Assassino (Assassin) ----
        {id: "assassin_move_spd", character: "assassin", label: "Passo Sombrio", synth_field: "synth_move_spd_bonus", per_rank: 5, cost: 50,
         desc_flavor: "Deslocamento veloz nas sombras tornando o assassino um alvo escorregadio.",
         desc_value: "+5 de Velocidade de Movimento permanente por nivel.", icon_type: "boot"},
        {id: "assassin_instinto_assassino", character: "assassin", label: "Instinto Assassino", synth_field: "synth_execute_bonus", per_rank: 0.08, cost: 0,
         desc_flavor: "Golpes certeiros em orgaos vitais que finalizam presas enfraquecidas rapidamente.",
         desc_value: "+8% de Dano de Execucao contra inimigos com pouca vida.", icon_type: "execute"},
        {id: "assassin_reflexos_sombrios", character: "assassin", label: "Reflexos Sombrios", synth_field: "synth_dodge", per_rank: 0.02, cost: 0,
         desc_flavor: "Capacidade sobrenatural de esquivar de ataques sem sofrer nenhum dano.",
         desc_value: "+2% de Chance de Esquiva total por nivel.", icon_type: "dodge"},
        {id: "assassin_laminas_envenenadas", character: "assassin", label: "Laminas Envenenadas", synth_field: "synth_poison_on_hit", per_rank: 1, cost: 0,
         desc_flavor: "Veneno corrosivo aplicado nas adagas que drena a vida do alvo com o tempo.",
         desc_value: "+1 de Dano continuo de Veneno por golpe desferido.", icon_type: "poison"},
        {id: "assassin_vampirismo_sombrio", character: "assassin", label: "Vampirismo Sombrio", synth_field: "synth_lifesteal", per_rank: 0.02, cost: 70,
         desc_flavor: "Rito sombrio que suga a forca vital dos inimigos feridos para recompor o assassino.",
         desc_value: "+2% de Roubo de Vida ao desferir dano fisico.", icon_type: "lifesteal"},
        {id: "assassin_sombra_mortal", character: "assassin", label: "Sombra Mortal", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 70,
         desc_flavor: "Afiacao meticulosa das laminas para cortes letais e penetracao implacavel.",
         desc_value: "+3 de Poder Fisico (Dano) por nivel de talento.", icon_type: "dagger"},

        // ---- Talentos Gerais (Baús) ----
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
         desc_value: "+3 de Poder Fisico por rank.", icon_type: "sword"},
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

function knight_get_archetype_name(_elem) {
    switch (_elem) {
        case "water": return "Paladino";
        case "fire": return "Berserker";
        case "wind": return "Duelista";
        case "earth": return "Guardiao";
        default: return "Cavaleiro";
    }
}

function knight_get_archetype_desc(_elem) {
    switch (_elem) {
        case "water": return "Paladino: Especial gera Aura de Sobrevida em area que cura/protege.";
        case "fire": return "Berserker: Ataque amplo devastador. Especial entra em Furia Ardente (+50% dano/+regen).";
        case "wind": return "Duelista: Ataque duplo veloz em combo. Especial e Aparar (Parry com contra-ataque de 360).";
        case "earth": return "Guardiao: Ataque concentrado. Especial Bastiao bloqueia 100% dano fisico e magico + Taunt.";
        default: return "Cavaleiro: Espada de medio alcance e escudo com bloqueio fisico tradicional.";
    }
}

function get_talents_for_character(_character) {
    var _all = get_talent_defs();
    var _out = [];
    for (var i = 0; i < array_length(_all); i++) {
        if (_all[i].character == _character) array_push(_out, _all[i]);
    }
    return _out;
}

function knight_get_talents_for_affinity(_affinity) {
    var _all = get_talents_for_character("knight");
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
    ensure_meta_loaded();
    var _def = get_talent_def_by_id(_id);
    if (is_undefined(_def)) return false;
    if (_def.cost <= 0) return true;
    return variable_struct_exists(global.meta_unlocked, _id);
}

function element_is_unlocked(_elem) {
    if (_elem == "none") return true;
    ensure_meta_loaded();
    if (variable_global_exists("meta_elements") && variable_struct_exists(global.meta_elements, _elem)) {
        return global.meta_elements[$ _elem];
    }
    return true; // Default unlocked for testing & play
}

function element_unlock(_elem) {
    ensure_meta_loaded();
    if (!variable_global_exists("meta_elements")) global.meta_elements = {};
    global.meta_elements[$ _elem] = true;
    save_meta();
}

function load_meta_from_disk() {
    global.meta_unlocked = {};
    global.gold = 0;
    global.meta_elements = { "water": true, "fire": true, "wind": true, "earth": true };

    if (!file_exists("meta.ini")) return;

    ini_open("meta.ini");
    global.gold = ini_read_real("meta", "gold", 0);

    var _all = get_talent_defs();
    for (var i = 0; i < array_length(_all); i++) {
        var _id = _all[i].id;
        if (ini_read_real("unlocks", _id, 0) >= 1) {
            global.meta_unlocked[$ _id] = true;
        }
    }

    global.meta_elements.water = (ini_read_real("elements", "water", 1) >= 1);
    global.meta_elements.fire  = (ini_read_real("elements", "fire", 1) >= 1);
    global.meta_elements.wind  = (ini_read_real("elements", "wind", 1) >= 1);
    global.meta_elements.earth = (ini_read_real("elements", "earth", 1) >= 1);

    ini_close();
}

function save_meta() {
    ensure_meta_loaded();
    ini_open("meta.ini");
    ini_write_real("meta", "gold", global.gold);

    var _all = get_talent_defs();
    for (var i = 0; i < array_length(_all); i++) {
        var _id = _all[i].id;
        ini_write_real("unlocks", _id, talent_is_unlocked(_id) ? 1 : 0);
    }

    if (variable_global_exists("meta_elements")) {
        ini_write_real("elements", "water", (variable_struct_exists(global.meta_elements, "water") && global.meta_elements.water) ? 1 : 0);
        ini_write_real("elements", "fire",  (variable_struct_exists(global.meta_elements, "fire") && global.meta_elements.fire) ? 1 : 0);
        ini_write_real("elements", "wind",  (variable_struct_exists(global.meta_elements, "wind") && global.meta_elements.wind) ? 1 : 0);
        ini_write_real("elements", "earth", (variable_struct_exists(global.meta_elements, "earth") && global.meta_elements.earth) ? 1 : 0);
    }
    ini_close();
}

function talent_purchase(_id) {
    ensure_meta_loaded();
    var _def = get_talent_def_by_id(_id);
    if (is_undefined(_def)) return false;
    if (talent_is_unlocked(_id)) return false;
    if (global.gold < _def.cost) return false;

    global.gold -= _def.cost;
    global.meta_unlocked[$ _id] = true;
    save_meta();
    return true;
}

function player_gain_gold(_amount) {
    ensure_meta_loaded();
    var _p = instance_find(obj_player, 0);
    var _mult = (_p != noone) ? (1 + _p.synth_gold_bonus) : 1;
    global.gold += round(_amount * _mult);
    save_meta();
}

// Rebuilds every synth_* field from scratch based on the 3 chosen talent slots and their
// current in-run rank. Call after any rank change, before player_recompute_attributes.
function player_recompute_synthetics(_p) {
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

    // 1. Fundamentais
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

    // 2. Paladino
    _p.synth_paladino_bencao_mare = 0;
    _p.synth_paladino_bastiao_liquido = 0;
    _p.synth_paladino_gota_purificadora = 0;
    _p.synth_paladino_correnteza_dilacerante = 0;
    _p.synth_paladino_golpe_nascente = 0;
    _p.synth_paladino_escudo_espelhado = 0;
    _p.synth_paladino_graca_abencoada = 0;
    _p.synth_paladino_julgamento_sereno = 0;

    // 3. Berserker
    _p.synth_berserk_arco_incendiario = 0;
    _p.synth_berserk_frenesi_ardente = 0;
    _p.synth_berserk_combustao_espontanea = 0;
    _p.synth_berserk_sede_sangue = 0;
    _p.synth_berserk_cinzas_sacrificio = 0;
    _p.synth_berserk_lamina_brasa = 0;
    _p.synth_berserk_vinganca_flamejante = 0;
    _p.synth_berserk_furia_imortal = 0;

    // 4. Duelista
    _p.synth_duelista_riposte_perfeito = 0;
    _p.synth_duelista_passo_eolico = 0;
    _p.synth_duelista_combo_vendaval = 0;
    _p.synth_duelista_danca_laminas = 0;
    _p.synth_duelista_aparar_cadeia = 0;
    _p.synth_duelista_vacuo_cortante = 0;
    _p.synth_duelista_reflexos_celere = 0;
    _p.synth_duelista_estocada_fulminante = 0;

    // 5. Guardiao
    _p.synth_guardiao_muralha_sismica = 0;
    _p.synth_guardiao_provocacao_esmagadora = 0;
    _p.synth_guardiao_carapaca_granito = 0;
    _p.synth_guardiao_retaliacao_sismica = 0;
    _p.synth_guardiao_fissura_telurica = 0;
    _p.synth_guardiao_bastiao_inabalavel = 0;
    _p.synth_guardiao_peso_esmagador = 0;
    _p.synth_guardiao_fortaleza_viva = 0;

    // 6. Lendarios / Hibridos
    _p.synth_lendario_vapor_sagrado = 0;
    _p.synth_lendario_tempestade_poeira = 0;
    _p.synth_lendario_gelo_fendido = 0;
    _p.synth_lendario_tempestade_ignea = 0;
    _p.synth_lendario_avatar_elemental = 0;
    _p.synth_lendario_cavaleiro_apocalipse = 0;
    _p.synth_lendario_escudo_titanico = 0;
    _p.synth_lendario_eco_ancestrais = 0;

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

    // Atributos derivados diretos
    if (_p.synth_fio_carrasco > 0) _p.synth_execute_bonus += _p.synth_fio_carrasco;
    if (_p.synth_duelista_reflexos_celere > 0) _p.synth_dodge += _p.synth_duelista_reflexos_celere;
    if (_p.synth_guardiao_carapaca_granito > 0) _p.synth_def_fisica += _p.synth_guardiao_carapaca_granito;
    if (_p.synth_paladino_bencao_mare > 0) _p.synth_hp_reg += _p.synth_paladino_bencao_mare;
    if (_p.synth_aco_temperado > 0) {
        var _gold = variable_global_exists("gold") ? global.gold : 0;
        _p.synth_def_fisica += min(8, floor(_gold / 100) * _p.synth_aco_temperado);
    }
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
    var _pool = get_general_talent_defs();
    if (array_length(_pool) == 0) return "";
    return _pool[irandom(array_length(_pool) - 1)].id;
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
    return global.paused || global.attr_window_open || global.chest_reward_open || global.hitstop_timer > 0;
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
