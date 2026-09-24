# Fallen Hero — Especificação de Arte

Documento para o artista: tudo o que o jogo precisa de arte, com tamanhos, animações, cores e o formato de entrega. Hoje **todo o jogo é desenhado por código** (formas simples). Cada item abaixo substitui um desses desenhos; os comportamentos já existem, então a arte só precisa seguir os estados listados.

---

## 1. Regras técnicas gerais

### 1.1 Resolução e escala
* **Tela do jogo:** 1366 × 768, câmera em escala 1:1 (1 pixel da arte = 1 pixel na tela, salvo quando indicado).
* **Vista:** top-down em **3/4** (vemos o chão de cima e a frente dos personagens), como em Zelda: A Link to the Past / Hades.
* **Estilo:** livre (pixel art ou pintado). Se for **pixel art**, desenhe em **metade do tamanho** e o jogo amplia **2×** (valores da coluna "Nativo 2×" nas tabelas). Mantenha a **mesma densidade de pixel** em tudo (personagens, tiles e efeitos).
* **Colisão:** cada personagem tem um círculo de colisão no chão (os "pés"). A arte pode ser maior que o círculo, mas o círculo precisa ficar embaixo do corpo.

### 1.2 Origem (ponto de âncora)
* **Personagens, inimigos, chefes, NPCs:** origem no **centro do círculo de colisão**, na altura do chão (entre os pés). A arte "cresce" para cima a partir daí.
* **Objetos de chão (perigos, selos, portal, poças):** origem no **centro** do objeto.
* **Tiles:** origem no canto superior esquerdo.

### 1.3 Direções
* **Mínimo (MVP):** personagens desenhados **olhando para a direita**; o jogo espelha para a esquerda.
* **Ideal (depois):** 3 direções — lado (espelhado), frente (baixo) e costas (cima).

### 1.4 Formato de entrega
* **PNG com fundo transparente**, uma **tira horizontal** por animação (todos os quadros lado a lado, mesmo tamanho de quadro).
* Todos os quadros de uma mesma entidade com **o mesmo tamanho de tela (canvas)** e a mesma origem.
* **Nome do arquivo:** `spr_<entidade>_<animação>_<n>f.png` — ex.: `spr_knight_walk_6f.png`, `spr_slime_water_death_5f.png`.
* Indique a **velocidade** (quadros por segundo) se for diferente de 10 fps.
* Não é preciso desenhar o "piscar branco" de dano: o jogo faz isso sozinho.

### 1.5 O que o código já faz sozinho (não desenhar)
Números de dano, faíscas de impacto, tremor de tela, piscar de dano, barras de vida flutuantes, sombra circular simples (pode ser substituída), textos e balões de dica.

---

## 2. Paleta e direção de arte

### 2.1 Cores dos elementos (usadas em efeitos, UI e brilhos)
| Elemento | Cor principal |
|---|---|
| Água | `#46AAFF` |
| Fogo | `#FF8228` |
| Vento | `#C8FAFF` |
| Terra | `#AA7D46` |

### 2.2 Paletas dos inimigos (base · sombra · luz · destaque)
Cada família tem cores próprias para não se confundir (principalmente na Água, onde tudo era azul).

| Templo | Slime | Elemental | Conjuradora | Golem | Espírito |
|---|---|---|---|---|---|
| **Água** | `#2D73E1` `#143782` `#96C8FF` `#E6F5FF` (azul oceano) | `#28C8B9` `#0F6969` `#AAFAF0` `#FFFFFF` (turquesa) | `#463796` `#231950` `#C8EBFF` `#96EBFF` (índigo) | `#C8E8FA` `#6991B9` `#FFFFFF` `#6ECDFF` (gelo pálido) | Ondina `#50C8EB` `#1E5AAA` `#C8F5FF` `#FFFFFF` |
| **Fogo** | `#FF7D28` `#962D0F` `#FFD278` `#FFFF00` | `#EB3C23` `#780F0A` `#FFAA3C` `#FFEB6E` | `#73191E` `#370A0F` `#E67832` `#FFC83C` | `#502A23` `#23120F` `#8C503C` `#FF821E` (rocha + magma) | Salamandra `#EB5A1E` `#6E190A` `#FFBE50` `#FFFF00` |
| **Vento** | `#B9F0FA` `#5F9BAF` `#FFFFFF` `#8CE1FF` | `#DCFAFF` `#6EAAC3` `#FFFFFF` `#A0FFDC` | `#E1F0EB` `#559696` `#FFFFFF` `#78E6D2` | `#96A5BE` `#414B64` `#E6F0FF` `#FFF078` (nuvem + raio) | Sílfide `#D2FFF0` `#5AAA96` `#FFFFFF` `#AAFFC8` |
| **Terra** | `#8C6941` `#46321E` `#C8A56E` `#78AA46` | `#967652` `#4B3A28` `#D2B482` `#FFBE50` | `#5F6E37` `#2D3719` `#C8AA6E` `#96DC5A` | `#7D6955` `#3C3228` `#AF9B82` `#78AF46` (pedra + musgo) | Gnomo `#966E46` `#46321E` `#EBE1D2` `#509646` |

