[CmdletBinding()]
param(
    [switch]$Watch,
    [switch]$Open
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$compilerPath = Join-Path $projectRoot '.tools\typst\typst.exe'
$sourcePath = Join-Path $projectRoot 'thesis\main.typ'
$outputDirectory = Join-Path $projectRoot 'build'
$outputPath = Join-Path $outputDirectory 'studienarbeit.pdf'

try {
    if ($Watch -and $Open) { throw 'Bitte -Watch und -Open getrennt verwenden.' }
    if (-not (Test-Path -LiteralPath $compilerPath)) {
        $systemCompiler = Get-Command typst -ErrorAction SilentlyContinue
        if (-not $systemCompiler) {
            throw 'Typst fehlt. Zuerst scripts\setup.ps1 ausfuehren.'
        }
        $compilerPath = $systemCompiler.Source
    }
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    $operation = if ($Watch) { 'watch' } else { 'compile' }
    & $compilerPath $operation --root $projectRoot $sourcePath $outputPath
    if ($LASTEXITCODE -ne 0) { throw "Typst meldet einen Fehler (Exit-Code $LASTEXITCODE)." }
    if (-not $Watch) { Write-Host "PDF erstellt: $outputPath" }
    if ($Open) { Invoke-Item -LiteralPath $outputPath }
} catch {
    Write-Error "PDF-Erstellung fehlgeschlagen: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
}
