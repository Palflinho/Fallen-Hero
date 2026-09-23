# Fallen Hero — Bestiário Elemental

Os inimigos são criaturas criadas a partir do poder dos elementos (slimes, elementais, conjuradores, golens, espíritos). Cada família tem uma mecânica própria por elemento.

## Regras de leitura (Miyamoto / Sakurai)

- **Forma = tipo de ataque:** círculo no chão = área; linha = investida; seta = projétil.
- **Cor = elemento:** azul = Água, laranja = Fogo, branco/ciano = Vento, marrom = Terra.
- **Todo golpe forte deixa uma janela de vulnerabilidade.** Durante a janela o inimigo recebe **+50% de dano**. Um anel amarelo pulsante aparece em volta dele.
- Qualquer estado de preparação (`*_windup`, `*_warn`) mostra o balão **"!"** sobre a cabeça.

## Slimes

| Elemento | Mecânica | Como punir |
|---|---|---|
| Água (`obj_slime`) | **Investida** com linha de aviso, deixando um **rastro de gelo escorregadio** (3s). Ao morrer **se divide em 2 mini-slimes**. Se os dois continuarem vivos por 3s, correm um para o outro e **se reúnem** com 60% de vida. Um fio de água liga os minis. | Mate um dos minis antes que se reúnam. |
| Fogo (`obj_fire_slime`) | Abaixo de 30% de vida **incha piscando por 1,2s e explode** (raio 64), ferindo o jogador **e os outros inimigos**, e deixando brasas no chão. | Termine o slime durante o inchaço, ou atraia-o para perto de outros inimigos. |
| Vento (`obj_wind_slime`) | **Salta em arco** até onde o jogador estava; a sombra marca o pouso. **No ar fica intangível.** O pouso causa dano e empurrão radial. | Saia do círculo e bata nele nos 0,5s após o pouso. |
| Terra (`obj_earth_slime`) | **Carapaça frontal:** golpes pela frente ricocheteiam (0 de dano). 3 golpes na carapaça a quebram. **Rola em linha** e fica tonto 0,9s girando (as costas ficam expostas). | Ataque pelas costas ou force o rolamento contra uma parede (fica tonto por mais tempo). |

## Elementais

| Elemento | Mecânica | Como punir |
|---|---|---|
| Água (`obj_elemental`) | **Bolha lenta teleguiada.** Se tocar, prende o jogador por 1s. **Qualquer ataque estoura a bolha.** | Estoure a bolha e avance. |
| Fogo (`obj_fire_elemental`) | **Leque de 3 tiros.** Onde cada tiro bate, o chão **queima por 3s**. Fica 0,6s parado após disparar. | Avance entre os tiros durante a recuperação. |
| Vento (`obj_wind_elemental`) | Arremessa **bumerangues** (acertam na ida e na volta). Se o jogador chega perto, **se teleporta** para longe... mas fica **0,5s atordoado** ao reaparecer. | Siga o rastro tracejado do teleporte e puna. |
| Terra (`obj_earth_elemental`) | **Estaca atrasada:** um marcador segue o jogador, trava e a estaca irrompe **0,8s depois**. Fica 0,6s enraizado ao cravar. | Continue se movendo; ataque enquanto ele crava. |

## Conjuradores

| Elemento | Mecânica | Janela |
|---|---|---|
| Água (`obj_frost_caster`) | **Cruz de gelo "+"** a partir do ponto sob o jogador; as células viram **gelo escorregadio por 6s**. | As diagonais são seguras. |
| Fogo (`obj_magma_caster`) | **3 meteoros encadeados**: cada um marca a posição atual do jogador e cai 0,85s depois. | Fica **exausto 1s** após canalizar. |
| Vento (`obj_wind_caster`) | **Barreira de vento (3s):** reflete flechas e bolas de fogo e cria um **vórtice** que puxa o jogador para o olho do furacão (que causa dano). Golpes corpo a corpo atravessam a barreira. Sem a barreira, lança uma rajada em área que empurra. | **Exausto 1s** após a barreira. |
| Terra (`obj_earth_caster`) | **Muralhas de pedra** temporárias (4s) dos dois lados do jogador, formando um corredor, seguidas de um **tremor** sob ele. | **Exausto 0,8s** após o tremor. |