### 2.3 Direção de arte (da Lore)
* **Planeta natal (Vila Subterrânea):** paleta seca — vermelho óxido, laranja poeirento, rocha escura, céu acinzentado.
* **Planeta da jornada (templos):** cores vibrantes e saturadas — verdes exuberantes, turquesa, flores roxas, luz dourada.
* **Tecnologia do Salvador / corrupção:** metal frio, cabos, luzes ciano/vermelhas — deve parecer **estranha** ao mundo orgânico dos povos.
* **Leitura acima de tudo:** ataques inimigos precisam de **pose de aviso (telegraph)** bem visível antes do golpe; pontos fracos (núcleo do Titã, costas do slime de terra) precisam se destacar.

---

## 3. Heróis (4 povos)

Um corpo por classe. As **16 especializações** (classe + elemento) usam o **mesmo corpo** com **detalhes na cor do elemento** (faixa, gema, brilho da arma) e **efeitos** próprios (seção 8).

| Classe | Povo | Silhueta (Lore) | Arma |
|---|---|---|---|
| Cavaleiro | **Rinoceronte** | Volumoso, placas de armadura integradas à pele, chifre com anéis de aço rúnico | Espada + escudo grande |
| Maga | **Raposa** | Mantos flutuantes, várias caudas ou adereços cerimoniais, orbes orbitando as garras | Cajado / foco arcano |
| Arqueiro | **Lagarto** | Agachado e atento, cauda para equilíbrio, olhos independentes | Arco longo assimétrico de quitina e fibras |
| Assassino | **Urutau** | Alongado, capa em forma de asas recolhidas, textura de casca de árvore, máscara de bico curto com fendas luminosas | Duas adagas curvas |

**Tamanho:** círculo de colisão de 28 px de diâmetro. Personagem com ~**48 × 64 px na tela**. **Canvas recomendado: 64 × 64** (nativo 2×: 32 × 32), com folga para a arma no ataque.

### 3.1 Animações de cada herói
| Animação | Quadros | Observação |
|---|---|---|
| `idle` | 4 | Respiração |
| `walk` | 6 | |
| `attack` | 4–6 | Cavaleiro: golpe em arco · Maga: conjurar projétil · Arqueiro: puxar e soltar · Assassino: dois cortes rápidos |
| `defend` | 2–4 | Pose da habilidade de defesa (ver 3.2) |
| `hurt` | 2 | |
| `death` | 6 | Cai e fica no chão |
| `victory` | 4 | Opcional (tela final) |

### 3.2 Pose de defesa / especial por especialização
| Classe | Neutro | Água | Fogo | Vento | Terra |
|---|---|---|---|---|---|
| Cavaleiro | Bloqueio de escudo | Lanceiro — ergue a aura | Cavaleiro Rúnico — entra em fúria (pose agressiva) | Duelista — aparar (parry) | Guardião — Bastião (escudo cravado no chão) |
| Maga | Escudo de mana | Atiradora Arcana — cria a redoma de gelo | Piromante — explosão 360° | Ilusionista — teleporte (sumir/aparecer) | Templária — ergue o monolito |
| Arqueiro | Rolamento | Caçador das Marés — cambalhota de névoa | Artilheiro Arcano — salto para trás atirando | Caçador Furtivo — rolamento ciclônico | Sentinela — ancorar no chão |
| Assassino | Ficar invisível (fade) | Rastreador — dissipar em névoa | Alquimista — arremessar bomba de cinzas | Algoz do Tufão — salto das sombras | Cavaleiro Sombrio — pele de obsidiana |

