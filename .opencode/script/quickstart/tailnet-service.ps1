param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("install", "uninstall", "start", "stop", "status", "logs")]
  [string]$Action,

  [string]$Name = "opencode-tailnet",
  [int]$Port = 4096,
  [int]$TsHttpsPort = 8443,
  [int]$Tail = 200
)

$ErrorActionPreference = "Stop"

Write-Host "=== TAILNET SERVICE SCRIPT ===" -ForegroundColor Cyan
Write-Host "Action: $Action" -ForegroundColor Yellow
Write-Host "Name: $Name" -ForegroundColor Yellow
Write-Host "Port: $Port" -ForegroundColor Yellow
Write-Host "TsHttpsPort: $TsHttpsPort" -ForegroundColor Yellow
Write-Host "==============================" -ForegroundColor Cyan

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

$nssmPath = Get-NssmPath

if ($Action -eq "install") {
  $portInUse = Get-NetTCPConnection | Where-Object { $_.LocalPort -eq $Port }
  if ($portInUse) {
      throw "Port $Port is already in use. Please stop the process using this port before proceeding."
  }
  if (Test-ServiceExists -Name $Name) {
    Remove-ServiceBestEffort -Name $Name
    Start-Sleep -Seconds 1
  }

  $bashCommand = ("./.opencode/script/quickstart/tailnet.sh --service --port {0} --ts-https {1}" -f $Port, $TsHttpsPort)

  if ($null -ne $nssmPath) {

    Write-Host "Installing service with configuration:"
    Write-Host "  Name: $Name"
    Write-Host "  Port: $Port"
    Write-Host "  TsHttpsPort: $TsHttpsPort"
    Write-Host ""

    $nssmArgs = @("-lc", $bashCommand)

    Write-Host "About to execute NSSM install command:"
    Write-Host "$nssmPath install $Name $bashPath $($nssmArgs[0]) ""$($nssmArgs[1])"""
    Write-Host "Press Enter to continue or Ctrl+C to cancel..."
    Read-Host

    & $nssmPath install $Name $bashPath $nssmArgs[0] ('"{0}"' -f $nssmArgs[1])
    Write-Host "$nssmPath install $Name $bashPath $($nssmArgs[0]) ""$($nssmArgs[1])"""
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

$logsDir = Join-Path $repoRoot ".opencode\logs"
    Write-Host "Creating logs directory: $logsDir"
    New-Item -ItemType Directory -Force -Path $logsDir | Out-Null
    
    $serviceStdout = Join-Path $repoRoot ".opencode\logs\service-stdout.log"
    $serviceStderr = Join-Path $repoRoot ".opencode\logs\service-stderr.log"
    Write-Host "Setting log paths:"
    Write-Host "  Stdout: $serviceStdout"
    Write-Host "  Stderr: $serviceStderr"
    & $nssmPath set $Name AppStdout $serviceStdout | Out-Null
    & $nssmPath set $Name AppStderr $serviceStderr | Out-Null
& $nssmPath set $Name AppRotateFiles 1 | Out-Null
    & $nssmPath set $Name AppRotateOnline 1 | Out-Null
    & $nssmPath set $Name AppRotateSeconds 86400 | Out-Null
& $nssmPath set $Name AppRotateBytes 10485760 | Out-Null
    & $nssmPath edit $Name
    
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
