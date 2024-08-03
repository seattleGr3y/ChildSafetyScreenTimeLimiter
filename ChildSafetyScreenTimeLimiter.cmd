@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
powershell -NoProfile -ExecutionPolicy bypass -command "& { %~dpn0.ps1 %* }"
exit /b

