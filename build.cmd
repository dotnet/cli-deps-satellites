@echo off
setlocal
cd /d %~dp0
powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -Command "& \"%~dp0build.ps1\" %*; exit $LastExitCode;"
