@echo off
setlocal enabledelayedexpansion
for /r %%i in ('"dir E:\test\bushu /a/s/b/on .*"') do (
set s=%%i
set s=!s:%~dp0=!
echo !s!>> filename.txt
)