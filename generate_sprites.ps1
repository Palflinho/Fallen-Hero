Add-Type -AssemblyName System.Drawing

$width = 128
$height = 32
$bytes = New-Object byte[] ($width * $height)

function Set-Px($x, $y, $c) {
    if ($x -ge 0 -and $x -lt 128 -and $y -ge 0 -and $y -lt 32) {
        $bytes[$y * 128 + $x] = [byte]$c
    }
}

function Fill-Rect($x0, $y0, $w, $h, $c) {
    for ($y = $y0; $y -lt ($y0 + $h); $y++) {
        for ($x = $x0; $x -lt ($x0 + $w); $x++) {
            Set-Px $x $y $c
        }
    }
}

function Draw-Box($x0, $y0, $w, $h, $border, $fill) {
    Fill-Rect $x0 $y0 $w $h $border
    Fill-Rect ($x0 + 1) ($y0 + 1) ($w - 2) ($h - 2) $fill
}

# ----------------------------------------------------
# Sprite 0 (0,0): Hero Down (Quadrado com Olhos Baixo)
# ----------------------------------------------------
Draw-Box 2 2 12 12 1 3
# Eyes (White dots with black pupils looking down)
Set-Px 4 9 6; Set-Px 5 9 6; Set-Px 4 10 1; Set-Px 5 10 1
Set-Px 10 9 6; Set-Px 11 9 6; Set-Px 10 10 1; Set-Px 11 10 1
# Center direction indicator / belt
Set-Px 7 11 7; Set-Px 8 11 7

# ----------------------------------------------------
# Sprite 1 (16,0): Hero Up (Quadrado de Costas/Olhando Cima)
# ----------------------------------------------------
Draw-Box 18 2 12 12 1 3
# Back shell / pattern
Fill-Rect 21 4 6 5 2
Set-Px 23 11 7; Set-Px 24 11 7

# ----------------------------------------------------
# Sprite 2 (32,0): Hero Right (Quadrado Olhando Direita)
# ----------------------------------------------------
Draw-Box 34 2 12 12 1 3
# Eyes looking right
Set-Px 41 5 6; Set-Px 42 5 6; Set-Px 42 6 1
Set-Px 41 8 6; Set-Px 42 8 6; Set-Px 42 9 1
# Direction line / sword point on right side
Set-Px 44 7 5; Set-Px 45 7 5

# ----------------------------------------------------
# Sprite 3 (48,0): Attack Slash (Arco de Golpe de Espada)
# ----------------------------------------------------
# Slash arc of white and yellow energy
for ($i = 0; $i -lt 12; $i++) {
    Set-Px (50 + $i) (2 + [int]([Math]::Sin($i * 0.3) * 6)) 6
    Set-Px (50 + $i) (3 + [int]([Math]::Sin($i * 0.3) * 6)) 7
}

# ----------------------------------------------------
# Sprite 4 (64,0): Chefe / Inimigo (Quadrado com Olhinhos Ameaçadores)
# ----------------------------------------------------
Draw-Box 65 1 14 14 1 8
# Menacing Eyes (Red circle + Yellow inner pupil)
# Left eye
Fill-Rect 68 5 3 3 8
Set-Px 69 6 9
# Right eye
Fill-Rect 73 5 3 3 8
Set-Px 74 6 9
# Angry brows
Set-Px 68 4 1; Set-Px 69 4 1; Set-Px 70 5 1
Set-Px 74 4 1; Set-Px 73 4 1; Set-Px 72 5 1

# ----------------------------------------------------
# Sprite 5 (80,0): Boneco de Treino (Training Dummy)
# ----------------------------------------------------
# Wooden post
Fill-Rect 87 8 2 8 11
# Cross arms
Fill-Rect 82 7 12 2 11
# Straw body
Fill-Rect 84 4 8 8 10
Draw-Box 84 4 8 8 1 10
# Red Bullseye Target on chest
Fill-Rect 86 6 4 4 8
Fill-Rect 87 7 2 2 6
Set-Px 87 7 8

# ----------------------------------------------------
# Sprite 6 (96,0): Projétil / Flecha / Magia
# ----------------------------------------------------
Fill-Rect 100 6 8 4 7
Fill-Rect 102 7 4 2 6
Set-Px 107 7 1; Set-Px 108 7 1

# ----------------------------------------------------
# Sprite 7 (112,0): Escudo de Defesa / Bloqueio
# ----------------------------------------------------
Fill-Rect 116 3 8 10 7
Draw-Box 116 3 8 10 1 7
Fill-Rect 118 5 4 6 5

# ----------------------------------------------------
# Row 2 (y=16): Moradores da Vila (NPCs) & Estruturas
# ----------------------------------------------------

