@echo off&setlocal enabledelayedexpansion
rem 部署目录
set SRC="E:\testROOT"
rem 备份目录
set BAK="E:\test\bak"
rem 开始创建文件夹
for /r %%a in (*) do (
   set /a num+=1
   set str=%%~dpa
   set str=!str:%cd%=!
   echo xiangduipath:!str!
   md %BAK%\!str!
)
rem 开始备份

