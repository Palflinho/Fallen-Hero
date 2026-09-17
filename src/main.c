/*---------------------------------------------------------------------------------
    Fallen Hero - Super Nintendo (SNES) Native 16-Bit Edition
    Visual Graphic Sprites Engine (Reproduzindo fielmente os graficos do GameMaker)
---------------------------------------------------------------------------------*/
#include <snes.h>
#include "game.h"
#include "sprites.h"

// IDs dos Sprites de Hardware na OAM (Multiplos de 4 obrigatorios no hardware SNES)
#define OAM_PLAYER         (0 * 4)   // 0: Heroi (quadrado com olhinhos)
#define OAM_ATTACK         (1 * 4)   // 4: Arco de corte / golpe
#define OAM_DUMMY          (2 * 4)   // 8: Boneco de treino (alvo bullseye)
#define OAM_NPC0           (3 * 4)   // 12: Tanuki (Japao)
#define OAM_NPC1           (4 * 4)   // 16: Castor (Canada)
#define OAM_NPC2           (5 * 4)   // 20: Bisao (EUA)
#define OAM_NPC3           (6 * 4)   // 24: Ornitorrinco (Australia)
#define OAM_ALTAR          (7 * 4)   // 28: Altar das Essencias
#define OAM_PORTAL         (8 * 4)   // 32: Portal Dimensional (Vila)
#define OAM_BOSS           (9 * 4)   // 36: Guardiao Corrompido / Chefe (Masmorra)
#define OAM_SLIME1         (10 * 4)  // 40: Slime / Minion 1
#define OAM_SLIME2         (11 * 4)  // 44: Slime / Minion 2
#define OAM_PROJECTILE     (12 * 4)  // 48: Disparo Magico do Chefe
#define OAM_ESSENCE        (13 * 4)  // 52: Orbe da Essencia Elemental
#define OAM_DUNGEON_PORTAL (14 * 4)  // 56: Portal de Retorno (Masmorra)

// Instancias Globais
static Player player;
static GameState current_state;
static u8 selected_npc = 0xFF;
static u16 pad_held = 0;
static u16 pad_down = 0;
static u8 hud_dirty = 1;

// Estado da Vila
static u8 dummy_hit_flash = 0;
static u16 dummy_damage = 0;

// Estado da Masmorra
static Boss boss;
static Minion slime1;
static Minion slime2;
static Projectile proj;
static u8 essence_spawned = 0;
static u8 essence_collected = 0;
static u8 dungeon_portal_open = 0;

// Os 4 Contadores de Historia da Vila (Refugiados de outros paises)
static const VillageNPC npcs[4] = {
    {
        64, 100,
        "Anciao Tanuki", "JAPAO",
        "O mundo respirava em 4 elementos...",
        "Ate o usurpador arrancar os guardioes!",
        "Reunimos toda a magia neste altar."
    },
    {
        185, 100,
        "Castor Construtor", "CANADA",
        "Esta vila e o ultimo abrigo na poeira.",
        "A agua dos pocos esta quase no fim...",
        "Se voce falhar, o mundo morre com a gente."
    },
    {
        50, 160,
        "Bisao Veterano", "EUA",
        "Nao hesite diante do perigo, jovem.",
        "Teste seus golpes e honre os 4 povos!",
        "Aperte X para alternar entre as 4 classes."
    },
    {
        120, 165,
        "Ornitorrinco Mistico", "AUSTRALIA",
        "O portal esta estavel... mas e um misterio.",
        "Nenhum ser vivo cruzou antes de voce.",
        "Voce sera o primeiro a ver o outro lado!"
    }
};

static const char* class_names[4] = {
    "TATU (TERRA)",
    "LOBOGUARA (FOGO)",
    "LAGARTO (AGUA)",
    "URUTAU (VENTO)"
};

static const char* class_weapons[4] = {
    "Espada & Escudo",
    "Cajado Solar",
    "Arco & Flecha",
    "Adagas Duplas"
};

void init_player(void) {
    player.x = 120;
    player.y = 110;
    player.dir = 0;
    player.class_id = CLASS_TATU;
    player.element = ELEM_TERRA;
    player.hp = 100;
    player.max_hp = 100;
    player.atk_timer = 0;
    player.invuln_timer = 0;
    player.is_moving = 0;
    player.essences_rescued = 0;
}