O rolamento/teleporte pode ser a mesma animação com efeito diferente por cima.

### 3.3 Retratos de diálogo (já existem os 4 dos heróis)
`spr_portrait_knight / mage / archer / assassin` — 1024 × 1024 (mostrados em 96 × 96 na caixa de diálogo).

---

## 4. Inimigos comuns (16 + 2 suportes)

Todos com círculo de colisão de **28 px** (≈ **48 × 48 na tela**, canvas **48 × 48**, nativo 2×: 24 × 24). As variantes **Alfa** e **Campeão Raro** são o mesmo sprite ampliado pelo jogo (não precisa desenhar).

**Animações comuns a todos:** `idle/move` (4–6), `windup` (aviso antes do ataque, 2–4), `attack` (2–4), `death` (4–6).

| Família | Água | Fogo | Vento | Terra |
|---|---|---|---|---|
| **Slime** (corpo a corpo) | Investida deixando rastro de gelo; ao morrer **se divide em 2 mini-slimes** (desenhar versão mini, ~60%) | **Incha piscando e explode** abaixo de 30% de vida (`swell` 4f) | **Salta em arco** (`jump`, sombra fica no chão) | **Carapaça na frente** (visível), **rola** em linha (`roll`), fica **tonto** (`dizzy`) com as costas expostas; carapaça **quebrada** (variante) |
| **Elemental** (à distância) | Solta **bolha** lenta | Leque de 3 tiros | Arremessa **bumerangue**; **teleporta** (`vanish`/`appear`) e fica tonto | Crava estaca (`root`: fica enraizado) |
| **Conjuradora** (a "bruxa") | Conjura cruz de gelo (`channel`) | Canaliza 3 meteoros; `exhausted` | Barreira de vento (`barrier`); `exhausted` | Ergue muralhas; `exhausted` |
| **Golem** (mini-chefe, ~**96 × 96**, canvas 96 × 96) | Golem de Gelo | Golem de Lava | **Golem da Tempestade:** estados `solid`, `mist` (translúcido), `tornado` (girando), `dizzy` | **Golem de Pedra:** armadura de 6 placas (`armored` → `broken`), `stomp`, arremesso de pedregulho |

**Suportes:**
* **Fogo-Fátuo** (`obj_wisp`): pequeno, voador, ~**16 × 16**; animação de flutuar e de "infundir" um aliado (brilho).
* **Totem Elemental** (`obj_elem_totem`): estacionário, ~**32 × 48**, uma versão por elemento + **aura no chão** (círculo) na cor do elemento.

---

## 5. Espíritos Elementais (chefes das Arenas)

~**64 × 64 na tela** (colisão 32–40 px). Barra de vida própria. Fase 2 aos 50%.

| Espírito | Estados para desenhar |
|---|---|
| **Ondina** (Água) | flutuar, cuspir leque de gotas, **clone de água** (versão translúcida; a verdadeira tem **coroa de gotas brilhantes**), trocar de lugar, **canalizar cura** (fase 2), atordoada |
| **Salamandra** (Fogo) | serpentear (corpo longo em segmentos: cabeça + 3–5 segmentos), cuspir fogo, **mergulhar na lava** e **emergir**, exposta |
| **Sílfide** (Vento) | invisível (só **poeira** — desenhar a nuvem de poeira), aparecer, rajada, anel de bumerangues, **vórtice** (fase 2) |
| **Gnomo** (Terra) | **cavar** (some no chão com monte de terra), **emergir**, arremessar pedregulho, cravar estacas |

---

## 6. Chefes (Generais corrompidos e O Salvador)

Grandes: **~128–192 px na tela** (colisão de 92 a 124 px de diâmetro). **Canvas recomendado: 192 × 192** (nativo 2×: 96 × 96). Cada um tem 3 fases (a arte pode ganhar rachaduras/brilho mais forte por fase — opcional).

