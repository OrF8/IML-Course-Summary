@echo off
setlocal EnableExtensions

echo.
set /p USEMSG=Do you want to enter a commit message? (y/n): 

if /I "%USEMSG%"=="y" (
    echo.
    set /p MSG=Enter commit message: 
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync.ps1" -Message "%MSG%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync.ps1"
)

echo.
pause
