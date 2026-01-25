param(
  [Parameter(Mandatory = $true)]
  [int]$Port,

  [switch]$Force
)

function Get-ListeningPids([int]$Port) {
  # Prefer Get-NetTCPConnection when available.
  if (Get-Command Get-NetTCPConnection -ErrorAction SilentlyContinue) {
    return @(Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique)
  }

  $matches = netstat -ano | Select-String "LISTENING" | Select-String ":$Port\s"
  if (-not $matches) { return @() }

  $pids = @()
  foreach ($line in $matches) {
    $parts = ($line -replace "\s+", " ").Trim().Split(" ")
    $pid = $parts[-1]
    if ($pid -match "^\d+$") { $pids += [int]$pid }
  }
  return @($pids | Sort-Object -Unique)
}

$pids = Get-ListeningPids -Port $Port
if (-not $pids -or $pids.Count -eq 0) {
  Write-Host "No process is listening on port $Port."
  exit 0
}

Write-Host "Listening PIDs on port $Port: $($pids -join ', ')"
foreach ($pid in $pids) {
  try {
    $p = Get-Process -Id $pid -ErrorAction Stop
    Write-Host ("PID {0}: {1}" -f $pid, $p.ProcessName)
  } catch {
    Write-Host ("PID {0}: <unknown>" -f $pid)
  }
}

if (-not $Force) {
  $ans = Read-Host "Kill these PIDs? [y/N]"
  if ($ans -notmatch '^[Yy]$') {
    Write-Host "Aborted."
    exit 0
  }
}

foreach ($pid in $pids) {
  try {
    Stop-Process -Id $pid -Force -ErrorAction Stop
  } catch {
    Write-Host ("Failed to kill PID {0}: {1}" -f $pid, $_.Exception.Message)
  }
}

Write-Host "Done."
