# Script de automacao para compilacao do APK Android do Fallen Hero
$ErrorActionPreference = "Stop"

$env:JAVA_HOME = "C:\Users\palfn\AppData\Local\Android\jdk-17"
$env:PATH = "C:\Users\palfn\AppData\Local\Android\jdk-17\bin;$env:PATH"

$igor = "C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23\bin\igor\windows\x64\Igor.exe"
$runtime = "C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23"
$user = "C:\Users\palfn\AppData\Roaming\GameMakerStudio2-LTS2026\palflinho_2647503"
$project = Join-Path $PSScriptRoot "Fallen Hero.yyp"
$cache = "C:\Temp\GM_Cache"
$temp = "C:\Temp\GM_Temp"
$outApk = Join-Path $PSScriptRoot "Fallen Hero.apk"
$buildApk = Join-Path $PSScriptRoot "Build\Fallen Hero.apk"

# Remove release APK anterior para garantir build limpo
$sourceApk = "C:\Temp\GM_Cache\Android\Default\com.palflinho.fallenhero\build\outputs\apk\release\com.palflinho.fallenhero-release.apk"
if (Test-Path $sourceApk) {
    Remove-Item $sourceApk -Force -ErrorAction SilentlyContinue
}

Write-Host "Iniciando compilacao do APK Android (ARM64) com JDK 17..." -ForegroundColor Cyan

$cmdArgs = @(
    "--project=$project",
    "--rp=$runtime",
    "--uf=$user",
    "--cache=$cache",
    "--temp=$temp",
    "--of=$outApk",
    "--tf=$outApk",
    "--config=Default",
    "-r=VM",
    "android",
    "Package"
)

& $igor $cmdArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilacao falhou com codigo de saida $LASTEXITCODE."
}

if (Test-Path $sourceApk) {
    Copy-Item $sourceApk -Destination $outApk -Force
    if (-not (Test-Path (Join-Path $PSScriptRoot "Build"))) {
        New-Item -ItemType Directory -Path (Join-Path $PSScriptRoot "Build") -Force | Out-Null
    }
    Copy-Item $sourceApk -Destination $buildApk -Force
    $sizeMb = [math]::Round(((Get-Item $outApk).Length / 1MB), 2)
    Write-Host "APK gerado com sucesso!" -ForegroundColor Green
    Write-Host "Arquivo: $outApk ($sizeMb MB)" -ForegroundColor Green
    Write-Host "Arquivo: $buildApk ($sizeMb MB)" -ForegroundColor Green
} else {
    Write-Error "Falha ao localizar o APK compilado pelo Gradle."
}