void init_custom_palettes(void) {
    setPalette(&sprites_pal, 128 + 0 * 16, 16 * 2); // Pal 0: Tatu (Tan padrao)
    setPalette(&sprites_pal, 128 + 1 * 16, 16 * 2); // Pal 1: Guara (Fogo)
    setPalette(&sprites_pal, 128 + 2 * 16, 16 * 2); // Pal 2: Lagarto (Agua) / Slimes
    setPalette(&sprites_pal, 128 + 3 * 16, 16 * 2); // Pal 3: Urutau (Vento)
    setPalette(&sprites_pal, 128 + 4 * 16, 16 * 2); // Pal 4: Flash de Impacto (Branco puro)

    // Pal 1: Lobo-Guara (Laranja vivo e Ouro)
    setPaletteColor(128 + 16 * 1 + 3, RGB5(30, 14, 2));   // Laranja fogo
    setPaletteColor(128 + 16 * 1 + 4, RGB5(31, 26, 8));   // Ouro cintilante

    // Pal 2: Lagarto (Verde e Lima)
    setPaletteColor(128 + 16 * 2 + 3, RGB5(4, 22, 10));   // Verde escamas
    setPaletteColor(128 + 16 * 2 + 4, RGB5(14, 30, 16));  // Verde lima

    // Pal 3: Urutau (Cinza camuflado e Prata)
    setPaletteColor(128 + 16 * 3 + 3, RGB5(13, 13, 15));  // Cinza casca
    setPaletteColor(128 + 16 * 3 + 4, RGB5(23, 24, 26));  // Cinza pluma clara

    // Pal 4: Flash de Impacto (Branco brilhante)
    setPaletteColor(128 + 16 * 4 + 3,  RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 4,  RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 8,  RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 10, RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 11, RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 14, RGB5(31, 31, 31));
}

void get_hp_bar(char *out, s16 cur, s16 max, u8 len) {
    u8 filled = 0;
    u8 i;
    if (cur > 0 && max > 0) {
        filled = (u8)(((s32)cur * len) / max);
    }
    if (filled > len) filled = len;
    for (i = 0; i < len; i++) {
        out[i] = (i < filled) ? '=' : '-';
    }
    out[len] = '\0';
}

void clear_dialogue_box(void) {
    u8 y;
    for (y = 18; y <= 26; y++) {
        consoleDrawText(1, y, "                              ");
    }
}

void clear_screen_text(void) {
    u8 y;
    for (y = 0; y < 28; y++) {
        consoleDrawText(0, y, "                                ");
    }
}

void check_village_interactions(void) {
    u8 i;
    // 1. Checa interacao com os 4 NPCs
    for (i = 0; i < 4; i++) {
        s16 dx = player.x - (s16)npcs[i].x;
        s16 dy = player.y - (s16)npcs[i].y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx < 22 && dy < 22) {
            selected_npc = i;
            current_state = STATE_DIALOGUE;
            clear_dialogue_box();
            hud_dirty = 1;
            return;
        }
    }

    // 2. Checa interacao com o Altar Central (120, 70)
    {
        s16 dx = player.x - 120;
        s16 dy = player.y - 70;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx < 22 && dy < 22) {
            current_state = STATE_ALTAR_MENU;
            clear_dialogue_box();
            hud_dirty = 1;
            return;
        }
    }

    // 3. Checa interacao com o Portal Dimensional (120, 35)
    {
        s16 dx = player.x - 120;
        s16 dy = player.y - 35;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx < 24 && dy < 24) {
            current_state = STATE_PORTAL_CONFIRM;
            clear_dialogue_box();
            hud_dirty = 1;
            return;
        }
    }
}

