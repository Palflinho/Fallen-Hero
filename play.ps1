$root = $PSScriptRoot
Set-Location $root

# Compila o jogo
& "$root\build.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Falha ao compilar. Abortando inicializacao do emulador." -ForegroundColor Red
    exit $LASTEXITCODE
}

# Inicia o emulador com a ROM
$emuDir = "$root\tools\emulator"
$emu = "$emuDir\snes9x-x64.exe"
$rom = "$root\fallen_hero.sfc"

if (Test-Path $emu) {
    Write-Host "Iniciando Snes9x com Fallen Hero..." -ForegroundColor Green
    Start-Process -FilePath $emu -WorkingDirectory $emuDir -ArgumentList "`"$rom`""
} else {
    Write-Host "Emulador nao encontrado em $emu. Abra $rom no seu emulador favorito." -ForegroundColor Yellow
}
