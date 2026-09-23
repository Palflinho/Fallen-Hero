# FALLEN HERO — GAME DESIGN DOCUMENT (GDD) COMPLETO & OFICIAL
**Versão:** 3.0 (Master Gold Definitive)  
**Engine:** GameMaker LTS (Compatibilidade GML LTS 2026)  
**Gênero:** Top-Down Action Roguelike RPG com Progressão Elemental  
**Inspirações de Design:** *Hades*, *Dead Cells*, *Hyper Light Drifter*, *Super Smash Bros* (Filosofia Sakurai) e *The Legend of Zelda* (Filosofia Miyamoto)  
**Status do Projeto:** Em desenvolvimento — protótipo jogável com sistemas completos; arte final, música e finais ainda pendentes. Compile e teste a cada entrega.

---

## 1. RESUMO EXECUTIVO & VISÃO GERAL

### 1.1 Premissa do Jogo
Em **Fallen Hero**, o jogador assume o papel de um dos quatro campeões remanescentes de um mundo agonizante. Quatro raças antropomórficas — o **Rinoceronte** (Cavaleiro), a **Raposa** (Maga), o **Lagarto Teiú** (Arqueiro) e o **Pássaro Urutau** (Assassino) — atravessam um portal dimensional arcaico para caçar o suposto "Mal Supremo" que roubou as quatro Essências Elementais de seu planeta, transformando sua pátria em um deserto vermelho de ferrugem e cinzas.

À medida que o jogador avança pelas masmorras dos templos da **Água**, **Fogo**, **Vento** e **Terra**, liberta os antigos Guardiões corrompidos e desenvolve uma árvore de **210 Talentos Elementais**, ele descobre que o novo mundo exuberante onde luta é sustentado pelas essências roubadas e que o "monstro invasor" é um **humano comum**, lutando desesperadamente para salvar a Terra asfixiada. Ao vencer, o herói se depara com a maior tragédia moral: recuperar a vida do seu povo significa condenar a civilização humana à extinção.

### 1.2 Pilares Fundamentais de Gameplay
1. **Combate Responsivo com "Juice" (Sakurai Polish):** Impactos pesados com *hit-stop*, *screen shake* com decaimento exponencial, física de ricochete em paredes, atrito reduzido no gelo e retroalimentação visual de números flutuantes e partículas dinâmicas.
2. **Coesão de Mecânicas (Miyamoto Design):** Nenhuma habilidade tem propósito único. A defesa do Cavaleiro protege, absorve projéteis, dispara ondas de choque e pode ser cancelada instantaneamente com `[X]`. A invisibilidade do Assassino corta aggro de inimigos, permite posicionamento pelas costas (*backstab*) e arma minas de basalto na quebra.
3. **Matriz Elemental 4×4:** Quatro classes cruzadas com quatro afinidades elementais geram 16 arquétipos especializados de combate (ex: Cavaleiro Paladino com Água, Berserker com Fogo, Duelista com Vento, Guardião com Terra).
4. **Progressão Dupla (Roguelike + Metagame):** Runs dinâmicas pelas masmorras de 7 etapas por fase, complementadas pelo Hub da **Vila Subterrânea**, onde o ouro acumulado (com retenção de 60% na morte) desbloqueia árvores permanentes, diálogos e novos pedestais de poder.

---

## 2. BÍBLIA DE LORE, NARRATIVA & DILEMA MORAL

### 2.1 Os Três Significados de "Fallen Hero"
1. **Os Guardiões Caídos:** As quatro divindades protetoras dos biomas originais sofreram corrupção por parasitas tecnológicos, transformando-se nos chefes de cada templo. O herói não os destrói com ódio, mas os liberta por um doloroso ato de misericórdia.
2. **O Humano Caído:** O arqui-inimigo selado no Santuário Orbital (`obj_boss_human`). Não é um demônio espacial, mas um sobrevivente da Terra do século XXII, que viu a atmosfera do seu mundo ruir e aceitou ser visto como o maior monstro do cosmos para que seus filhos respirassem céu azul.
3. **O Jogador como Herói Caído:** Ao retirar as Essências, o bioma ao redor murcha e morre. Salvar o planeta natal significa transformar o paraíso dos refugiados da Terra no mesmo inferno desértico que os heróis deixaram para trás.

### 2.2 As Três Conclusões Possíveis
* **Final da Vingança (Padrão):** O jogador recupera as 4 Essências, volta à Vila Subterrânea e restaura o mundo natal. O planeta Terra e seus abrigos colapsam sem energia.
* **Final do Conquistador:** O herói decide não retornar, destrói a cúpula dos sobreviventes e assume o trono do paraíso como novo tirano protetor.
* **Final da Síntese (True Ending Secreto):** Conquistado ao finalizar a run com nível de Maestria Máxima e completando o ciclo de orbes na Vila. O herói funde a própria força vital aos quatro pedestais sagrados, tecendo uma ponte dimensional perpétua que compartilha a energia vital entre os dois planetas.

