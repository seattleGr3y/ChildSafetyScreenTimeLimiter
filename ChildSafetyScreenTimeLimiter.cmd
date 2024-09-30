@echo off
set "breakTimeWarning="
set breakTimeWarningPSparam=%breakTimeWarning%
set "breakTimeStart="
set breakTimeStartPSparam=%breakTimeStart%
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION


if "%breakTimeWarningPSparam%" goto command1
: command1
start PowerShell -ExecutionPolicy Bypass -File .\ChildSafetyScreenTimeLimiter_Setup.ps1
start PowerShell -ExecutionPolicy Bypass -File .\%~dpn0.ps1 -breakTimeWarning
exit /b

if "%breakTimeStartPSparam%" goto command2
: command2
start PowerShell -ExecutionPolicy Bypass -File .\ChildSafetyScreenTimeLimiter_Setup.ps1
start PowerShell -ExecutionPolicy Bypass -File .\%~dpn0.ps1 -breakTimeStart
exit /b