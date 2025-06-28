@echo off
REM NeoAsset One-Click ISO Builder

fltmc >nul 2>&1 || (
    echo.
    echo  Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
echo.
echo  NeoAsset One-Click ISO Builder
echo  -------------------------------
echo  Location: %CD%
echo.

powershell -ExecutionPolicy Bypass -NoProfile -File ".\auto_build_iso.ps1"

echo.
echo  Press any key to exit.
pause >nul
