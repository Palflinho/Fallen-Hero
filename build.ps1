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
    Remove-Item "src/*.obj", "src/*.ps", "src/*.asm", "hdr.obj", "linkfile", "*.sym", "*.symfull", "*.log" -ErrorAction SilentlyContinue
    Remove-Item "fallen_hero.sfc" -ErrorAction SilentlyContinue
    Write-Host "Limpeza concluida!" -ForegroundColor Green
    exit 0
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "   Compilando Fallen Hero para Super Nintendo    " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# 1. Compilar src/main.c para .ps
Write-Host "[1/5] Compilando C com 816-tcc..." -ForegroundColor Gray
& "$bin/816-tcc.exe" -I"$pvsneslib/include" -I"$devkitsnes/include" -I"include" -Wall -c "src/main.c" -o "src/main.ps"
if ($LASTEXITCODE -ne 0) { throw "Falha na compilacao C com 816-tcc." }

# 2. Otimizar .ps para .asm
Write-Host "[2/5] Otimizando com 816-opt..." -ForegroundColor Gray
& "$toolBin/816-opt.exe" -i "src/main.ps" -o "src/main.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na otimizacao com 816-opt." }

# 3. Montar src/main.asm para .obj
Write-Host "[3/5] Montando codigo com wla-65816..." -ForegroundColor Gray
& "$bin/wla-65816.exe" -d -s -x -I "." -o "src/main.obj" "src/main.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na montagem de src/main.asm." }

# 4. Montar hdr.asm para .obj
Write-Host "[4/5] Montando cabecalho do cartucho (hdr.asm)..." -ForegroundColor Gray
& "$bin/wla-65816.exe" -d -s -x -I "." -o "hdr.obj" "hdr.asm"
if ($LASTEXITCODE -ne 0) { throw "Falha na montagem de hdr.asm." }

# 5. Gerar linkfile e linkar ROM .sfc
Write-Host "[5/5] Linkando ROM SNES com wlalink..." -ForegroundColor Gray
$linkContent = @"
[objects]
hdr.obj
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
