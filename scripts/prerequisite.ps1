$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    $scriptDir = Split-Path -Parent $PSCommandPath
    return (Resolve-Path (Join-Path $scriptDir "..")).Path
}

function Get-BashPath {
    $bash = Get-Command "bash.exe" -ErrorAction SilentlyContinue
    if ($bash) { return $bash.Source }

    $bash = Get-Command "bash" -ErrorAction SilentlyContinue
    if ($bash) { return $bash.Source }

    throw "bash not found. Install Git for Windows (Git Bash) or add bash.exe to PATH."
}

param(
    [ValidateSet("install", "check")]
    [string]$Action = "install",
    [switch]$NoOpencode,
    [switch]$NoOhMyOpencode,
    [switch]$NoKanoSkill
)

$repoRoot = Get-RepoRoot
$bashPath = Get-BashPath
$shPath = Join-Path $repoRoot "scripts/prerequisite.sh"

if (-not (Test-Path $shPath)) {
    throw "Missing script: $shPath"
}

$args = @($shPath, $Action)
if ($NoOpencode) { $args += "--no-opencode" }
if ($NoOhMyOpencode) { $args += "--no-oh-my-opencode" }
if ($NoKanoSkill) { $args += "--no-kano-skill" }

Push-Location $repoRoot
try {
    & $bashPath @args
}
finally {
    Pop-Location
}