## Golens (mini-chefes da sala pré-chefe)

- **Golem de Gelo** e **Golem de Lava** — mantidos como estavam.
- **Golem de Tempestade (`obj_storm_golem`, Vento):** alterna **sólido** (dispara rajada em leque) e **névoa** (intangível e translúcido, só se reposiciona). Vira **tornado** e persegue girando e empurrando por 2,2s; depois fica **tonto 2s** (+50% de dano).
- **Golem de Pedra (`obj_stone_golem`, Terra):** **inempurrável**. Tem **armadura** (6 placas): enquanto houver armadura recebe só 35% do dano; cada golpe arranca uma placa. Sem placas → **ARMADURA QUEBRADA**: atordoado 2,5s e +50% de dano. A armadura se refaz 8s depois. **Pisão** com onda de choque em anel que se expande; **arremessa pedregulhos** que viram obstáculos por 7s.

## Suportes

- **Fogo-fátuo (`obj_wisp`):** pequeno, frágil e voador. Não ataca: voa até um aliado e o **infunde** por 1s, tornando-o elite (afixo aleatório, cura 30%, mais força). Foge se o jogador chegar perto. Mate-o antes!
- **Totem Elemental (`obj_elem_totem`):** estacionário, com aura visível no chão. Água cura, Fogo acelera, Vento **reflete projéteis**, Terra concede **escudo de pedra** (absorve 1 golpe). É prioridade de alvo.

## Espíritos Elementais (chefes das Arenas)

Depois da última onda, o espírito do templo desperta no centro da arena. Barra de vida própria no topo da tela; aos 50% entra na **fase 2**.

- **Ondina (Água):** leque de gotas; **clones de água** (morrem com 1 golpe; a verdadeira tem uma coroa de gotas brilhantes) e troca de lugar com um deles. Fase 2: **cura canalizada** (cause 8% da vida dela em dano para **interromper** → atordoada 2s) e cruz de gelo.
- **Salamandra (Fogo):** **serpenteia** deixando rastro de fogo; cuspe em leque; **mergulha na lava** (intangível), persegue por baixo e **emerge** sob o jogador após aviso circular → exposta 1,3s. Fase 2: mergulha 2 vezes seguidas e a erupção solta um anel de fogo.
- **Sílfide (Vento):** **invisível**, só a poeira denuncia onde está (pode ser atingida mesmo invisível). **Rajada** que atravessa a arena, **anel de bumerangues**. Fase 2: **vórtice** que puxa e reflete projéteis.
- **Gnomo (Terra):** **escava** e emerge sob o jogador; **pedregulhos** que viram obstáculos; **3 estacas** atrasadas. Fase 2: ao emergir levanta um anel de estacas e arremessa 2 rochas.

## Onde aparecem

- **Exploração 2:** um Fogo-fátuo.
- **Exploração 3:** um Totem Elemental no centro.
- **Arena:** Fogo-fátuo a partir da 2ª onda, Totem na última onda e, por fim, o Espírito.
- **Pré-chefe:** Golem de Gelo (Água), Lava (Fogo), Tempestade (Vento), Pedra (Terra).
- **Masmorra procedural:** conjuradores têm 30% de chance de vir com um Totem; atiradores têm 20% de chance de vir com um Fogo-fátuo.

## Ganchos técnicos (para novos inimigos)

Variáveis genéricas em `obj_enemy_parent` (tratadas em `enemy_take_damage` e no Draw base):
`fh_untargetable`, `fh_shell_hits`/`fh_shell_arc`, `fh_vuln_timer`, `fh_haste_timer`, `fh_totem_shield`, `fh_infused`, `draw_z`, `draw_alpha`, `atk_scale`.
Helpers em `scripts/scr_elemental_ai`: `elem_dmg`, `elem_push_player`, `elem_hit_player_circle`, `elem_spawn_ground`, `elem_spawn_missile`, `elem_raise_wall`, `elem_reflect_player_projectiles`, `spirit_init`...
Efeitos: `obj_elem_ground` (chão de fogo/gelo), `obj_elem_missile` (bolha, tiro de fogo, bumerangue, estaca, meteoro, cruz de gelo, pedregulho), `obj_elem_wall` (parede temporária, filha de `obj_wall`).
