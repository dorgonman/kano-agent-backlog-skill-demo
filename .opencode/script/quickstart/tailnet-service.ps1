param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("install", "uninstall", "start", "stop", "status", "logs")]
  [string]$Action,

  [string]$Name = "oc-tailnet",
  [int]$Port = 4096,
  [int]$TsHttpsPort = 8443,
  [int]$Tail = 200
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
  $scriptDir = Split-Path -Parent $PSCommandPath
  # .opencode/script/quickstart -> repo root is ../../..
  return (Resolve-Path (Join-Path $scriptDir "..\\..\\..")).Path
}

function Get-BashPath {
  $bash = Get-Command "bash.exe" -ErrorAction SilentlyContinue
  if ($null -ne $bash) { return $bash.Source }

  $bash = Get-Command "bash" -ErrorAction SilentlyContinue
  if ($null -ne $bash) { return $bash.Source }

  throw "bash not found. Install Git for Windows (Git Bash) or add bash.exe to PATH."
}

function Get-NssmPath {
  $nssm = Get-Command "nssm.exe" -ErrorAction SilentlyContinue
  if ($null -ne $nssm) { return $nssm.Source }
  return $null
}

function Get-DirOfCommand {
  param([Parameter(Mandatory = $true)][string]$Name)
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if ($null -eq $cmd) { return $null }
  return (Split-Path -Parent $cmd.Source)
}

function Get-BunExePath {
  $bunExe = Get-Command "bun.exe" -ErrorAction SilentlyContinue
  if ($bunExe -and (Test-Path $bunExe.Source)) {
    return $bunExe.Source
  }

  $bun = Get-Command "bun" -ErrorAction SilentlyContinue
  if ($bun -and (Test-Path $bun.Source) -and ($bun.Source -like "*.exe")) {
    return $bun.Source
  }

  $candidates = @(
    (Join-Path $env:LOCALAPPDATA "Microsoft\\WinGet\\Links\\bun.exe"),
    (Join-Path $env:USERPROFILE ".bun\\bin\\bun.exe"),
    "C:\\Program Files\\Bun\\bun.exe",
    "C:\\Program Files (x86)\\Bun\\bun.exe"
  ) | Where-Object { $_ -and ($_ -ne "") } | Select-Object -Unique

  foreach ($candidate in $candidates) {
    if (Test-Path $candidate) { return $candidate }
  }

  # Last resort: use where.exe (works even if bun comes from shims/links).
  try {
    $out = & where.exe bun.exe 2>$null
    if ($LASTEXITCODE -eq 0 -and $out) {
      foreach ($line in $out) {
        if (Test-Path $line) { return $line }
      }
    }
  }
  catch { }

  return $null
}

function Assert-Admin {
  $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  if (-not $isAdmin) {
    throw "Administrator privileges required (Windows service install/remove). Re-run PowerShell as Admin."
  }
}

function Test-ServiceExists {
  param([Parameter(Mandatory = $true)][string]$Name)
  & sc.exe query $Name *> $null
  return ($LASTEXITCODE -eq 0)
}

function Remove-ServiceBestEffort {
  param([Parameter(Mandatory = $true)][string]$Name)

  try { & sc.exe stop $Name *> $null } catch { }
  try { & sc.exe delete $Name *> $null } catch { }

  $nssmPath = Get-NssmPath
  if ($null -ne $nssmPath) {
    try { & $nssmPath remove $Name confirm *> $null } catch { }
  }
}

Assert-Admin

$repoRoot = Get-RepoRoot
$bashPath = Get-BashPath
$tailnetSh = Join-Path $repoRoot ".opencode\\script\\quickstart\\tailnet.sh"

if (-not (Test-Path $tailnetSh)) {
  throw "Missing script: $tailnetSh"
}

$bashCommand = ("./.opencode/script/quickstart/tailnet.sh --service --port {0} --ts-https {1}" -f $Port, $TsHttpsPort)
$args = @("-lc", $bashCommand)

$nssmPath = Get-NssmPath

