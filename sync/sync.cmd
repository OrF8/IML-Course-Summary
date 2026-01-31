@echo off
setlocal

echo.
set /p USEMSG=Do you want to enter a commit message? (y/n): 

if /I "%USEMSG%"=="y" (
    echo.
    set /p MSG=Enter commit message: 
    powershell -ExecutionPolicy Bypass -File "%~dp0sync.ps1" "%MSG%"
) else (
    powershell -ExecutionPolicy Bypass -File "%~dp0sync.ps1"
)

echo.
pause
