# FALLEN HERO — GAME DESIGN DOCUMENT (GDD) COMPLETO & OFICIAL
**Versão:** 3.0 (Master Gold Definitive)  
**Engine:** GameMaker LTS (Compatibilidade GML LTS 2026)  
**Gênero:** Top-Down Action Roguelike RPG com Progressão Elemental  
**Inspirações de Design:** *Hades*, *Dead Cells*, *Hyper Light Drifter*, *Super Smash Bros* (Filosofia Sakurai) e *The Legend of Zelda* (Filosofia Miyamoto)  
**Status do Projeto:** 100% Integrado, Compilável e Validado na branch `main`

---

## 1. RESUMO EXECUTIVO & VISÃO GERAL

### 1.1 Premissa do Jogo
Em **Fallen Hero**, o jogador assume o papel de um dos quatro campeões remanescentes de um mundo agonizante. Quatro raças antropomórficas inspiradas na fauna brasileira — o **Tatu-Bola** (Cavaleiro), a **Lobo-Guará** (Maga), o **Lagarto Teiú** (Arqueiro) e o **Pássaro Urutau** (Assassino) — atravessam um portal dimensional arcaico para caçar o suposto "Mal Supremo" que roubou as quatro Essências Elementais de seu planeta, transformando sua pátria em um deserto vermelho de ferrugem e cinzas.

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

## 3. OS QUATRO HERÓIS JOGÁVEIS (FAUNA BRASILEIRA)

```
       [ O TATU-BOLA ]                     [ A LOBO-GUARÁ ]
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

### 3.1 Cavaleiro (Tatu-Bola — Macho)
* **Atributos Base:** HP 140, Dano 12, Defesa Física 4, Velocidade 150 px/s.
* **Ataque Básico:** Talho frontal amplo (varredura de espada em 180° com repelência física).
* **Habilidade Especial (Defesa / [X]):** Ergue o escudo. Bloqueia 50% a 100% de dano frontal, absorve projéteis.
  * **QoL Integrada:** Pode cancelar a qualquer instante antes do fim da duração apertando `[X]` novamente.
* **Afinidades Elementais:**
  * *Água (Paladino):* Gera barreira de sobrevida sagrada e ondas de cura em combate.
  * *Fogo (Berserker):* Converte vida perdida em velocidade e dano em labaredas; fúria imortal.
  * *Vento (Duelista):* Concede combo duplo de lâmina veloz e rajadas cortantes de ar.
  * *Terra (Guardião Tectônico):* Aumenta a couraça corporal proporcionalmente aos inimigos próximos.

### 3.2 Maga (Lobo-Guará — Fêmea)
* **Atributos Base:** HP 90, Dano 18, Defesa Mágica 5, Velocidade 155 px/s.
* **Ataque Básico:** Disparo de esferas místicas de longo alcance com aceleração contínua.
* **Habilidade Especial (Defesa / [X]):** Prisão Criogênica / Campo de Mana. Concede invulnerabilidade temporária estática.
  * **QoL Integrada:** Cancelável a qualquer momento com `[X]`.
* **Afinidades Elementais:**
  * *Água (Criomante):* Nova glacial e ondas torrenciais que empurram inimigos por 150px.
  * *Fogo (Piromante):* Dispara meteoros de magma devastadores e sopros de dragão.
  * *Vento (Aeromante):* Vórtice de gravidade galvânica que puxa e esquiva de projéteis em movimento.
  * *Terra (Geomante):* Ruptura sísmica perfurante e muralhas protetoras de granito.

### 3.3 Arqueiro (Lagarto Teiú — Macho)
* **Atributos Base:** HP 100, Dano 15, Cadência Alta, Velocidade 165 px/s.
* **Ataque Básico:** Disparo de flechas lineares de alta perfuração com dano escalonado pela distância percorrida.
* **Habilidade Especial (Defesa / [X]):** Rolamento Tático Evasivo com quadros de invulnerabilidade total.
* **Afinidades Elementais:**
  * *Água (Glacial):* Pistas escorregadias de gelo e névoas ilusórias que cegam os perseguidores.
  * *Fogo (Balista Piromante):* Flechas explosivas de fósforo e tornados ígneos a cada 3 tiros.
  * *Vento (Tempestade):* Tiro supersônico, tempestade de 9 flechas em leque e reflexos de esquiva.
  * *Terra (Arpão Tectônico):* Tiros cataclísmicos colossais e atordoamento por impacto contra paredes.

### 3.4 Assassino (Pássaro Urutau — Andrógino / Mãe-da-lua)
* **Atributos Base:** HP 95, Dano 14, Taxa Crítica 20%, Velocidade 180 px/s.
* **Ataque Básico:** Golpes rápidos de adagas curvas com bônus de 50% a 175% por golpe nas costas (*Backstab*).
* **Habilidade Especial (Defesa / [X]):** Passo Espectral / Furtividade.
  * **Mecânica de Aggro:** Ao ativar, chama imediatamente [`player_enter_stealth()`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_combat/scr_combat.gml#L1567-L1579), forçando todos os inimigos a perderem a visão e retornarem para patrulha.
  * **Movimentação Tática:** Move-se a 80% da velocidade normal enquanto invisível.
  * **Emboscada:** Quebra a invisibilidade atacando para desferir um acerto crítico garantido e plantar uma Mina de Basalto.
* **Afinidades Elementais:**
  * *Água (Espectro):* Passo fantasma que teletransporta para trás do alvo e ceifa em 360°.
  * *Fogo (Vulcânico):* Bomba de cinzas com cegueira, marcas de enxofre e lâmina de magma derretido.
  * *Vento (Tufão):* Reflexos que cortam projéteis inimigos em voo e tornados de adagas frontais.
  * *Terra (Obsidiana):* Ignora armadura física de elites e crava adagas no solo em choques tectônicos.

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

O catálogo de talentos está 100% definido em [`scr_talents.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_talents/scr_talents.gml) e operante nos eventos de combate:

