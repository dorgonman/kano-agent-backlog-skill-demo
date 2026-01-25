@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "DEFAULT_NAME=opencode-tailnet"
set "DEFAULT_PORT=5096"
set "DEFAULT_TS_HTTPS_PORT=9443"

set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%tailnet-service.ps1"
set "REPO_ROOT=%SCRIPT_DIR%..\..\.."
for %%I in ("%REPO_ROOT%") do set "REPO_ROOT=%%~fI"
set "PREREQ_PS1=%REPO_ROOT%\scripts\prerequisite.ps1"

rem Ensure elevation (services require admin; double-click usually isn't elevated).
net session >nul 2>&1
if not "%errorlevel%"=="0" (
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Start-Process -Verb RunAs -FilePath $env:ComSpec -ArgumentList '/c','\"\"%~f0\"\"' } catch { Write-Host $_.Exception.Message; exit 2 }"
  exit /b %errorlevel%
)


echo.
echo === TAILNET SERVICE REGISTER ===
echo About to register service with these parameters:
echo   Name: %DEFAULT_NAME%
echo   Port: %DEFAULT_PORT%
echo   TsHttpsPort: %DEFAULT_TS_HTTPS_PORT%
echo   Script: %PS1%
echo ================================
echo.
pause
echo.
echo DEBUG: Registering service '%DEFAULT_NAME%' with Port=%DEFAULT_PORT%, TsHttpsPort=%DEFAULT_TS_HTTPS_PORT%
echo DEBUG: PowerShell command: powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action install -Name "%DEFAULT_NAME%" -Port %DEFAULT_PORT% -TsHttpsPort %DEFAULT_TS_HTTPS_PORT%
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action install -Name "%DEFAULT_NAME%" -Port %DEFAULT_PORT% -TsHttpsPort %DEFAULT_TS_HTTPS_PORT%

if errorlevel 1 goto :fail

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action start -Name "%DEFAULT_NAME%" >nul 2>&1

echo.
echo OK: Service '%DEFAULT_NAME%' registered (installed) and started.
echo.
echo How to connect:
echo - Run: tailscale serve status
echo - Use the URL shown under "Available within your tailnet"
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

:fail
echo ERROR: Register failed.
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
exit /b 0