| Chefe | Colisão | Estados para desenhar |
|---|---|---|
| **General da Água** — "Tênis Glacial" (Guardião corrompido, Sereia Criogênica) | 120 px | idle, lançar **Orbe Glacial**, rebater o orbe, rajada em leque, **pisão**, **Onda de Maré**, **CONGELADO** (preso em gelo — janela de dano), recuperar |
| **General Magma** — "Touro de Magma" | 124 px | idle, **mirar investida** (pose de carga), **investida**, bater na parede → **CROSTA RACHADA** (magma exposto — janela de dano), erupção, leque de magma |
| **General Zephyrus** — "Céu e Chão" (Falcão Tempestuoso) | 92 px | **no ar** (sprite no alto + **sombra** no chão, separados), mergulho, **ASAS PRESAS** no chão (janela de dano), leque de penas |
| **Titã Monólito** — "Costas Expostas" (Bastião de Basalto) | 108 px | **frente blindada** e **núcleo brilhante nas costas** (precisa das vistas de frente/lado/costas ou do núcleo desenhado separado), varredura em cone, **pisão**, **PRESO AO CHÃO** com a couraça aberta, giro 360° |
| **O Salvador** — exoesqueleto de combate | 96 px | flutuar, **escudo de energia** (bolha), **SOBRECARGA** (escudo caído, faíscas — janela de dano), plasma triplo, mirar/disparar **laser**, ataque orbital |
| **Drone do Salvador** | 24 px | ~32 × 32, flutuar, atirar, com cabo de energia até o Salvador (o jogo desenha o cabo) |

**Revelação final:** a couraça do Salvador **estilhaça** e revela **Dr. Victor**, um homem comum, ferido, caído no chão (1 sprite ou ilustração).

---

## 7. NPCs, retratos e personagens da história

| Personagem | Sprite no mundo | Retrato (1024 × 1024, exibido em 96 × 96) |
|---|---|---|
| **Ancião Tatupóba** (tatu, vila) | ~48 × 64, idle | Sim |
| **Mercador das Marés** (loja no meio da expedição) | ~48 × 64 + **barraca/tapete** com mercadorias | Sim |
| **4 Generais** | (seção 6) | Sim, um por General (versão corrompida) |
| **O Salvador** (armadura) e **Dr. Victor** (sem armadura) | (seção 6) | Sim, os dois |
| **4 Espíritos** | (seção 5) | Sim, um por espírito |
| **Bonecos de treino** (vila) | ~32 × 48: parado e com espada de madeira (`windup` e `swing`) | Não |

---

## 8. Efeitos visuais (VFX)

Tiras curtas (4–8 quadros), fundo transparente. Tamanhos na tela.

### 8.1 Ataques dos heróis
| Efeito | Tamanho | Uso |
|---|---|---|
| Arco de espada | ~64 × 64 | Cavaleiro (versões por elemento: azul/laranja/branco/marrom) |
| Flecha | ~16 × 4 | Arqueiro (normal, gelo, fogo, vento, pesada) |
| Adaga arremessada / faca espectral | ~12 × 12 | Assassino, Rastreador |
| Projétil arcano / bola de fogo / lança de gelo / raio | ~16 × 16 | Maga (uma cor por especialização) |
| Lâmina d'água | ~32 × 12 | Lanceiro |
| Explosão de runa de fogo | ~96 × 96 | Cavaleiro Rúnico |
| Estilhaços de gelo | ~8 × 8 | Lança Estilhaçante |

### 8.2 Defesas e especiais
Escudo de mana (bolha), aura do Lanceiro, fúria ardente (chamas no corpo), brilho de parry, Bastião (escudo de pedra), redoma de gelo, explosão 360° de fogo, arco elétrico do teleporte, monolito basáltico (pilar ~32 × 64), névoa da cambalhota, fumaça do salto para trás, rolamento ciclônico, âncora no chão, invisibilidade (fade), névoa do Rastreador, nuvem da bomba de cinzas (~96 × 96), rastro do salto das sombras, pele de obsidiana (brilho escuro).

### 8.3 Ataques inimigos
Bolha d'água (prende), tiro de fogo, bumerangue, estaca de terra (surge do chão), meteoro (+ marcador de queda), cruz de gelo, pedregulho (vira obstáculo), muralha de pedra, barreira/vórtice de vento, orbe glacial do General, onda de maré (faixa horizontal), laser do Salvador, impacto orbital (+ marcador), penas do Zephyrus, onda de choque em anel.

### 8.4 Chão e marcadores
Rastro de gelo escorregadio, chão em chamas, brasas, névoa/poeira, **círculos de aviso** (vermelho translúcido), linha de mira da investida.

