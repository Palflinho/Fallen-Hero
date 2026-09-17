/*---------------------------------------------------------------------------------
    Fallen Hero ? Super Nintendo (SNES) Native 16-Bit Edition
    Programmed in C with PVSnesLib
---------------------------------------------------------------------------------*/
#include <snes.h>
#include "game.h"

// Inst?ncias Globais
static Player player;
static GameState current_state;
static u8 selected_npc = 0xFF;
static u16 pad_held = 0;
static u16 pad_down = 0;
static u8 old_grid_x = 0;
static u8 old_grid_y = 0;
static u8 last_class_id = 0xFF;
static u8 last_atk_timer = 0;
static u8 redraw_village = 1;

// Os 4 Contadores de Hist?ria da Vila (Refugiados de outros pa?ses)
static const VillageNPC npcs[4] = {
    {
        64, 72,
        "Anciao Tanuki", "JAPAO",
        "O mundo respirava em 4 elementos...",
        "Ate o usurpador arrancar os guardioes!",
        "Reunimos toda a magia neste altar."
    },
    {
        180, 72,
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
        180, 160,
        "Ornitorrinco Mistico", "AUSTRALIA",
        "O portal esta estavel... mas e um misterio.",
        "Nenhum ser vivo cruzou antes de voce.",
        "Voce sera o primeiro a ver o outro lado!"
    }
};

static const char* class_names[4] = {
    "TATU (TERRA)    ",
    "LOBOGUARA (FOGO)",
    "LAGARTO (AGUA)  ",
    "URUTAU (VENTO)  "
};

static const char* class_weapons[4] = {
    "Espada & Escudo",
    "Cajado Solar   ",
    "Arco & Flecha  ",
    "Adagas Duplas  "
};

void init_player(void) {
    player.x = 120;
    player.y = 112;
    player.dir = 0;
    player.class_id = CLASS_TATU;
    player.element = ELEM_TERRA;
    player.hp = 100;
    player.max_hp = 100;
    player.atk_timer = 0;
    player.is_moving = 0;
    player.essences_rescued = 0;
    old_grid_x = (u8)(player.x / 8);
    old_grid_y = (u8)(player.y / 8);
}

void check_npc_interaction(void) {
    u8 i;
    for (i = 0; i < 4; i++) {
        s16 dx = (s16)player.x - (s16)npcs[i].x;
        s16 dy = (s16)player.y - (s16)npcs[i].y;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (dx < 24 && dy < 24) {
            selected_npc = i;
            current_state = STATE_DIALOGUE;
            return;
        }
    }
}

void draw_village_ui(void) {
    consoleDrawText(1, 1, "== FALLEN HERO (SNES 16-BIT) ==");

    consoleDrawText(1, 3, "CLASSE: ");
    consoleDrawText(9, 3, (char*)class_names[player.class_id]);

    consoleDrawText(1, 4, "ARMA:   ");
    consoleDrawText(9, 4, (char*)class_weapons[player.class_id]);

    consoleDrawText(1, 5, "HP: 100/100  ESSENCIAS: 0/4   ");

    consoleDrawText(1, 7, "------------------------------");
    consoleDrawText(5, 8, "[ ALTAR DAS ESSENCIAS ]");
    consoleDrawText(2, 10, "[T] Tanuki(JP)");
    consoleDrawText(17, 10, "[C] Castor(CA)");
    consoleDrawText(2, 17, "[B] Bisao(US)");
    consoleDrawText(17, 17, "[O] Ornitor(AU)");

    consoleDrawText(4, 20, "[ PORTAL DO DESCONHECIDO ]");
    consoleDrawText(1, 22, "------------------------------");
    consoleDrawText(1, 24, "D-Pad:Andar Y:Ataque X:Classe ");
    consoleDrawText(1, 25, "A:Conversar com Moradores     ");
}

