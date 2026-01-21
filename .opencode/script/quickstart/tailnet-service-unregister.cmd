@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "DEFAULT_NAME=opencode-tailnet"
set "DEFAULT_PORT=5096"
set "DEFAULT_TS_HTTPS_PORT=9443"

set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%tailnet-service.ps1"

rem Ensure elevation (services require admin; double-click usually isn't elevated).
net session >nul 2>&1
if not "%errorlevel%"=="0" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Start-Process -Verb RunAs -FilePath $env:ComSpec -ArgumentList '/c','\"\"%~f0\"\"' } catch { Write-Host $_.Exception.Message; exit 2 }"
  exit /b %errorlevel%
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" -Action uninstall -Name "%DEFAULT_NAME%" -Port "%DEFAULT_PORT%" -TsHttpsPort "%DEFAULT_TS_HTTPS_PORT%"
if errorlevel 1 goto :fail

echo.
echo OK: Service '%DEFAULT_NAME%' unregistered (removed).
echo.
pause
exit /b 0

:fail
echo ERROR: Unregister failed.
pause
exit /b 2