### 5.1 Distribuição Estrutural (211 Talentos Totais)
* **Cavaleiro (50 Talentos):**
  * 10 Base (Postura Firme, Lâmina Afiada, Golpe Pesado, Escudo de Choque, Segundo Fôlego, etc.)
  * 8 Água / Paladino (Lâmina da Maré, Bastilha Sagrada, Escudo Espelhado, Julgamento Sereno, etc.)
  * 8 Fogo / Berserker (Fúria Ardente, Lâmina em Brasa, Fúria Imortal, Impacto Vulcânico, etc.)
  * 8 Vento / Duelista (Combo Vendaval, Postura Eólica, Lâmina Relâmpago, Dança das Lâminas, etc.)
  * 8 Terra / Guardião (Fissura Telúrica, Carapaça de Granito, Fortaleza Viva, Peso Esmagador, etc.)
  * 8 Lendários / Mestria (Cavaleiro do Apocalipse, Avatar Elemental, etc.)
* **Maga (50 Talentos):**
  * 10 Base (Canalização Fluida, Eco Mágico, Fluxo Conduzido, etc.)
  * 8 Água / Criomante (Onda Torrencial, Lança de Zero Absoluto, Prisma de Gelo, etc.)
  * 8 Fogo / Piromante (Meteoro de Magma, Sopro de Dragão, Conflagração Furiosa, etc.)
  * 8 Vento / Aeromante (Vórtice Cortante, Olho do Furacão, Passo Céfiro, etc.)
  * 8 Terra / Geomante (Ruptura Sísmica, Espinhos Telúricos, Armadura de Granito, etc.)
  * 8 Lendários / Mestria (Singularidade Dimensional, Conjurador Supremo, etc.)