---

## 9. Tileset (cenários)

As salas são montadas por código em blocos. Por isso **as paredes precisam ser "esticáveis"** (o código cria paredes de qualquer largura/altura).

### 9.1 Grade
* **Tile de chão/parede: 48 × 48 na tela** (nativo 2×: 24 × 24). *Hoje a grade das masmorras é de 45 px; quando os tiles chegarem eu ajusto o código para 48.*
* Cada câmara da masmorra tem **16 × 12 tiles**; a masmorra é uma grade de 3 × 3 câmaras.

### 9.2 Conjunto por cenário
Para **cada** cenário da lista 9.3:
| Peça | Detalhe |
|---|---|
| **Chão** | 1 tile base **sem emenda** + 3–4 variações (rachadura, musgo, detalhe) |
| **Parede** | Conjunto **9-slice** (4 cantos, 4 bordas, centro) **ou** autotile de 16/47 peças. Vista 3/4: **topo** da parede + **face frontal** (~24 px de altura) |
| **Pilar / obstáculo** | ~48 × 48 e ~96 × 96 (os blocos de cobertura das salas) |
| **Porta selada do chefe** | Barricada, 4 tiles de largura (180–192 px), estados fechada/abrindo |
| **Decoração** | 6–10 peças soltas (plantas, pedras, estátuas, tochas, poças, ossos...) |
| **Sombra de parede** | Faixa escura translúcida na base da face da parede |

### 9.3 Cenários
| Cenário | Tema |
|---|---|
| **Templo da Água** | Ruínas submersas, colunas cobertas de algas, poças, gelo nas bordas (Povo Lagarto: pântano) |
| **Templo do Fogo** | Cratera vulcânica, basalto, rios de magma nas bordas (Povo Raposa) |
| **Templo do Vento** | Copas das árvores gigantes, plataformas de madeira, nuvens (Povo Urutau) |
| **Templo da Terra** | Fortaleza de basalto nas planícies, pedra maciça (Povo Rinoceronte) |
| **Arena** (uma por templo) | Mesmo tema do templo + **runa central** no chão (~128 × 128) e **barreira** circular |
| **Loja do Mercador** | Sala neutra e acolhedora, tapetes, lanternas |
| **Vila Subterrânea** | Caverna habitada, paleta seca do planeta natal; casas (em produção em outro computador), fogueiras, 4 pedestais, portal |
| **Santuário Orbital** (Templo 5 / Salvador) | Nave/estação humana: metal, painéis, janela com o planeta verde lá embaixo |

---

## 10. Objetos interativos, perigos e armadilhas

| Objeto | Tamanho na tela | Estados / animação |
|---|---|---|
| **Selo** (`obj_boss_button`) | 40 × 40 | apagado (pulsando) → **ativado** (coluna de luz) |
| **Portal de saída** (`obj_stage_gate`) | 80 × 80 | fechado, aberto (girando), **4 luzes** ao redor (apagada/acesa) |
| **Baú** | 44 × 44 | fechado, abrindo (4f), aberto |
| **Orbe de cura** | 44 × 44 | flutuando (4f) |
| **Rastro de luz do selo** | 16 × 16 | voando (4f) |
| **Pedestais das Essências** (vila, 4) | ~48 × 64 | vazio / aceso (um por elemento) |
| **Fogueira** (vila) | ~48 × 48 | fogo (6f) |
| **Portal da vila** | ~96 × 96 | vórtice (8f) |
| **Gelo escorregadio** | 32 × 32 | estático |
| **Poça d'água** | ~48 × 32 | ondulando |
| **Poça de lava** | 32 × 32 | borbulhando |
| **Lava cíclica** | 32 × 32 | apagada → aviso → ativa |
| **Areia movediça** | 48 × 48 | girando devagar |
| **Ciclone** | 48 × 48 | girando (6f), se move |
| **Corrente de vento** | faixa | setas/linhas de vento em movimento |
| **Fissura da terra** | ~64 × 24 | fechada → abre |
| **Armadilha de espinhos** | 32 × 32 | recolhida → aviso → espinhos para fora |
| **Armadilha de gás** | saída + nuvem (raio 70) | nuvem verde (6f) |
| **Esmagador** | raio 60 | bloco erguido → cai |
| **Armadilha de dardos** | ~32 × 32 + dardo 12 × 4 | disparo |

