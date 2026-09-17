.include "hdr.asm"
.accu 16
.index 16
.16bit
.define __check_npc_interaction_locals 6
.define __draw_dialogue_locals 4
.define __main_locals 2

.SECTION ".init_playertext_0x0" SUPERFREE

init_player:
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 0
lda.w #112
sta.w tccs_{WLA_FILENAME}_player + 2
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 6
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 8
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 12
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 0
lsr a
lsr a
lsr a
and.w #255
sep #$20
sta.l tccs_{WLA_FILENAME}_old_grid_x + 0
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 2
lsr a
lsr a
lsr a
and.w #255
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_old_grid_y + 0
rep #$20
rtl
.ENDS

.SECTION ".check_npc_interactiontext_0x1" SUPERFREE

check_npc_interaction:
.ifgr __check_npc_interaction_locals 0
tsa
sec
sbc #__check_npc_interaction_locals
tas
.endif
lda.w #0
sta.b tcc__r0
sep #$20
sta -1 + __check_npc_interaction_locals + 1,s
rep #$20
__local_2:
lda.w #0
sep #$20
lda -1 + __check_npc_interaction_locals + 1,s
rep #$20
sta.b tcc__r0
sec
sbc.w #4
bvc +
eor #$8000
+
bmi +
brl __local_0
+
bra __local_1
__local_8:
lda.w #0
sep #$20
lda -1 + __check_npc_interaction_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -1 + __check_npc_interaction_locals + 1,s
rep #$20
bra __local_2
__local_1:
lda.w #0
sep #$20
lda -1 + __check_npc_interaction_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #24
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_npcs
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_npcs + 0
clc
adc.b tcc__r0
sta.b tcc__r1
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.b [tcc__r1]
sta.b tcc__r2
sec
lda.b tcc__r0
sbc.b tcc__r2
sta -4 + __check_npc_interaction_locals + 1,s
lda.w #0
sep #$20
lda -1 + __check_npc_interaction_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #24
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_npcs
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_npcs + 0
clc
adc.b tcc__r0
inc a
inc a
sta.b tcc__r1
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.b [tcc__r1]
sta.b tcc__r2
sec
lda.b tcc__r0
sbc.b tcc__r2
sta -6 + __check_npc_interaction_locals + 1,s
lda -4 + __check_npc_interaction_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_3
+
stz.b tcc__r0
lda -4 + __check_npc_interaction_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -4 + __check_npc_interaction_locals + 1,s
__local_3:
lda -6 + __check_npc_interaction_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_4
+
stz.b tcc__r0
lda -6 + __check_npc_interaction_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -6 + __check_npc_interaction_locals + 1,s
__local_4:
lda -4 + __check_npc_interaction_locals + 1,s
sta.b tcc__r0
sec
sbc.w #24
bvc +
eor #$8000
+
bmi +
brl __local_5
+
lda -6 + __check_npc_interaction_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #24
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_5:
brl __local_6
+
lda.w #0
sep #$20
lda -1 + __check_npc_interaction_locals + 1,s
sta.l tccs_{WLA_FILENAME}_selected_npc + 0
rep #$20
lda.w #1
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
bra __local_7
__local_6:
jmp.w __local_8
__local_0:
__local_7:
.ifgr __check_npc_interaction_locals 0
tsa
clc
adc #__check_npc_interaction_locals
tas
.endif
rtl
.ENDS

.SECTION ".draw_village_uitext_0x2" SUPERFREE

draw_village_ui:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_names
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_names + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 3
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_weapons
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_weapons + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 4
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45 + 0
pea.w 5
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46 + 0
pea.w 7
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47 + 0
pea.w 8
pea.w 5
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48 + 0
pea.w 10
pea.w 2
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49 + 0
pea.w 10
pea.w 17
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50 + 0
pea.w 17
pea.w 2
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51 + 0
pea.w 17
pea.w 17
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52 + 0
pea.w 20
pea.w 4
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54 + 0
pea.w 24
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
rtl
.ENDS

.SECTION ".draw_dialoguetext_0x3" SUPERFREE

