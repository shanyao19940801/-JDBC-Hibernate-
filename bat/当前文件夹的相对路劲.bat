@echo off&setlocal enabledelayedexpansion
for /r %%a in (*) do (
   set /a num+=1
   set str=%%~dpa
   set str=!str:%cd%=!
   echo xiangduipath:!str!
)
echo num%num%
pause
