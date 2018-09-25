cho off & setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('"dir E:\test\bushu /a/s/b/on .*"') do (
set file=%%~dpi
set file=!file:/=/!
echo !file! >> path1.txt
)