draw_dialogue:
.ifgr __draw_dialogue_locals 0
tsa
sec
sbc #__draw_dialogue_locals
tas
.endif
lda.w #0
sep #$20
lda 3 + __draw_dialogue_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #24
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_npcs
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_npcs + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta -4 + __draw_dialogue_locals + 1,s
lda.b tcc__r1h
sta -2 + __draw_dialogue_locals + 1,s
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56 + 0
pea.w 7
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57 + 0
pea.w 8
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -4 + __draw_dialogue_locals + 1,s
sta.b tcc__r0
lda -2 + __draw_dialogue_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #4
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 9
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -4 + __draw_dialogue_locals + 1,s
sta.b tcc__r0
lda -2 + __draw_dialogue_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #8
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 9
pea.w 22
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58 + 0
pea.w 10
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -4 + __draw_dialogue_locals + 1,s
sta.b tcc__r0
lda -2 + __draw_dialogue_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #12
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 12
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -4 + __draw_dialogue_locals + 1,s
sta.b tcc__r0
lda -2 + __draw_dialogue_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #16
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 14
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -4 + __draw_dialogue_locals + 1,s
sta.b tcc__r0
lda -2 + __draw_dialogue_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #20
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 16
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
.ifgr __draw_dialogue_locals 0
tsa
clc
adc #__draw_dialogue_locals
tas
.endif
rtl
.ENDS

.SECTION ".maintext_0x4" SUPERFREE

main:
.ifgr __main_locals 0
tsa
sec
sbc #__main_locals
tas
.endif
sep #$20
lda #0
pha
rep #$20
jsr.l consoleInitDefaultText
tsa
clc
adc #1
tas
pea.w 12288
sep #$20
lda #0
pha
rep #$20
jsr.l bgSetGfxPtr
tsa
clc
adc #3
tas
sep #$20
lda #0
pha
rep #$20
pea.w 26624
sep #$20
lda #0
pha
rep #$20
jsr.l bgSetMapPtr
tsa
clc
adc #4
tas
pea.w (0 * 256 + 1)
sep #$20
rep #$20
jsr.l setMode
pla
sep #$20
lda #1
pha
rep #$20
jsr.l bgSetDisable
tsa
clc
adc #1
tas
sep #$20
lda #2
pha
rep #$20
jsr.l bgSetDisable
tsa
clc
adc #1
tas
jsr.l init_player
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l setScreenOn
jsr.l draw_village_ui
__local_37:
lda.l pad_keys + 0
sta.l tccs_{WLA_FILENAME}_pad_held + 0
lda.l pad_keysdown + 0
sta.l tccs_{WLA_FILENAME}_pad_down + 0
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #0
beq +
brl __local_9
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_redraw_village + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_10
+
jsr.l draw_village_ui
lda.w #0
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_redraw_village + 0
rep #$20
__local_10:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #2048
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_11
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #70
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_12
+
lda.w tccs_{WLA_FILENAME}_player + 2
dec a
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_12:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
__local_11:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #1024
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_13
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #155
tay
bcc ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_14
+
lda.w tccs_{WLA_FILENAME}_player + 2
inc a
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_14:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
__local_13:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #512
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_15
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #20
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_16
+
lda.w tccs_{WLA_FILENAME}_player + 0
dec a
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_16:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
__local_15:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #256
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_17
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #225
tay
bcc ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_18
+
lda.w tccs_{WLA_FILENAME}_player + 0
inc a
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_18:
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
__local_17:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #64
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_19
+
lda.w tccs_{WLA_FILENAME}_player + 6
sta.b tcc__r0
inc.b tcc__r0
ldx.b tcc__r0
lda.w #4
jsr.l tcc__div
txa
sta.w tccs_{WLA_FILENAME}_player + 6
lda.w tccs_{WLA_FILENAME}_player + 6
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 8
__local_19:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_20
+
lda.w #15
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
__local_20:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_21
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
__local_21:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_22
+
jsr.l check_npc_interaction
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #1
beq +
brl __local_23
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_selected_npc + 0
pha
rep #$20
jsr.l draw_dialogue
tsa
clc
adc #1
tas
__local_23:
__local_22:
lda.w tccs_{WLA_FILENAME}_player + 0
lsr a
lsr a
lsr a
and.w #255
sep #$20
sta -1 + __main_locals + 1,s
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 2
lsr a
lsr a
lsr a
and.w #255
sep #$20
sta -2 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_last_class_id + 0
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 6
sta.b tcc__r1
ldx #1
sec
sbc.b tcc__r0
tay
bne +
dex
+
stx.b tcc__r5
txa
bne +
brl __local_24
+
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_names
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_names + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 3
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_weapons
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_weapons + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 4
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
and.w #255
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_last_class_id + 0
rep #$20
__local_24:
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_old_grid_x + 0
rep #$20
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
bne +
dex
+
stx.b tcc__r5
txa
beq +
brl __local_25
+
lda.w #0
sep #$20
lda -2 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_old_grid_y + 0
rep #$20
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
bne +
dex
+
stx.b tcc__r5
txa
beq +
__local_25:
brl __local_26
+
jmp.w __local_27
__local_26:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_old_grid_x + 0
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_old_grid_y + 0
rep #$20
sta.b tcc__r1
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62 + 0
pei (tcc__r1)
pei (tcc__r0)
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
sta.l tccs_{WLA_FILENAME}_old_grid_x + 0
rep #$20
lda.w #0
sep #$20
lda -2 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_old_grid_y + 0
rep #$20
__local_27:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_28
+
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda -2 + __main_locals + 1,s
rep #$20
sta.b tcc__r1
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63 + 0
pei (tcc__r1)
pei (tcc__r0)
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_last_atk_timer + 0
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_29
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64 + 0
pea.w 24
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_29:
jmp.w __local_30
__local_28:
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda -2 + __main_locals + 1,s
rep #$20
sta.b tcc__r1
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65 + 0
pei (tcc__r1)
pei (tcc__r0)
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_last_atk_timer + 0
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_31
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66 + 0
pea.w 24
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_31:
__local_30:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_last_atk_timer + 0
rep #$20
jmp.w __local_32
__local_9:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #1
beq +
brl __local_33
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
brl __local_34
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
__local_34:
brl __local_35
+
bra __local_36
__local_35:
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #255
sep #$20
sta.l tccs_{WLA_FILENAME}_selected_npc + 0
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_redraw_village + 0
rep #$20
__local_36:
__local_33:
__local_32:
jsr.l WaitForVBlank
jmp.w __local_37
lda.w #0
sta.b tcc__r0
__local_38:
.ifgr __main_locals 0
tsa
clc
adc #__main_locals
tas
.endif
rtl
.ENDS
.RAMSECTION "ram{WLA_FILENAME}.data" APPENDTO "globram.data"

