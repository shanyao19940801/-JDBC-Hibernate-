rem 当前路径相对路径
@echo off
setlocal enabledelayedexpansion
for /r %%i in (*.*) do (
set s=%%i
set s=!s:%~dp0=!
echo !s!>> filename.txt
)