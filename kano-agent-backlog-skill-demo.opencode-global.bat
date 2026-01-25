@echo off
REM OpenCode Console Launcher (GLOBAL mode) for kano-agent-backlog-skill-demo
REM Forces OPENCODE_REPO_LOCAL=0 and delegates to the main launcher.

setlocal
set "OPENCODE_REPO_LOCAL=0"
call "%~dp0kano-agent-backlog-skill-demo.opencode.bat" %*
exit /b %ERRORLEVEL%