if ($Action -eq "install") {
  if (Test-ServiceExists -Name $Name) {
    Remove-ServiceBestEffort -Name $Name
    Start-Sleep -Seconds 1
  }

  if ($null -ne $nssmPath) {
    # Prefer repo-local HOME and Bun install locations so services do not depend on a user profile.
    $repoOpencodeDir = Join-Path $repoRoot ".opencode"
    $repoBunInstall = Join-Path $repoOpencodeDir ".bun"
    $repoBunBin = Join-Path $repoBunInstall "bin"
    New-Item -ItemType Directory -Force -Path $repoOpencodeDir | Out-Null
    New-Item -ItemType Directory -Force -Path $repoBunBin | Out-Null

    # Make Bun available to the service even when it runs under LocalSystem.
    # If Bun exists on this machine, copy bun.exe into the repo-local bun bin dir.
    $bunExePath = Get-BunExePath
    if ($bunExePath) {
      try {
        Copy-Item -Force -Path $bunExePath -Destination (Join-Path $repoBunBin "bun.exe")
        $bunDest = Join-Path $repoBunBin "bun.exe"
        if (Test-Path $bunDest) {
          Write-Host "OK: bun.exe copied into repo-local bin: $bunDest"
        }
      }
      catch {
        Write-Warning "Failed to copy bun.exe into repo: $($_.Exception.Message)"
      }
    }
    else {
      Write-Warning "bun.exe not found for this installer session; service may fail with BunInstallFailedError."
    }

    & $nssmPath install $Name $bashPath @args
    if ($LASTEXITCODE -ne 0) { throw "nssm install failed (exit=$LASTEXITCODE)" }
    & $nssmPath set $Name AppDirectory $repoRoot | Out-Null
    & $nssmPath set $Name DisplayName $Name | Out-Null
    & $nssmPath set $Name Start SERVICE_AUTO_START | Out-Null
    # Ensure service can find tools (opencode/tailscale/bun), and has writable HOME/BUN_INSTALL.
    $opencodeDir = Get-DirOfCommand -Name "opencode"
    $tailscaleDir = Get-DirOfCommand -Name "tailscale"
    $bunDir = Get-DirOfCommand -Name "bun"
    $extraDirs = @($repoBunBin, $opencodeDir, $tailscaleDir, $bunDir) | Where-Object { $_ -and ($_ -ne "") } | Select-Object -Unique
    $path = ($env:PATH + ";" + ($extraDirs -join ";"))

    $envBlock = @(
      ("PATH={0}" -f $path),
      ("HOME={0}" -f $repoRoot),
      ("USERPROFILE={0}" -f $env:USERPROFILE),
      ("BUN_INSTALL={0}" -f $repoBunInstall),
      ("OPENCODE_HOME={0}" -f $repoOpencodeDir)
    ) -join "`n"
    & $nssmPath set $Name AppEnvironmentExtra $envBlock | Out-Null

    & $nssmPath set $Name AppStdout (Join-Path $repoRoot ".opencode\\logs\\service-stdout.log") | Out-Null
    & $nssmPath set $Name AppStderr (Join-Path $repoRoot ".opencode\\logs\\service-stderr.log") | Out-Null
    & $nssmPath set $Name AppRotateFiles 1 | Out-Null
    & $nssmPath set $Name AppRotateOnline 1 | Out-Null
    & $nssmPath set $Name AppRotateSeconds 86400 | Out-Null
    & $nssmPath set $Name AppRotateBytes 10485760 | Out-Null

    if (-not (Test-ServiceExists -Name $Name)) {
      throw "Service '$Name' was not created successfully."
    }

    Write-Host "OK: installed service via NSSM: $Name"
    return
  }

  $escaped = $bashCommand.Replace('"', '\"')
  $binPath = ('"{0}" /c "cd /d ""{1}"" && ""{2}"" -lc ""{3}"""' -f $env:ComSpec, $repoRoot, $bashPath, $escaped)

  # sc.exe requires spaces exactly like: binPath= "..."
  & sc.exe create $Name binPath= $binPath start= auto DisplayName= $Name | Out-Null
  Write-Host "OK: installed service via sc.exe: $Name"
  return
}

if ($Action -eq "uninstall") {
  if ($null -ne $nssmPath) {
    & $nssmPath stop $Name | Out-Null
    & $nssmPath remove $Name confirm | Out-Null
    Write-Host "OK: removed service via NSSM: $Name"
    return
  }

  & sc.exe stop $Name | Out-Null
  & sc.exe delete $Name | Out-Null
  Write-Host "OK: removed service via sc.exe: $Name"
  return
}

if ($Action -eq "start") { & sc.exe start $Name; return }
if ($Action -eq "stop") { & sc.exe stop $Name; return }
if ($Action -eq "status") { & sc.exe query $Name; return }
if ($Action -eq "logs") {
  $serviceStdout = Join-Path $repoRoot ".opencode\\logs\\service-stdout.log"
  $serviceStderr = Join-Path $repoRoot ".opencode\\logs\\service-stderr.log"
  $opencodeStdout = Join-Path $repoRoot ".opencode\\logs\\opencode-stdout.log"
  $opencodeStderr = Join-Path $repoRoot ".opencode\\logs\\opencode-stderr.log"

  Write-Host "Log files:"
  Write-Host "- $serviceStdout"
  Write-Host "- $serviceStderr"
  Write-Host "- $opencodeStdout"
  Write-Host "- $opencodeStderr"
  Write-Host ""

  $files = @($serviceStdout, $serviceStderr, $opencodeStdout, $opencodeStderr)
  foreach ($file in $files) {
    if (Test-Path $file) {
      Write-Host "=== Tail ${Tail}: $file ==="
      Get-Content -Tail $Tail $file
      Write-Host ""
    } else {
      Write-Host "=== Missing: $file ==="
      Write-Host ""
    }
  }
  return
}
