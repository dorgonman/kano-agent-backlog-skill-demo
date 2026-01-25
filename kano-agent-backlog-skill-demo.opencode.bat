@echo off
REM OpenCode Console Launcher for kano-agent-backlog-skill-demo
REM This script launches the OpenCode terminal user interface

setlocal

set "REPO_ROOT=%~dp0"
pushd "%REPO_ROOT%" >nul

REM Default to repo-local mode unless explicitly overridden by the caller.
if "%OPENCODE_REPO_LOCAL%"=="" set "OPENCODE_REPO_LOCAL=1"

REM Keep runtime writable even in restricted environments by forcing data/cache to repo-local.
REM (Does NOT change where OpenCode reads global config from unless XDG_CONFIG_HOME is set below.)
set "XDG_DATA_HOME=%REPO_ROOT%.opencode\xdg\data"
set "XDG_CACHE_HOME=%REPO_ROOT%.opencode\xdg\cache"
if not exist "%XDG_DATA_HOME%" mkdir "%XDG_DATA_HOME%" >nul 2>nul
if not exist "%XDG_CACHE_HOME%" mkdir "%XDG_CACHE_HOME%" >nul 2>nul

REM Default: repo-local (OPENCODE_REPO_LOCAL=1). Set OPENCODE_REPO_LOCAL=0 to use global config.
if /I "%OPENCODE_REPO_LOCAL%"=="1" goto :repo_local
goto :global

:repo_local
set "OPENCODE_HOME=%REPO_ROOT%.opencode"
set "XDG_CONFIG_HOME=%REPO_ROOT%.opencode\xdg\config"

if not exist "%XDG_CONFIG_HOME%" mkdir "%XDG_CONFIG_HOME%" >nul 2>nul

echo Launching OpenCode (repo-local state) for kano-agent-backlog-skill-demo...
echo   OPENCODE_HOME=%OPENCODE_HOME%
echo   XDG_CONFIG_HOME=%XDG_CONFIG_HOME%
echo   XDG_DATA_HOME=%XDG_DATA_HOME%
echo   XDG_CACHE_HOME=%XDG_CACHE_HOME%
echo.
goto :run

:global
echo Launching OpenCode (global config) for kano-agent-backlog-skill-demo...
echo   Using %USERPROFILE%\.config\opencode\opencode.json
echo   Tip: set OPENCODE_REPO_LOCAL=1 to isolate per-repo
echo.

:run

opencode

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: OpenCode failed to start.
    echo Make sure OpenCode is installed: npm install -g opencode-ai
    echo.
    echo If you see BunInstallFailedError with a file: path, it usually means a stale plugin was installed from a local folder that no longer exists.
    echo This launcher isolates OpenCode to repo-local state so you can start clean.
    pause
    popd >nul
    endlocal
    exit /b 1
)

popd >nul
endlocal
