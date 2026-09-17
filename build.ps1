param(
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
Set-Location $root

$tools = "tools/pvsneslib"
$devkitsnes = "$tools/devkitsnes"
$pvsneslib = "$tools/pvsneslib"
$bin = "$devkitsnes/bin"
$toolBin = "$devkitsnes/tools"
$libDir = "$pvsneslib/lib/LoROM_SlowROM"

if ($Clean) {
    Write-Host "Limpando artefatos de build SNES..." -ForegroundColor Yellow
    Remove-Item "src/*.obj", "src/*.ps", "src/*.asm", "hdr.obj", "data.obj", "linkfile", "*.sym", "*.symfull", "*.log" -ErrorAction SilentlyContinue
    Remove-Item "fallen_hero.sfc" -ErrorAction SilentlyContinue
    Write-Host "Limpeza concluida!" -ForegroundColor Green
    exit 0
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "   Compilando Fallen Hero para Super Nintendo    " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# 1. Gerar/Converter Sprites Graficos do GameMaker
Write-Host "[1/6] Convertendo graficos com gfx4snes..." -ForegroundColor Gray
if (-not (Test-Path "gfx/sprites.bmp")) {
    & powershell.exe -ExecutionPolicy Bypass -File "$root/generate_sprites.ps1"
}
& "$toolBin/gfx4snes.exe" -s 16 -o 16 -u 16 -p -t bmp -i "gfx/sprites.bmp"
if ($LASTEXITCODE -ne 0) { throw "Falha na conversao de sprites com gfx4snes." }

# 2. Montar data.asm (Sprites binarios) para data.obj
Write-Host "[2/6] Montando data.asm com wla-65816..." -ForegroundColor Gray
& "$bin/wla-65816.exe" -d -s -x -I "." -o "data.obj" "data.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na montagem de data.asm." }

# 3. Compilar src/main.c para .ps
Write-Host "[3/6] Compilando C com 816-tcc..." -ForegroundColor Gray
& "$bin/816-tcc.exe" -I"$pvsneslib/include" -I"$devkitsnes/include" -I"include" -Wall -c "src/main.c" -o "src/main.ps"
if ($LASTEXITCODE -ne 0) { throw "Falha na compilacao C com 816-tcc." }

# 4. Otimizar .ps para .asm e montar para .obj
Write-Host "[4/6] Otimizando com 816-opt e montando src/main.asm..." -ForegroundColor Gray
& "$toolBin/816-opt.exe" -i "src/main.ps" -o "src/main.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na otimizacao com 816-opt." }
& "$bin/wla-65816.exe" -d -s -x -I "." -o "src/main.obj" "src/main.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na montagem de src/main.asm." }

# 5. Montar hdr.asm para .obj
Write-Host "[5/6] Montando cabecalho do cartucho (hdr.asm)..." -ForegroundColor Gray
& "$bin/wla-65816.exe" -d -s -x -I "." -o "hdr.obj" "hdr.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na montagem de hdr.asm." }

# 6. Gerar linkfile e linkar ROM .sfc
Write-Host "[6/6] Linkando ROM SNES com wlalink..." -ForegroundColor Gray
$linkContent = @"
[objects]
hdr.obj
data.obj
src/main.obj
$libDir/crt0_snes.obj
$libDir/libc.obj
$libDir/libm.obj
$libDir/libtcc.obj
"@
Set-Content -Path "linkfile" -Value $linkContent -Encoding ASCII

& "$bin/wlalink.exe" -d -s -v -A -c -L "$libDir" linkfile fallen_hero.sfc
if ($LASTEXITCODE -ne 0) { throw "Falha no linking com wlalink." }

if (Test-Path "fallen_hero.sfc") {
    $rom = Get-Item "fallen_hero.sfc"
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host " SUCESSO! ROM SNES Gerada com Perfeicao:         " -ForegroundColor Green
    Write-Host " Arquivo: $($rom.FullName)                       " -ForegroundColor Green
    Write-Host " Tamanho: $($rom.Length) bytes (Cartucho 256 KB) " -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
} else {
    throw "Arquivo fallen_hero.sfc nao encontrado apos o link."
}