void enter_dungeon(void) {
    setFadeEffect(FADE_OUT);
    WaitForVBlank();

    clear_screen_text();

    current_state = STATE_DUNGEON;
    player.x = 120;
    player.y = 180; // Entrada sul da câmara
    player.dir = 1; // Olhando para cima
    player.hp = 100;
    player.max_hp = 100;
    player.atk_timer = 0;
    player.invuln_timer = 0;

    // Chefe: O Guardiao Corrompido
    boss.x = 120;
    boss.y = 65;
    boss.dir_x = 1;
    boss.dir_y = 0;
    boss.max_hp = 300;
    boss.hp = 300;
    boss.hit_flash = 0;
    boss.shoot_timer = 60;
    boss.is_alive = 1;

    // Slimes / Minions
    slime1.x = 55;
    slime1.y = 120;
    slime1.hp = 50;
    slime1.hit_flash = 0;
    slime1.is_alive = 1;

    slime2.x = 185;
    slime2.y = 120;
    slime2.hp = 50;
    slime2.hit_flash = 0;
    slime2.is_alive = 1;

    // Projetil
    proj.is_active = 0;
    proj.x = 0;
    proj.y = 240;

    essence_spawned = 0;
    essence_collected = 0;
    dungeon_portal_open = 0;

    hud_dirty = 1;

    WaitForVBlank();
    setFadeEffect(FADE_IN);
}

void return_to_village(u8 won) {
    setFadeEffect(FADE_OUT);
    WaitForVBlank();

    clear_screen_text();

    current_state = STATE_VILLAGE;
    player.x = 120;
    player.y = 65; // Aparece logo abaixo do portal
    player.dir = 0;
    player.hp = player.max_hp;
    player.atk_timer = 0;
    player.invuln_timer = 0;

    hud_dirty = 1;

    WaitForVBlank();
    setFadeEffect(FADE_IN);

    if (won) {
        current_state = STATE_VICTORY;
        hud_dirty = 1;
    }
}

void draw_hud(void) {
    char hp_buf[12];
    char boss_buf[12];
    const VillageNPC *npc;

    if (current_state == STATE_VILLAGE || current_state == STATE_DIALOGUE ||
        current_state == STATE_PORTAL_CONFIRM || current_state == STATE_ALTAR_MENU ||
        current_state == STATE_VICTORY) {

        consoleDrawText(1, 1, "== FALLEN HERO (SNES 16-BIT) ==");
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);
        consoleDrawText(1, 3, "ARMA:   ");
        consoleDrawText(9, 3, (char*)class_weapons[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 4, "HP:[%s] %d/100 ESSENCIA:%d/4", hp_buf, player.hp, player.essences_rescued);

        if (current_state == STATE_VILLAGE) {
            consoleDrawText(1, 25, "D-Pad:Andar  Y:Ataque  X:Classe");
            consoleDrawText(1, 26, "A:Interagir (NPC/Altar/Portal) ");
        } else if (current_state == STATE_DIALOGUE && selected_npc < 4) {
            npc = &npcs[selected_npc];
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, (char*)npc->name);
            consoleDrawText(22, 19, (char*)npc->country);
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, (char*)npc->line1);
            consoleDrawText(1, 22, (char*)npc->line2);
            consoleDrawText(1, 23, (char*)npc->line3);
            consoleDrawText(1, 25, "[A / B] Fechar conversa       ");
            consoleDrawText(1, 26, "==============================");
        } else if (current_state == STATE_PORTAL_CONFIRM) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "PORTAL DIMENSIONAL            ");
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, "O portal ressoa com energia...");
            consoleDrawText(1, 22, "Cruzaremos para o outro lado! ");
            consoleDrawText(1, 23, "Entrar no Templo do Guardiao? ");
            consoleDrawText(1, 24, "------------------------------");
            consoleDrawText(1, 25, "[A] ATRAVESSAR PORTAL         ");
            consoleDrawText(1, 26, "[B] Ficar na Vila             ");
        } else if (current_state == STATE_ALTAR_MENU) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "ALTAR DOS 4 ELEMENTOS         ");
            consoleDrawText(1, 20, "------------------------------");
            if (player.essences_rescued >= 1) {
                consoleDrawText(1, 21, "TERRA: [OK]  FOGO: [--]");
            } else {
                consoleDrawText(1, 21, "TERRA: [--]  FOGO: [--]");
            }
            if (player.essences_rescued >= 2) {
                consoleDrawText(14, 21, "FOGO: [OK]");
            }
            if (player.essences_rescued >= 3) {
                consoleDrawText(1, 22, "AGUA:  [OK]  VENTO:[--]");
            } else {
                consoleDrawText(1, 22, "AGUA:  [--]  VENTO:[--]");
            }
            if (player.essences_rescued >= 4) {
                consoleDrawText(14, 22, "VENTO:[OK]");
            }
            consoleDrawText(1, 23, "Restaure os 4 guardioes!      ");
            consoleDrawText(1, 25, "[A / B] Fechar Altar          ");
            consoleDrawText(1, 26, "==============================");
        } else if (current_state == STATE_VICTORY) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "VITORIA! ESSENCIA RESGATADA!  ");
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, "O Guardiao foi purificado!    ");
            consoleDrawText(1, 22, "A magia elemental voltou!     ");
            consoleDrawText(1, 23, "A vila celebra o seu retorno! ");
            consoleDrawText(1, 25, "[A / B] Continuar explorando  ");
            consoleDrawText(1, 26, "==============================");
        }
    } else if (current_state == STATE_DUNGEON) {
        consoleDrawText(1, 1, "== TEMPLO ELEMENTAL (MASMORRA)==");
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 3, "HP HEROI: [%s] %d/100", hp_buf, player.hp);

        if (boss.is_alive) {
            get_hp_bar(boss_buf, boss.hp, boss.max_hp, 8);
            consoleDrawText(1, 4, "CHEFE:    [%s] %d/%d ", boss_buf, boss.hp, boss.max_hp);
        } else {
            consoleDrawText(1, 4, "CHEFE: [ DERROTADO! ] TOQUE ORBE");
        }

        consoleDrawText(1, 25, "D-Pad:Andar  Y:Ataque  X:Classe");
        if (dungeon_portal_open) {
            consoleDrawText(1, 26, "PORTAL ABERTO! Toque no topo!  ");
        } else {
            consoleDrawText(1, 26, "Derrote o Guardiao Corrompido! ");
        }
    }
}

