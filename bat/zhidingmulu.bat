@echo off & setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('"dir E:\test\bushu /a/s/b/on .*"') do (
set file=%%~fi
set file=!file:%~dp0=!
echo !file! >> path1.txt
)