void draw_dialogue(u8 npc_idx) {
    const VillageNPC *npc = &npcs[npc_idx];
    consoleDrawText(1, 7,  "==============================");
    consoleDrawText(1, 8,  "MORADOR DA VILA DOS REFUGIADOS");
    consoleDrawText(1, 9,  (char*)npc->name);
    consoleDrawText(22, 9, (char*)npc->country);
    consoleDrawText(1, 10, "------------------------------");
    consoleDrawText(1, 12, (char*)npc->line1);
    consoleDrawText(1, 14, (char*)npc->line2);
    consoleDrawText(1, 16, (char*)npc->line3);
    consoleDrawText(1, 18, "------------------------------");
    consoleDrawText(1, 20, "[A / B] Fechar conversa       ");
    consoleDrawText(1, 21, "==============================");
}

int main(void) {
    // Inicializa subsistema de texto/console do SNES
    consoleInitDefaultText(0);

    // Configura Modo 1 de v?deo (256x224)
    bgSetGfxPtr(0, 0x3000);
    bgSetMapPtr(0, 0x6800, SC_32x32);
    setMode(BG_MODE1, 0);
    bgSetDisable(1);
    bgSetDisable(2);

    init_player();
    current_state = STATE_VILLAGE;

    setScreenOn();
    draw_village_ui();

    while (1) {
        // Leitura autom?tica dos bot?es do controle pelo VBLANK
        pad_held = padsCurrent(0);
        pad_down = padsDown(0);

        if (current_state == STATE_VILLAGE) {
            u8 new_grid_x, new_grid_y;

            // Se acabou de voltar de di?logo, redesenha tela
            if (redraw_village) {
                draw_village_ui();
                redraw_village = 0;
            }

            // Movimenta??o com o D-Pad
            player.is_moving = 0;
            if (pad_held & KEY_UP) {
                if (player.y > 70) player.y -= 2;
                player.dir = 1;
                player.is_moving = 1;
            }
            if (pad_held & KEY_DOWN) {
                if (player.y < 155) player.y += 2;
                player.dir = 0;
                player.is_moving = 1;
            }
            if (pad_held & KEY_LEFT) {
                if (player.x > 20) player.x -= 2;
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
                player.atk_timer = 15;
            }
            if (player.atk_timer > 0) {
                player.atk_timer--;
            }

            // Interagir com NPC / Objeto (Bot?o A)
            if (pad_down & KEY_A) {
                check_npc_interaction();
                if (current_state == STATE_DIALOGUE) {
                    draw_dialogue(selected_npc);
                }
            }

            // Atualiza??o do Personagem em Tela
            new_grid_x = (u8)(player.x / 8);
            new_grid_y = (u8)(player.y / 8);

            // Atualiza classe se mudou
            if (player.class_id != last_class_id) {
                consoleDrawText(9, 3, (char*)class_names[player.class_id]);
                consoleDrawText(9, 4, (char*)class_weapons[player.class_id]);
                last_class_id = player.class_id;
            }

            // Limpa posi??o antiga se moveu
            if (new_grid_x != old_grid_x || new_grid_y != old_grid_y) {
                consoleDrawText(old_grid_x, old_grid_y, " ");
                old_grid_x = new_grid_x;
                old_grid_y = new_grid_y;
            }

            // Desenha estado do jogador (ataque ou normal)
            if (player.atk_timer > 0) {
                consoleDrawText(new_grid_x, new_grid_y, "*");
                if (last_atk_timer == 0) {
                    consoleDrawText(1, 24, "GOLPE: * ATAQUE EXECUTADO! *  ");
                }
            } else {
                consoleDrawText(new_grid_x, new_grid_y, "@");
                if (last_atk_timer > 0) {
                    consoleDrawText(1, 24, "D-Pad:Andar Y:Ataque X:Classe ");
                }
            }
            last_atk_timer = player.atk_timer;

        } else if (current_state == STATE_DIALOGUE) {
            // Sair do di?logo (Bot?o B ou A)
            if ((pad_down & KEY_B) || (pad_down & KEY_A)) {
                current_state = STATE_VILLAGE;
                selected_npc = 0xFF;
                redraw_village = 1;
            }
        }

        // Sincroniza??o de 60 FPS com VBLANK
        WaitForVBlank();
    }

    return 0;
}
