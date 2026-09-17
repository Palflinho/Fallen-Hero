/*---------------------------------------------------------------------------------
    Fallen Hero ? Super Nintendo (SNES) Native 16-Bit Edition
    Visual Graphic Sprites Engine (Reproduzindo fielmente os graficos do GameMaker)
---------------------------------------------------------------------------------*/
#include <snes.h>
#include "game.h"
#include "sprites.h"

// Inst?ncias Globais
static Player player;
static GameState current_state;
static u8 selected_npc = 0xFF;
static u16 pad_held = 0;
static u16 pad_down = 0;

// Estado do Inimigo / Chefe (Quadrado com olhinhos ameacadores do GameMaker)
static s16 enemy_x = 170;
static s16 enemy_y = 70;
static s8  enemy_dir = 1;

// Estado do Boneco de Treino
static u8 dummy_hit_flash = 0;
static u16 dummy_damage = 0;

// Os 4 Contadores de Hist?ria da Vila (Refugiados de outros pa?ses)
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
    player.is_moving = 0;
    player.essences_rescued = 0;
}

void init_custom_palettes(void) {
    // Paleta 0: Tatu (Guerreiro / Terra - Marrom e Ferro)
    setPalette(&sprites_pal, 128, 16 * 2);

    // Paleta 1: Lobo-Guar? (Maga / Fogo - Laranja vivo e Ouro)
    setPaletteColor(144 + 1, RGB5(2, 2, 2));
    setPaletteColor(144 + 2, RGB5(16, 4, 4));
    setPaletteColor(144 + 3, RGB5(31, 14, 4));
    setPaletteColor(144 + 4, RGB5(31, 24, 8));
    setPaletteColor(144 + 5, RGB5(31, 30, 2));
    setPaletteColor(144 + 6, RGB5(31, 31, 31));
    setPaletteColor(144 + 7, RGB5(6, 26, 31));

    // Paleta 2: Lagarto (Arqueiro / ?gua - Verde e Lima)
    setPaletteColor(160 + 1, RGB5(2, 2, 2));
    setPaletteColor(160 + 2, RGB5(4, 12, 6));
    setPaletteColor(160 + 3, RGB5(6, 24, 10));
    setPaletteColor(160 + 4, RGB5(16, 31, 14));
    setPaletteColor(160 + 5, RGB5(16, 10, 4));
    setPaletteColor(160 + 6, RGB5(31, 31, 31));
    setPaletteColor(160 + 7, RGB5(6, 24, 31));

    // Paleta 3: Urutau (Assassino / Vento - Cinza casca e Olho amarelo el?trico)
    setPaletteColor(176 + 1, RGB5(2, 2, 2));
    setPaletteColor(176 + 2, RGB5(6, 6, 8));
    setPaletteColor(176 + 3, RGB5(14, 14, 16));
    setPaletteColor(176 + 4, RGB5(20, 20, 22));
    setPaletteColor(176 + 5, RGB5(26, 27, 29));
    setPaletteColor(176 + 6, RGB5(31, 30, 0));
    setPaletteColor(176 + 7, RGB5(16, 6, 24));

    // Paleta 4: Inimigo / Chefe (Quadrado com Olhos Amea?adores do GameMaker)
    setPaletteColor(192 + 1, RGB5(0, 0, 0));
    setPaletteColor(192 + 2, RGB5(12, 2, 4));
    setPaletteColor(192 + 3, RGB5(25, 4, 4));
    setPaletteColor(192 + 4, RGB5(31, 2, 2));
    setPaletteColor(192 + 5, RGB5(31, 31, 2));
    setPaletteColor(192 + 6, RGB5(31, 31, 31));

    // Paleta 5: Boneco de Treino & Vila
    setPaletteColor(208 + 1, RGB5(0, 0, 0));
    setPaletteColor(208 + 2, RGB5(10, 6, 3));
    setPaletteColor(208 + 3, RGB5(24, 20, 12));
    setPaletteColor(208 + 4, RGB5(29, 26, 18));
    setPaletteColor(208 + 5, RGB5(30, 3, 3));
    setPaletteColor(208 + 6, RGB5(31, 31, 31));
}

