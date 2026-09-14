# Script de automacao para compilacao do build PC (Windows) do Fallen Hero
$ErrorActionPreference = "Stop"

$igor = "C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23\bin\igor\windows\x64\Igor.exe"
$runtime = "C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23"
$runner = "$runtime\windows\x64\Runner.exe"
$user = "C:\Users\palfn\AppData\Roaming\GameMakerStudio2-LTS2026\palflinho_2647503"
$project = Join-Path $PSScriptRoot "Fallen Hero.yyp"
$cache = "C:\Temp\GM_Cache"
$temp = "C:\Temp\GM_Temp"
$buildDir = Join-Path $PSScriptRoot "Build"
$outputDir = Join-Path $PSScriptRoot "output\Fallen Hero"
$zipPath = Join-Path $PSScriptRoot "Fallen Hero - Build.zip"

Write-Host "Compilando bytecode Windows com Igor..." -ForegroundColor Cyan

$cmdArgs = @(
    "--project=$project",
    "--rp=$runtime",
    "--uf=$user",
    "--cache=$cache",
    "--temp=$temp",
    "--config=Default",
    "-r=VM",
    "windows",
    "Compile"
)

& $igor $cmdArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilacao do bytecode Windows falhou."
}

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

Copy-Item -Path "$outputDir\Fallen Hero.win" -Destination "$buildDir\data.win" -Force
Copy-Item -Path $runner -Destination "$buildDir\Fallen Hero.exe" -Force
if (Test-Path (Join-Path $PSScriptRoot "options.ini")) {
    Copy-Item -Path (Join-Path $PSScriptRoot "options.ini") -Destination "$buildDir\options.ini" -Force
}

# Remover saves residuais da pasta Build para garantir build limpo
if (Test-Path "$buildDir\save.ini") { Remove-Item "$buildDir\save.ini" -Force }
if (Test-Path "$buildDir\meta.json") { Remove-Item "$buildDir\meta.json" -Force }
if (Test-Path "$buildDir\meta.ini") { Remove-Item "$buildDir\meta.ini" -Force }

# Gerar pacote Zip para PC (incluindo apenas os arquivos necessarios para PC)
Write-Host "Gerando pacote ZIP para PC..." -ForegroundColor Cyan
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

$pcFiles = @(
    "$buildDir\Fallen Hero.exe",
    "$buildDir\data.win"
)
if (Test-Path "$buildDir\options.ini") { $pcFiles += "$buildDir\options.ini" }

Compress-Archive -Path $pcFiles -DestinationPath $zipPath -CompressionLevel Optimal

$sizeMb = [math]::Round(((Get-Item $zipPath).Length / 1MB), 2)
Write-Host "Build PC gerado com sucesso!" -ForegroundColor Green
Write-Host "Executavel: $buildDir\Fallen Hero.exe" -ForegroundColor Green
Write-Host "Pacote ZIP: $zipPath ($sizeMb MB)" -ForegroundColor Green
