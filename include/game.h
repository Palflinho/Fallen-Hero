#ifndef _GAME_H_
#define _GAME_H_

#include <snes.h>

#define SCREEN_W 256
#define SCREEN_H 224

// Game States
typedef enum {
    STATE_VILLAGE = 0,
    STATE_DIALOGUE,
    STATE_ALTAR_MENU,
    STATE_DUNGEON
} GameState;

// Classes (Os 4 Her?is)
typedef enum {
    CLASS_TATU = 0,     // Guerreiro / Terra (Armadura pesada, escudo)
    CLASS_GUARA = 1,    // Maga / Fogo (Chamas arcanas)
    CLASS_LAGARTO = 2,  // Arqueiro / ?gua (Flechas e agilidade)
    CLASS_URUTAU = 3    // Assassino / Vento (Adagas duplas, furtivo)
} HeroClass;

// Elements
typedef enum {
    ELEM_TERRA = 0,
    ELEM_FOGO = 1,
    ELEM_AGUA = 2,
    ELEM_VENTO = 3
} ElementType;

// Player Structure
typedef struct {
    u16 x;
    u16 y;
    u8 dir;             // 0=Down, 1=Up, 2=Left, 3=Right
    HeroClass class_id;
    ElementType element;
    u16 hp;
    u16 max_hp;
    u8 atk_timer;
    u8 is_moving;
    u8 essences_rescued; // 0 a 4
} Player;

// NPC Structure for Village Storytellers
typedef struct {
    u16 x;
    u16 y;
    const char *name;
    const char *country;
    const char *line1;
    const char *line2;
    const char *line3;
} VillageNPC;

#endif // _GAME_H_