---

## 11. Interface (UI)

Resolução da interface: **1366 × 768**. Peças **9-slice** para caixas (qualquer tamanho).

| Peça | Observação |
|---|---|
| **Logo "FALLEN HERO"** + subtítulo "As Crônicas dos Elementos" | Tela inicial |
| **Fundo da tela inicial** | Ilustração 1366 × 768 |
| **Caixa/painel 9-slice** | Menus, ficha do herói, loja, baú, opções |
| **Botão** (normal, selecionado, desativado) | 9-slice |
| **Card do herói (HUD)** | Moldura com barras de **vida**, **XP** e **recarga da habilidade** |
| **Barra de vida do chefe** | Topo da tela, larga, com moldura |
| **Minimapa** | Moldura + ícones: herói, selo (pendente/ativado), portal, baú, inimigo, chefe, mercador |
| **Caixa de diálogo** | 880 × 150, espaço do retrato 96 × 96 |
| **Ícones de talento** (32 × 32 ou 48 × 48) | 30 tipos: `arrow_speed`, `barrier`, `bastion`, `block`, `boot`, `bow`, `burn`, `cdr`, `crit`, `dagger`, `dodge`, `execute`, `fireball`, `fury`, `gold`, `haste`, `holy`, `lifesteal`, `magic_def`, `pierce`, `poison`, `regen`, `riposte`, `rock`, `second_wind`, `shield`, `shockwave`, `sword`, `thorns`, `wind` |
| **Ícones de elemento** | Água, Fogo, Vento, Terra, Neutro |
| **Ícones de classe** | Cavaleiro, Maga, Arqueiro, Assassino |
| **Ícones das 16 especializações** | Opcional |
| **Ícones de botão** | Teclado (Z, X, ESC, T, setas, 1–5), **Xbox** (A, B, X, Y, Start, LB/RB), **PlayStation** (✕, ○, □, △, Options, L1/R1), toque |
| **Moeda de ouro**, **ponto de talento**, **selo** (ícones pequenos) | HUD e loja |
| **Fonte** | Hoje: Liberation Sans. Se quiser uma fonte própria (ex.: pixel), precisa ter **acentos do português** (á, ã, ç, é, ê, í, ó, õ, ú) |

---

## 12. Telas de história

| Tela | Formato |
|---|---|
| **Revelação** (Dr. Victor caído, planeta verde na janela) | Ilustração 1366 × 768 (opcional; hoje é só texto) |
| **Final da Vingança** | 1–3 ilustrações (vila revivendo / abrigos humanos apagando) |
| **Final do Conquistador** | 1–3 ilustrações (cúpula caindo / herói no trono) |
| **Final da Síntese** | 1–3 ilustrações (ponte entre os mundos / criança humana e filhote sob o mesmo céu) |
| **Fundo dos créditos** | 1366 × 768 |

---

## 13. Prioridades de produção

| Prioridade | Itens |
|---|---|
| **1 — Jogável bonito** | 4 heróis (idle, walk, attack, defend, hurt, death) · 16 inimigos comuns + fogo-fátuo + totem · tileset do **Templo da Água** + **Vila** · selo, portal, baú, orbe de cura · HUD, caixas e botões · logo |
| **2 — Campanha completa** | 4 golems · 4 espíritos · 5 chefes + drone · tilesets de **Fogo, Vento, Terra**, arenas, loja e **Santuário Orbital** · perigos e armadilhas · retratos (Ancião, Mercador, Generais, Salvador, Dr. Victor, Espíritos) · ícones de talento |
| **3 — Acabamento** | VFX de todas as especializações · poses de especial por especialização · 3 direções dos personagens · ilustrações dos finais e da revelação · ícones de botão por controle · ícones de especialização |

---

## 14. Arte que já existe no projeto (referência)
* `spr_portrait_knight / mage / archer / assassin` — retratos 1024 × 1024 (em uso nos diálogos).
* `sprites/main_soldier.png`, `main_mage.png`, `main_archer.png`, `main_assassin.png` (600 × 600) — artes conceituais iniciais.
* `sprites/water_slime.png`, `water_elemental.png` (256 × 256), `tileset.png` (128 × 96), `soldier_attack.png`, `soldier_sword.png` — testes antigos, podem ser substituídos.