* **Arqueiro (50 Talentos):**
  * 10 Base (Tiro em Corrida, Aljava Leve, Reflexo do Caçador, Flecha Pesada, etc.)
  * 8 Água / Glacial (Pista Escorregadia, Névoa Ilusória, etc.)
  * 8 Fogo / Balista (Balista Piromante, Tempestade Ígnea Aérea, etc.)
  * 8 Vento / Tempestade (Tempestade de Mil Tiros, Tiro Supersônico, Dança dos Ventos, etc.)
  * 8 Terra / Caçador de Basalto (Tiro Cataclísmico, Flecha Arpão de Pedra, etc.)
  * 8 Lendários / Mestria (Atirador Fantasma, Falcão Cósmico, etc.)
* **Assassino (50 Talentos):**
  * 10 Base (Golpe Jugular, Passo Silencioso, Esquiva Reflexa, Execução Fria, Lâminas Gêmeas, etc.)
  * 8 Água / Espectro (Passo das Marés, Maré da Ceifa, Estocada de Gelo Fino, etc.)
  * 8 Fogo / Vulcânico (Passo Explosivo, Marca do Enxofre, Lâmina de Magma, Supernova Sombria, etc.)
  * 8 Vento / Tufão (Celeridade Fantasma, Reflexos Célere, Tornado de Adagas, Esquiva Espectral, etc.)
  * 8 Terra / Obsidiana (Corte de Obsidiana, Pele Pétrea, Mina de Basalto, Golpe Tectônico, etc.)
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
2. **Arena de Desafio (Etapa 3):** Portas trancam-se magicamente; o jogador enfrenta 3 ondas escalonadas de inimigos com elites. A vitória gera o **Baú de Tesouro com Cards Comparativos** no estilo Nintendo.
3. **Loja de Intermissão (Etapa 4):** Espaço neutro protegido pelo Mercador Interdimensional. Permite comprar poções de cura, aumentos definitivos de ataque/defesa para a run e trocar talentos ativos.
4. **Exploração Avançada & Pré-Chefe (Salas 5 e 6):** Densidade máxima de inimigos e sala de preparação com fontes de cura.
5. **Câmara do Guardião (Etapa 7):** Batalha contra o chefe elemental do bioma.

### 6.3 Os Cinco Grandes Chefes
1. **Templo da Água — Golem de Gelo Arcaico (`obj_boss`):** Estilhaços criogênicos, tempestades de granizo e congelamento do solo.
2. **Templo do Fogo — Titã de Magma Vulcânico (`obj_boss2`):** Poças de lava permanentes, ondas de calor radiante e erupções subterrâneas.
3. **Templo do Vento — Falcão das Tempestades (`obj_boss3`):** Ciclones móveis, investidas aéreas ultrarrápidas e zonas de vácuo cortante.
4. **Templo da Terra — Colosso Tectônico (`obj_boss4`):** Fissuras sísmicas no solo, terremotos de impacto e armadura impenetrável que exige quebra de postura (*stagger*).
5. **Santuário Orbital — O Guardião Humano (`obj_boss_human`):**
   * *Fase 1 (Armadura Titânica):* Disparos de laser contínuo (`laser_beam`), escudos de energia defletores (`energy_shield`) e convocação de drones de vigilância.
   * *Fase 2 (Sobrecarga de Emergência):* Sobrecarga de propulsores, pulsos EMP e chuvas de artilharia orbital.
   * *Desfecho Dramático:* Quebra da couraça e diálogo final do humano, desvendando o segredo da Terra.

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
* **Card de Baú Tríplice:** Ao abrir um baú de arena, o jogo pausa e exibe cards nítidos comparando os três slots de talento do herói com o novo poder sorteado.
* **Ficha do Herói em Duas Colunas:** Painel limpo com árvore de maestria, atributos calculados em tempo real (dano físico, mágico, defesa, velocidade, cadência) e descrições com auto-ajuste de linha (`string_height_ext`).

### 8.3 Síntese Sonora Procedural 16-bit (`scr_audio.gml`)
* **Zero Dependências Externas:** O jogo sintetiza seus próprios efeitos sonoros em tempo de execução via buffers PCM (`audio_create_buffer_sound`):
  * Lâminas, impactos pesados e socos (*noise sweeps* e *crunches*).
  * Parries e defesas perfeitas (*chimes* harmônicos e sinos metálicos).
  * Baús e triunfos (*fanfares* arpejadas em onda senoidal).
  * Vento, fogo e explosões (*filtered brown/white noise*).
