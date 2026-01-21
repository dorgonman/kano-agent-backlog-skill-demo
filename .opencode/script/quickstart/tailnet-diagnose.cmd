@echo off
setlocal EnableExtensions

echo ========================================
echo Tailscale Serve Diagnostics
echo ========================================
echo.

echo [1] Current Tailscale serve status:
echo ----------------------------------------
tailscale serve status
echo.

echo [2] Resetting Tailscale serve configuration...
echo ----------------------------------------
tailscale serve reset
echo OK: Tailscale serve reset completed.
echo.

echo [3] New Tailscale serve status (should be empty):
echo ----------------------------------------
tailscale serve status
echo.

echo ========================================
echo Diagnostics complete!
echo ========================================
echo.
echo Next steps:
echo 1. Restart your Windows service: tailnet-service-register.cmd
echo 2. Verify the new configuration with: tailscale serve status
echo.

pause
