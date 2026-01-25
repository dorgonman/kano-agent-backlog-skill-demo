@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "DEFAULT_NAME=opencode-tailnet"
set "DEFAULT_PORT=4096"
set "DEFAULT_TS_HTTPS_PORT=8443"

set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%tailnet-service.ps1"

set "ACTION=%~1"
if "%ACTION%"=="" set "ACTION=bootstrap"

rem Ensure elevation (services require admin; double-click usually isn't elevated).
net session >nul 2>&1
if not "%errorlevel%"=="0" (
  rem Relaunch elevated with the same args. If no args, run bootstrap.
  set "FULL_ARGS=%*"
  if "%FULL_ARGS%"=="" set "FULL_ARGS=bootstrap"
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Start-Process -Verb RunAs -FilePath $env:ComSpec -ArgumentList '/c','\"\"%~f0\"\" %FULL_ARGS%' } catch { Write-Host $_.Exception.Message; exit 2 }"
  exit /b %errorlevel%
)

if /i "%ACTION%"=="bootstrap" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action install -Name "%DEFAULT_NAME%" -Port %DEFAULT_PORT% -TsHttpsPort %DEFAULT_TS_HTTPS_PORT%
  if errorlevel 1 goto :fail
  powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action start -Name "%DEFAULT_NAME%" >nul 2>&1

  rem Wait until service reports RUNNING (avoid confusing START_PENDING output).
  for /l %%i in (1,1,20) do (
    sc.exe query "%DEFAULT_NAME%" | findstr /i "RUNNING" >nul && goto :running
    timeout /t 1 >nul
  )
:running
  powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action status -Name "%DEFAULT_NAME%" >nul 2>&1
  echo.
  echo OK: Service '%DEFAULT_NAME%' installed and started.
  echo.
  echo How to connect:
  echo - Run: tailscale serve status
  echo - Use the URL shown under "Available within your tailnet"
  echo.
  echo If you see this in the browser:
  echo   {"name":"BunInstallFailedError",...}
  echo Install Bun (bun.sh) and then restart the service (double-click again).
  echo.
  set "TS_EXE="
  for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "$c=Get-Command tailscale -ErrorAction SilentlyContinue; if($c){$c.Source}"`) do set "TS_EXE=%%T"
  if not defined TS_EXE if exist "C:\Program Files\Tailscale\tailscale.exe" set "TS_EXE=C:\Program Files\Tailscale\tailscale.exe"
  if not defined TS_EXE if exist "C:\Program Files (x86)\Tailscale\tailscale.exe" set "TS_EXE=C:\Program Files (x86)\Tailscale\tailscale.exe"

  if defined TS_EXE (
    call :print_tailscale_status "!TS_EXE!"
  ) else (
    echo INFO: tailscale.exe not found in PATH for this shell.
    echo INFO: Open a new terminal where tailscale is available, then run: tailscale serve status
  )
  pause
  exit /b 0
)

shift
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action "%ACTION%" %*
exit /b %errorlevel%

:fail
echo ERROR: Operation failed.
pause
exit /b 2

:print_tailscale_status
set "TS=%~1"
set "FOUND=0"
for /l %%i in (1,1,20) do (
  "%TS%" serve status | findstr /i "Available within your tailnet" >nul && set "FOUND=1"
  if "!FOUND!"=="1" goto :ts_done
  timeout /t 1 >nul
)
:ts_done
echo tailscale serve status:
"%TS%" serve status
"%TS%" serve status | findstr /i "No serve config" >nul
if !errorlevel! EQU 0 (
  echo.
  echo WARN: tailscale serve has no config yet.
  echo WARN: Dump logs:
  echo - Double-click again and choose "logs" (or run: tailnet-service.cmd logs)
  echo - Or open:
  echo   .opencode\logs\service-stderr.log
  echo   .opencode\logs\service-stdout.log
  echo   .opencode\logs\opencode-stderr.log
)
exit /b 0