tccs_{WLA_FILENAME}_selected_npc dsb 2
tccs_{WLA_FILENAME}_pad_held dsb 2
tccs_{WLA_FILENAME}_pad_down dsb 2
tccs_{WLA_FILENAME}_old_grid_x dsb 1
tccs_{WLA_FILENAME}_old_grid_y dsb 1
tccs_{WLA_FILENAME}_last_class_id dsb 1
tccs_{WLA_FILENAME}_last_atk_timer dsb 1
tccs_{WLA_FILENAME}_redraw_village dsb 2
tccs_{WLA_FILENAME}_class_names dsb 16
tccs_{WLA_FILENAME}_class_weapons dsb 16

.ENDS

.SECTION "{WLA_FILENAME}.data" APPENDTO "glob.data"

.db $ff,$0
.db $0,$0
.db $0,$0
.db $0
.db $0
.db $ff
.db $0
.db $1,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34 + 0, :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38 + 0, :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41
.ENDS

.SECTION ".rodata" SUPERFREE

tccs_{WLA_FILENAME}_npcs: .db $40,$0,$48,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}14 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}14
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}15 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}15
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}16 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}16
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}17 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}17
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}18 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}18
.db $b4,$0,$48,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}19 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}19
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}20 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}20
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23
.db $32,$0,$a0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28
.db $b4,$0,$a0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}14: .db $41,$6e,$63,$69,$61,$6f,$20,$54,$61,$6e,$75,$6b,$69,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}15: .db $4a,$41,$50,$41,$4f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}16: .db $4f,$20,$6d,$75,$6e,$64,$6f,$20,$72,$65,$73,$70,$69,$72,$61,$76,$61,$20,$65,$6d,$20,$34,$20,$65,$6c,$65,$6d,$65,$6e,$74,$6f,$73,$2e,$2e,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}17: .db $41,$74,$65,$20,$6f,$20,$75,$73,$75,$72,$70,$61,$64,$6f,$72,$20,$61,$72,$72,$61,$6e,$63,$61,$72,$20,$6f,$73,$20,$67,$75,$61,$72,$64,$69,$6f,$65,$73,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}18: .db $52,$65,$75,$6e,$69,$6d,$6f,$73,$20,$74,$6f,$64,$61,$20,$61,$20,$6d,$61,$67,$69,$61,$20,$6e,$65,$73,$74,$65,$20,$61,$6c,$74,$61,$72,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}19: .db $43,$61,$73,$74,$6f,$72,$20,$43,$6f,$6e,$73,$74,$72,$75,$74,$6f,$72,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}20: .db $43,$41,$4e,$41,$44,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21: .db $45,$73,$74,$61,$20,$76,$69,$6c,$61,$20,$65,$20,$6f,$20,$75,$6c,$74,$69,$6d,$6f,$20,$61,$62,$72,$69,$67,$6f,$20,$6e,$61,$20,$70,$6f,$65,$69,$72,$61,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22: .db $41,$20,$61,$67,$75,$61,$20,$64,$6f,$73,$20,$70,$6f,$63,$6f,$73,$20,$65,$73,$74,$61,$20,$71,$75,$61,$73,$65,$20,$6e,$6f,$20,$66,$69,$6d,$2e,$2e,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23: .db $53,$65,$20,$76,$6f,$63,$65,$20,$66,$61,$6c,$68,$61,$72,$2c,$20,$6f,$20,$6d,$75,$6e,$64,$6f,$20,$6d,$6f,$72,$72,$65,$20,$63,$6f,$6d,$20,$61,$20,$67,$65,$6e,$74,$65,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24: .db $42,$69,$73,$61,$6f,$20,$56,$65,$74,$65,$72,$61,$6e,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25: .db $45,$55,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26: .db $4e,$61,$6f,$20,$68,$65,$73,$69,$74,$65,$20,$64,$69,$61,$6e,$74,$65,$20,$64,$6f,$20,$70,$65,$72,$69,$67,$6f,$2c,$20,$6a,$6f,$76,$65,$6d,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27: .db $54,$65,$73,$74,$65,$20,$73,$65,$75,$73,$20,$67,$6f,$6c,$70,$65,$73,$20,$65,$20,$68,$6f,$6e,$72,$65,$20,$6f,$73,$20,$34,$20,$70,$6f,$76,$6f,$73,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28: .db $41,$70,$65,$72,$74,$65,$20,$58,$20,$70,$61,$72,$61,$20,$61,$6c,$74,$65,$72,$6e,$61,$72,$20,$65,$6e,$74,$72,$65,$20,$61,$73,$20,$34,$20,$63,$6c,$61,$73,$73,$65,$73,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29: .db $4f,$72,$6e,$69,$74,$6f,$72,$72,$69,$6e,$63,$6f,$20,$4d,$69,$73,$74,$69,$63,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30: .db $41,$55,$53,$54,$52,$41,$4c,$49,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31: .db $4f,$20,$70,$6f,$72,$74,$61,$6c,$20,$65,$73,$74,$61,$20,$65,$73,$74,$61,$76,$65,$6c,$2e,$2e,$2e,$20,$6d,$61,$73,$20,$65,$20,$75,$6d,$20,$6d,$69,$73,$74,$65,$72,$69,$6f,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32: .db $4e,$65,$6e,$68,$75,$6d,$20,$73,$65,$72,$20,$76,$69,$76,$6f,$20,$63,$72,$75,$7a,$6f,$75,$20,$61,$6e,$74,$65,$73,$20,$64,$65,$20,$76,$6f,$63,$65,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33: .db $56,$6f,$63,$65,$20,$73,$65,$72,$61,$20,$6f,$20,$70,$72,$69,$6d,$65,$69,$72,$6f,$20,$61,$20,$76,$65,$72,$20,$6f,$20,$6f,$75,$74,$72,$6f,$20,$6c,$61,$64,$6f,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34: .db $54,$41,$54,$55,$20,$28,$54,$45,$52,$52,$41,$29,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35: .db $4c,$4f,$42,$4f,$47,$55,$41,$52,$41,$20,$28,$46,$4f,$47,$4f,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36: .db $4c,$41,$47,$41,$52,$54,$4f,$20,$28,$41,$47,$55,$41,$29,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37: .db $55,$52,$55,$54,$41,$55,$20,$28,$56,$45,$4e,$54,$4f,$29,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38: .db $45,$73,$70,$61,$64,$61,$20,$26,$20,$45,$73,$63,$75,$64,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39: .db $43,$61,$6a,$61,$64,$6f,$20,$53,$6f,$6c,$61,$72,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40: .db $41,$72,$63,$6f,$20,$26,$20,$46,$6c,$65,$63,$68,$61,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41: .db $41,$64,$61,$67,$61,$73,$20,$44,$75,$70,$6c,$61,$73,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42: .db $3d,$3d,$20,$46,$41,$4c,$4c,$45,$4e,$20,$48,$45,$52,$4f,$20,$28,$53,$4e,$45,$53,$20,$31,$36,$2d,$42,$49,$54,$29,$20,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44: .db $41,$52,$4d,$41,$3a,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45: .db $48,$50,$3a,$20,$31,$30,$30,$2f,$31,$30,$30,$20,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$53,$3a,$20,$30,$2f,$34,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47: .db $5b,$20,$41,$4c,$54,$41,$52,$20,$44,$41,$53,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$53,$20,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48: .db $5b,$54,$5d,$20,$54,$61,$6e,$75,$6b,$69,$28,$4a,$50,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49: .db $5b,$43,$5d,$20,$43,$61,$73,$74,$6f,$72,$28,$43,$41,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50: .db $5b,$42,$5d,$20,$42,$69,$73,$61,$6f,$28,$55,$53,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51: .db $5b,$4f,$5d,$20,$4f,$72,$6e,$69,$74,$6f,$72,$28,$41,$55,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52: .db $5b,$20,$50,$4f,$52,$54,$41,$4c,$20,$44,$4f,$20,$44,$45,$53,$43,$4f,$4e,$48,$45,$43,$49,$44,$4f,$20,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54: .db $44,$2d,$50,$61,$64,$3a,$41,$6e,$64,$61,$72,$20,$59,$3a,$41,$74,$61,$71,$75,$65,$20,$58,$3a,$43,$6c,$61,$73,$73,$65,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55: .db $41,$3a,$43,$6f,$6e,$76,$65,$72,$73,$61,$72,$20,$63,$6f,$6d,$20,$4d,$6f,$72,$61,$64,$6f,$72,$65,$73,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57: .db $4d,$4f,$52,$41,$44,$4f,$52,$20,$44,$41,$20,$56,$49,$4c,$41,$20,$44,$4f,$53,$20,$52,$45,$46,$55,$47,$49,$41,$44,$4f,$53,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60: .db $5b,$41,$20,$2f,$20,$42,$5d,$20,$46,$65,$63,$68,$61,$72,$20,$63,$6f,$6e,$76,$65,$72,$73,$61,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62: .db $20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63: .db $2a,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64: .db $47,$4f,$4c,$50,$45,$3a,$20,$2a,$20,$41,$54,$41,$51,$55,$45,$20,$45,$58,$45,$43,$55,$54,$41,$44,$4f,$21,$20,$2a,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65: .db $40,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66: .db $44,$2d,$50,$61,$64,$3a,$41,$6e,$64,$61,$72,$20,$59,$3a,$41,$74,$61,$71,$75,$65,$20,$58,$3a,$43,$6c,$61,$73,$73,$65,$20,$0
.ENDS

