@echo off&setlocal enabledelayedexpansion
rem 部署目录
set SRC=E:\test\ROOT
rem 备份目录
set BAK=E:\test\bak
rem 开始备份文件
for /r %%i in (*.*) do (
	set s=%%i
	set s=!s:%~dp0=!
	copy %SRC%\!s! %BAK%\!s!
)


