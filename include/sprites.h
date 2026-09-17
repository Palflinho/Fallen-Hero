#ifndef _SPRITES_H_
#define _SPRITES_H_

#include <snes.h>

extern unsigned char sprites_til, sprites_tilend;
extern unsigned char sprites_pal, sprites_palend;

// Indices de Tiles dos Sprites de 16x16 (Linha 1: 0, 2, 4, 6, 8, 10, 12, 14)
#define SPR_HERO_DOWN        0   // Quadrado com olhinhos para baixo
#define SPR_HERO_UP          2   // Quadrado com costas / olhando para cima
#define SPR_HERO_RIGHT       4   // Quadrado com olhinhos para a direita (use hflip para esquerda)
#define SPR_ATTACK_SLASH     6   // Arco de golpe / corte de espada ou adaga
#define SPR_BOSS_ENEMY       8   // General / Chefe: quadrado com olhinhos ameacadores
#define SPR_TRAINING_DUMMY  10   // Boneco de Treino com alvo bullseye no peito
#define SPR_PROJECTILE      12   // Flecha do Arqueiro / Disparo Magico da Maga / Projetil do Chefe
#define SPR_SHIELD          14   // Escudo de Defesa do Cavaleiro / Escudo de Mana da Maga

// Linha 2 (Tiles iniciam em 32)
#define SPR_PEDESTAL        32   // Pedestal de Selecao de Classe da Vila
#define SPR_CHEST_CLOSED    34   // Bau de Tesouro Fechado
#define SPR_CHEST_OPENED    36   // Bau de Tesouro Aberto com brilho
#define SPR_ELEMENTAL       38   // Elemental de Gelo (inimigo que ataca e recua a distancia)
#define SPR_ALTAR           40   // Altar Central das 4 Essencias
#define SPR_PORTAL          42   // Portal Dimensional
#define SPR_SLIME           44   // Slime / Minion (quadradinho gelatinoso)
#define SPR_ESSENCE         46   // Orbe da Essencia Elemental Resgatada

#endif // _SPRITES_H_
