# Fallen Hero — Guia Oficial de Desenvolvimento Super Nintendo (SNES 16-Bit)

Bem-vindo à versão nativa de **Fallen Hero** para o console **Super Nintendo Entertainment System (SNES)**!

Este projeto é programado em **Linguagem C** e montado para o processador **Ricoh 5A22 (65C816 de 16-bit)** do SNES, gerando uma ROM oficial `.sfc` que roda em emuladores e cartuchos físicos de verdade.

---

## 1. Como Jogar e Compilar (1-Clique)

### Para Compilar e Jogar Imediatamente:
No terminal PowerShell, execute:
```powershell
./play.ps1
```
*Este comando compila o código em C, monta o cartucho de 256 KB e abre o jogo automaticamente no emulador Snes9x!*

### Para Apenas Compilar:
```powershell
./build.ps1
```
Gera o arquivo `fallen_hero.sfc` na raiz do projeto.

---

## 2. Controles no Super Nintendo (Padrão Snes9x)

| Função no Jogo | Botão no Controle do SNES | Tecla Padrão no Teclado (Snes9x) |
| :--- | :--- | :--- |
| **Movimentação (8 Direções)** | **D-Pad** (Cima, Baixo, Esquerda, Direita) | **Setas Direcionais** |
| **Atacar (Golpe de Arma)** | **Botão Y** | Tecla **S** |
| **Trocar de Classe (Tatu / Guará / Lagarto / Urutau)** | **Botão X** | Tecla **D** |
| **Interagir / Falar com Morador** | **Botão A** | Tecla **X** |
| **Fechar Diálogo / Cancelar** | **Botão B** | Tecla **Z** |
| **Pausar** | **Start** | Tecla **Enter** |

---

## 3. O que já está Funcionando na Versão SNES (Milestone 1)

1. **Hardware 16-Bit Ativo:**
   * Resolução nativa de **256 × 224** pixels a **60 FPS** cravados sincronizados com o VBLANK.
   * Inicialização de VRAM, CGRAM (paletas), e Modo de Vídeo 1 do SNES.
2. **Sistema de Classes Brasileiro:**
   * **Tatu-Canastra:** Guerreiro / Terra (Espada & Escudo).
   * **Lobo-Guará:** Maga / Fogo (Cajado Solar).
   * **Lagarto:** Arqueiro / Água (Arco & Flecha).
   * **Urutau:** Assassino / Vento (Adagas Duplas).
   * Aperte o botão **X** para ciclar entre eles em tempo real.
3. **Vila dos Refugiados & Storytellers (Os 4 Moradores):**
   * **Ancião Tanuki (Japão 🇯🇵):** Conta sobre o passado dos 4 elementos e a perda das Essências.
   * **Castor Construtor (Canadá 🇨🇦):** Conta sobre a seca dos poços e a sobrevivência da vila.
   * **Bisão Veterano (EUA 🇺🇸):** Dá dicas sobre os quatro povos e treina o guerreiro.
   * **Ornitorrinco Místico (Austrália 🇦🇺):** Revela o mistério diante do Portal Dimensional.
   * Chegue perto de qualquer um deles e aperte o botão **A** para abrir a caixa de diálogo!
4. **Sistema de Combate Básico:**
   * Botão **Y** desfere o ataque da classe com feedback visual e temporização.

---

## 4. Estrutura do Código em C

* `src/main.c`: Loop principal, inicialização de hardware, máquina de estados da vila e diálogos.
* `include/game.h`: Estruturas do Jogador, das Classes, dos Elementos e dos Moradores.
* `hdr.asm`: Cabeçalho oficial do cartucho de SNES (LoROM 256 KB, modo NTSC).
* `tools/`: Compilador PVSnesLib (816-tcc, wla-65816, wlalink) e emulador Snes9x portáteis.