* **Vozes Chiptune (Estilo Banjo-Kazooie):** Cada raça e personagem possui um tom de modulação sonora próprio durante as caixas de diálogo (Tatu grave em serra, Lobo médio suave em seno, Lagarto estalado, Urutau etéreo em tom harmônico).

---

## 9. MAPA DE ARQUITETURA TÉCNICA DO PROJETO

### 9.1 Scripts Centrais
* [`scripts/scr_combat/scr_combat.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_combat/scr_combat.gml): Mecânicas de dano, mitigação inteligente, knockback, projéteis, 210 procs elementais, furtividade e hit-stops.
* [`scripts/scr_talents/scr_talents.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_talents/scr_talents.gml): Definição dos 211 talentos, sintetizadores de atributos, cálculo de custos balanceados e sistema de baús.
* [`scripts/scr_audio/scr_audio.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_audio/scr_audio.gml): Gerador PCM matemático de áudio procedural 16-bit e reprodução com pitch randômico.
* [`scripts/scr_ai/scr_ai.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_ai/scr_ai.gml): Cones de visão, sentido aranha, flanco adaptativo, mira preditiva e patrulhas.
* [`scripts/scr_hud/scr_hud.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_hud/scr_hud.gml): Desenho de minimapa, status do jogador, barras de vida/mana e avisos de combate.
* [`scripts/scr_dialogue_data/scr_dialogue_data.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_dialogue_data/scr_dialogue_data.gml): Textos narrativos, diálogos dos heróis, NPCs da vila e do confronto final com o humano.
* [`scripts/scr_locale/scr_locale.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_locale/scr_locale.gml): Suporte a internacionalização (i18n) e alternância dinâmica de idiomas.

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
| **Classes de Herói** | 4 (Tatu, Lobo, Lagarto, Urutau) | 100% Operante | [`obj_player/Create_0.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/objects/obj_player/Create_0.gml) |
| **Afinidades Elementais** | 4 (Água, Fogo, Vento, Terra) | 100% Operante | [`scr_combat.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_combat/scr_combat.gml) |
| **Catálogo de Talentos** | 211 (50×4 + 11 Gerais) | 100% Concluído | [`scr_talents.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_talents/scr_talents.gml) |
| **Procs Ativos de Combate** | 211 Efeitos Únicos | 100% Integrado | [`scr_combat.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_combat/scr_combat.gml) / Projéteis |
| **Mitigação Físico vs Mágico** | 2 Tipos + Retornos Decrescentes | 100% Integrado | [`scr_combat.gml:2205`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_combat/scr_combat.gml#L2205) |
| **Mecânica de Furtividade** | Perda de Aggro + 80% Vel | 100% Integrado | [`player_enter_stealth()`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_combat/scr_combat.gml#L1567) |
| **Cancelamento de Habilidade** | `[X]` para Cavaleiro e Maga | 100% Integrado | [`obj_player/Step_0.gml:630`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/objects/obj_player/Step_0.gml#L630) |
| **Hub da Vila Subterrânea** | Fogueira, Ancião, Pedestais | 100% Operante | [`room_village`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/rooms/room_village) |
| **Chefes de Masmorra** | 5 (4 Elementais + Humano) | 100% Operante | [`obj_boss_human`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/objects/obj_boss_human) / `obj_boss 1-4` |
| **Síntese de Áudio Procedural**| 24 Efeitos PCM + Vozes Chiptune | 100% Operante | [`scr_audio.gml`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/scripts/scr_audio/scr_audio.gml) |
| **Planilhas de Metadados** | Excel `.xlsx` e `.csv` | 100% Sincronizado | [`Talentos_Fallen_Hero.xlsx`](file:///e:/Documentos/Reposit%C3%B3rios/Fallen-Hero/Talentos_Fallen_Hero.xlsx) (0 Pendências) |

---
*Documento homologado e integrado ao repositório oficial de Fallen Hero.*