---

## 3. OS QUATRO HERÓIS JOGÁVEIS

```
       [ O RINOCERONTE ]                     [ A RAPOSA ]
       Classe: Cavaleiro                   Classe: Maga
       Papel: Tanque / Bastião             Papel: Controle / Artilharia
       Arma: Espada & Broquel              Arma: Orbe Arcana & Centelhas
       Aparência: Placas de casco,         Aparência: Manto xamânico,
       cinto robusto, postura inabalável.  orelhas atentas, brinco de pena.

       [ O LAGARTO TEIÚ ]                  [ O PÁSSARO URUTAU ]
       Classe: Arqueiro                    Classe: Assassino
       Papel: Precisão / Dano à Distância  Papel: Furtividade / Burst Crítico
       Arma: Arco Composto de Fibras       Arma: Adagas Curvas de Penugem
       Aparência: Escamas camufladas,      Aparência: Asas como capa, olhos
       olhos telescópicos, postura baixa.  mágicos luminescentes, andrógino.
```

### 3.1 Cavaleiro (Rinoceronte — Macho)
* **Atributos Base (nível 1, sem afinidade — `obj_player/Create_0.gml`):** HP 100, Poder 12 (físico), Defesa 8, recarga do ataque 0,28 s, Velocidade 180 px/s.
* **Ataque Básico:** Talho frontal amplo (varredura de espada em 180° com repelência física).
* **Habilidade Especial (Defesa / [X]):** Ergue o escudo. Bloqueia 50% a 100% de dano frontal, absorve projéteis.
  * **QoL Integrada:** Pode cancelar a qualquer instante antes do fim da duração apertando `[X]` novamente.
* **Afinidades Elementais:**
  * *Água (Lanceiro — estilo Arqueiro):* Cada golpe solta uma lâmina d'água de longo alcance; a aura de sobrevida cura e protege.
  * *Fogo (Cavaleiro Rúnico — estilo Maga):* Alcance normal, mas todo golpe que acerta detona uma runa de fogo em área (maior durante a Fúria) que também interrompe canalizações.
  * *Vento (Duelista — estilo Assassino):* Aparar e contra-atacar; combo duplo de lâmina veloz e rajadas cortantes de ar.
  * *Terra (Guardião — Maestria):* Aumenta a couraça corporal proporcionalmente aos inimigos próximos.

### 3.2 Maga (Raposa — Fêmea)
* **Atributos Base (nível 1, sem afinidade):** HP 70, Poder 14 (mágico), Defesa 3, recarga do ataque 0,9 s, Velocidade 160 px/s.
* **Ataque Básico:** Disparo de esferas místicas de longo alcance com aceleração contínua.
* **Habilidade Especial (Defesa / [X]):** Prisão Criogênica / Campo de Mana. Concede invulnerabilidade temporária estática.
  * **QoL Integrada:** Cancelável a qualquer momento com `[X]`.
* **Afinidades Elementais:**
  * *Água (Atiradora Arcana — estilo Arqueiro):* Lanças de gelo mais rápidas, perfurantes e de longo alcance (+30% em alvos lentos).
  * *Fogo (Piromante — Maestria):* Dispara meteoros de magma devastadores e sopros de dragão.
  * *Vento (Ilusionista — estilo Assassino):* Salto voltaico (teleporte); Vórtice de gravidade galvânica que puxa e esquiva de projéteis em movimento.
  * *Terra (Templária — estilo Cavaleiro):* Pilar de Basalto e mais defesa; Ruptura sísmica perfurante e muralhas protetoras de granito.

### 3.3 Arqueiro (Lagarto Teiú — Macho)
* **Atributos Base (nível 1, sem afinidade):** HP 80, Poder 8 (físico), Defesa 4, recarga do ataque 0,38 s, Velocidade 200 px/s.
* **Ataque Básico:** Disparo de flechas lineares de alta perfuração com dano escalonado pela distância percorrida.
* **Habilidade Especial (Defesa / [X]):** Rolamento Tático Evasivo com quadros de invulnerabilidade total.
* **Afinidades Elementais:**
  * *Água (Caçador das Marés — Maestria):* Pistas escorregadias de gelo e névoas ilusórias que cegam os perseguidores.
  * *Fogo (Artilheiro Arcano — estilo Maga):* Flechas explosivas de fósforo e tornados ígneos a cada 3 tiros.
  * *Vento (Caçador Furtivo — estilo Assassino):* Tiro supersônico, tempestade de 9 flechas em leque e reflexos de esquiva.
  * *Terra (Sentinela — estilo Cavaleiro):* Âncora que o torna inabalável; Tiros cataclísmicos colossais e atordoamento por impacto contra paredes.

