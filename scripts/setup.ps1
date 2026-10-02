[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$typstVersion = '0.15.1'
$compilerDirectory = Join-Path $projectRoot '.tools\typst'
$compilerPath = Join-Path $compilerDirectory 'typst.exe'

try {
    $codeCommand = Get-Command code -ErrorAction SilentlyContinue
    if (-not $codeCommand) {
        throw 'VS Code wurde nicht im PATH gefunden. VS Code installieren und ein neues Terminal oeffnen.'
    }

    $installedVersion = ''
    if (Test-Path -LiteralPath $compilerPath) {
        $installedVersion = & $compilerPath --version
        if ($LASTEXITCODE -ne 0) { throw 'Der vorhandene Typst-Compiler konnte nicht gestartet werden.' }
    }

    if ($installedVersion -notmatch ('^typst ' + [regex]::Escape($typstVersion) + '(\s|$)')) {
        $architecture = $env:PROCESSOR_ARCHITECTURE
        if ($env:PROCESSOR_ARCHITEW6432) { $architecture = $env:PROCESSOR_ARCHITEW6432 }
        $target = switch ($architecture) {
            'AMD64' { 'x86_64-pc-windows-msvc' }
            'ARM64' { 'aarch64-pc-windows-msvc' }
            default { throw "Nicht unterstuetzte Windows-Architektur: $architecture" }
        }

        $downloadDirectory = Join-Path $projectRoot '.tools\downloads'
        $archivePath = Join-Path $downloadDirectory "typst-$typstVersion-$target.zip"
        $extractDirectory = Join-Path $downloadDirectory "typst-$typstVersion-$target"
        $downloadUrl = "https://github.com/typst/typst/releases/download/v$typstVersion/typst-$target.zip"
        New-Item -ItemType Directory -Path $downloadDirectory, $compilerDirectory -Force | Out-Null

        Write-Host "Lade Typst $typstVersion aus dem offiziellen GitHub-Repository ..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath -UseBasicParsing -TimeoutSec 120
        Expand-Archive -LiteralPath $archivePath -DestinationPath $extractDirectory -Force
        $executables = @(Get-ChildItem -LiteralPath $extractDirectory -Filter typst.exe -File -Recurse)
        if ($executables.Count -ne 1) { throw 'Das Downloadarchiv enthaelt keinen eindeutigen Typst-Compiler.' }
        Copy-Item -LiteralPath $executables[0].FullName -Destination $compilerPath -Force
    }

    & $compilerPath --version
    if ($LASTEXITCODE -ne 0) { throw 'Die Typst-Installation konnte nicht verifiziert werden.' }

    Write-Host 'Installiere die VS-Code-Erweiterung Tinymist Typst ...'
    & $codeCommand.Source --install-extension 'myriad-dreamin.tinymist'
    if ($LASTEXITCODE -ne 0) { throw 'Die Tinymist-Installation ist fehlgeschlagen.' }
    $installedExtensions = & $codeCommand.Source --list-extensions
    if ($LASTEXITCODE -ne 0 -or $installedExtensions -notcontains 'myriad-dreamin.tinymist') {
        throw 'Tinymist konnte in VS Code nicht verifiziert werden.'
    }

    & (Join-Path $PSScriptRoot 'build.ps1')
    if ($LASTEXITCODE -ne 0) { throw 'Die erste PDF-Erstellung ist fehlgeschlagen.' }
    Write-Host 'Setup abgeschlossen. tensor-networks.code-workspace in VS Code oeffnen.'
} catch {
    Write-Error "Setup nicht abgeschlossen: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
}