void check_npc_interaction(void) {
    u8 i;
    for (i = 0; i < 4; i++) {
        s16 dx = (s16)player.x - (s16)npcs[i].x;
        s16 dy = (s16)player.y - (s16)npcs[i].y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx < 20 && dy < 20) {
            selected_npc = i;
            current_state = STATE_DIALOGUE;
            return;
        }
    }
}

void clear_dialogue_box(void) {
    u8 y;
    for (y = 18; y <= 26; y++) {
        consoleDrawText(1, y, "                              ");
    }
}

void draw_hud(void) {
    consoleDrawText(1, 1, "== FALLEN HERO (SNES 16-BIT) ==");
    consoleDrawText(1, 2, "CLASSE: ");
    consoleDrawText(9, 2, (char*)class_names[player.class_id]);
    consoleDrawText(1, 3, "ARMA:   ");
    consoleDrawText(9, 3, (char*)class_weapons[player.class_id]);
    consoleDrawText(1, 4, "HP: [========] 100/100  ESSENCIAS: 0/4");

    if (current_state == STATE_VILLAGE) {
        consoleDrawText(1, 25, "D-Pad:Andar  Y:Ataque  X:Classe");
        consoleDrawText(1, 26, "A:Falar com Moradores");
    } else if (current_state == STATE_DIALOGUE && selected_npc < 4) {
        const VillageNPC *npc = &npcs[selected_npc];
        consoleDrawText(1, 18, "==============================");
        consoleDrawText(1, 19, (char*)npc->name);
        consoleDrawText(22, 19, (char*)npc->country);
        consoleDrawText(1, 20, "------------------------------");
        consoleDrawText(1, 21, (char*)npc->line1);
        consoleDrawText(1, 22, (char*)npc->line2);
        consoleDrawText(1, 23, (char*)npc->line3);
        consoleDrawText(1, 25, "[A / B] Fechar conversa       ");
        consoleDrawText(1, 26, "==============================");
    }
}