### 3.4 Assassino (Pássaro Urutau — Andrógino / Mãe-da-lua)
* **Atributos Base (nível 1, sem afinidade):** HP 60, Poder 6 (físico), Defesa 2, recarga do ataque 0,15 s, Velocidade 190 px/s.
* **Ataque Básico:** Golpes rápidos de adagas curvas com bônus de 50% a 175% por golpe nas costas (*Backstab*).
* **Habilidade Especial (Defesa / [X]):** Passo Espectral / Furtividade.
  * **Mecânica de Aggro:** Ao ativar, chama imediatamente [`player_enter_stealth()`](../scripts/scr_combat/scr_combat.gml#L1567-L1579), forçando todos os inimigos a perderem a visão e retornarem para patrulha.
  * **Movimentação Tática:** Move-se a 80% da velocidade normal enquanto invisível.
  * **Emboscada:** Quebra a invisibilidade atacando para desferir um acerto crítico garantido e plantar uma Mina de Basalto.
* **Afinidades Elementais:**
  * *Água (Rastreador — estilo Arqueiro):* Todo 3º golpe arremessa facas espectrais que marcam o alvo.
  * *Fogo (Alquimista — estilo Maga):* Bomba de cinzas com cegueira, marcas de enxofre e lâmina de magma derretido.
  * *Vento (Algoz do Tufão — Maestria):* Reflexos que cortam projéteis inimigos em voo e tornados de adagas frontais.
  * *Terra (Cavaleiro Sombrio — estilo Cavaleiro):* Ignora armadura física de elites e crava adagas no solo em choques tectônicos.

---

## 4. SISTEMA DE COMBATE & FILOSOFIA DE DESIGN

```
                                  [ DANO INIMIGO ]
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
         [ DANO FÍSICO ]                                 [ DANO MÁGICO ]
      (Melee, Mordidas, Chifres,                    (Projéteis, Raios, Fogo,
       Investidas, Espinhos de Solo)                 Gás Tóxico, Ciclones de Ar)
                 │                                               │
                 ▼                                               ▼
       Mitigado por DEF FÍSICA                        Mitigado por DEF MÁGICA
      (synth_def_fisica + Armadura)                  (synth_def_magica + Resist)
                 │                                               │
                 └───────────────────────┬───────────────────────┘
                                         ▼
                   [ FÓRMULA DE RETORNOS DECRESCENTES ]
                        Redução = min(0.68, Def / (Def + 32))
                                         │
                                         ▼
                     [ PISO DE IMPACTO: min 20% do Dano ]
                                         │
                                         ▼
                     [ ABSORÇÃO DE SOBREVIDA / BARREIRA ]
                                         │
                                         ▼
                           [ DANO FINAL APLICADO AO HP ]
```

### 4.1 Mitigação Tática Inteligente
Implementada no commit `7c1a9cd` e refinada em `scr_combat.gml`:
* **Ataques Físicos:** Inimigos de combate corpo a corpo, feras dentadas, slimes de contato e investidas de chefes testam a **Defesa Física** do personagem.
* **Ataques Mágicos:** Projéteis balísticos, orbes elementais, poças de lava e tempestades de vento testam a **Defesa Mágica**.
* **Retornos Decrescentes (Diminishing Returns):** Impede a invulnerabilidade passiva mantendo a relevância dos tanques:
  $$\text{Redu\c{c}\~ao} = \min\left(0.68, \frac{\text{Defesa}}{\text{Defesa} + 32}\right)$$
  * Defesa 10: ~24% de redução
  * Defesa 20: ~38% de redução
  * Defesa 35: ~52% de redução
  * Teto máximo inquebrável: 68%
* **Piso de Impacto (Sakurai Rule):** A menos que haja bloqueio com escudo ou parry ativo, nenhum golpe sofrido causa menos de 20% do impacto original (mínimo de 2 de dano), garantindo tensão permanente nas masmorras.

### 4.2 Filosofia Masahiro Sakurai (Feedback e Prazer Tátil)
* **Hit-Stop (Micro-congelamento):** Impactos críticos congelam a simulação por 0.04s a 0.18s, dando peso físico ao aço e à magia.
* **Screen Shake com Decaimento Linear/Exponencial:** Explosões sacodem a visão com base na violência do impacto.
* **Física de Colisão em Paredes:** Arremessar inimigos contra a arquitetura causa dano bônus esmagador e atordoamento.
* **Atrito Diferenciado em Superfícies:** Pisos congelados (`fh_place_on_ice`) possuem atrito de 0.985, permitindo derrapagens estratégicas e knockback prolongado.

---

## 5. A MATRIZ DOS 210 TALENTOS ELEMENTAIS

O catálogo de talentos está 100% definido em [`scr_talents.gml`](../scripts/scr_talents/scr_talents.gml) e operante nos eventos de combate:

### 5.1 Distribuição Estrutural (211 Talentos Totais)
* **Cavaleiro (50 Talentos):**
  * 10 Base (Postura Firme, Lâmina Afiada, Golpe Pesado, Escudo de Choque, Segundo Fôlego, etc.)
  * 8 Água / Lanceiro (Lâmina Perfurante, Estocada Distante, Maré de Lâminas, Bastião Líquido, Escudo Espelhado, etc.)
  * 8 Fogo / Cavaleiro Rúnico (Runa Ampliada, Runa em Cadeia, Combustão Espontânea, Lâmina em Brasa, Fúria Imortal, etc.)
  * 8 Vento / Duelista (Combo Vendaval, Postura Eólica, Lâmina Relâmpago, Dança das Lâminas, etc.)
  * 8 Terra / Guardião (Fissura Telúrica, Carapaça de Granito, Fortaleza Viva, Peso Esmagador, etc.)
  * 8 Lendários / Mestria (Cavaleiro do Apocalipse, Avatar Elemental, etc.)
* **Maga (50 Talentos):**
  * 10 Base (Canalização Fluida, Eco Mágico, Fluxo Conduzido, etc.)
  * 8 Água / Atiradora Arcana (Mira Firme, Lança Estilhaçante, Lança de Zero Absoluto, Onda Torrencial, etc.)
  * 8 Fogo / Piromante (Meteoro de Magma, Sopro de Dragão, Conflagração Furiosa, etc.)
  * 8 Vento / Ilusionista (Vórtice Cortante, Olho do Furacão, Passo Céfiro, etc.)
  * 8 Terra / Templária (Ruptura Sísmica, Espinhos Telúricos, Armadura de Granito, etc.)
  * 8 Lendários / Mestria (Singularidade Dimensional, Conjurador Supremo, etc.)
* **Arqueiro (50 Talentos):**
  * 10 Base (Tiro em Corrida, Aljava Leve, Reflexo do Caçador, Flecha Pesada, etc.)
  * 8 Água / Caçador das Marés (Pista Escorregadia, Névoa Ilusória, etc.)
  * 8 Fogo / Artilheiro Arcano (Balista Piromante, Tempestade Ígnea Aérea, etc.)
  * 8 Vento / Caçador Furtivo (Tempestade de Mil Tiros, Tiro Supersônico, Dança dos Ventos, etc.)
  * 8 Terra / Sentinela (Tiro Cataclísmico, Flecha Arpão de Pedra, etc.)
  * 8 Lendários / Mestria (Atirador Fantasma, Falcão Cósmico, etc.)
* **Assassino (50 Talentos):**
  * 10 Base (Golpe Jugular, Passo Silencioso, Esquiva Reflexa, Execução Fria, Lâminas Gêmeas, etc.)
  * 8 Água / Rastreador (Leque de Facas, Presa Marcada, Passo das Marés, Maré da Ceifa, etc.)
  * 8 Fogo / Alquimista (Passo Explosivo, Marca do Enxofre, Lâmina de Magma, Supernova Sombria, etc.)
  * 8 Vento / Algoz do Tufão (Celeridade Fantasma, Reflexos Célere, Tornado de Adagas, Esquiva Espectral, etc.)
  * 8 Terra / Cavaleiro Sombrio (Corte de Obsidiana, Pele Pétrea, Mina de Basalto, Golpe Tectônico, etc.)
  * 8 Lendários / Mestria (Lâmina da Guilhotina, Eco dos Assassinos, etc.)
* **Talentos Gerais Neutros (11 Talentos):**
  * Vigor (+HP Max), Fortuna (+Ouro), Reflexos (+Esquiva), Ímpeto (+Velocidade), Precisão (+Crítico), Fôlego Extra (Auto-reviver), etc.

### 5.2 Curva de Custo Balanceada
Gerenciada por `talent_get_upgrade_cost(_id, _cur_rank)`:
* **Talentos de Nó-Chave (Rank Único / max_r: 1):** Custo de 3 a 15 pontos de talento conforme a raridade (Base 3-5, Avançado 6-9, Lendário 12-15).
* **Talentos Escalonáveis (Ranks 1 a 10):**
  * Rank 0 $\rightarrow$ 1: 1 a 2 pontos (Acesso inicial imediato)
  * Ranks 2 $\rightarrow$ 4: 3 a 5 pontos por nível (Consolidação de build)
  * Ranks 5 $\rightarrow$ 10: 6 a 9 pontos por nível (Especialização final e investimento de endgame)

### 5.3 Slots e Pontos de Talento na Run
* **5 slots por run:** o jogador escolhe **3 talentos** na tela pré-run; os **2 slots extras** começam vazios e são preenchidos durante a partida com talentos achados em baús/portais (o baú nunca sorteia um talento já equipado).
* **O rank pertence ao slot:** trocar o talento de um slot mantém o rank já investido nele.
* **Pontos por nível:** ao atingir o nível N o herói ganha cerca de N/3 pontos, no mínimo 1 (níveis 1-4 = 1, 5-7 = 2, 8-10 = 3, 11-13 = 4...). A run começa no nível 1 com 1 ponto. Fórmula em `talent_points_for_level()`.

---

## 6. ARQUITETURA DE FASES, DUNGEONS & VILA HUB

```
   [ VILA SUBTERRÂNEA ] ────► [ PORTAL DIMENSIONAL ]
     • Ancião (Lore & Metagame)     │
     • Fogueira (Save & Cura)       │
     • 4 Pedestais Elementais       ▼
                           [ TEMPLO ELEMENTAL ]
                             Etapa 1: Exploração 1
                             Etapa 2: Exploração 2
                             Etapa 3: Arena 2.5 (Ondas + Baú de Talento)
                             Etapa 4: Loja Mid-Run 3 (Mercador)
                             Etapa 5: Exploração 3
                             Etapa 6: Câmara Pré-Chefe 5 (Descanso)
                             Etapa 7: Chefe Guardião 6 ──► Resgate da Essência
                                                           (Retorna ao Hub)
```

### 6.1 O Hub: A Vila Subterrânea (`room_village`)
* **A Fogueira Ancestral (`obj_bonfire`):** Ponto de descanso que regenera vida e registra a memória da jornada.
* **O Ancião da Vila (`obj_village_elder`):** NPC com sistema completo de diálogos e revelações graduais sobre a origem do cataclismo.
* **Os Pedestais das Essências (`obj_pedestal_element`):** Quatro totens sagrados onde as essências resgatadas são alocadas, acendendo o templo e ativando bênçãos mundiais permanentes.
* **O Portal de Expedição (`obj_village_portal`):** Seleção de masmorras elementais desbloqueadas e progressão contínua.

### 6.2 O Ciclo de 7 Etapas por Masmorra
1. **Exploração Inicial (Salas 1 e 2):** Combates contra patrulhas de inimigos comuns, descoberta de potes de ouro e aprendizado dos perigos ambientais (lama movediça, poças de lava, gelo).
2. **Arena de Desafio (Etapa 3):** Portas trancam-se magicamente; o jogador enfrenta ondas escalonadas de inimigos com elites (Água 2, Fogo 3, Vento 3, Terra 4) e, ao final, o **Espírito Elemental** do templo desperta como chefe da arena (ver 6.4). A vitória gera o **Baú de Tesouro com Cards Comparativos** no estilo Nintendo.
3. **Loja de Intermissão (Etapa 4):** Espaço neutro protegido pelo Mercador Interdimensional. Permite comprar poções de cura, aumentos definitivos de ataque/defesa para a run e trocar talentos ativos.
4. **Exploração Avançada & Pré-Chefe (Salas 5 e 6):** Densidade máxima de inimigos e sala de preparação com fontes de cura.
5. **Câmara do Guardião (Etapa 7):** Batalha contra o chefe elemental do bioma.

### 6.3 Os Cinco Grandes Chefes
Cada chefe tem **uma mecânica central** (estilo Zelda) que abre a **janela de dano**. Fora da janela o chefe recebe só dano leve; na janela recebe 100% **+50%** (anel amarelo, aviso "JANELA DE DANO" na barra). Todos têm **3 fases** (marcadas na barra em 66% e 33%): cada fase acrescenta um golpe. Os quatro Generais usam a **IA Adaptativa** (resistem à classe que os venceu nas últimas runs e mostram a mutação sobre a cabeça).

1. **General da Água (`obj_boss`) — "Tênis Glacial":** lança um **Orbe Glacial** lento e teleguiado. Qualquer ataque do jogador rebate o orbe; se voltar e o General não conseguir devolver, ele fica **CONGELADO** (4,5s). Fase 1 ele não devolve; fase 2 devolve 1x; fase 3 devolve 2x (cada vez mais rápido). Também: rajada em leque (pausa enquanto o orbe está em jogo), pisão contra quem gruda nele (fase 2+: congela o chão em cruz) e **Onda de Maré** (fase 2+), uma faixa que varre a arena com uma brecha por onde passar (fase 3: duas ondas cruzadas).
2. **General Magma (`obj_boss2`) — "Touro de Magma":** a **investida** mira (linha de aviso que trava 0,35s antes) e só para quando bate em algo. Se bater na **parede**: **CROSTA RACHADA** (4s). Se acertar o jogador, ele não fica exposto. **Exceção do Cavaleiro:** com o escudo erguido ele segura a investida — o Cavaleiro comum é arrastado, sente o impacto (dano reduzido pelo bloqueio) e abre uma janela curta de 2s; o **Guardião** (Terra) segura sem recuar e sem dano, abrindo a janela completa de 4s. Também: erupções marcadas que incendeiam o chão (fase 3: 5 pontos), leque de magma (fase 2+), rastro de fogo na investida e pedras caindo ao se chocar (fase 2+), ricochete na parede antes de ficar exposto (fase 3).
3. **General Zephyrus (`obj_boss3`) — "Céu e Chão":** **no ar é intangível** (só a sombra fica no chão) e dispara leques de penas. Depois a sombra persegue o jogador, **trava** e ele **mergulha**. Após o último mergulho fica com as **ASAS PRESAS** (3,5s). Fase 1: 1 mergulho; fase 2: 2 mergulhos + 2 ciclones soltos; fase 3: 3 mergulhos + **vendavais** que empurram o jogador pela arena.
4. **Titã Monolito (`obj_boss4`) — "Costas Expostas":** a **frente é blindada** (golpes ricocheteiam) e o **núcleo brilha nas costas**; ele gira devagar para encarar o jogador (mais rápido a cada fase). **Varredura** em cone na frente. O **pisão** (só quando o jogador está perto) solta uma onda de choque em anel e o deixa **PRESO AO CHÃO** com a couraça aberta (3,2s, dano em qualquer lado). Fase 2: muralhas de pedra atrás de si + pedregulhos que viram obstáculos; fase 3: **giro de 360°** se o jogador acampar nas costas.
5. **O Salvador (`obj_boss_human`) — "Protocolo de Drones":** o **escudo** fica ativo enquanto houver **drones** vivos (`obj_boss_drone`, destrutíveis, ligados ao traje por um cabo de energia). Destruir todos causa **SOBRECARGA** (4,5s); depois ele lança drones novos (2/3/4 por fase). Também: plasma triplo, **laser** que mira e dispara (fase 2: o feixe **varre**; fase 3: **dois feixes** girando) e **ataque orbital** (fase 2+).

**Troca de fase (todos os chefes):** a vida trava no limite da fase (66% / 33%), então nenhum golpe pula uma fase. Ao mudar de fase o chefe encerra a janela de dano em andamento, solta um rugido que empurra o jogador e fica **IMUNE por 1,5s** enquanto muda de postura (`boss_update_phase` / `boss_phase_floor`).

### 6.3.0 Regra do Elemento (2 para 1)
Cada elemento pertence a uma classe e **empresta uma ferramenta** do estilo dela: **Terra → Cavaleiro**, **Água → Arqueiro**, **Fogo → Maga**, **Vento → Assassino**. A classe base continua sendo o corpo (vida, ataque principal, botão de defesa); o elemento acrescenta uma coisa só. A classe no próprio elemento é a **Maestria** (Guardião, Piromante, Caçador das Marés, Algoz do Tufão): na lore, o herói que aprofunda a tradição do próprio povo em vez de aprender com outro (ver `LORE_E_NARRATIVA.md`). Os nomes das especializações evocam a classe emprestada (Duelista, Lanceiro, Cavaleiro Rúnico, Atiradora Arcana, Rastreador).

### 6.3.1 Interações de Classe
Cada classe tem um verbo contra os inimigos — **Cavaleiro segura** investidas com o escudo, **Maga interrompe** canalizações, **Arqueiro derruba** o que voa, **Assassino despista** o que persegue — e cada especialização tem uma interação própria (ex.: Criomante apaga o Slime de Fogo e congela o General Magma; Templária arranca o Gnomo do subsolo). Tabela completa em [`INTERACOES_DE_CLASSE.md`](INTERACOES_DE_CLASSE.md).

### 6.4 Os Espíritos Elementais (Chefes das Arenas)
Criaturas nascidas do próprio poder do elemento, guardiãs de cada arena. Detalhes completos em [`INIMIGOS_ELEMENTAIS.md`](INIMIGOS_ELEMENTAIS.md).
1. **Ondina (Água, `obj_spirit_ondina`):** leque de gotas, clones de água que morrem com 1 golpe e troca de lugar; na fase 2, cura canalizada (interrompível) e cruz de gelo.
2. **Salamandra (Fogo, `obj_spirit_salamandra`):** serpenteia deixando rastro de fogo, cospe leques de fogo e mergulha na lava para emergir sob o jogador.
3. **Sílfide (Vento, `obj_spirit_silfide`):** invisível, só a poeira denuncia; rajada atravessando a arena, anel de bumerangues e, na fase 2, vórtice.
4. **Gnomo (Terra, `obj_spirit_gnomo`):** escava e emerge sob o jogador, arremessa pedregulhos que viram obstáculos e crava estacas atrasadas.

---

## 7. INTELIGÊNCIA ARTIFICIAL & SENTIDOS DOS INIMIGOS

A IA dos inimigos (`scr_ai.gml`) combina comportamentos clássicos de arcade com percepção tática moderna:

```
               \                     /
                \   CONE FRONTAL    /     -> Detecção instantânea por visão direta
                 \  (65° a 90°)    /
                  \               /
                   \             /
                    \   INIMIGO /
                     \   (x, y) /
                      ──────────
                     /          \
                    /   FLANCO   \        -> Sentido Aranha lateral (alerta a 125°)
                   /  (Aranha)    \          *Bypassado pelo Passo Silencioso!*
                  /                \
                 ────────────────────
                 [ PONTO CEGO TRASEIRO ]   -> Invisível ao inimigo (> 125°).
                                             Garante Backstab e aproximação furtiva.
```

1. **Visão Frontal Direta:** Campo cônico onde o inimigo detecta o jogador à distância e transiciona de `patrol` para `chase`.
2. **Sentido Aranha Lateral:** Pressente aproximações laterais a curta distância, virando-se bruscamente para engajar.
   * *Interação com Talento:* O talento **Passo Silencioso** do Assassino desativa o Sentido Aranha dos monstros, permitindo contorná-los sem ser notado.
3. **Ponto Cego Traseiro:** Permite emboscadas, abates silenciosos e multiplicadores colossais de *Backstab*.
4. **Táticas de Bando & Mira Preditiva:** Elites e arqueiros calculam a velocidade do jogador para disparar à frente da trajetória (*lead aim*), enquanto unidades leves tentam flanquear pelas pontas da sala.

---

## 8. INTERFACE, CONTROLES & ÁUDIO RETRO

### 8.1 Esquema Unificado de Controles
* **Movimentação:** `[W][A][S][D]` / `[Setas]` / `Analógico Esquerdo / D-Pad`.
* **Ataque Básico / Confirmar:** `[Z]` / `Enter` / Botão Sul do Gamepad (`A / Cruz`).
* **Habilidade Especial / Defesa / Voltar:** `[X]` / `ESC` / Botão Leste do Gamepad (`B / Círculo`).
* **Ficha do Herói & Talentos:** `[G]` / Botão Norte do Gamepad (`Y / Triângulo`).
* **Pausa do Jogo:** `[P]` / `ESC` / Botão `Start`.
* **Touch Mobile:** Analógico virtual dinâmico e botões virtuais de alta sensibilidade na tela.

### 8.2 HUD & Menus com Semiótica Nintendo
* **Minimapa Vetorial:** Exibe o traçado da masmorra em tempo real, ícones de portas, posição do jogador e indicadores de direção sem vazamento de memória ou sobreposição na tela.
* **Card de Baú Tríplice:** Ao abrir um baú de arena, o jogo pausa e exibe cards nítidos comparando os slots de talento do herói (3 iniciais + 2 extras) com o novo poder sorteado.
* **Ficha do Herói em Duas Colunas:** Painel limpo com árvore de maestria, atributos calculados em tempo real (dano físico, mágico, defesa, velocidade, cadência) e descrições com auto-ajuste de linha (`string_height_ext`).

### 8.3 Síntese Sonora Procedural 16-bit (`scr_audio.gml`)
* **Zero Dependências Externas:** O jogo sintetiza seus próprios efeitos sonoros em tempo de execução via buffers PCM (`audio_create_buffer_sound`):
  * Lâminas, impactos pesados e socos (*noise sweeps* e *crunches*).
  * Parries e defesas perfeitas (*chimes* harmônicos e sinos metálicos).
  * Baús e triunfos (*fanfares* arpejadas em onda senoidal).
  * Vento, fogo e explosões (*filtered brown/white noise*).
* **Vozes Chiptune (Estilo Banjo-Kazooie):** Cada raça e personagem tem um tom próprio definido em `scr_audio` (Rinoceronte grave em serra, Raposa médio suave em seno, Lagarto estalado, Urutau etéreo em tom harmônico). **Pendente:** as vozes ainda não tocam nas caixas de diálogo.
* **Música:** ainda não existe. **Pendente.**

---

## 9. MAPA DE ARQUITETURA TÉCNICA DO PROJETO

### 9.1 Scripts Centrais
* [`scripts/scr_combat/scr_combat.gml`](../scripts/scr_combat/scr_combat.gml): Mecânicas de dano, mitigação inteligente, knockback, projéteis, 210 procs elementais, furtividade e hit-stops.
* [`scripts/scr_talents/scr_talents.gml`](../scripts/scr_talents/scr_talents.gml): Definição dos 211 talentos, sintetizadores de atributos, cálculo de custos balanceados e sistema de baús.
* [`scripts/scr_audio/scr_audio.gml`](../scripts/scr_audio/scr_audio.gml): Gerador PCM matemático de áudio procedural 16-bit e reprodução com pitch randômico.
* [`scripts/scr_ai/scr_ai.gml`](../scripts/scr_ai/scr_ai.gml): Cones de visão, sentido aranha, flanco adaptativo, mira preditiva e patrulhas.
* [`scripts/scr_hud/scr_hud.gml`](../scripts/scr_hud/scr_hud.gml): Desenho de minimapa, status do jogador, barras de vida/mana e avisos de combate.
* [`scripts/scr_dialogue_data/scr_dialogue_data.gml`](../scripts/scr_dialogue_data/scr_dialogue_data.gml): Textos narrativos, diálogos dos heróis, NPCs da vila e do confronto final com o humano.
* [`scripts/scr_locale/scr_locale.gml`](../scripts/scr_locale/scr_locale.gml): Suporte a internacionalização (i18n) e alternância dinâmica de idiomas.

### 9.2 Objetos Vitais
* `obj_player`: Controlador do herói, máquinas de estados (idle, walk, attack, defend, hurt), timers de buffs e entrada de dados.
* `obj_enemy_parent`: Classe-mãe de todos os monstros, física de knockback, atrito no gelo, inteligência artificial e barras de vida flutuantes.
* `obj_boss_human`: Chefe final do jogo com escudo de energia, raio laser orbital e diálogo interativo.
* `obj_pedestal_element`: Receptáculo das quatro essências na vila subterrânea.
* `obj_bonfire`: Ponto de descanso e salvação na vila.
* `obj_midrun_shop`: Interface de compra e melhorias a meio da masmorra.
* `obj_char_select`: Tela de seleção dos quatro heróis com pré-visualização de atributos e lore.

---

## 10. TABELA DE AUDITORIA & REGISTRO DE STATUS

| Componente | Quantidade / Dimensão | Status de Implementação | Verificação de Código |
| :--- | :---: | :---: | :--- |
| **Classes de Herói** | 4 (Rinoceronte, Raposa, Lagarto, Urutau) | 100% Operante | [`obj_player/Create_0.gml`](../objects/obj_player/Create_0.gml) |
| **Afinidades Elementais** | 4 (Água, Fogo, Vento, Terra) | 100% Operante | [`scr_combat.gml`](../scripts/scr_combat/scr_combat.gml) |
| **Catálogo de Talentos** | 211 (50×4 + 11 Gerais) | 100% Concluído | [`scr_talents.gml`](../scripts/scr_talents/scr_talents.gml) |
| **Procs Ativos de Combate** | 211 Efeitos Únicos | 100% Integrado | [`scr_combat.gml`](../scripts/scr_combat/scr_combat.gml) / Projéteis |
| **Mitigação Físico vs Mágico** | 2 Tipos + Retornos Decrescentes | 100% Integrado | [`scr_combat.gml:2205`](../scripts/scr_combat/scr_combat.gml#L2205) |
| **Mecânica de Furtividade** | Perda de Aggro + 80% Vel | 100% Integrado | [`player_enter_stealth()`](../scripts/scr_combat/scr_combat.gml#L1567) |
| **Cancelamento de Habilidade** | `[X]` para Cavaleiro e Maga | 100% Integrado | [`obj_player/Step_0.gml:630`](../objects/obj_player/Step_0.gml#L630) |
| **Hub da Vila Subterrânea** | Fogueira, Ancião, Pedestais | 100% Operante | [`room_village`](../rooms/room_village) |
| **Chefes de Masmorra** | 5 (4 Elementais + Humano) | 100% Operante | [`obj_boss_human`](../objects/obj_boss_human) / `obj_boss 1-4` |
| **Síntese de Áudio Procedural**| 27 Efeitos PCM + 8 Vozes | Efeitos operantes; vozes não tocadas nos diálogos | [`scr_audio.gml`](../scripts/scr_audio/scr_audio.gml) |
| **Música** | — | Não existe | — |
| **Três Finais (Vingança, Conquistador, Síntese)** | 3 | Não implementado (derrotar o Humano leva direto à tela de vitória) | [`obj_stage_gate/Step_0.gml`](../objects/obj_stage_gate/Step_0.gml) |
| **Fonte da Interface** | Liberation Sans (SIL OFL), faixa Latin-1 | Embutida em `datafiles/fonts` | [`ui_font()`](../scripts/scr_locale/scr_locale.gml) |
| **Idiomas** | PT, EN, ES, JA | PT completo; demais parciais; JA sem fonte com caracteres japoneses | [`scr_locale.gml`](../scripts/scr_locale/scr_locale.gml) |
| **Planilhas de Metadados** | Excel `.xlsx` e `.csv` | 100% Sincronizado | [`Talentos_Fallen_Hero.xlsx`](../Talentos_Fallen_Hero.xlsx) (0 Pendências) |

---
*Documento homologado e integrado ao repositório oficial de Fallen Hero.*