# Sprite 8 (0,16): Tanuki NPC (Japão)
Draw-Box 2 18 12 12 1 3
# Mask around eyes
Fill-Rect 4 22 8 3 2
Set-Px 5 23 6; Set-Px 6 23 1
Set-Px 9 23 6; Set-Px 10 23 1

# Sprite 9 (16,16): Castor NPC (Canadá)
Draw-Box 18 18 12 12 1 11
# Eyes and tooth
Set-Px 21 22 6; Set-Px 22 22 1
Set-Px 25 22 6; Set-Px 26 22 1
Set-Px 23 26 6; Set-Px 24 26 6

# Sprite 10 (32,16): Bisão NPC (EUA)
Draw-Box 34 18 12 12 1 2
# Horns
Set-Px 33 17 6; Set-Px 34 18 6
Set-Px 46 17 6; Set-Px 45 18 6
# Eyes
Set-Px 37 22 6; Set-Px 38 22 1
Set-Px 41 22 6; Set-Px 42 22 1

# Sprite 11 (48,16): Ornitorrinco NPC (Austrália)
Draw-Box 50 18 12 12 1 14
# Duck bill
Fill-Rect 54 24 6 3 15
Set-Px 53 22 6; Set-Px 54 22 1
Set-Px 57 22 6; Set-Px 58 22 1

# Sprite 12 (64,16): Altar Central (Monumento das Essências)
Draw-Box 66 18 12 12 1 5
Fill-Rect 68 20 8 8 2
# 4 Elemental Slots
Set-Px 69 21 8; Set-Px 74 21 12; Set-Px 69 26 14; Set-Px 74 26 9

# Sprite 13 (80,16): Portal Dimensional (Vortice)
Draw-Box 82 17 12 14 1 13
Fill-Rect 84 19 8 10 12
Fill-Rect 86 21 4 6 6

# Sprite 14 (96,16): Slime / Minion (Quadradinho menor com olhinhos do GameMaker)
Draw-Box 99 19 10 10 1 14
# Slime eyes looking at hero
Set-Px 101 22 6; Set-Px 102 22 1
Set-Px 105 22 6; Set-Px 106 22 1
# Slime highlight
Set-Px 100 20 4; Set-Px 101 20 4

# Sprite 15 (112,16): Orbe de Essencia Elemental (Resgate)
Fill-Rect 116 19 8 8 12
Draw-Box 115 18 10 10 1 7
Fill-Rect 117 20 6 6 6
# Pulsing core
Set-Px 119 22 9; Set-Px 120 22 9


# Create Bitmap and copy bytes
$bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format8bppIndexed)
$pal = $bmp.Palette

$colors = @(
    [System.Drawing.Color]::FromArgb(255, 0, 255),    # 0: Transparent
    [System.Drawing.Color]::FromArgb(15, 15, 20),     # 1: Black
    [System.Drawing.Color]::FromArgb(60, 45, 35),     # 2: Dark Shade
    [System.Drawing.Color]::FromArgb(180, 130, 80),   # 3: Tatu Tan
    [System.Drawing.Color]::FromArgb(220, 180, 130),  # 4: Highlight
    [System.Drawing.Color]::FromArgb(150, 160, 175),  # 5: Steel
    [System.Drawing.Color]::FromArgb(255, 255, 255),  # 6: White
    [System.Drawing.Color]::FromArgb(255, 215, 50),   # 7: Gold
    [System.Drawing.Color]::FromArgb(215, 35, 35),    # 8: Red (Enemy body / eyes)
    [System.Drawing.Color]::FromArgb(255, 240, 20),   # 9: Yellow (Enemy pupil!)
    [System.Drawing.Color]::FromArgb(190, 160, 95),   # 10: Straw
    [System.Drawing.Color]::FromArgb(85, 50, 25),     # 11: Wood
    [System.Drawing.Color]::FromArgb(50, 200, 240),   # 12: Cyan
    [System.Drawing.Color]::FromArgb(20, 50, 120),    # 13: Deep Blue
    [System.Drawing.Color]::FromArgb(50, 180, 75),    # 14: Green
    [System.Drawing.Color]::FromArgb(240, 105, 30)    # 15: Orange
)

for ($i = 0; $i -lt $colors.Length; $i++) {
    $pal.Entries[$i] = $colors[$i]
}
$bmp.Palette = $pal

$rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
$data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::WriteOnly, [System.Drawing.Imaging.PixelFormat]::Format8bppIndexed)
[System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $bytes.Length)
$bmp.UnlockBits($data)

$outPath = Join-Path $PSScriptRoot "gfx/sprites.bmp"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Bmp)
$bmp.Dispose()
Write-Host "gfx/sprites.bmp gerado com sucesso em $outPath!"
