@echo off & setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('"dir /s/b/on *.*"') do (
set file=%%~fi
set file=!file:/=/!
echo !file! >> path1.txt
)