int main(void) {
    // 1. Inicializa o console de texto (BG0)
    consoleInitDefaultText(0);

    // 2. Configura Modo 1 de v?deo (256x224)
    bgSetGfxPtr(0, 0x3000);
    bgSetMapPtr(0, 0x6800, SC_32x32);
    setMode(BG_MODE1, 0);
    bgSetDisable(1);
    bgSetDisable(2);

    // 3. Inicializa os Sprites de Hardware (OAM) com tamanho 16x16
    oamInitGfxSet(&sprites_til, (&sprites_tilend - &sprites_til), &sprites_pal, (&sprites_palend - &sprites_pal), 0, 0x0000, OBJ_SIZE16_L32);

    init_custom_palettes();
    init_player();
    current_state = STATE_VILLAGE;

    setScreenOn();

    while (1) {
        // Leitura autom?tica dos controles
        pad_held = padsCurrent(0);
        pad_down = padsDown(0);

        if (current_state == STATE_VILLAGE) {
            // Movimenta??o flu?da em pixels com D-Pad
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
                if (player.x > 16) player.x -= 2;
                player.dir = 2;
                player.is_moving = 1;
            }
            if (pad_held & KEY_RIGHT) {
                if (player.x < 225) player.x += 2;
                player.dir = 3;
                player.is_moving = 1;
            }

            // Troca de Classe (Bot?o X)
            if (pad_down & KEY_X) {
                player.class_id = (player.class_id + 1) % 4;
                player.element = (ElementType)player.class_id;
            }

            // Ataque (Bot?o Y)
            if (pad_down & KEY_Y) {
                player.atk_timer = 14;

                // Colis?o do Ataque com o Boneco de Treino (180, 140)
                if (player.x >= 160 && player.x <= 200 && player.y >= 120 && player.y <= 160) {
                    dummy_hit_flash = 12;
                    dummy_damage += 25;
                }
            }
            if (player.atk_timer > 0) player.atk_timer--;
            if (dummy_hit_flash > 0) dummy_hit_flash--;

            // Patrulha do Chefe / Monstro (Quadrado com olhinhos)
            enemy_x += enemy_dir;
            if (enemy_x > 215) enemy_dir = -1;
            if (enemy_x < 155) enemy_dir = 1;

            // Interagir com NPC / Objeto (Bot?o A)
            if (pad_down & KEY_A) {
                check_npc_interaction();
                if (current_state == STATE_DIALOGUE) {
                    clear_dialogue_box();
                }
            }
        } else if (current_state == STATE_DIALOGUE) {
            // Fechar di?logo (Bot?o B ou A)
            if ((pad_down & KEY_B) || (pad_down & KEY_A)) {
                current_state = STATE_VILLAGE;
                selected_npc = 0xFF;
                clear_dialogue_box();
            }
        }

        // ==========================================
        // Atualiza??o de Hardware Sprites (OAM)
        // ==========================================

        // 1. Sprite do Jogador (OAM 0)
        u16 spr_tile = SPR_HERO_DOWN;
        u8 spr_hflip = 0;
        if (player.dir == 1) {
            spr_tile = SPR_HERO_UP;
        } else if (player.dir == 2) {
            spr_tile = SPR_HERO_RIGHT;
            spr_hflip = 1; // Espelhamento horizontal para olhar para esquerda!
        } else if (player.dir == 3) {
            spr_tile = SPR_HERO_RIGHT;
            spr_hflip = 0;
        }
        oamSet(0, player.x, player.y, 3, spr_hflip, 0, spr_tile, player.class_id);
        oamSetEx(0, OBJ_SMALL, OBJ_SHOW);

        // 2. Sprite de Ataque / Golpe (OAM 1)
        if (player.atk_timer > 0) {
            s16 atk_x = player.x;
            s16 atk_y = player.y;
            u8 atk_hflip = 0;
            if (player.dir == 0) atk_y += 12;
            else if (player.dir == 1) atk_y -= 12;
            else if (player.dir == 2) { atk_x -= 12; atk_hflip = 1; }
            else if (player.dir == 3) { atk_x += 12; }

            oamSet(1, atk_x, atk_y, 3, atk_hflip, 0, SPR_ATTACK_SLASH, 0);
            oamSetEx(1, OBJ_SMALL, OBJ_SHOW);
        } else {
            oamSetVisible(1, OBJ_HIDE);
        }

        // 3. Chefe / Monstro (OAM 2: Quadrado com Olhinhos do GameMaker)
        u8 enemy_hflip = (enemy_dir < 0) ? 1 : 0;
        oamSet(2, enemy_x, enemy_y, 3, enemy_hflip, 0, SPR_BOSS_ENEMY, 4);
        oamSetEx(2, OBJ_SMALL, OBJ_SHOW);

        // 4. Boneco de Treino (OAM 3: Post, straw body & red bullseye target)
        u8 dummy_pal = (dummy_hit_flash > 0) ? 0 : 5; // Pisca em branco quando toma golpe
        oamSet(3, 180, 140, 2, 0, 0, SPR_TRAINING_DUMMY, dummy_pal);
        oamSetEx(3, OBJ_SMALL, OBJ_SHOW);

        // 5. Os 4 Moradores da Vila (OAM 4, 5, 6, 7)
        oamSet(4, npcs[0].x, npcs[0].y, 2, 0, 0, SPR_NPC_TANUKI,  0);
        oamSet(5, npcs[1].x, npcs[1].y, 2, 0, 0, SPR_NPC_CASTOR,  0);
        oamSet(6, npcs[2].x, npcs[2].y, 2, 0, 0, SPR_NPC_BISAO,   0);
        oamSet(7, npcs[3].x, npcs[3].y, 2, 0, 0, SPR_NPC_ORNITOR, 0);
        oamSetEx(4, OBJ_SMALL, OBJ_SHOW);
        oamSetEx(5, OBJ_SMALL, OBJ_SHOW);
        oamSetEx(6, OBJ_SMALL, OBJ_SHOW);
        oamSetEx(7, OBJ_SMALL, OBJ_SHOW);

        // 6. Altar das Essencias (OAM 8) e Portal Dimensional (OAM 9)
        oamSet(8, 120, 70,  2, 0, 0, SPR_ALTAR,  0);
        oamSet(9, 120, 35,  2, 0, 0, SPR_PORTAL, 0);
        oamSetEx(8, OBJ_SMALL, OBJ_SHOW);
        oamSetEx(9, OBJ_SMALL, OBJ_SHOW);

        // 7. Atualiza o HUD / Di?logos
        draw_hud();

        // Sincroniza??o cravada em 60 FPS com VBLANK do SNES
        WaitForVBlank();
    }

    return 0;
}

