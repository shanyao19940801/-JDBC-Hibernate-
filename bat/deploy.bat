@echo off&setlocal enabledelayedexpansion
rem ����Ŀ¼
set SRC=E:\test\ROOT
rem ����Ŀ¼
set BAK=E:\test\bak
rem ����������Ŀ¼
set DEPLOY=E:\Study\gitother\other-everything\bat\bushu

rem ��ʼ�����ļ���
for /r %%a in (*) do (
   set /a num+=1
   set str=%%~dpa
   set str=!str:%cd%=!
   echo xiangduipath:!str!
   md %BAK%\!str!
)

rem ��ʼ�����ļ�
for /r %%i in (*.*) do (
	set s=%%i
	set s=!s:%~dp0=!
	copy %SRC%\!s! %BAK%\!s!
)

rem ��ʼ�ϴ������ļ�
for /r %%i in (*.*) do (
	set s=%%i
	set s=!s:%~dp0=!
	copy %DEPLOY%\!s! %SRC%\!s!
)