.RAMSECTION ".bss" BANK $7e SLOT 2
tccs_{WLA_FILENAME}_player dsb 18
tccs_{WLA_FILENAME}_current_state dsb 2
.ENDS
.SECTION ".rel.rodata" SUPERFREE

.db $4,$0,$0,$0,$1,$d,$0,$0,$8,$0,$0,$0,$1,$e,$0,$0,$c,$0,$0,$0,$1,$f,$0,$0,$10,$0,$0,$0,$1,$10,$0,$0,$14,$0,$0,$0,$1,$11,$0,$0,$1c,$0,$0,$0,$1,$12,$0,$0,$20,$0,$0,$0,$1,$13,$0,$0,$24,$0,$0,$0,$1,$14,$0,$0,$28,$0,$0,$0,$1,$15,$0,$0,$2c,$0,$0,$0,$1,$16,$0,$0,$34,$0,$0,$0,$1,$17,$0,$0,$38,$0,$0,$0,$1,$18,$0,$0,$3c,$0,$0,$0,$1,$19,$0,$0,$40,$0,$0,$0,$1,$1a,$0,$0,$44,$0,$0,$0,$1,$1b,$0,$0,$4c,$0,$0,$0,$1,$1c,$0,$0,$50,$0,$0,$0,$1,$1d,$0,$0,$54,$0,$0,$0,$1,$1e,$0,$0,$58,$0,$0,$0,$1,$1f,$0,$0,$5c,$0,$0,$0,$1,$20,$0,$0
.ENDS