int main(void) {
    // 1. Limpa VRAM e zera todos os 128 sprites da OAM
    dmaClearVram();
    oamClear(0, 0);

    // 2. Inicializa o console de texto (BG0)
    consoleInitDefaultText(0);
    bgSetGfxPtr(0, 0x3000);
    bgSetMapPtr(0, 0x6800, SC_32x32);
    setMode(BG_MODE1, 0);
    bgSetDisable(1);
    bgSetDisable(2);

    // 3. Inicializa os Sprites de Hardware (OAM) com tamanho 16x16
    oamInitGfxSet(&sprites_til, (&sprites_tilend - &sprites_til), &sprites_pal, (&sprites_palend - &sprites_pal), 0, 0x0000, OBJ_SIZE16_L32);

    // 4. Configura as paletas dos herois, chefes e efeitos
    init_custom_palettes();

    // 5. Configura tamanho OBJ_SMALL e visibilidade OBJ_SHOW UMA UNICA VEZ para todos os sprites ativos
    oamSetEx(OAM_PLAYER,         OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_ATTACK,         OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_DUMMY,          OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_NPC0,           OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_NPC1,           OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_NPC2,           OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_NPC3,           OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_ALTAR,          OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_PORTAL,         OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_BOSS,           OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_SLIME1,         OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_SLIME2,         OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_PROJECTILE,     OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_ESSENCE,        OBJ_SMALL, OBJ_SHOW);
    oamSetEx(OAM_DUNGEON_PORTAL, OBJ_SMALL, OBJ_SHOW);

    init_player();
    current_state = STATE_VILLAGE;
    hud_dirty = 1;

    setScreenOn();

    while (1) {
        pad_held = padsCurrent(0);
        pad_down = padsDown(0);

        // =========================================================================
        // ESTADO 1: A VILA (Hub Seguro de Inicio)
        // =========================================================================
        if (current_state == STATE_VILLAGE) {
            player.is_moving = 0;
            if (pad_held & KEY_UP) {
                if (player.y > 36) player.y -= 2;
                player.dir = 1;
                player.is_moving = 1;
            }
            if (pad_held & KEY_DOWN) {
                if (player.y < 185) player.y += 2;
                player.dir = 0;
                player.is_moving = 1;
            }
            if (pad_held & KEY_LEFT) {
                if (player.x > 16) player.x -= 2;
                player.dir = 2;
                player.is_moving = 1;
            }
            if (pad_held & KEY_RIGHT) {
                if (player.x < 225) player.x += 2;
                player.dir = 3;
                player.is_moving = 1;
            }

            // Atravessar ao caminhar diretamente para dentro do Portal no topo (120, 35)
            if (player.y <= 42 && player.x >= 110 && player.x <= 130) {
                current_state = STATE_PORTAL_CONFIRM;
                clear_dialogue_box();
                hud_dirty = 1;
            }

            // Troca de Classe (Botao X)
            if (pad_down & KEY_X) {
                player.class_id = (player.class_id + 1) % 4;
                player.element = (ElementType)player.class_id;
                hud_dirty = 1;
            }

            // Ataque (Botao Y)
            if (pad_down & KEY_Y) {
                player.atk_timer = 12;

                // Colisao do Ataque com o Boneco de Treino (180, 140)
                {
                    s16 ddx = player.x - 180;
                    s16 ddy = player.y - 140;
                    if (ddx < 0) ddx = -ddx;
                    if (ddy < 0) ddy = -ddy;
                    if (ddx < 22 && ddy < 22) {
                        dummy_hit_flash = 10;
                        dummy_damage += 25;
                        hud_dirty = 1;
                    }
                }
            }
            if (player.atk_timer > 0) player.atk_timer--;
            if (dummy_hit_flash > 0) dummy_hit_flash--;

            // Interagir com NPC, Altar ou Portal (Botao A)
            if (pad_down & KEY_A) {
                check_village_interactions();
            }
        }
        // =========================================================================
        // ESTADO 2: CONFIRMACAO DO PORTAL DIMENSIONAL
        // =========================================================================
        else if (current_state == STATE_PORTAL_CONFIRM) {
            if (pad_down & KEY_A) {
                // Atravessa o Portal para a Masmorra!
                enter_dungeon();
            } else if (pad_down & KEY_B) {
                // Recua um passo e fecha a confirmacao
                player.y = 52;
                current_state = STATE_VILLAGE;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 3: DIALOGO / ALTAR / VITORIA
        // =========================================================================
        else if (current_state == STATE_DIALOGUE || current_state == STATE_ALTAR_MENU || current_state == STATE_VICTORY) {
            if ((pad_down & KEY_B) || (pad_down & KEY_A)) {
                current_state = STATE_VILLAGE;
                selected_npc = 0xFF;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 4: A MASMORRA / ARENA DO CHEFE ("O Outro Lado do Portal")
        // =========================================================================
        else if (current_state == STATE_DUNGEON) {
            player.is_moving = 0;
            if (pad_held & KEY_UP) {
                if (player.y > 45) player.y -= 2;
                player.dir = 1;
                player.is_moving = 1;
            }
            if (pad_held & KEY_DOWN) {
                if (player.y < 185) player.y += 2;
                player.dir = 0;
                player.is_moving = 1;
            }
            if (pad_held & KEY_LEFT) {
                if (player.x > 20) player.x -= 2;
                player.dir = 2;
                player.is_moving = 1;
            }
            if (pad_held & KEY_RIGHT) {
                if (player.x < 220) player.x += 2;
                player.dir = 3;
                player.is_moving = 1;
            }

            // Troca de Classe na Masmorra (Botao X)
            if (pad_down & KEY_X) {
                player.class_id = (player.class_id + 1) % 4;
                player.element = (ElementType)player.class_id;
                hud_dirty = 1;
            }

            // Ataque do Heroi (Botao Y)
            if (pad_down & KEY_Y) {
                player.atk_timer = 12;

                // Hitbox do Ataque
                s16 hx = player.x;
                s16 hy = player.y;
                if (player.dir == 0) hy += 14;
                else if (player.dir == 1) hy -= 14;
                else if (player.dir == 2) hx -= 14;
                else if (player.dir == 3) hx += 14;

                // 1. Acertar o Chefe
                if (boss.is_alive) {
                    s16 bdx = hx - boss.x;
                    s16 bdy = hy - boss.y;
                    if (bdx < 0) bdx = -bdx;
                    if (bdy < 0) bdy = -bdy;
                    if (bdx < 20 && bdy < 20) {
                        boss.hp -= 25;
                        boss.hit_flash = 10;
                        boss.x += (boss.dir_x > 0) ? -6 : 6; // Knockback
                        hud_dirty = 1;

                        if (boss.hp <= 0) {
                            boss.hp = 0;
                            boss.is_alive = 0;
                            slime1.is_alive = 0;
                            slime2.is_alive = 0;
                            essence_spawned = 1;
                            dungeon_portal_open = 1;
                            hud_dirty = 1;
                        }
                    }
                }

                // 2. Acertar Slime 1
                if (slime1.is_alive) {
                    s16 s1dx = hx - slime1.x;
                    s16 s1dy = hy - slime1.y;
                    if (s1dx < 0) s1dx = -s1dx;
                    if (s1dy < 0) s1dy = -s1dy;
                    if (s1dx < 16 && s1dy < 16) {
                        slime1.hp -= 25;
                        slime1.hit_flash = 10;
                        if (slime1.hp <= 0) slime1.is_alive = 0;
                    }
                }

                // 3. Acertar Slime 2
                if (slime2.is_alive) {
                    s16 s2dx = hx - slime2.x;
                    s16 s2dy = hy - slime2.y;
                    if (s2dx < 0) s2dx = -s2dx;
                    if (s2dy < 0) s2dy = -s2dy;
                    if (s2dx < 16 && s2dy < 16) {
                        slime2.hp -= 25;
                        slime2.hit_flash = 10;
                        if (slime2.hp <= 0) slime2.is_alive = 0;
                    }
                }
            }

            if (player.atk_timer > 0) player.atk_timer--;
            if (player.invuln_timer > 0) player.invuln_timer--;

            // IA do Chefe (Movimento e Disparo)
            if (boss.is_alive) {
                boss.x += boss.dir_x;
                if (boss.x > 195) boss.dir_x = -1;
                if (boss.x < 45)  boss.dir_x = 1;

                if (boss.hit_flash > 0) boss.hit_flash--;

                boss.shoot_timer--;
                if (boss.shoot_timer == 0) {
                    // Dispara projétil na direção do jogador
                    proj.x = boss.x;
                    proj.y = boss.y + 8;
                    proj.vx = (player.x > boss.x) ? 2 : -2;
                    proj.vy = (player.y > boss.y) ? 2 : 1;
                    proj.is_active = 1;
                    boss.shoot_timer = 90; // Dispara a cada 1.5s
                }
            }

            // IA dos Slimes (Perseguem o heroi)
            if (slime1.is_alive) {
                if (slime1.hit_flash > 0) slime1.hit_flash--;
                if (player.x > slime1.x) slime1.x += 1;
                else if (player.x < slime1.x) slime1.x -= 1;
                if (player.y > slime1.y) slime1.y += 1;
                else if (player.y < slime1.y) slime1.y -= 1;
            }

            if (slime2.is_alive) {
                if (slime2.hit_flash > 0) slime2.hit_flash--;
                if (player.x > slime2.x) slime2.x += 1;
                else if (player.x < slime2.x) slime2.x -= 1;
                if (player.y > slime2.y) slime2.y += 1;
                else if (player.y < slime2.y) slime2.y -= 1;
            }

            // Movimento do Projetil Magico
            if (proj.is_active) {
                proj.x += proj.vx;
                proj.y += proj.vy;
                if (proj.x < 10 || proj.x > 245 || proj.y < 30 || proj.y > 215) {
                    proj.is_active = 0;
                }
            }

            // Dano sofrido pelo Heroi (Dano de contato e projeteis)
            if (player.invuln_timer == 0) {
                // Dano por contato com o Chefe
                if (boss.is_alive) {
                    s16 bdx = player.x - boss.x;
                    s16 bdy = player.y - boss.y;
                    if (bdx < 0) bdx = -bdx;
                    if (bdy < 0) bdy = -bdy;
                    if (bdx < 16 && bdy < 16) {
                        player.hp -= 20;
                        player.invuln_timer = 40;
                        hud_dirty = 1;
                    }
                }

                // Dano por contato com Slime 1
                if (slime1.is_alive) {
                    s16 s1dx = player.x - slime1.x;
                    s16 s1dy = player.y - slime1.y;
                    if (s1dx < 0) s1dx = -s1dx;
                    if (s1dy < 0) s1dy = -s1dy;
                    if (s1dx < 14 && s1dy < 14) {
                        player.hp -= 10;
                        player.invuln_timer = 30;
                        hud_dirty = 1;
                    }
                }

                // Dano por contato com Slime 2
                if (slime2.is_alive) {
                    s16 s2dx = player.x - slime2.x;
                    s16 s2dy = player.y - slime2.y;
                    if (s2dx < 0) s2dx = -s2dx;
                    if (s2dy < 0) s2dy = -s2dy;
                    if (s2dx < 14 && s2dy < 14) {
                        player.hp -= 10;
                        player.invuln_timer = 30;
                        hud_dirty = 1;
                    }
                }

                // Dano por contato com Projetil
                if (proj.is_active) {
                    s16 pdx = player.x - proj.x;
                    s16 pdy = player.y - proj.y;
                    if (pdx < 0) pdx = -pdx;
                    if (pdy < 0) pdy = -pdy;
                    if (pdx < 12 && pdy < 12) {
                        player.hp -= 15;
                        proj.is_active = 0;
                        player.invuln_timer = 35;
                        hud_dirty = 1;
                    }
                }

                // Morte do Heroi -> Retorno a Vila para se recuperar
                if (player.hp <= 0) {
                    player.hp = 0;
                    return_to_village(0);
                }
            }

            // Coleta do Orbe da Essencia Elemental
            if (essence_spawned && !essence_collected) {
                s16 edx = player.x - 120;
                s16 edy = player.y - 110;
                if (edx < 0) edx = -edx;
                if (edy < 0) edy = -edy;
                if (edx < 18 && edy < 18) {
                    essence_collected = 1;
                    if (player.essences_rescued < 4) {
                        player.essences_rescued++;
                    }
                    hud_dirty = 1;
                }
            }

            // Portal de Retorno a Vila (ao derrotar o chefe e tocar no portal no topo)
            if (dungeon_portal_open) {
                if (player.y <= 42 && player.x >= 110 && player.x <= 130) {
                    return_to_village(1);
                }
            }
        }

        // =========================================================================
        // ATUALIZACAO DOS SPRITES DE HARDWARE (OAM)
        // =========================================================================

        // 1. Heroi (OAM_PLAYER = 0)
        {
            u16 spr_tile = SPR_HERO_DOWN;
            u8 spr_hflip = 0;
            if (player.dir == 1) {
                spr_tile = SPR_HERO_UP;
            } else if (player.dir == 2) {
                spr_tile = SPR_HERO_RIGHT;
                spr_hflip = 1;
            } else if (player.dir == 3) {
                spr_tile = SPR_HERO_RIGHT;
                spr_hflip = 0;
            }
            // Pisca em branco se estiver invulneravel
            u8 hero_pal = (player.invuln_timer > 0 && (player.invuln_timer & 2)) ? 4 : player.class_id;
            oamSet(OAM_PLAYER, player.x, player.y, 3, spr_hflip, 0, spr_tile, hero_pal);
        }

        // 2. Arco de Ataque (OAM_ATTACK = 4)
        if (player.atk_timer > 0) {
            s16 atk_x = player.x;
            s16 atk_y = player.y;
            u8 atk_hflip = 0;
            if (player.dir == 0) atk_y += 12;
            else if (player.dir == 1) atk_y -= 12;
            else if (player.dir == 2) { atk_x -= 12; atk_hflip = 1; }
            else if (player.dir == 3) { atk_x += 12; }
            oamSet(OAM_ATTACK, atk_x, atk_y, 3, atk_hflip, 0, SPR_ATTACK_SLASH, 0);
        } else {
            oamSet(OAM_ATTACK, 0, 240, 0, 0, 0, 0, 0);
        }

        if (current_state == STATE_VILLAGE || current_state == STATE_DIALOGUE ||
            current_state == STATE_PORTAL_CONFIRM || current_state == STATE_ALTAR_MENU ||
            current_state == STATE_VICTORY) {

            // Sprites da Vila Ativos
            u8 dummy_pal = (dummy_hit_flash > 0) ? 4 : 0;
            oamSet(OAM_DUMMY,  180, 140, 3, 0, 0, SPR_TRAINING_DUMMY, dummy_pal);
            oamSet(OAM_NPC0,   npcs[0].x, npcs[0].y, 3, 0, 0, SPR_NPC_TANUKI,  0);
            oamSet(OAM_NPC1,   npcs[1].x, npcs[1].y, 3, 0, 0, SPR_NPC_CASTOR,  0);
            oamSet(OAM_NPC2,   npcs[2].x, npcs[2].y, 3, 0, 0, SPR_NPC_BISAO,   0);
            oamSet(OAM_NPC3,   npcs[3].x, npcs[3].y, 3, 0, 0, SPR_NPC_ORNITOR, 0);
            oamSet(OAM_ALTAR,  120, 70, 3, 0, 0, SPR_ALTAR,  0);
            oamSet(OAM_PORTAL, 120, 35, 3, 0, 0, SPR_PORTAL, 0);

            // Sprites da Masmorra Ocultos fora da tela
            oamSet(OAM_BOSS,           0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME1,         0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME2,         0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PROJECTILE,     0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ESSENCE,        0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_DUNGEON_PORTAL, 0, 240, 0, 0, 0, 0, 0);

        } else if (current_state == STATE_DUNGEON) {

            // Sprites da Vila Ocultos fora da tela
            oamSet(OAM_DUMMY,  0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_NPC0,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_NPC1,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_NPC2,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_NPC3,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ALTAR,  0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PORTAL, 0, 240, 0, 0, 0, 0, 0);

            // 1. Chefe / Guardiao Corrompido (Quadrado com olhinhos ameacadores)
            if (boss.is_alive) {
                u8 boss_pal = (boss.hit_flash > 0) ? 4 : 0;
                u8 boss_hflip = (boss.dir_x < 0) ? 1 : 0;
                oamSet(OAM_BOSS, boss.x, boss.y, 3, boss_hflip, 0, SPR_BOSS_ENEMY, boss_pal);
            } else {
                oamSet(OAM_BOSS, 0, 240, 0, 0, 0, 0, 0);
            }

            // 2. Slime 1
            if (slime1.is_alive) {
                u8 s1_pal = (slime1.hit_flash > 0) ? 4 : 2;
                oamSet(OAM_SLIME1, slime1.x, slime1.y, 3, 0, 0, SPR_SLIME, s1_pal);
            } else {
                oamSet(OAM_SLIME1, 0, 240, 0, 0, 0, 0, 0);
            }

            // 3. Slime 2
            if (slime2.is_alive) {
                u8 s2_pal = (slime2.hit_flash > 0) ? 4 : 2;
                oamSet(OAM_SLIME2, slime2.x, slime2.y, 3, 0, 0, SPR_SLIME, s2_pal);
            } else {
                oamSet(OAM_SLIME2, 0, 240, 0, 0, 0, 0, 0);
            }

            // 4. Projetil Magico do Chefe
            if (proj.is_active) {
                oamSet(OAM_PROJECTILE, proj.x, proj.y, 3, 0, 0, SPR_PROJECTILE, 1);
            } else {
                oamSet(OAM_PROJECTILE, 0, 240, 0, 0, 0, 0, 0);
            }

            // 5. Orbe de Essencia Elemental
            if (essence_spawned && !essence_collected) {
                oamSet(OAM_ESSENCE, 120, 110, 3, 0, 0, SPR_ESSENCE, 0);
            } else {
                oamSet(OAM_ESSENCE, 0, 240, 0, 0, 0, 0, 0);
            }

            // 6. Portal de Retorno a Vila
            if (dungeon_portal_open) {
                oamSet(OAM_DUNGEON_PORTAL, 120, 35, 3, 0, 0, SPR_PORTAL, 0);
            } else {
                oamSet(OAM_DUNGEON_PORTAL, 0, 240, 0, 0, 0, 0, 0);
            }
        }

        // Atualiza o HUD apenas em frames que houve mudanca (60 FPS cravados)
        if (hud_dirty) {
            draw_hud();
            hud_dirty = 0;
        }

        WaitForVBlank();
    }

    return 0;
}
