@echo off
REM OpenCode Console Launcher for kano-agent-backlog-skill-demo
REM This script launches the OpenCode terminal user interface

echo Launching OpenCode for kano-agent-backlog-skill-demo...
echo.

opencode

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: OpenCode failed to start.
    echo Make sure OpenCode is installed: npm install -g opencode-ai
    pause
    exit /b 1
)
