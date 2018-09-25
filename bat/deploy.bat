@echo off&setlocal enabledelayedexpansion
rem 部署目录
set SRC=E:\test\ROOT
rem 备份目录
set BAK=E:\test\bak
rem 发布包所在目录
set DEPLOY=E:\Study\gitother\other-everything\bat\bushu

rem 开始创建文件夹
for /r %%a in (*) do (
   set /a num+=1
   set str=%%~dpa
   set str=!str:%cd%=!
   echo xiangduipath:!str!
   md %BAK%\!str!
)

rem 开始备份文件
for /r %%i in (*.*) do (
	set s=%%i
	set s=!s:%~dp0=!
	copy %SRC%\!s! %BAK%\!s!
)

rem 开始上传更新文件
for /r %%i in (*.*) do (
	set s=%%i
	set s=!s:%~dp0=!
	copy %DEPLOY%\!s! %SRC%\!s!
)
